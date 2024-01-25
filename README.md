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
| ![Atumori-_3_](https://github.com/masu314/atumori/assets/148468447/9cf0fe29-db93-489a-9d6b-39946634ab6f) | 
|Topページでは人気のタグや新着投稿、人気の投稿が確認できます。カテゴリーボタンから各カテゴリーのマイデザインを確認することもできます。


| ログイン画面 | 投稿画面 |
| ---- | ---- |
| ![Atumori (19)](https://github.com/masu314/atumori/assets/148468447/d4829763-bcaa-4c12-aad3-6df904d2f2cc) |![Atumori (12)](https://github.com/masu314/atumori/assets/148468447/abd663f1-e943-401a-9289-d6a978586173) |
| Twitter認証でログインすることができます。 | 画像を添付フォームにはプレニュー機能を実装しました。カテゴリーは多階層になっており、親カテゴリーを選択すると、それに紐づく子カテゴリーが選択できます。 |

| 投稿一覧画面　| 投稿詳細画面 |
| ---- | ---- |
| ![Atumori (13)](https://github.com/masu314/atumori/assets/148468447/b91488cd-a840-4471-b632-209ba229e2ea) |![Atumori (14)](https://github.com/masu314/atumori/assets/148468447/f9f8debe-6778-47e2-b637-10e3d9d8ae33) |
| 投稿一覧画面では検索機能を実装し、カテゴリーやキーワードでマイデザインを検索することができるようにしました。気になったマイデザインがあれば、お気に入り登録することができます。 | 詳細ページでは、作品IDと作者IDが確認できます。パンくずリストにはマイデザインが属しているカテゴリーが表示されます。カテゴリーやタグをクリックすると、各カテゴリーやタグに紐づくマイデザインを閲覧できます。|

| アカウント一覧画面 | ユーザー詳細画面 |
| ---- | ---- |
| ![Atumori (15)](https://github.com/masu314/atumori/assets/148468447/2d1ce12f-0e7b-4e28-bcf7-7ac1042557bd) | ![Atumori (16)](https://github.com/masu314/atumori/assets/148468447/8ba6ba1f-294d-4db5-82d1-82126815e148) |
| ユーザーを検索することができます。気になったユーザーがいればフォローすることもできます。 | ユーザーが投稿したマイデザインを確認できます。お気に入りタブからはお気に入り登録したマイデザインを確認できます。 |

| アカウント編集画面 | 退会画面 |
| ---- | ---- |
| ![Atumori (17)](https://github.com/masu314/atumori/assets/148468447/9fe20bbf-0853-4b1a-8ea5-45457928bb4d) | ![Atumori (18)](https://github.com/masu314/atumori/assets/148468447/17cf8d42-1fdd-4c21-8b15-e05dd340f06a) |
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




