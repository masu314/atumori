require 'rails_helper'

RSpec.describe "Posts", type: :system do
  let!(:other_posts) { create_list(:post, 3) }

  it "投稿一覧ページに全ての投稿が表示されること" do
    visit posts_path
    other_posts.each do |other_post|
      expect(page).to have_content other_post.title
      expect(page).to have_content other_post.user.name
    end
  end

  it "投稿詳細ページが閲覧できること" do
    visit post_path(other_posts[0].id)
    expect(page).to have_content other_posts[0].title
    expect(page).to have_content other_posts[0].work_id
    expect(page).to have_content other_posts[0].author_id
    expect(page).to have_content other_posts[0].created_at.strftime('%Y/%m/%d %H:%M')
    expect(page).to have_content other_posts[0].user.name
    expect(page).to have_button other_posts[0].category.name
    expect(current_path).to eq post_path(other_posts[0].id)
  end

  describe "ユーザーページ" do
    let!(:other_user) { create(:user) }
    let!(:other_user_posts) { create_list(:post, 3, user_id: other_user.id) }
    let!(:other_user_favorites) { create_list(:favorite, 3, user_id: other_user.id)}
    
    it "ユーザーに紐づいている投稿が全て表示されること" do
      visit user_path(other_user.id)
      other_user_posts.each do |other_user_post|
        expect(page).to have_content other_user_post.title
        expect(page).to have_content other_user_post.user.name
      end
    end

    it "ユーザーに紐づいているお気に入り投稿が全て表示されること" do
      visit user_path(other_user.id)
      find('label[for=TAB-02]').click
      other_user_favorites.each do |other_user_favorite|
        expect(page).to have_content other_user_favorite.post.title
        expect(page).to have_content other_user_favorite.user.name
      end
    end

    describe "検索機能" do
      let!(:search_category) { create(:category, name: "test") }

      it "投稿のカテゴリー検索ができること" do
        other_posts[0].category_id = search_category.id
        other_posts[0].save
         visit posts_path
         find("#search_category_id").find("option[value='#{search_category.id}']").select_option
         click_button "検索"
         expect(page).to have_content(other_posts[0].title)
      end
      it "投稿のキーワード検索ができること" do
        other_posts[1].title = "あいうえお"
        other_posts[1].save
        visit posts_path
        within('.search-form') do
          fill_in 'q[title_or_user_name_or_text_or_tags_name_cont]', with: 'あいうえお'
        end
        click_button "検索"
        expect(page).to have_content(other_posts[1].title)
      end
      describe "投稿の並び替えができること" do
        let!(:search_favorites) { create(:favorite, post_id: other_posts[0].id) }
      
        it "新着順に並び替えることができること" do
          other_posts[2].created_at = Faker::Time.between(from: DateTime.now - 1, to: DateTime.now, format: :default)
          other_posts[1].save
          visit posts_path
          find("#q_sorts").find("option[value='created_at desc']").select_option
          click_button "検索"
          within('.post-list') do
            expect(page.text).to match(/#{other_posts[1].title}[\s\S]*#{other_posts[0].title}/)
          end
        end
        it "人気順に並び替えることができること" do
          visit posts_path
          find("#q_sorts").find("option[value='favorites_count desc']").select_option
          click_button "検索"
          within('.post-list') do
            expect(page.text).to match(/#{other_posts[0].title}[\s\S]*#{other_posts[1].title}/)
          end
        end
      end
    end 
  end
  
  describe "ログイン前" do
    it "投稿できないこと" do
      visit new_post_path
      expect(current_path).to eq new_user_session_path
      expect(page).to have_content 'アカウント登録もしくはログインしてください。'
    end

    it "投稿を編集できないこと" do
      visit edit_post_path(other_posts[0].id)
      expect(current_path).to eq new_user_session_path
      expect(page).to have_content 'アカウント登録もしくはログインしてください。'
    end
  end

  describe "ログイン後" do
    let!(:user) { create(:user) }
    let!(:post) { create(:post, user_id: user.id) }
    let!(:category) { create(:category, name: "test_category2") }
  
    before do
      visit new_user_session_path
      fill_in "メールアドレス", with: user.email
      fill_in "パスワード", with: user.password
      click_button "ログインする"
    end

    describe "新規投稿" do
      context "フォームの入力値が正常な場合" do
        it "投稿できること" do
          visit new_post_path
          fill_in "タイトル", with: "test"
          attach_file "画像", "#{Rails.root}/spec/fixtures/other-image.png"
          fill_in "作品ID", with: "MO-1111-1111-1111"
          fill_in "作者ID", with: "MA-1111-1111-1111"
          find("#post_category_id").find("option[value='#{category.id}']").select_option
          click_button "投稿する"
          expect(current_path).to eq posts_path
          expect(page).to have_content '投稿しました'
        end
      end
      context "タイトルが未入力の場合" do
        it "投稿が失敗すること" do
          visit new_post_path
          fill_in "タイトル", with: ""
          attach_file "画像", "#{Rails.root}/spec/fixtures/other-image.png"
          fill_in "作品ID", with: "MO-1111-1111-1111"
          fill_in "作者ID", with: "MA-1111-1111-1111"
          find("#post_category_id").find("option[value='#{category.id}']").select_option
          click_button "投稿する"
          expect(current_path).to eq new_post_path
          message = page.find('#post_title').native.attribute('validationMessage')
          expect(message).to eq "このフィールドを入力してください。"
        end
      end
      context "画像が添付されていない場合" do
        it "投稿が失敗すること" do
          visit new_post_path
          fill_in "タイトル", with: "test"
          fill_in "作品ID", with: "MO-1111-1111-1111"
          fill_in "作者ID", with: "MA-1111-1111-1111"
          find("#post_category_id").find("option[value='#{category.id}']").select_option
          click_button "投稿する"
          expect(current_path).to eq new_post_path
          message = page.find('#post_image').native.attribute('validationMessage')
          expect(message).to eq "ファイルを選択してください。"
        end
      end
      context "画像が5MBより大きいサイズの場合" do
        it "投稿が失敗すること" do
          visit new_post_path
          fill_in "タイトル", with: "test"
          attach_file "画像", "#{Rails.root}/spec/fixtures/big-size-image.jpeg"
          fill_in "作品ID", with: "MO-1111-1111-1111"
          fill_in "作者ID", with: "MA-1111-1111-1111"
          find("#post_category_id").find("option[value='#{category.id}']").select_option
          click_button "投稿する"
          expect(current_path).to eq new_post_path
          expect(page).to have_content '画像は5MB以下である必要があります。'
        end
      end
      context "作品IDが未入力の場合" do
        it "投稿が失敗すること" do
          visit new_post_path
          fill_in "タイトル", with: "test"
          attach_file "画像", "#{Rails.root}/spec/fixtures/other-image.png"
          fill_in "作品ID", with: ""
          fill_in "作者ID", with: "MA-1111-1111-1111"
          find("#post_category_id").find("option[value='#{category.id}']").select_option
          click_button "投稿する"
          expect(current_path).to eq new_post_path
          message = page.find('#post_work_id').native.attribute('validationMessage')
          expect(message).to eq "このフィールドを入力してください。"
        end
      end
      context "作品IDが指定された形式で入力されなかった場合" do
        it "投稿が失敗すること" do
          visit new_post_path
          fill_in "タイトル", with: "test"
          attach_file "画像", "#{Rails.root}/spec/fixtures/other-image.png"
          fill_in "作品ID", with: "MA211113111151111"
          fill_in "作者ID", with: "MA-1111-1111-1111"
          find("#post_category_id").find("option[value='#{category.id}']").select_option
          click_button "投稿する"
          expect(current_path).to eq new_post_path
          message = page.find('#post_work_id').native.attribute('validationMessage')
          expect(message).to eq "指定されている形式で入力してください。"
        end
      end
      context "作者IDが未入力の場合" do
        it "投稿が失敗すること" do
          visit new_post_path
          fill_in "タイトル", with: "test"
          attach_file "画像", "#{Rails.root}/spec/fixtures/other-image.png"
          fill_in "作品ID", with: "MO-1111-1111-1111"
          fill_in "作者ID", with: ""
          find("#post_category_id").find("option[value='#{category.id}']").select_option
          click_button "投稿する"
          expect(current_path).to eq new_post_path
          message = page.find('#post_author_id').native.attribute('validationMessage')
          expect(message).to eq "このフィールドを入力してください。"
        end
      end
      context "作者IDが指定された形式で入力されなかった場合" do
        it "投稿が失敗すること" do
          visit new_post_path
          fill_in "タイトル", with: "test"
          attach_file "画像", "#{Rails.root}/spec/fixtures/other-image.png"
          fill_in "作品ID", with: "MO-1111-1111-1111"
          fill_in "作者ID", with: "MA-A299-K222-KAAA"
          find("#post_category_id").find("option[value='#{category.id}']").select_option
          click_button "投稿する"
          expect(current_path).to eq new_post_path
          message = page.find('#post_author_id').native.attribute('validationMessage')
          expect(message).to eq "指定されている形式で入力してください。"
        end
      end
      context "カテゴリーIDが未入力の場合" do
        it "投稿が失敗すること" do
          visit new_post_path
          fill_in "タイトル", with: "test"
          attach_file "画像", "#{Rails.root}/spec/fixtures/other-image.png"
          fill_in "作品ID", with: "MO-1111-1111-1111"
          fill_in "作者ID", with: "MA-1111-1111-1111"
          click_button "投稿する"
          expect(current_path).to eq new_post_path
          message = page.find('#post_category_id').native.attribute('validationMessage')
          expect(message).to eq "リスト内の項目を選択してください。"
        end
      end
    end

    describe "投稿の編集" do
      context "フォームの入力値が正常な場合" do
        it "編集できること" do
          visit edit_post_path(post.id)
          fill_in "タイトル", with: "edit_test"
          attach_file "画像", "#{Rails.root}/spec/fixtures/hut-image.png"
          fill_in "作品ID", with: "MO-1111-1111-1111"
          fill_in "作者ID", with: "MA-1111-1111-1111"
          find("#post_category_id").find("option[value='#{category.id}']").select_option
          click_button "更新する"
          expect(current_path).to eq post_path(post.id)
          expect(page).to have_content '更新しました'
        end
      end
      context "タイトルが空欄の場合" do
        it "編集が失敗すること" do
          visit edit_post_path(post.id)
          fill_in "タイトル", with: ""
          click_button "更新する"
          expect(current_path).to eq edit_post_path(post.id)
          message = page.find('#post_title').native.attribute('validationMessage')
          expect(message).to eq "このフィールドを入力してください。"
        end
      end
      context "画像が5MBより大きいサイズの場合" do
        it "編集が失敗すること" do
          visit edit_post_path(post.id)
          attach_file "画像", "#{Rails.root}/spec/fixtures/big-size-image.jpeg"
          click_button "更新する"
          expect(current_path).to eq edit_post_path(post.id)
          expect(page).to have_content '画像は5MB以下である必要があります。'
        end
      end
      context "作品IDが空欄の場合" do
        it "編集が失敗すること" do
          visit edit_post_path(post.id)
          fill_in "作品ID", with: ""
          click_button "更新する"
          expect(current_path).to eq edit_post_path(post.id)
          message = page.find('#post_work_id').native.attribute('validationMessage')
          expect(message).to eq "このフィールドを入力してください。"
        end
      end
      context "作品IDが指定された形式で入力されなかった場合" do
        it "編集が失敗すること" do
          visit edit_post_path(post.id)
          fill_in "作品ID", with: "MA211113111151111"
          click_button "更新する"
          expect(current_path).to eq edit_post_path(post.id)
          message = page.find('#post_work_id').native.attribute('validationMessage')
          expect(message).to eq "指定されている形式で入力してください。"
        end
      end
      context "作者IDが空欄の場合" do
        it "編集が失敗すること" do
          visit edit_post_path(post.id)
          fill_in "作者ID", with: ""
          click_button "更新する"
          expect(current_path).to eq edit_post_path(post.id)
          message = page.find('#post_author_id').native.attribute('validationMessage')
          expect(message).to eq "このフィールドを入力してください。"
        end
      end
      context "作者IDが指定された形式で入力されなかった場合" do
        it "編集が失敗すること" do
          visit edit_post_path(post.id)
          fill_in "作者ID", with: "MA-A299-K222-KAAA"
          click_button "更新する"
          expect(current_path).to eq edit_post_path(post.id)
          message = page.find('#post_author_id').native.attribute('validationMessage')
          expect(message).to eq "指定されている形式で入力してください。"
        end
      end
      context "カテゴリーIDが空欄の場合" do
        it "編集が失敗すること" do
          visit edit_post_path(post.id)
          find("#post_category_id").find("option[value='']").select_option
          click_button "更新する"
          expect(current_path).to eq edit_post_path(post.id)
          message = page.find('#post_category_id').native.attribute('validationMessage')
          expect(message).to eq "リスト内の項目を選択してください。"
        end
      end

      context "自分以外の投稿を編集する場合" do
        it "編集画面に遷移できず、投稿詳細画面にリダイレクトされること" do
          visit edit_post_path(other_posts[0].id)
          expect(current_path).to eq post_path(other_posts[0].id)
          expect(page).to have_content '他のユーザーの投稿は編集・削除できません'
        end
      end
    end

    it "投稿を削除できること" do
      visit post_path(post.id)
      click_button "削除"
      expect do
        expect(page.accept_confirm).to eq "本当に削除しますか？"
        expect(page).to have_content '投稿を削除しました'
        expect(current_path).to eq posts_path
      end. to change(Post, :count).by(-1)
    end
  end
end
