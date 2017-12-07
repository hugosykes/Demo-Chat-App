$(document).ready(function() {
    
  var scheme = "ws://";
  var uri = scheme + window.document.location.host + '/';
  var ws = new WebSocket(uri);

  ws.onmessage = function(message) {
    var data = JSON.parse(message.data);
    $("#chat-text").append("<scan>Handle: " + data.handle + "\nMessage: " + data.text + "");
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
});