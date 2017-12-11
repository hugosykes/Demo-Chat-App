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
    add_username(parsed_json['senderName']) if parsed_json['text'] == ""
  end

  def send_message_to_correct_recipient(clients, message)
    receiver = message[:receiverName]
    wsid = find_WSID(receiver)
    clients.each { |client| client.send(message) if client.object_id == wsid }
  end

  def disconnects(name)
    @username_WSID_directory.each { |user| user[:WSID] = nil if user[:name] == name }
  end
end
