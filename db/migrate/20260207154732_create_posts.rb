class CreatePosts < ActiveRecord::Migration[8.0]
  def change
    create_table :posts do |t|
      t.string :title
      t.text :body
      t.datetime :published_at
      t.string :slug

      t.timestamps
    end

    add_index :posts, :slug, unique: true
    add_index :posts, :published_at
  end
end
