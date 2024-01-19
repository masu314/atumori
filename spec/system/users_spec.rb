require 'rails_helper'

RSpec.describe "Users", type: :system do
  let(:user) { create(:user) }

  describe "ログイン前" do
    describe "ユーザーの新規登録" do
      context "フォームの入力値が正常の場合" do
        it "ユーザーの新規登録が成功する" do
          visit new_user_registration_path
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
          visit new_user_registration_path
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
          visit new_user_registration_path
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
          visit new_user_registration_path
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
          visit new_user_registration_path
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
          visit new_user_registration_path
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
          visit new_user_registration_path
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
    it "ユーザー情報を編集できないこと" do
      visit edit_user_registration_path
      expect(current_path).to eq new_user_session_path
      expect(page).to have_content 'アカウント登録もしくはログインしてください。'
    end
  end

  describe "ログイン" do
    context "フォームの入力値が正常の場合" do
      it "ログインが成功する" do
        visit new_user_session_path
        fill_in "メールアドレス", with: user.email
        fill_in "パスワード", with: user.password
        click_button "ログインする"
        expect(current_path).to eq root_path
        expect(page).to have_content 'ログインしました。'
      end
    end
    context "フォームの入力値に誤りがある場合" do
      it "ログインが失敗する" do
        visit new_user_session_path
        fill_in "メールアドレス", with: "miss_email@example.com"
        fill_in "パスワード", with: "miss_password"
        click_button "ログインする"
        expect(current_path).to eq new_user_session_path
        expect(page).to have_content 'メールアドレス もしくはパスワードが不正です。'
      end
    end
    context "フォームが未入力の場合" do
      it "ログインが失敗する" do
        visit new_user_session_path
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
      context "フォームの入力値が正常の場合" do
        it "ユーザー情報の更新が成功する" do
          visit edit_user_registration_path
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
          visit edit_user_registration_path
          fill_in "ユーザー名", with: ""
          click_button "更新する"
          expect(current_path).to eq edit_user_registration_path
          message = page.find('#user_name').native.attribute('validationMessage')
          expect(message).to eq "このフィールドを入力してください。"
        end
      end
      context "メールアドレスが何も入力されていない場合" do
        it "ユーザー情報の更新が失敗する" do
          visit edit_user_registration_path
          fill_in "メールアドレス", with: ""
          click_button "更新する"
          expect(current_path).to eq edit_user_registration_path
          message = page.find('#user_email').native.attribute('validationMessage')
          expect(message).to eq "このフィールドを入力してください。"
        end
      end
      context "パスワード（6文字以上）だけ入力した場合" do
        it "ユーザー情報の更新が失敗する" do
          visit edit_user_registration_path
          fill_in "パスワード（6文字以上）", with: "password"
          click_button "更新する"
          expect(current_path).to eq edit_user_registration_path
          expect(page).to have_content '確認用パスワードが内容とあっていません。'
        end
      end
      context "パスワードが6文字以下の場合" do
        it "ユーザー情報の更新が失敗する" do
          visit edit_user_registration_path
          fill_in "パスワード（6文字以上）", with: "test"
          fill_in "パスワード（確認用）", with: "test"
          click_button "更新する"
          expect(current_path).to eq edit_user_registration_path
          expect(page).to have_content 'パスワードは6文字以上に設定して下さい。'
        end
      end
    end

    describe "フォロー機能" do
      let!(:other_user) { create(:user) }
      it "フォロー、フォロー解除ができること" do
        visit user_path(other_user.id)
        click_button "フォローする"
        expect(other_user.followers.count).to eq(1)
        expect(user.followings.count).to eq(1)
        click_button "フォロー中"
        expect(other_user.followers.count).to eq(0)
        expect(user.followings.count).to eq(0)
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
