require 'rails_helper'

RSpec.describe "Users", type: :system do
  let(:user) { create(:user) }
  let!(:other_users) { create_list(:user, 3) }

  it "ユーザー一覧ページに全てのユーザーが表示されること" do
    visit users_path
    other_users.each do |other_user|
      expect(page).to have_content other_user.name
    end
  end

  it "投稿詳細ページが閲覧できること" do
    visit user_path(other_users[0].id)
    expect(page).to have_content other_users[0].name
    expect(current_path).to eq user_path(other_users[0].id)
  end

  describe "検索機能" do
    it "ユーザー名で検索できること" do
      other_users[0].name = "あいうえお"
      other_users[0].save
      visit users_path
      within('.search-form') do
        fill_in 'q[name_cont]', with: 'あいうえお'
      end
      click_button "検索"
      expect(page).to have_content(other_users[0].name)
    end

    describe "ユーザーの並び替えができること" do
      let!(:follow_relation) { create(:follow_relation, followed_id: other_users[2].id, follower_id: other_users[1].id) }
      let!(:post) { create(:post, user_id:other_users[0].id)}

      it "新着順に並び替えることができること" do
        other_users[2].created_at = Faker::Time.between(from: DateTime.now - 1, to: DateTime.now, format: :default)
        other_users[2].save
        visit users_path
        find("#q_sorts").find("option[value='created_at desc']").select_option
        click_button "検索"
        within('.user-list') do
          expect(page.text).to match(/#{other_users[1].name}[\s\S]*#{other_users[0].name}/)
        end
      end
      it "フォロワー数順番に並び替えることができること" do
        visit users_path
        find("#q_sorts").find("option[value='followers_count desc']").select_option
        click_button "検索"
        within('.user-list') do
          expect(page.text).to match(/#{other_users[2].name}[\s\S]*#{other_users[0].name}/)
        end
      end
      it "投稿数順に並び替えができること" do
        visit users_path
        find("#q_sorts").find("option[value='posts_count desc']").select_option
        click_button "検索"
        within('.user-list') do
          expect(page.text).to match(/#{other_users[0].name}[\s\S]*#{other_users[1].name}/)
        end
      end
    end
  end

  describe "ログイン前" do
    describe "ユーザーの新規登録" do
      before do
        visit new_user_registration_path
      end

      describe "通常の新規登録" do
        context "フォームの入力値が正常な場合" do
          it "ユーザーの新規登録が成功する" do
            fill_in "ユーザー名", with: "testuser"
            fill_in "メールアドレス", with: "email@example.com"
            fill_in "パスワード（6文字以上）", with: "password"
            fill_in "パスワード（確認用）", with: "password"
            click_button "登録する"
            expect(current_path).to eq root_path
            expect(page).to have_content 'アカウント登録が完了しました。'
          end 
        end
        context "登録済みのメールアドレスを使用" do
          it "ユーザーの新規作成が失敗する" do
            fill_in "ユーザー名", with: "testuser"
            fill_in "メールアドレス", with: user.email
            fill_in "パスワード（6文字以上）", with: "password"
            fill_in "パスワード（確認用）", with: "password"
            click_button "登録する"
            expect(current_path).to eq new_user_registration_path
            expect(page).to have_content 'メールアドレスは既に使用されています。'
          end
        end
        context "メールアドレスが未入力の場合" do
          it "ユーザーの新規作成が失敗する" do
            fill_in "ユーザー名", with: "testuser"
            fill_in "メールアドレス", with: ""
            fill_in "パスワード（6文字以上）", with: "password"
            fill_in "パスワード（確認用）", with: "password"
            click_button "登録する"
            expect(current_path).to eq new_user_registration_path
            message = page.find('#user_email').native.attribute('validationMessage')
            expect(message).to eq "このフィールドを入力してください。"
          end
        end
        context "ユーザー名が未入力の場合" do
          it "ユーザーの新規作成が失敗する" do
            fill_in "ユーザー名", with: ""
            fill_in "メールアドレス", with: "email@example.com"
            fill_in "パスワード（6文字以上）", with: "password"
            fill_in "パスワード（確認用）", with: "password"
            click_button "登録する"
            expect(current_path).to eq new_user_registration_path
            message = page.find('#user_name').native.attribute('validationMessage')
            expect(message).to eq "このフィールドを入力してください。"
          end
        end
        context "パスワードが未入力の場合" do
          it "ユーザーの新規作成が失敗する" do
            fill_in "ユーザー名", with: "testuser"
            fill_in "メールアドレス", with: "email@example.com"
            fill_in "パスワード（6文字以上）", with: ""
            fill_in "パスワード（確認用）", with: ""
            click_button "登録する"
            expect(current_path).to eq new_user_registration_path
            message = page.find('#user_password').native.attribute('validationMessage')
            expect(message).to eq "このフィールドを入力してください。"
          end
        end
        context "パスワード（6文字以上）だけ入力した場合" do
          it "ユーザーの新規作成が失敗する" do
            fill_in "ユーザー名", with: "testuser"
            fill_in "メールアドレス", with: "email@example.com"
            fill_in "パスワード（6文字以上）", with: "password"
            fill_in "パスワード（確認用）", with: ""
            click_button "登録する"
            expect(current_path).to eq new_user_registration_path
            message = page.find('#user_password_confirmation').native.attribute('validationMessage')
            expect(message).to eq "このフィールドを入力してください。"
          end
        end
        context "パスワードが６文字未満の場合" do
          it "ユーザーの新規作成が失敗する" do
            fill_in "ユーザー名", with: "testuser"
            fill_in "メールアドレス", with: "email@example.com"
            fill_in "パスワード（6文字以上）", with: "test"
            fill_in "パスワード（確認用）", with: "test"
            click_button "登録する"
            expect(current_path).to eq new_user_registration_path
            expect(page).to have_content 'パスワードは6文字以上に設定して下さい。'
          end
        end
      end

      describe "Twitterでの新規登録" do
        before do
          OmniAuth.config.mock_auth[:twitter] = nil
        end

        context 'ユーザーがTwitter認証を許可した場合' do
          it '登録が成功する' do
            Rails.application.env_config['omniauth.auth'] = twitter_mock
            click_button "Twitterで登録"
            expect(page).to have_content 'Twitter アカウントによる認証に成功しました。'
            expect(current_path).to eq root_path
          end
        end
        context "ユーザーがTwitter認証を許可しなかった場合" do
          it '登録が失敗する' do
            Rails.application.env_config['omniauth.auth'] = twitter_invalid_mock
            click_button "Twitterで登録"
            expect(page).to have_content 'Twitter アカウントによる認証に失敗しました。'
            expect(current_path).to eq new_user_session_path
          end
        end
      end
    end

    it "ユーザー情報を編集できないこと" do
      visit edit_user_registration_path
      expect(current_path).to eq new_user_session_path
      expect(page).to have_content 'アカウント登録もしくはログインしてください。'
    end
  end

  describe "ログイン" do
    before do
      visit new_user_session_path
    end

    context "フォームの入力値が正常な場合" do
      it "ログインが成功する" do
        fill_in "メールアドレス", with: user.email
        fill_in "パスワード", with: user.password
        click_button "ログインする"
        expect(current_path).to eq root_path
        expect(page).to have_content 'ログインしました。'
      end
    end
    context "フォームの入力値に誤りがある場合" do
      it "ログインが失敗する" do
        fill_in "メールアドレス", with: "miss_email@example.com"
        fill_in "パスワード", with: "miss_password"
        click_button "ログインする"
        expect(current_path).to eq new_user_session_path
        expect(page).to have_content 'メールアドレス もしくはパスワードが不正です。'
      end
    end
    context "フォームが未入力の場合" do
      it "ログインが失敗する" do
        fill_in "メールアドレス", with: ""
        fill_in "パスワード", with: ""
        click_button "ログインする"
        expect(current_path).to eq new_user_session_path
        expect(page).to have_content 'メールアドレス もしくはパスワードが不正です。'
      end
    end
  end

  describe "ログイン後" do
    before do
      visit new_user_session_path
      fill_in "メールアドレス", with: user.email
      fill_in "パスワード", with: user.password
      click_button "ログインする"
    end

    describe "ユーザー情報の編集" do
      before do
        visit edit_user_registration_path
      end
      
      context "フォームの入力値が正常の場合" do
        it "ユーザー情報の更新が成功する" do
          fill_in "ユーザー名", with: "edit_testuser"
          fill_in "メールアドレス", with: "edit_email@example.com"
          attach_file "アイコン画像", "#{Rails.root}/spec/fixtures/other-image.png"
          fill_in "フレンドコード", with: "SW-1111-1111-1111"
          fill_in "プロフィール", with: "edit_test"
          fill_in "パスワード（6文字以上）", with: "edit_password"
          fill_in "パスワード（確認用）", with: "edit_password"
          click_button "更新する"
          expect(current_path).to eq user_path(user.id)
          expect(page).to have_content 'アカウント情報を変更しました。'
        end
      end
      context "ユーザー名が何も入力されていない場合" do
        it "ユーザー情報の更新が失敗する" do
          fill_in "ユーザー名", with: ""
          click_button "更新する"
          expect(current_path).to eq edit_user_registration_path
          message = page.find('#user_name').native.attribute('validationMessage')
          expect(message).to eq "このフィールドを入力してください。"
        end
      end
      context "アイコン画像が5MBより大きいサイズの場合" do
        it "ユーザー情報の更新が失敗する" do
          attach_file "アイコン画像", "#{Rails.root}/spec/fixtures/big-size-image.jpeg"
          click_button "更新する"
          expect(current_path).to eq edit_user_registration_path
          expect(page).to have_content '画像は5MB以下である必要があります。'
        end
      end
      context "メールアドレスが何も入力されていない場合" do
        it "ユーザー情報の更新が失敗する" do
          fill_in "メールアドレス", with: ""
          click_button "更新する"
          expect(current_path).to eq edit_user_registration_path
          message = page.find('#user_email').native.attribute('validationMessage')
          expect(message).to eq "このフィールドを入力してください。"
        end
      end
      context "パスワード（6文字以上）だけ入力した場合" do
        it "ユーザー情報の更新が失敗する" do
          fill_in "パスワード（6文字以上）", with: "password"
          click_button "更新する"
          expect(current_path).to eq edit_user_registration_path
          expect(page).to have_content '確認用パスワードが内容とあっていません。'
        end
      end
      context "パスワードが6文字以下の場合" do
        it "ユーザー情報の更新が失敗する" do
          fill_in "パスワード（6文字以上）", with: "test"
          fill_in "パスワード（確認用）", with: "test"
          click_button "更新する"
          expect(current_path).to eq edit_user_registration_path
          expect(page).to have_content 'パスワードは6文字以上に設定して下さい。'
        end
      end
      context "フレンドコードが指定された形式で入力されていない場合" do
        it "ユーザー情報の更新が失敗する" do
          fill_in "フレンドコード", with: "test"
          click_button "更新する"
          expect(current_path).to eq edit_user_registration_path
          message = page.find('#user_friend_code').native.attribute('validationMessage')
          expect(message).to eq "指定されている形式で入力してください。"
        end
      end
    end

    it "ログアウトできること" do
      visit root_path
      find('.dropdown-toggle').click
      click_on "ログアウト"
      expect(current_path).to eq root_path
      expect(page).to have_content 'ログアウトしました。'
    end

    it "退会できること" do
      visit root_path
      find('.dropdown-toggle').click
      click_on "退会手続き"
      expect(current_path).to eq destroy_user_check_path
      click_button "退会する"
      expect do
        expect(page.accept_confirm).to eq "本当に退会しますか？"
        expect(page).to have_content 'アカウントを削除しました。またのご利用をお待ちしております。'
      end. to change(User, :count).by(-1)
    end
  end
end
