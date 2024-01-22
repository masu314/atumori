require 'rails_helper'

RSpec.describe Post, type: :model do
  let!(:post) {create(:post)}

  it "user_idがない場合、無効である" do
    post.user_id = nil
    expect(post.valid?).to eq false
  end

  it "titleがない場合、無効である" do
    post.title = ""
    expect(post.valid?).to eq false
  end

  it "titleが20字より多い場合、無効である" do
    post.title = "テスト" * 7
    expect(post.valid?).to eq false
  end

  it "category_idがない場合、無効である" do
    post.category_id = nil
    expect(post.valid?).to eq false
  end

  it "work_idがない場合、無効である" do
    post.work_id = ""
    expect(post.valid?).to eq false
  end

  it "author_idがない場合、無効である" do
    post.author_id = ""
    expect(post.valid?).to eq false
  end

  it "textが200字より多い場合、無効である" do
    post.text = "テストです" * 40 + "あ"
    expect(post.valid?).to eq false
  end

  it "imageがない場合、無効である" do
    post.image.purge
    expect(post.valid?).to eq false
  end
  
  it "imageが5MBより大きい場合、無効である" do
    post.image.attach(io: File.open('spec/fixtures/big-size-image.jpeg'), filename: 'big-size-image.jpeg')
    expect(post.valid?).to eq false
  end
end
