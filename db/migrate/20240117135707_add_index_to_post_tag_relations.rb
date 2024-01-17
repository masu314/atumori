class AddIndexToPostTagRelations < ActiveRecord::Migration[6.1]
  def change
    add_index :post_tag_relations, [:post_id, :tag_id],unique: true
  end
end
