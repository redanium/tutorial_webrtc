import QtQuick 2.6
import QtQuick.Window 2.2
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4

import QtWebSockets 1.0

// import CWebRTCStreamRenderer 1.0
import QWebRTCProxy 1.0

import "." // QTBUG-34418, singletons require explicit import to load qmldir file

Item {

  id: root

  property var noop: function(){}

  // login and room for Janus dispatcher API
  property string login:   ""
  property string room:    ""

  // a little helper for the connection to the Janus Wrapper
  property bool activatedWebSocket: false

  // session_id is unique across transactions and handles id
  property var session_id: 0

  // when we get new publisher ID, we need to create an handle for it
  // this keeps memory of the publisher ID based on the trasnsaction key
  property var publishers: []

  // indexed by handle_id
  property var pcs: []

  // --- outgoing signals
  signal sendingMessage(  string msg )
  signal messageReceived( string msg )
  signal logMessage(      string msg )

  // ---- stream signals
  signal addstream(    variant stream )
  signal removestream( variant stream )

  function subscribe( my_handle_id, my_offer )
  {
    // Create new peer Connections
    pcs[my_handle_id] = QWebRTCProxy.createPeerConnection();

    // wire everything up
    pcs[my_handle_id].onaddstream.connect(function(stream){
      addstream( stream )
    })
    pcs[my_handle_id].onicecandidate.connect(function(new_candidate){
      var msg = {
        janus: "trickle",
        candidate: new_candidate,
        handle_id: my_handle_id,
        session_id: session_id
      }
      sendMessage(msg)
    })
    pcs[my_handle_id].onsetremotedescriptionsuccess.connect(function(){
      console.log("pc.setRemoteDescription() | sucess");
      pcs[my_handle_id].createAnswer();
    })
    pcs[my_handle_id].oncreateanswersuccess.connect(function(answer){
      console.log("pc.createAnswer() | sucess");
      pcs[my_handle_id].setLocalDescription(answer);
      sendStart(my_handle_id, answer.sdp);
    })

    // Execute JSEP
    pcs[my_handle_id].setRemoteDescription( my_offer );  
  }

  function unsubscribe(feed,name) { 
    // HOMEWORK :-)
  }

  function sendStart(my_handle_id, my_sdp){
      var msg = {
        janus:      "message",
        session_id: session_id,
        handle_id:  my_handle_id,
        body: {
          request: "start",
          room:    1234
        },
        jsep: {
          sdp: my_sdp,
          type: "answer"
        }
      };
      sendMessage(msg,noop)
  }

  function sendLogin(){
    var msg = { janus: "create" };
    sendMessage(msg);
  }

  /**
   *  SIGNAL HANDLER: mark Websocket as Activated / Deactivated
   */
  signal activateWebSocket
  onActivateWebSocket: {
    if(activatedWebSocket){
      // nothing to do, already ON
    } else {
      activatedWebSocket = true
      janusWebSocketWrapper.active = true
    }
  }

  /**
   * Handle everything related to websockets:
   * - set up / login
   * - incoming messages
   * - outgoing messages
   * - dispatch by message type
   * - ...
   */
  WebSocket {
    property string serverUrl: "ws://janus1.cosmosoftware.io:8188"
    id:                        janusWebSocketWrapper
    url:                       serverUrl
    active:                    false

    onTextMessageReceived: {
      // send to main UI for display
      messageReceived(message)

      var msg = JSON.parse(message)
      console.log("<== " + message);

      // unknown type
      if(msg.janus === undefined){
        console.log("Unknown msg type.");
        return;
      }

      //Check response type
      switch(msg.janus) {
        case 'success':
          if( !msg.session_id ) { // answer to "create" with session_id
            session_id = msg.data.id;
            sendAttachPlugin()
            return;
          } else {                // answer to "attach" with handle_id
            if( !publishers[msg.transaction] ) {
               sendJoin(msg.data.id, "publisher")
            } else {
               sendJoin(msg.data.id, "listener", publishers[msg.transaction] )
            }
            return;
          }
          break;
        case 'event':
          parseEvent( msg );
          break;
        case 'ack':
        default:
          break;
      }
    }

    function parseEvent( msg ) {
      // 'joined'
      // subscribe to all publisher 
      if (msg.plugindata.data.publishers !== undefined){
        for (var publisher in msg.plugindata.data.publishers){
          var transaction = randomString(16)
          publishers[transaction] = msg.plugindata.data.publishers[publisher].id 
          sendAttachPlugin( transaction )
        }
      }
      if( msg.plugindata.data.videoroom === "attached" ) {
        console.log( msg.sender )
        subscribe( msg.sender, msg.jsep )
      }
    }    

    function sendJoin( my_handle_id, my_ptype, my_feed ) {
      var body = {
        request: "join",
        room:    1234,
        ptype:   my_ptype
      };
      if( my_ptype === "publisher" ) {
        body.display = "my_name";
      } else {
        body.feed = my_feed;
      }
      var msg = {
        janus:      "message",
        body:       body,
        session_id: session_id,
        handle_id:  my_handle_id
      };
      sendMessage(msg,noop)
    }

    function sendAttachPlugin(my_transaction){
      var msg = {
        janus:  "attach",
        plugin: "janus.plugin.videoroom",
        opaque_id: "videoroomtest-" + randomString(16),
        session_id: session_id
      };
      if( my_transaction !== undefined ) { msg.transaction = my_transaction }
      sendMessage(msg,noop)
    }

    /**
     * Handle wrapper status change (websocket open/close)
    */
    onStatusChanged: {
      console.log("Status Changed: "+janusWebSocketWrapper.status)
      if (janusWebSocketWrapper.status === WebSocket.Error) {
        console.log("Websocket error: " + janusWebSocketWrapper.errorString)
      } else if (janusWebSocketWrapper.status === WebSocket.Open) {
        logMessage('Websocket open.')
        console.log("Websocket open.")
        sendLogin()
      } else if (janusWebSocketWrapper.status === WebSocket.Closed) {
        console.log("Websocket closed.")
      } else {
        console.log("Websocket status yet unsupported.")
      }
    }
  } // end of websocket object

  // --------------------------------------------------------------------

  function sendMessage(message, callback)
  {
    if(!message["transaction"])
      message["transaction"] = randomString(16);
    // JS console
    console.log('==>', JSON.stringify(message));
    // My App console
    sendingMessage(JSON.stringify(message))
    // Janus
    janusWebSocketWrapper.sendTextMessage(JSON.stringify(message));
  }

  function randomString(len)
  {
    var charSet = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
    var randomString = '';
    for (var i = 0; i < len; i++) {
      var randomPoz = Math.floor(Math.random() * charSet.length);
      randomString += charSet.substring(randomPoz,randomPoz+1);
    }
    return randomString;
  }

  Component.onCompleted: {
    //Activate websocket
    activateWebSocket();
  }
}
