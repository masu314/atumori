class ChangeUserRelationshipsToFollowRelations < ActiveRecord::Migration[6.1]
  def change
    rename_table :user_relationships, :follow_relations
  end
end
