require(File.expand_path('../middlewares/comms_operator.rb', File.dirname(__FILE__)))

describe CommsOperator do

  username_WSID_directory = [
    { name: 'Hugo', WSID: nil },
    { name: 'Ollie', WSID: 1 },
    { name: 'Chris', WSID: 2 }
  ]
  
  let(:subject) { CommsOperator.new(username_WSID_directory) }
  
  let(:ws_incorrect) { double :ws, object_id: 1, send: nil}
  let(:ws_correct) { double :ws, object_id: 2, send: nil}
  let(:clients) { [ws_correct, ws_incorrect]}
  
  message = '{"senderName": "Ollie", "receiverName": "Chris", "text": "Hello", "error": false}'
  
  before (:each) do
    username_WSID_directory = [
      { name: 'Hugo', WSID: nil },
      { name: 'Ollie', WSID: 1 },
      { name: 'Chris', WSID: 2 }
    ]
  end

  it 'adds new usernames to the username_WSID_directory' do
    subject.add_username('Lucy', nil)
    expect(username_WSID_directory.last[:name]).to eq 'Lucy'
  end

  it 'searches username_WSID_directory for a recipient\'s name and returns their WSID' do
    expect(subject.find_WSID('Ollie')).to eq 1
  end

  it 'returns false if recipients name doesn\'t exist in the username_WSID_directory' do
    expect(subject.find_WSID('Lucy')).to eq false
  end

  it "should add user to WSID directory if message isn't 'genuine' (text != '')" do
    json = '{"senderName": "Lucy", "receiverName": "", "text":"", "error":false}'
    expect { subject.check_genuine_message(json, nil) }.to change { username_WSID_directory.length }.by(1)
    expect { subject.check_genuine_message(json, nil) }.to change { username_WSID_directory.length }.by(0)
  end

  it "should report that the message is true if it has text" do
    json = '{"senderName": "Lucy", "receiverName": "", "text":"tarah!", "error":false}'  
    expect(subject.check_genuine_message(json, nil)).to eq true
  end

  it 'should send message to Chris if senderName is Chris' do
    expect(ws_correct).to receive(:send)
    subject.send_message_to_correct_recipient(clients, message, nil)
  end

  it "should nillify Chris's WSID if he disconnects" do
    subject.disconnects(2)
    expect(username_WSID_directory[2]["Chris"]).to eq nil
  end
end
