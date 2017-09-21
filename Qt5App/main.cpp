#include <QApplication>
#include <QPushButton>
#include <QLabel>

int main(int argc, char** argv){
	QApplication app(argc, argv);
    QPushButton *button = new QPushButton ("Hello World!");
 
	//QObject::connect(button,SIGNAL(clicked()), button,SLOT(quit()));

    return app.exec();
}
