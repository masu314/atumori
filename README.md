## みんなのマイデザイン
![Atumori](https://github.com/masu314/atumori/assets/148468447/5bffde11-134b-404e-b4aa-cf91cfda5337)

## アプリURL
https://atumori-9091afc5e633.herokuapp.com/

## アプリ概要
「あつまれどうぶつの森」のマイデザインを共有できるアプリです。

## アプリの作成理由
「あつまれどうぶつの森」で作成されたマイデザインの公開は、一般的に Twitter でされることが多いです。しかし、Twitterだとカテゴリー検索ができないため、自分が欲しいマイデザインをスムーズに探せるように、カテゴリー検索機能があるマイデザイン共有サイトを作成しました。

## 機能一覧
* ユーザー登録、ログイン機能（devise）
* Twitter認証（omniauth-twitter）
* 投稿機能
* 検索機能（ransack）
* お気に入り登録機能
* フォロー機能
* タグ機能
* カテゴリー機能（ancestory,Ajax）

## 主なページ

| トップ画面 |
| ---- |
| ![Atumori-_1_](https://github.com/masu314/atumori/assets/148468447/2fbf2d32-3a68-4ba2-860a-3d18c4d8dbeb) | 
|Topページでは人気のタグや新着投稿、人気の投稿が確認できます。カテゴリーボタンから各カテゴリーのマイデザインを確認することもできます。


| ログイン画面 | 投稿画面 |
| ---- | ---- |
| ![Atumori (3)](https://github.com/masu314/atumori/assets/148468447/96950587-9b8c-42bd-9c51-d18cab38fec5) |　![Atumori (4)](https://github.com/masu314/atumori/assets/148468447/95c35cd9-d26c-4625-bd00-fc67e288a3b3) |
| Twitter認証でログインすることができます。 | 画像を添付フォームにはプレニュー機能を実装しました。カテゴリーは多階層になっており、親カテゴリーを選択すると、それに紐づく子カテゴリーが選択できます。 |

| 投稿一覧画面　| 投稿詳細画面 |
| ---- | ---- |
| ![Atumori (5)](https://github.com/masu314/atumori/assets/148468447/a674badf-8693-4a0a-9a7b-be7d5c6bea16) |　![Atumori (6)](https://github.com/masu314/atumori/assets/148468447/464d9b03-c318-4cb9-911f-ab4a435fb0d6) |
| 投稿一覧画面では検索機能を実装し、カテゴリーやキーワードでマイデザインを検索することができるようにしました。気になったマイデザインがあれば、お気に入り登録することができます。 | 詳細ページでは、作品IDと作者IDが確認できます。パンくずリストにはマイデザインが属しているカテゴリーが表示されます。カテゴリーやタグをクリックすると、各カテゴリーやタグに紐づくマイデザインを閲覧できます。|

| ユーザー一覧画面 | ユーザー詳細画面 |
| ---- | ---- |
| ![Atumori (7)](https://github.com/masu314/atumori/assets/148468447/e4908e62-23b3-4408-a707-a28caa9bc38e) | ![Atumori (8)](https://github.com/masu314/atumori/assets/148468447/c3e92f02-ba9a-4083-a9ed-0b11351fd2fb) |
| ユーザーを検索することができます。気になったユーザーがいればフォローすることもできます。 | ユーザーが投稿したマイデザインを確認できます。お気に入りタブからはお気に入り登録したマイデザインを確認できます。 |

| ユーザー編集画面 | 退会画面 |
| ---- | ---- |
| ![Atumori (9)](https://github.com/masu314/atumori/assets/148468447/f1eae4fa-25fc-4cbf-80dd-2299f91548ff) | ![Atumori (10)](https://github.com/masu314/atumori/assets/148468447/8a8ff199-4803-4341-9619-e236228b2556) |
| 編集画面からはアイコン画像やフレンドコードを設定することができます。 | 登録したユーザー情報を削除したい場合は、この画面から退会できます。 |

## 使用技術

#### バックエンド
- Ruby 3.0.4
- Rails 6.1.3.2
- RSpec
- Rubocop

#### フロントエンド
- HTML
- SCSS
- JavaScript（jQuery）

#### データベース
- MySQL 8.2.0

#### インフラストラクチャー
- Amazon S3
- Heroku

## テスト
* RSpec
  * モデルスペック
  * システムスペック

## ER図
![erd](https://github.com/masu314/atumori/assets/148468447/24f86678-e419-477f-9dc9-1d9b356673a2)

## 工夫した点

### カテゴリー機能
検索画面や投稿画面で、親カテゴリーが選択されたら、親カテゴリーに紐づく子カテゴリーが表示されるようにしました。
![2024-01-22-23 37 09](https://github.com/masu314/atumori/assets/148468447/233f09f2-eabd-4533-9d4c-558e456a0fcf)




