class AddColumnToPost < ActiveRecord::Migration[6.1]
  def change
    add_column :posts, :favorites_count, :integer
  end
end
