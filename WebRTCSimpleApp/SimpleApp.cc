#include "webrtc/api/peerconnectioninterface.h"

int main(int argc, char** argv) {

  rtc::scoped_refptr<webrtc::PeerConnectionFactoryInterface>
  peer_connection_factory = webrtc::CreatePeerConnectionFactory();

  return 0;
}
