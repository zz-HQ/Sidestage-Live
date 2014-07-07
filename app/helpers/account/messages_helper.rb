module Account::MessagesHelper
  
  def deal_system_message_body(message)
    json = JSON.parse(message.body)
    partner = message.sender == current_user ? message.receiver : message.sender
    current_user_to_s = current_user.id == json["current_user_id"].to_i ? "you" : "partner"

    t("view.messages.system_messages.deals.#{json['state']}.#{current_user_to_s}",  
      partner_name: partner.profile_name, 
      artist_path: artist_path(partner), 
      artists_path: artists_path,
      price: localized_price(json["price"], json["currency"]),
      event_date: l(json["event_date"].to_date, format: :event_date)).html_safe rescue ""
  end
  
  def system_message_body(message)
    json = JSON.parse(message.body)
    case json["source"]
    when "Deal"
      deal_system_message_body(message)
    else
      message.body
    end
  end
  
  def message_body(message)
    message.system_message? ? system_message_body(message) : message.body
  end
  
end
