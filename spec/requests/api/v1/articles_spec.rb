require "rails_helper"

RSpec.describe "Api::V1::Articles", type: :request do
  describe "GET /articles" do
    subject { get(api_v1_articles_path) }

    let!(:article1) { create(:article, updated_at: 1.days.ago) }
    let!(:article2) { create(:article, updated_at: 2.days.ago) }
    let!(:article3) { create(:article) }

    it "記事の一覧が取得できる" do
      subject
      res = JSON.parse(response.body)
      expect(response).to have_http_status(:ok)
      expect(res.length).to eq 3
      expect(res.map {|d| d["id"] }).to eq [article3.id, article1.id, article2.id]
      expect(res[0].keys).to eq ["id", "title", "updated_at", "user"]
      expect(res[0]["user"].keys).to eq ["id", "name", "email"]
    end
  end

  describe "GET /articles/:id" do
    subject { get(api_v1_article_path(article_id)) }

    context "指定した id の記事が存在する場合" do
      let(:article_id) { article.id }
      let(:article) { create(:article) }

      it "指定した記事の値を取得できる" do
        subject
        res = JSON.parse(response.body)
        expect(response).to have_http_status(:ok)
        expect(res["id"]).to eq article.id
        expect(res["title"]).to eq article.title
        expect(res["body"]).to eq article.body
        expect(res["updated_at"]).to be_present
        expect(res["user"].keys).to eq ["id", "name", "email"]
      end
    end

    context "指定したidが存在しない時" do
      let(:article_id) { 1_000_000 }

      it "記事が見つからない" do
        expect { subject }.to raise_error ActiveRecord::RecordNotFound
      end
    end

    describe "POST /articles" do
      subject { post(api_v1_articles_path, params: params, headers: headers) }

      let(:current_user) { create(:user) }
      let(:params) { { article: attributes_for(:article) } }
      let(:headers) { current_user.create_new_auth_token }

      it "記事の作成ができる" do
        expect { subject }.to change { Article.where(user_id: current_user.id).count }.by(1)
        res = JSON.parse(response.body)
        expect(res["title"]).to eq params[:article][:title]
        expect(res["body"]).to eq params[:article][:body]
        expect(response).to have_http_status(:ok)
      end
    end

    describe "PATCH /api/v1/articles/:id" do
      subject { patch(api_v1_article_path(article.id), params: params, headers: headers) }

      let(:params) { { article: attributes_for(:article) } }
      let(:current_user) { create(:user) }
      let(:headers) { current_user.create_new_auth_token }

      context "自分の記事のを更新する時" do
        let(:article) { create(:article, user: current_user) }
        it "記事を更新できる" do
          expect { subject }.to change { article.reload.title }.from(article.title).to(params[:article][:title]) &
                                change { article.reload.body }.from(article.body).to(params[:article][:body])
          expect(response).to have_http_status(:ok)
        end
      end

      context "自分以外の記事を更新しようとした時" do
        let(:other_user) { create(:user) }
        let!(:article) { create(:article, user: other_user) }

        it "更新に失敗する" do
          expect { subject }.to raise_error(ActiveRecord::RecordNotFound) &
                                change { Article.count }.by(0)
        end
      end
    end

    describe "DELETE /api/v1/articles/:id" do
      subject { delete(api_v1_article_path(article_id), headers: headers) }

      let(:current_user) { create(:user) }
      let(:article_id) { article.id }
      let(:headers) { current_user.create_new_auth_token }

      context "自分の記事を削除しようとした時" do
        let!(:article) { create(:article, user: current_user) }

        it "記事を削除できる" do
          expect { subject }.to change { Article.count }.by(-1)
          expect(response).to have_http_status(:no_content)
        end
      end

      context "他人の記事を削除しようとする時" do
        let(:other_user) { create(:user) }
        let!(:article) { create(:article, user: other_user) }

        it "削除に失敗する" do
          expect { subject }.to raise_error(ActiveRecord::RecordNotFound)
          change { Article.count }.by(0)
        end
      end
    end
  end
end
