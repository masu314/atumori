class RemovePostidFromUsers < ActiveRecord::Migration[6.1]
  def change
    remove_column :users, :post_id, :integer
  end
end
