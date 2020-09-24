# == Schema Information
#
# Table name: article_likes
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  article_id :bigint           not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_article_likes_on_article_id  (article_id)
#  index_article_likes_on_user_id     (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (article_id => articles.id)
#  fk_rails_...  (user_id => users.id)
#
require "rails_helper"

RSpec.describe ArticleLike, type: :model do
  context "ユーザーと記事が存在する時" do
    let(:article_like) { build(:article_like) }
    it "お気に入りできる" do
      expect(article_like).to be_valid
    end
  end

  context "ユーザーがログインしてない時" do
    let(:article_like) { build(:article_like, user_id: nil) }
    it "エラーが出る" do
      expect(article_like).to be_invalid
    end
  end
end
