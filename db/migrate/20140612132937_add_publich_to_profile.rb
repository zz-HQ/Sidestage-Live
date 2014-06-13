class AddPublichToProfile < ActiveRecord::Migration
  def change
    add_column :profiles, :published, :boolean, default: false
    add_column :users, :about, :text
    add_column :users, :newsletter_subscribed, :boolean, default: false
  end
end
