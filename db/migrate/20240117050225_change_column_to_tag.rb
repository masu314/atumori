class ChangeColumnToTag < ActiveRecord::Migration[6.1]
    def up
      change_column :tags, :name, :string, null: false, collation: 'utf8mb4_bin'
    end
    def down
      change_column :tags, :name, :string, null: false
    end
end
