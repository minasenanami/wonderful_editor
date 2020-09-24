# == Schema Information
#
# Table name: articles
#
#  id         :bigint           not null, primary key
#  body       :text
#  title      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_articles_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
require "rails_helper"

RSpec.describe Article, type: :model do
  context "タイトルと本文が入力されている時" do
    let(:article) { build(:article) }
    it "記事が作成される" do
      expect(article).to be_valid
    end
  end

  context "タイトルしか入力されていない時" do
    let(:article) { build(:article, body: nil) }
    it "エラーする" do
      expect(article).to be_invalid
    end
  end

  context "本文しか入力していない時" do
    let(:article) { build(:article, title: nil) }
    it "エラーする" do
      expect(article).to be_invalid
      expect(article.errors.details[:title][0][:error]).to eq :blank
    end
  end
end
