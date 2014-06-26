class CreateReviews < ActiveRecord::Migration
  def change
    create_table :reviews do |t|
      t.integer :author_id
      t.integer :profile_id
      t.integer :artist_id
      t.text :body
      t.integer :rate, limit: 1
      t.timestamps
    end
    add_index :reviews, :profile_id
    add_index :reviews, :author_id
    add_index :reviews, :artist_id
  end
end
