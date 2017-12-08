$(document).ready(function() {

  var FayeWebSocket = require('faye-websocket');
    
  var scheme = "wss://";
  var uri = scheme + window.document.location.host + '/';
  var ws = new FayeWebSocket(uri);
  var messages = [];

  ws.onmessage = function(message) {
    var data = JSON.parse(message.data);
    $("#chat-text").append("<br><scan>" + data.handle + " says: " + data.text + "<br>");
  };

  function send() {
    var handle = $('#input-handle').val();
    var text = $("#input-text").val();
    ws.send(JSON.stringify({handle: handle, text: text }));
    $("#input-text").val('');
  }

  $('#input-text').keypress(function(event) {
    if (event.keyCode == '13') {
      send();
    }
  });

  $('#submit').click(function() {
    send();
  });
});