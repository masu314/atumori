require 'rails_helper'

RSpec.describe "Favorites", type: :system do
  let!(:post) { create(:post) }
  let(:user) { create(:user) }

  describe "ログイン前" do
    it "投稿一覧画面にお気に入りボタンが表示されないこと" do
      visit posts_path
      expect(page.all('.material-icons-outlined').empty?).to eq true
    end
    it "投稿詳細画面にお気に入りボタンが表示されないこと" do
      visit post_path(post.id)
      expect(page.all('.material-icons-outlined').empty?).to eq true
    end
  end
  
  describe "ログイン後" do
    before do
      visit new_user_session_path
      fill_in "メールアドレス", with: user.email
      fill_in "パスワード", with: user.password
      click_button "ログインする"
    end
    
    it "投稿をお気に入り登録・解除できること" do
      visit post_path(post.id)
      find(".material-icons-outlined").click
      expect(post.favorites.count).to eq(1)
      find(".material-icons-outlined").click
      expect(post.favorites.count).to eq(0)
    end
  end
end
