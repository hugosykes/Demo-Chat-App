$(document).ready(function() {

  var scheme = "ws://";
  var uri = scheme + window.document.location.host + '/';
  var ws = new WebSocket(uri);
  var messages = [];

  ws.onmessage = function(message) {
    console.log(message)
    // var data = JSON.parse(message.data);
    // $("#chat-text").append("<br><scan>" + data);
  };

  function send() {
    var handle = $('#input-handle').val();
    var text = $("#input-text").val();
    ws.send(JSON.stringify({
      handle: handle,
      text: text
    }));
    $("#input-text").val('');
  }

  $('#input-text').keypress(function(event) {
    if (textSanitiser('#input-text') && event.keyCode == '13') {
      send();
    } else {
      textSanitiseError();
    }
  });

  $('#submit').click(function() {
    if (textSanitiser('#input-text')) {
      send();
    } else {
      textSanitiseError();
    }
  });

  function textSanitiser(text_input) {
    if (text_input.includes('<' || '>')) {
      return false;
    } else {
      return true;
    }
  }

  function textSanitiseError() {
    $("#chat-text").append("<br><scan> Text input not valid. Remove symbols and try again.");
  }

});
