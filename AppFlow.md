FLOW:  Bridging Websocket Connections & Throwing errors between Whisper Users

Each user has a unique password protected account name.

e.g. {Username: @Lucy,  WSID:  nil}

Sending First Message:

User: User logs into app
Client: Opens a websocket and sends User’s :name to the server.
Server App: Generates a unique Websocket ID (WSID) for user.

e.g. {Username: @Lucy,  WSID: xxxxxxxxxxxxxx}

User:  User sends a JSON message to server containing the recipient’s username and message details.

e.g. {send_to:  @Chris, sent_from: @Lucy,  body: ‘hello’,  error:  False, etc...}

Server App:  Searches for the recipient’s username within directory database.
 If recipient’s username matches a name in the directory the message is sent out via the message’s WSID .
If the recipient’s username doesn’t match a name in directory, the message isn’t sent and the app throws an error back to sender via the message’s WSID.

Receiving first message:

User2: User2 logs into app
Client2: Connects to the websocket and sends User2’s name: to the server.
Server App: Generates a unique Websocket ID (WSID) for user.
All messages on server addressed to User2 are automatically sent to User2 via
