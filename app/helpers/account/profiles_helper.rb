module Account::ProfilesHelper
  
  def soundcloud_widget(iframe = nil)
    iframe = resource.soundcloud if iframe.blank?
    track_id = resource.soundcloud_id_from_iframe(iframe)
    return nil if track_id.blank?
    if resource.soundcloud.include?("users")
      iframe_src = "http#{ "s" unless browser.safari? }://w.soundcloud.com/player/?url=https://api.soundcloud.com/users/#{track_id}&auto_play=false&hide_related=false&show_comments=true&show_user=true&show_reposts=true&visual=true"
    elsif resource.soundcloud.include?("playlists")
      iframe_src = "http#{ "s" unless browser.safari? }://w.soundcloud.com/player/?url=https://api.soundcloud.com/playlists/#{track_id}&auto_play=false&hide_related=false&show_comments=true&show_user=true&show_reposts=true&visual=true"
    else
      iframe_src = "http#{ "s" unless browser.safari? }://w.soundcloud.com/player/?url=https://api.soundcloud.com/tracks/#{track_id}&auto_play=false&hide_related=false&show_comments=true&show_user=true&show_reposts=true&visual=true"
    end
    content_tag :iframe, nil, width: "100%", height: "350", scrolling: "no", frameborder: "no", src: iframe_src
  end

  def youtube_id
    resource.youtube[/^(?:https?:\/\/)?(?:www\.)?youtu(?:\.be|be\.com)\/(?:watch\?v=)?([\w-]{10,})/, 1]
  end

  def youtube_widget
    youtube_src = "//www.youtube.com/embed/#{youtube_id}?rel=0"
    content_tag :iframe, nil, width: "100%", height: "350", scrolling: "no", frameborder: "no", src: youtube_src
  end
  
end