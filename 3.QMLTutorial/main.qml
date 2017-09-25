import QtQuick 2.0  
import QtQuick.Window 2.2
import QtQuick.Controls 1.4

Window {
  visible: true  
  Rectangle {  
    Text {
		id: myText
		text: "Hello World" 
		function changeText(text) {
		myText.text = text;
		}
    }  
  }
  Button {
	id : myButton
	text : "emit signal"
	anchors.centerIn: parent  
	signal buttonClicked(string text)
	onClicked: {
               myButton.buttonClicked.connect(myText.changeText)
               myButton.buttonClicked("Button Clicked")
            }
	}
}  
