class ChangeRelationshipsToUserRelationships < ActiveRecord::Migration[6.1]
  def change
    rename_table :relationships, :user_relationships
  end
end
