require(File.expand_path('../middlewares/comms_operator.rb', File.dirname(__FILE__)))

describe CommsOperator do
  username_WSID_directory = [
    { name: 'Hugo', WSID: nil },
    { name: 'Ollie', WSID: 10_101_010_101_010 }
  ]

  let(:subject) { CommsOperator.new(username_WSID_directory) }
  json = '{"senderName": "Lucy", "receiverName": "", "text":"", "error":false}'  

  it 'adds new usernames to the username_WSID_directory' do
    subject.add_username('Lucy')
    expect(username_WSID_directory.last[:name]).to eq 'Lucy'
  end

  it 'searches username_WSID_directory for a recipient\'s name and returns their WSID' do
    expect(subject.find_WSID('Ollie')).to eq 10_101_010_101_010
  end

  it 'returns false if recipients name doesn\'t exist in the username_WSID_directory' do
    expect(subject.find_WSID('Chris')).to eq false
  end

  it 'should check whether message is to set up user with WSID directory' do
    expect(subject.check_genuine_message(json)).to eq false
  end
end
