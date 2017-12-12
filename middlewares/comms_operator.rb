class CommsOperator

  def initialize(dir = [])
    @username_WSID_directory = dir
  end

  def add_username(name, id)
    @username_WSID_directory.each { |user| return if !user[:name] }
    @username_WSID_directory.push({
      name: name, 
      WSID: id
    })
  end

  def find_WSID(name)
    @username_WSID_directory.each { |user| return user[:WSID] if user[:name] == name }
    false
  end

  def check_genuine_message(json, wsid)
    parsed_json = JSON.parse(json)
    if parsed_json["text"] == ""
      add_username(parsed_json["senderName"], wsid)
      return false
    end
    true
  end

  def send_message_to_correct_recipient(clients, message, wsid)
    return unless check_genuine_message(message, wsid)
    message = JSON.parse(message)
    ws_ids = [find_WSID(message["receiverName"]), find_WSID(message["senderName"])]
    clients.each do |client|
      if ws_ids.include?(client.object_id)
        client.send(JSON.stringify(message))
        # @username_WSID_directory.each { |user| p user[:name] if user[:WSID] == client.object_id }
      end
    end
  end

  def disconnects(name)
    @username_WSID_directory.each { |user| user[:WSID] = nil if user[:name] == name }
  end
end
