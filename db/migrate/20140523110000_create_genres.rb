class CreateGenres < ActiveRecord::Migration
  def up
    create_table :genres do |t|
      t.string :name
      t.timestamps
    end
    create_table :genres_profiles, id: false do |t|
      t.integer :genre_id
      t.integer :profile_id
    end
    add_index :genres_profiles, [:genre_id, :profile_id]
    
    Genre.create_translation_table!
    ['Everything', 'Classical', 'Rock/pop', 'Singer/songwriter', 'Anything but country', 'DJs - mainstream', 'DJs - techno', 'Cover bands'].each do |g|
      Genre.create :name => g
    end
  end

  def down
    Genre.drop_translation_table!
    drop_table :genres_profiles
    drop_table :genres
  end

end
