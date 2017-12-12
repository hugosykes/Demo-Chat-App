class CommsOperator

  def initialize(dir = [])
    @username_WSID_directory = dir
  end

  def add_username(name, id)
    @username_WSID_directory.each {|user| puts "BEFORE METHOD user: ", user[:name], ", and object_id: ", user[:WSID]}    
    @username_WSID_directory.each { |user| return if !user[:name] }
    @username_WSID_directory.push({
      name: name, 
      WSID: id
    })
    @username_WSID_directory.each {|user| puts "AFTER METHOD user: ", user[:name], ", and object_id: ", user[:WSID]}
  end

  def find_WSID(name)
    @username_WSID_directory.each { |user| return user[:WSID] if user[:name] == name }
    false
  end

  def check_genuine_message(json, wsid)
    parsed_json = JSON.parse(json)
    puts "Check_genuine: parsed_json['text']: ", parsed_json["text"]
    if parsed_json["text"] == ""
      add_username(parsed_json["senderName"], wsid)
      return false
    end
    true
  end

  def send_message_to_correct_recipient(clients, message, ws)
    return unless check_genuine_message(message, ws.object_id)
    parsed_message = JSON.parse(message)
    ws_ids = [find_WSID(parsed_message["receiverName"]), find_WSID(parsed_message["senderName"])]
    clients.each { |client| client.send(message) if ws_ids.include?(client.object_id) }
    clients.each { |client| puts ("client.object_id upon sending: ", client.object_id) if ws_ids.include?(client.object_id) }
  end

  def disconnects(name)
    @username_WSID_directory.each { |user| user[:WSID] = nil if user[:name] == name }
  end
end
