# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

clothes = Category.create(name: '服')
caps = Category.create(name: '帽子')
face_paint = Category.create(name: 'フェイスペイント')
accessories = Category.create(name: '小物')
ground = Category.create(name: '地面')
furniture = Category.create(name: '家具')
others = Category.create(name: 'その他')

['シャツ', 'パーカー', 'セーター', 'アウター', 'ワンピース', 'ドレス', '着物', 'その他'].each do |name|
  clothes.children.create(name: name)
end

['つば付きキャップ', 'ニットキャップ', 'つば付きハット', 'その他'].each do |name|
  caps.children.create(name: name)
end


['眉毛', '前髪', 'その他'].each do |name|
  face_paint.children.create(name: name)
end


['傘', 'うちわ', '手旗', 'スマホケース', 'その他'].each do |name|
  accessories.children.create(name: name)
end


['レンガ', 'タイル', '石畳', 'ウッドデッキ', '道路', 'ラグ', 'その他'].each do |name|
  ground.children.create(name: name)
end


['顔出し看板', '屋台', '看板', 'パネル', 'その他'].each do |name|
  furniture.children.create(name: name)
end

User.crete(name:'testuser', email: 'test@test', passward: "testtest")
Post.create(title: 'test', author_id: 'MA-1111-1111-1111', work_id: 'MO-A1A1-A1A1-A1A1, user_id: 1,
category_id: 9')
