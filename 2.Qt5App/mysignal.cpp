#include <QPushButton>

 MainWindow::MainWindow(QWidget *parent)
    : QMainWindow(parent)
 {
  // Create the button, make "this" the parent
    m_button = new QPushButton("My Button", this);
   }