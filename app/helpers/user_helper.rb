module UserHelper
  
  def profile_path
    current_user.profiles.count > 0 ? account_profile_path(current_user.profiles.first) : new_account_profile_path
  end

end
