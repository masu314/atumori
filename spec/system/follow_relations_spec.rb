require 'rails_helper'

RSpec.describe "FollowRelations", type: :system do
  let!(:other_users) { create_list(:user, 3) }
  let(:user) { create(:user) }
  let!(:follow_relation1) { create(:follow_relation, followed_id: other_users[2].id, follower_id: other_users[1].id) }
  let!(:follow_relation2) { create(:follow_relation, followed_id: other_users[2].id, follower_id: other_users[0].id) }
  let!(:follow_relation3) { create(:follow_relation, followed_id: other_users[1].id, follower_id: other_users[2].id) }

  it "フォロー中画面にフォローしているユーザーが表示されること" do
    visit user_followings_path(other_users[2].id)
    expect(page).to have_content other_users[1].name
  end

  it "フォロワー画面にフォローされているユーザーが表示されること" do
    visit user_followers_path(other_users[2].id)
    expect(page).to have_content other_users[1].name
    expect(page).to have_content other_users[0].name
  end

  describe "ログイン前" do
    it "ユーザー一覧画面にフォローボタンが表示されないこと" do
      visit users_path
      expect(page).to have_no_button('フォローする')
    end
    it "ユーザー詳細画面にフォローボタンが表示されないこと" do
      visit user_path(other_users[0].id)
      expect(page).to have_no_button('フォローする')
    end
  end

  describe "ログイン後" do
    before do
      visit new_user_session_path
      fill_in "メールアドレス", with: user.email
      fill_in "パスワード", with: user.password
      click_button "ログインする"
    end
    it "ログインユーザーにはフォローボタンが表示されていないこと" do
      visit user_path(user.id)
      expect(page).to have_no_button('フォローする')
    end
    it "他のユーザーをフォローしたり、フォローを解除できること" do
      visit user_path(other_users[0].id)
      click_button "フォローする"
      expect(other_users[0].followers.count).to eq(1)
      expect(user.followings.count).to eq(1)
      click_button "フォロー中"
      expect(other_users[0].followers.count).to eq(0)
      expect(user.followings.count).to eq(0)
    end
  end
end
