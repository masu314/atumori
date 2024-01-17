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

10.times do
  User.create!(
    name: Faker::Internet.unique.username(specifier: 1..20),
    email: Faker::Internet.unique.email,
    password: 'password',
    password_confirmation: 'password',
  )
end

20.times do
  post= Post.create!(title: 'test',
                    user_id: Faker::Number.within(range: 1..10),
                    category_id: Faker::Number.within(range: 8..39),
                    work_id: 'MO-K9FK-DR24-8WSD',
                    author_id: 'MA-4962-3953-4923')             
  post.image.attach(io: File.open(Rails.root.join('app/assets/images/post_image.JPG')), filename: 'post_image.JPG')
end

10.times do
  Favorite.create!(
    user_id: Faker::Number.within(range: 1..10),
    post_id: Faker::Number.within(range: 1..20)
  )
end

10.times do
  UserRelationship.create!(
    follower_id: Faker::Number.within(range: 1..10),
    followed_id: Faker::Number.within(range: 1..10)
  )
end
