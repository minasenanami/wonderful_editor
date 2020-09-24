# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  allow_password_change  :boolean          default(FALSE)
#  confirmation_sent_at   :datetime
#  confirmation_token     :string
#  confirmed_at           :datetime
#  email                  :string
#  encrypted_password     :string           default(""), not null
#  image                  :string
#  name                   :string
#  provider               :string           default("email"), not null
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  tokens                 :json
#  uid                    :string           default(""), not null
#  unconfirmed_email      :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_confirmation_token    (confirmation_token) UNIQUE
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#  index_users_on_uid_and_provider      (uid,provider) UNIQUE
#
require "rails_helper"

RSpec.describe User, type: :model do
  context "必要な情報が揃っている場合" do
    let(:user) { build(:user) }

    it "ユーザーが作成される" do
      expect(user).to be_valid
    end
  end

  context "名前だけの入力だけの場合" do
    let(:user) { build(:user, email: nil, password: nil) }
    it "ユーザーの作成に失敗する" do
      expect(user).not_to be_valid
    end
  end

  context "emailが無い場合" do
    let(:user) { build(:user, email: nil) }
    it "エラーが発生する" do
      expect(user).to be_invalid
    end
  end

  context "passwordが無い場合" do
    let(:user) { build(:user, password: nil) }
    it "エラーが発生する" do
      expect(user).to be_invalid
    end
  end
end
