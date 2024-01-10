# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

categpry1 = Category.create(name: '・お酒')
water, beer, sake, wine = drink.children.create(
  [
    { name: '水・ソフトドリンク' },
    { name: 'ビール・洋酒' },
    { name: '日本酒・焼酎' }
    { name: 'ワイン' }
  ]
)

['水・ミネラルウォーター', 'コーヒー', '野菜・果実飲料', 'お茶・紅茶', '炭酸飲料', 'スポーツドリンク'].each do |name|
  water.children.create(name: name)
end

['ビール・発泡酒', 'ウイスキー', 'チューハイ・ハイボール・カクテル'].each do |name|
  beer.children.create(name: name)
end

%w[焼酎 日本酒 梅酒].each do |name|
  sake.children.create(name: name)
end

['赤ワイン', '白ワイン', '飲み比べセット', 'スパークリングワイン・シャンパン'].each do |name|
  wine.children.create(name: name)
end
