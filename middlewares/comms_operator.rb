class CommsOperator

  def initialize(dir = [])
    @username_WSID_directory = dir
  end

  def add_username(name)
    @username_WSID_directory.push({
      name: name, 
      WSID: nil
    })
  end

  def find_WSID(name)
    @username_WSID_directory.each { |user| return user[:WSID] if user[:name] == name }
    false
  end

  def check_genuine_message(json)
    parsed_json = JSON.parse(json)
    if parsed_json["text"] == ""
      add_username(parsed_json["senderName"])
      return false
    end
    true
  end

  def send_message_to_correct_recipient(clients, message)
    return unless check_genuine_message(message)
    message = JSON.parse(message)
    ws_ids = [find_WSID(message["receiverName"]), find_WSID(message["senderName"])]
    clients.each { |client| client.send(message) if ws_ids.include?(client.object_id) }
  end

  def disconnects(name)
    @username_WSID_directory.each { |user| user[:WSID] = nil if user[:name] == name }
  end
end
