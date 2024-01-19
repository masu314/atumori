require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) {create(:user)}

  it "nameがない場合、無効である" do
    user.name = ""
    expect(user.valid?).to eq false
  end
  it "nameが20字より多い場合、無効である" do
    user.name = "テスト" * 7
    expect(user.valid?).to eq false
  end
  it "profileが200字より多い場合、無効である" do
    user.profile = "テストです" * 40 + "あ"
    expect(user.valid?).to eq false
  end
end
