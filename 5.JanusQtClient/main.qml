// QT Classes
import QtQuick 2.6
import QtQuick.Window 2.2
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4

// Our own QT Classes 
import CWebRTCStreamRenderer 1.0
import QWebRTCProxy 1.0

import "." // QTBUG-34418, singletons require explicit import to load qmldir file

// --- Main GUI Window
Window {

  // --- properties / members

  id: root       // id for reference by other QML objects

  visible: true  // wether the windows is visible

  width:  1280
  height: 1280

  title: qsTr("Simple Qt+webrtc+Janus Demo")

  property int nb_renderer: 0   // For display splitting

  CJanusVideoRoom{ id: webrtcroom } // The Janus-WebRTC widget 

  // --- Signals

  // receive msgs to print in the embedded console.
  signal addMessage(string msg)
  onAddMessage: { messagesField.append(msg) }

  // -- Functions

  function createRenderer( label ) {
    _videoWindow.visible = true
    nb_renderer = nb_renderer + 1;
    var widget = rendererComponent.createObject(_flow);
    widget.label = label;
    return widget.getRenderer();
  }

  // Find the renderer corresponding to provided id, and destroy it.
  // note that it destroys the underlying CWebRTCStreamRenderer object, and we
  // suppose that at that point, the rendering pipeline had been 
  // properly disconnected.
  function removeRenderer( label ) {
    for ( var i = 0 ; i < _flow.children.length; i++) {
      if ( _flow.children[i].label === label) {
        _flow.children[i].destroy();
        nb_renderer = nb_renderer - 1;
        return;
      }
    }
  }

  // -- GUI ELEMENTS 

  // top most GUI element
  // horizontal rectangle, with fields to enter
  // all informations related to Janus server login
  // upon clicking on the buton, delivers the info
  // to the Janus-WebRTC widget for action/login.
  Rectangle {
    id: controls
    width: parent.width
    height: 240
    anchors{
      top: parent.top
    }

  } // end of rectangle controls


  // A small Text Area
  // Print out all the messages received. Practically, a console / log area.
  Rectangle{
    id: messageArea
    anchors{
      // top: _videoWindow.bottom
      top:    controls.bottom
      bottom: parent.bottom
    }
    width: parent.width

    TextArea{
      id: messagesField
      width: parent.width
      height: parent.height
      anchors{
        left: parent.left
        top: parent.top
      }
      textFormat: TextEdit.AutoText
    }
  } // end of rectangle

  // The Area containing all the renderers for Remote Streams
  // The number of renderers is dynamic.
  // renderers are rendererComponents, and added as children
  // of _flow
  Window {
    id: _videoWindow
    width: 500 // root.width
    height: 500 // root.height
    visible: true
    color: "red"
    Rectangle {
      id: renderingArea
      color: "blue"
      anchors.fill: parent
      anchors.top: parent.top
      anchors.left: parent.left
      Flow {
        id: _flow
        anchors.fill: parent
        anchors.top: parent.top
        anchors.left: parent.left
      }
    }
    MouseArea {
      anchors.fill: parent
      onClicked: {
        if (_videoWindow.visibility === Window.FullScreen) {
          _videoWindow.showNormal()
        } else {
          _videoWindow.showFullScreen()
        }
      }
    } // endof MouseArea

  } // endof Window videoWindow

  // Holds a single renderer for a remote stream.
  // aware of the total number of renderers.
  // Basically an automatic sizeable wrapper
  // around CWebRTCStreamRenderer
  Component {
    id: rendererComponent

    Rectangle {
      property string stream_id : ""
      property real fpsCount : 0
      property int frameCount : 0
      property string label: ""
      height: parent.height / Math.ceil(Math.sqrt(nb_renderer));
      width:  parent.width  / Math.ceil(Math.sqrt(nb_renderer));
      color: "white"
      function getRenderer() { } // return _renderer }
      // the renderer in this rectangle
      // CWebRTCStreamRenderer {
      //   id: _renderer
      //   anchors{
      //     fill: parent
      //     margins: 2
      //   }
      //   onFrameUpdated:{ frameCount++; } // Compute FPS Helper
      // }
      Timer { // compute FPS
        interval: 1000
        repeat: true
        running: true
        onTriggered: {
          fpsCount = frameCount
          frameCount = 0
        }
      }
      Text { // renders label as overlay
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        text: label
        font.pixelSize: parent.height*0.1
        opacity: 0.8
        color: "white"
      }
      Text { // renders FPS as overlay
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        text: "FPS:"+fpsCount
        font.pixelSize: parent.height*0.1
        opacity: 0.8
        color: "white"
      }
    } // End of Rectangle
  } // End of Component

  Component.onCompleted: {
    webrtcroom.logMessage.connect(      addMessage )
    webrtcroom.sendingMessage.connect(  addMessage )
    webrtcroom.messageReceived.connect( addMessage )

    webrtcroom.addstream.connect( function(stream) {
      // Get first remote video track
      var videoTrack = stream.getVideoTracks()[0];
      // Create renderer for remote stream
      var renderer = createRenderer(videoTrack.id);
      // Render it
      renderer.setTrack(videoTrack);
    })
    webrtcroom.removestream.connect( function(stream) {
      // HOMEWORK :-)
    });
  }

}
