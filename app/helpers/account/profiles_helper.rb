module Account::ProfilesHelper
  
  def min_price_in_profile_location(profile)
    prices = []
    return prices.min if profile.location.blank?
    profile.contestant_prices.each do |contestant_profile|
      if contestant_profile.currency == profile.currency
        prices << contestant_profile.price
      else
        prices << price_in_current_currency(contestant_profile.price, contestant_profile.currency).round
      end
    end
    prices.min
  end
  
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
    content_tag :iframe, nil, width: "100%", height: "250", scrolling: "no", frameborder: "no", src: iframe_src
  end

  def youtube_id
    resource.youtube[/^(?:https?:\/\/)?(?:www\.)?youtu(?:\.be|be\.com)\/(?:watch\?v=)?([\w-]{10,})/, 1]
  end

  def youtube_widget
    youtube_src = "//www.youtube.com/embed/#{youtube_id}?rel=0&autoplay=0"
    content_tag :iframe, nil, width: "100%", height: "675", scrolling: "no", frameborder: "no", src: youtube_src
  end

  def youtube_thumbnail
    link_to "#", data: { lightbox: :html, target: "[data-container='yt-widget']" } do
        image_tag "https://img.youtube.com/vi/#{youtube_id}/hqdefault.jpg"
    end
  end

  def read_more_link(text, length = 220)
    if !text.blank? && text.size > length
        link = content_tag(:span, 'more', class: "toggle-about-text show-fulltext link")
        text = "#{truncate(strip_tags(text), length: length)} #{link}"
    else
        text = text
    end

    simple_format text
  end

  def read_less_link(text)
    link = content_tag(:span, '[^]', class: "toggle-about-text show-truncate link")
    text = "#{strip_tags(text)} #{link}"
    simple_format text
  end

  def play_button
    image_tag "icons/play_button.png", class: "play-btn"
  end

  def load_more?
    count = 0
    maxCount = 9

    count += resource.pictures.count
    count += 2 unless resource.youtube.blank?
    count += 2 unless resource.soundcloud.blank?

    count > maxCount
  end
  
  def profile_wizard_progress_icon(step)
    image_tag "icons/check_icon.png", id: profile_wizard_progress_icon_id(step), style: "display: #{@profile.step_persisted?(step) ? nil : "none;" }"
  end
  
  def profile_wizard_progress_icon_id(step)
    "profile_wizard_progress_icon_#{step}"
  end

end