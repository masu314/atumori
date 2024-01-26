class ChangeConfigFavoritesCountOfPosts < ActiveRecord::Migration[6.1]
  def change
    change_column :posts, :favorites_count, :integer, default: 0
  end
end
