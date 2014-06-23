module Account::ProfilesHelper
  
  def link_to_publish_profile(profile)
    css_class = ["btn", "btn-accept"]
    css_class << "unpublishable disabled" unless profile.publishable?
    url = profile.publishable? ? toggle_account_profile_path(profile) : "#"
    method = profile.publishable? ? :put : :get
    link_to "Publish", url, method: method, class: css_class, disabled: !profile.publishable?
  end

  def has_soundcloud?
    !!soundcloud_id_from_iframe(resource.soundcloud)
  end

  def soundcloud_widget(iframe = nil)
    iframe = resource.soundcloud if iframe.blank?
    track_id = soundcloud_id_from_iframe(iframe)
    return nil if track_id.blank?
    iframe_src = "https://w.soundcloud.com/player/?url=https%3A//api.soundcloud.com/tracks/#{track_id}&amp;auto_play=false&amp;hide_related=false&amp;show_comments=true&amp;show_user=true&amp;show_reposts=true&amp;visual=true"
    content_tag :iframe, nil, width: "100%", height: "350", scrolling: "no", frameborder: "no", src: iframe_src
  end

private

  def soundcloud_id_from_iframe(iframe)
    begin
      iframe.scan(/https%3A\/\/api.soundcloud.com\/tracks\/(\d*)/)[0][0]  
    rescue Exception => e
      return nil
    end
  end
  
end
