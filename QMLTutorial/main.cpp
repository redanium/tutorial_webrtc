#include <QGuiApplication>
#include <QQmlApplicationEngine>

int main(int argc, char** argv){
	//Main application
	QGuiApplication app(argc, argv);


  QQmlApplicationEngine engine;
  engine.load(QUrl(QStringLiteral("qrc:HelloWorld.qml")));

  return app.exec();
}
