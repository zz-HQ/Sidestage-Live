module UserHelper
  
  def profile_path
    current_user.profiles.first.present? && current_user.profiles.first.persisted? ? account_profile_path(current_user.profiles.first) : new_account_profile_path
  end

end
