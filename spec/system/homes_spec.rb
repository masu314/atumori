require 'rails_helper'

RSpec.describe "Homes", type: :system do
  let!(:post_tag_relations) { create_list(:post_tag_relation, 8) }
  let!(:favorites) { create_list(:favorite, 7 ) }
  let!(:posts) { create_list(:post, 7)}

  describe "topページ" do
    before do
      visit root_path
    end

    it "カテゴリーボタンをクリックすると各カテゴリーに紐づく投稿が表示されること" do
      post_tag_relations.each do |post_tag_relation|
        visit root_path
        click_on post_tag_relation.post.category.name
        expect(page).to have_content post_tag_relation.post.title
        expect(current_path).to eq posts_path
      end
    end

    it "人気のタグが7件まで表示され、タグをクリックすると各タグに紐づく投稿が表示されること" do
      post_tag_relations.first(7).each do |post_tag_relation|
        visit root_path
        click_button post_tag_relation.tag.name
        expect(page).to have_content post_tag_relation.post.title
        expect(current_path).to eq posts_path
      end
      visit root_path
      expect(page).to have_no_link post_tag_relations[7].tag.name
    end

    it "人気の投稿が6件まで表示され、「もっと見る」を押すと7件目以降の投稿が表示されること" do
      within('.favorite-contents') do
        favorites.last(6) do |favorite|
          expect(page).to have_content favorite.post.title
        end
        expect(page).to have_no_content favorites[0].post.title
        click_on "もっと見る"
      end
      expect(current_path).to eq posts_path
      expect(page).to have_content favorites[0].post.title
    end

    it "新着投稿が6件まで表示され、「もっと見る」を押すと7件目以降の投稿が表示されること" do
      within('.new-contents') do
        posts.last(6) do |post|
          expect(page).to have_content post.title
        end
        expect(page).to have_no_content posts[0].title
        click_on "もっと見る"
      end
      expect(current_path).to eq posts_path
      expect(page).to have_content posts[0].title
    end
  end

  describe "ヘッダー" do
    before do
      visit root_path
    end

    it "ヘッダーの検索フォームでキーワード検索できること" do
      posts[0].title = "あいうえお"
      posts[0].save
      within('.search-form-3') do
        fill_in 'q[title_or_user_name_or_text_or_tags_name_cont]', with: 'あいうえお'
        click_button ""
      end
      expect(current_path).to eq posts_path
      expect(page).to have_content(posts[0].title)
    end

    describe "各メニューの遷移先" do
      context "「みんなのマイデザイン」をクリックした場合" do
        it "ホーム画面に遷移すること" do
          visit posts_path
          click_on "みんなのマイデザイン"
          expect(current_path).to eq root_path
        end
      end
      context "「マイデザイン」をクリックした場合" do
        it "投稿一覧画面に遷移すること" do
          click_on "マイデザイン"
          expect(current_path).to eq posts_path
        end
      end
      context "「ユーザー」をクリックした場合" do
        it "ユーザー一覧画面に遷移すること" do
          click_on "ユーザー"
          expect(current_path).to eq users_path
        end
      end
    end

    describe "ログイン前" do
      before do
        visit root_path
      end

      describe "表示されるメニュー項目" do
        it "「マイデザイン」「ユーザー」「ログイン」「新規登録」だけが表示されること" do
          within(".navber-list") do
            expect(page).to have_content("マイデザイン")
            expect(page).to have_content("ユーザー")
            expect(page).to have_content("ログイン")
            expect(page).to have_content("新規登録")
            expect(page).to have_no_content("投稿する")
            expect(page).to have_no_content("マイページ")
            expect(page).to have_no_content("ユーザー編集")
            expect(page).to have_no_content("ログアウト")
            expect(page).to have_no_content("退会手続き")
          end
        end
      end

      describe "各メニューの遷移先" do
        context "「ログイン」をクリックした場合" do
          it "ログイン画面に遷移すること" do
          click_on "ログイン"
          expect(current_path).to eq new_user_session_path
          end
        end
        context "「新規登録」をクリックした場合" do
          it "新規登録画面に遷移すること" do
            click_on "新規登録"
            expect(current_path).to eq new_user_registration_path
          end
        end
      end
    end

    describe "ログイン後" do
      let(:user) { create(:user) }

      before do
        visit new_user_session_path
        fill_in "メールアドレス", with: user.email
        fill_in "パスワード", with: user.password
        click_button "ログインする"
      end

      describe "表示されるメニュー項目" do
        it "「マイデザイン」「ユーザー」、ユーザーのアイコン、「投稿する」「マイページ」「ユーザー編集」「ログアウト」「退会手続き」だけが表示されること" do
          within(".navber-list") do
            expect(page).to have_content("投稿する")
            expect(page).to have_content("マイデザイン")
            expect(page).to have_content("ユーザー")
            expect(page).to have_selector("img[src$='/assets/user-default-icon-3098d9a3fc78d14165cd2a39c455c753bb05f1d9e14c54ac77f8db088010c6c8.png']")
            find('.dropdown-toggle').click
            expect(page).to have_content("マイページ")
            expect(page).to have_content("ユーザー編集")
            expect(page).to have_content("ログアウト")
            expect(page).to have_content("退会手続き")
            expect(page).to have_no_content("ログイン")
            expect(page).to have_no_content("新規登録")
          end
        end
      end

      describe "各メニューの遷移先" do
        context "「投稿する」をクリックした場合" do
          it "投稿画面に遷移すること" do
            click_on "投稿する"
            expect(current_path).to eq new_post_path
          end
        end
        context "「マイページ」をクリックした場合" do
          it "現在ログインしているユーザーのユーザー画面に遷移すること" do
            find('.dropdown-toggle').click
            click_on "マイページ"
            expect(current_path).to eq user_path(user.id)
          end
        end
        context "「ユーザー編集」をクリックした場合" do
          it "ユーザー編集画面にに遷移すること" do
            find('.dropdown-toggle').click
            click_on "ユーザー編集"
            expect(current_path).to eq edit_user_registration_path
          end
        end
      end
    end
  end

  describe "フッター" do
    before do
      visit root_path
    end
    
    context "「みんなのマイデザインとは？」をクリックした場合" do
      it "「みんなのマイデザイン」について説明している画面に遷移すること" do
        click_on "みんなのマイデザインとは？"
        expect(current_path).to eq about_path
      end
    end
    context "「利用規約」をクリックした場合" do
      it "利用規約画面に遷移すること" do
        click_on "利用規約"
        expect(current_path).to eq terms_path
      end
    end
    context "「プライバシーポリシー」をクリックした場合" do
      it "プライバシーポリシー画面に遷移すること" do
        click_on "プライバシーポリシー"
        expect(current_path).to eq policy_path
      end
    end
  end
end
