# == Schema Information
#
# Table name: comments
#
#  id         :bigint           not null, primary key
#  body       :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  article_id :bigint           not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_comments_on_article_id  (article_id)
#  index_comments_on_user_id     (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (article_id => articles.id)
#  fk_rails_...  (user_id => users.id)
#

require "rails_helper"

RSpec.describe Comment, type: :model do
  context "コメントが入力されている時" do
    let(:comment) { build(:comment) }
    it "コメントが作成される" do
      expect(comment).to be_valid
    end
  end

  context "コメントが空の場合" do
    let(:comment) { build(:comment, body: nil) }
    it "コメントに失敗する" do
      expect(comment).to be_invalid
    end
  end

  context "userがログインしてない場合" do
    let(:comment) { build(:comment, user_id: nil) }
    it "コメントに失敗する" do
      expect(comment).to be_invalid
    end
  end
end
