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
    return parsed_json['text'] != ""
  end
end
