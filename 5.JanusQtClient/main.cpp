#include "moc_deps.h"

#include <QGuiApplication>
#include <QQmlApplicationEngine>

// Qt - libebRTC wrapper
#include "QWebRTCProxy.h"
#include "PeerConnectionProxy.h"
#include "MediaStreamProxy.h"
#include "VideoTrackProxy.h"
#include "CWebRTCStreamRenderer.h"

int main(int argc, char *argv[])
{
  // normal mandatory start
  QGuiApplication app(argc, argv);

  // Prepare the libwebrtc objects for QML
  QWebRTCProxy::qmlRegisterType();
  qmlRegisterInterface<PeerConnectionProxy>("PeerConnectionProxy");

  qmlRegisterType<CWebRTCStreamRenderer>("CWebRTCStreamRenderer", 1, 0, "CWebRTCStreamRenderer");
  qmlRegisterInterface<VideoTrackProxy>("MediaStreamProxy");
  qmlRegisterInterface<VideoTrackProxy>("VideoTrackProxy");
  qmlRegisterInterface<RTPSenderProxy>("RTPSenderProxy");

  QQmlApplicationEngine engine;
  engine.load(QUrl(QStringLiteral("qrc:/main.qml")));

  return app.exec();
}
