module Account::MessagesHelper
  
  def deal_system_message_body(message)
    json = JSON.parse(message.body)
    partner = message.sender == current_user ? message.receiver : message.sender
    current_user_to_s = current_user.id == json["current_user_id"].to_i ? "you" : "partner"
    raw t("view.messages.system_messages.deals.#{json['state']}.#{current_user_to_s}",  partner_name: partner.name, artists_path: artists_path)
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
