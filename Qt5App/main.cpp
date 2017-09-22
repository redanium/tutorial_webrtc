#include <QApplication>
#include <QPushButton>


int main(int argc, char** argv){
  //Main application
  QApplication app(argc, argv);
  //A button with Quit as text
  QPushButton button("Quit");
 	
  //Main feature of Qt : Signal / Slot
  // Basically a Signal is an event
  // and the slot is a method called for that event
  //This is connecting the button to the method quit() of the app
  QObject::connect(&button,SIGNAL(clicked()), &app,SLOT(quit()));
  //Show the button
  button.show();
  return app.exec();
}
