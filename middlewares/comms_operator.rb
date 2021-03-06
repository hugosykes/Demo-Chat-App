class CommsOperator

  def initialize(dir = [])
    @username_WSID_directory = dir
  end

  def add_username(name, id)
    @username_WSID_directory.each { |user| p "BEFORE METHOD user: ", user[:name], ", and object_id: ", user[:WSID]}    
    @username_WSID_directory.each do |user|
      if user[:name] == name
        user[:WSID] = id
        return
      end
    end
    @username_WSID_directory.push({
      name: name, 
      WSID: id
    })
    @username_WSID_directory.each {|user| p "AFTER METHOD user: ", user[:name], ", and object_id: ", user[:WSID]}
  end

  def find_WSID(name)
    @username_WSID_directory.each { |user| return user[:WSID] if user[:name] == name }
    false
  end

  def check_genuine_message(json, wsid)
    parsed_json = JSON.parse(json)
    p "Check_genuine: parsed_json['text']: ", parsed_json["text"]
    if parsed_json["text"] == ""
      add_username(parsed_json["senderName"], wsid)
      return false
    end
    true
  end

  def send_message_to_correct_recipient(clients, message, ws)
    return unless check_genuine_message(message, ws.object_id)
    parsed_message = JSON.parse(message)
    clients.each { |client| client.send(message) if find_WSID(parsed_message["senderName"]) == client.object_id }
  end

  def disconnects(wsid)
    @username_WSID_directory.each_with_index { |user, idx| @username_WSID_directory[idx][:WSID] = nil if user[:WSID] == wsid }
  end
end
