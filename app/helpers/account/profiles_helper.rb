module Account::ProfilesHelper
  
  def link_to_publish_profile(profile)
    css_class = ["btn", "btn-accept"]
    css_class << "unpublishable disabled" unless profile.publishable?
    url = profile.publishable? ? toggle_account_profile_path(profile) : "#"
    method = profile.publishable? ? :put : :get
    link_to "Publish", url, method: method, class: css_class, disabled: !profile.publishable?
  end
  
end
