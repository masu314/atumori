require 'rails_helper'

RSpec.describe Favorite, type: :model do
  let!(:favorite) { create(:favorite) }
  let(:favorite_dupulicate) { create(:favorite) }

  it "同じユーザーが同じ投稿にお気に入り登録した場合、無効である" do
    favorite_dupulicate.user_id = favorite.user_id
    favorite_dupulicate.post_id = favorite.post_id
    expect(favorite_dupulicate.valid?).to eq false
  end
end
