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

['あつ森', 'たぬきち', 'つねきち', 'しずえ', 'atumori'].each do |name|
  User.create!(
    name: name,
    email: Faker::Internet.unique.email,
    password: 'password',
    password_confirmation: 'password',
    created_at: Faker::Time.between(from: DateTime.now - 100, to: DateTime.now, format: :default)
  )
end

['ゆき', 'りんご', 'みかん', 'おもち'].each do |name|
  User.create!(
    name: name,
    email: Faker::Internet.unique.email,
    password: 'password',
    password_confirmation: 'password',
    created_at: Faker::Time.between(from: DateTime.now - 100, to: DateTime.now, format: :default)
  )
end

['しらたま', 'カレー大好き', 'ゲーム好き', 'さくら', '太郎', 'ゆめ', 'こころ', 'まい', '勇次郎'].each do |name|
  User.create!(
    name: name,
    email: Faker::Internet.unique.email,
    password: 'password',
    password_confirmation: 'password',
    created_at: Faker::Time.between(from: DateTime.now - 100, to: DateTime.now, format: :default)
  )
end

['太郎', 'ゆめ', 'こころ', 'まい', '勇次郎'].each do |name|
  User.create!(
    name: name,
    email: Faker::Internet.unique.email,
    password: 'password',
    password_confirmation: 'password',
    created_at: Faker::Time.between(from: DateTime.now - 100, to: DateTime.now, format: :default)
  )
end

5.times do |n|
  post= Post.create!(title: "トップス#{n+1}",
                    user_id: Faker::Number.within(range: 1..18),
                    category_id: Faker::Number.within(range: 8..10),
                    work_id: 'MO-K9FK-DR24-8WSD',
                    author_id: 'MA-4962-3953-4923',
                    created_at: Faker::Time.between(from: DateTime.now - 100, to: DateTime.now, format: :default))
  post.image.attach(io: File.open(Rails.root.join('app/assets/images/shurts-image.png')), filename: 'shurts-image.png')
end

2.times do |n|
  post= Post.create!(title: "アウター#{n+1}",
                    user_id: Faker::Number.within(range: 1..18),
                    category_id: 11,
                    work_id: 'MO-A3FD-QD20-1S7D',
                    author_id: 'MA-6912-3953-4923',
                    created_at: Faker::Time.between(from: DateTime.now - 100, to: DateTime.now, format: :default))           
  post.image.attach(io: File.open(Rails.root.join('app/assets/images/coat-image.png')), filename: 'coat_image.png')
end

3.times do |n|
  post= Post.create!(title: "ワンピース#{n+1}",
                    user_id: Faker::Number.within(range: 1..18),
                    category_id: Faker::Number.within(range: 12..15),
                    work_id: 'MO-B9LK-FR24-8WSA',
                    author_id: 'MA-4262-3933-4923',
                    created_at: Faker::Time.between(from: DateTime.now - 100, to: DateTime.now, format: :default))             
  post.image.attach(io: File.open(Rails.root.join('app/assets/images/dress-image.png')), filename: 'dress-image.png')
end

5.times do |n|
  post= Post.create!(title: "帽子#{n+1}",
                    user_id: Faker::Number.within(range: 1..18),
                    category_id: Faker::Number.within(range: 16..19),
                    work_id: 'MO-DO29-AE44-9WSD',
                    author_id: 'MA-9962-3353-4913',
                    created_at: Faker::Time.between(from: DateTime.now - 100, to: DateTime.now, format: :default))             
  post.image.attach(io: File.open(Rails.root.join('app/assets/images/hut-image.png')), filename: 'hut-image.png')
end

3.times do |n|
  post= Post.create!(title: "フェイスペイント#{n+1}",
                    user_id: Faker::Number.within(range: 1..18),
                    category_id: Faker::Number.within(range: 20..22),
                    work_id: 'MO-K98K-DR14-8WSD',
                    author_id: 'MA-4962-3953-4923',
                    created_at: Faker::Time.between(from: DateTime.now - 100, to: DateTime.now, format: :default))             
  post.image.attach(io: File.open(Rails.root.join('app/assets/images/face-paint-image.png')), filename: 'face-paint_image.png')
end

3.times do |n|
  post= Post.create!(title: "小物#{n+1}",
                    user_id: Faker::Number.within(range: 1..18),
                    category_id: Faker::Number.within(range: 23..27),
                    work_id: 'MO-S9FK-SR24-8WSD',
                    author_id: 'MA-3062-5953-4923',
                    created_at: Faker::Time.between(from: DateTime.now - 100, to: DateTime.now, format: :default))             
  post.image.attach(io: File.open(Rails.root.join('app/assets/images/komono-image.png')), filename: 'komono-image.png')
end

5.times do |n|
  post= Post.create!(title: "地面#{n+1}",
                    user_id: Faker::Number.within(range: 1..18),
                    category_id: Faker::Number.within(range: 28..34),
                    work_id: 'MO-K3FK-DR24-8WSD',
                    author_id: 'MA-5962-2953-4923',
                    created_at: Faker::Time.between(from: DateTime.now - 100, to: DateTime.now, format: :default))             
  post.image.attach(io: File.open(Rails.root.join('app/assets/images/ground-image.png')), filename: 'ground0image.png')
end

5.times do |n|
  post= Post.create!(title: "家具#{n+1}",
                    user_id: Faker::Number.within(range: 1..18),
                    category_id: Faker::Number.within(range: 35..39),
                    work_id: 'MO-C9FK-JR24-8WSD',
                    author_id: 'MA-1962-3923-4923',
                    created_at: Faker::Time.between(from: DateTime.now - 100, to: DateTime.now, format: :default))             
  post.image.attach(io: File.open(Rails.root.join('app/assets/images/kagu-image.png')), filename: 'kagu0image.png')
end

2.times do |n|
  post= Post.create!(title: "その他#{n+1}",
                    user_id: Faker::Number.within(range: 1..18),
                    category_id: 7,
                    work_id: 'MO-P9FK-DR24-8WSD',
                    author_id: 'MA-4962-8953-4923',
                    created_at: Faker::Time.between(from: DateTime.now - 100, to: DateTime.now, format: :default))             
  post.image.attach(io: File.open(Rails.root.join('app/assets/images/other-image.png')), filename: 'other0image.png')
end

10.times do
  FollowRelation.create!(
    follower_id: Faker::Number.within(range: 1..18),
    followed_id: Faker::Number.within(range: 1..18)
  )
end

['ナチュラル', '可愛い', '和風', 'ゴシック', 'ロリータ', 'レトロ', 'ポップ','ハロウィーン', 'クリスマス',
 'バレンタイン', 'ウェディング', '星', 'ハート', 'リボン', 'お花', 'キャラクター', '秋', '夏', '冬', '春'].each do |name|
  Tag.create!(name: name)
end

20.times do 
  PostTagRelation.create!(
    post_id: Faker::Number.within(range: 1..33),
    tag_id: Faker::Number.within(range: 1..20)
  )
end

20.times do
  Favorite.create!(
    user_id: Faker::Number.within(range: 1..18),
    post_id: Faker::Number.within(range: 1..33)
  )
end
