require 'rails_helper'

RSpec.describe Tag, type: :model do
  let(:tag){ create(:tag)}
  it "nameがない場合、無効である" do
    tag.name = ""
    expect(tag.valid?).to eq false
  end
end
