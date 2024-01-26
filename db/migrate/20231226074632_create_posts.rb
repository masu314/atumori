class CreatePosts < ActiveRecord::Migration[6.1]
  def change
    create_table :posts do |t|
      t.string :title
      t.string :image
      t.text :text
      t.string :work_id
      t.string :author_id

      t.timestamps
    end
  end
end
