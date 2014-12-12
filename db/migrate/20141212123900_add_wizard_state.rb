class AddWizardState < ActiveRecord::Migration
  
  def self.up
    add_column :profiles, :wizard_state, :string
    add_column :profiles, :published_at, :datetime
    Profile.update_all wizard_state: Profile::WIZARD_STEPS.join(",")
    Profile.where(published: true).update_all("published_at = created_at")
    remove_column :profiles, :published, :boolean
  end
  
  def self.down
    remove_column :profiles, :wizard_state
    add_column :profiles, :published, :boolean
    Profile.where("published_at IS NOT NULL").update_all published: true
    remove_column :profiles, :published_at
  end
  
end
