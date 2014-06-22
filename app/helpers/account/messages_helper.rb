module Account::MessagesHelper
  
  def deal_system_message_body(message)
    json = JSON.parse(message.body)
    customer = message.receiver_id == json["customer_id"].to_i ? message.receiver : message.sender
    artist = message.receiver == customer ? message.sender : message.receiver
    current_user_to_s = current_user == customer ? "customer" : "artist"
    raw t("view.messages.system_messages.deals.#{json['state']}.#{current_user_to_s}",  artists_path: artists_path, customer_name: customer.name)
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
