cmake_minimum_required( VERSION 3.2.0 FATAL_ERROR )
project( JanusApp )

find_package( libwebrtc REQUIRED )

find_package( Qt5 COMPONENTS Quick Widgets REQUIRED )

if( UNIX AND NOT APPLE )
  find_package( X11 REQUIRED )
  include_directories( ${X11_INCLUDE_DIR} )
endif()

set( CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -DQT_QML_DEBUG ")

set( CMAKE_AUTORCC ON )

# from QtWebrtc Install. To update to find_package ASAP.
#set( CMAKE_AUTOMOC_MOC_OPTIONS "-f/usr/local/include/moc_deps.h")

set( CMAKE_AUTOMOC ON )

# from QtWebrtc Install. To update to find_package ASAP.
include_directories( "/usr/local/include" )


add_executable( JanusApp
  main.cpp
  qml.qrc
  )

if( UNIX AND NOT APPLE )
  target_link_libraries( JanusApp
    Qt5::Widgets
    Qt5::Quick
    QtWebrtc
    ${WEBRTC_LIBRARIES}
    ${X11_LIBRARIES}
    ${X11_Xcomposite_LIB}
    ${X11_Xdamage_LIB}
    ${X11_Xfixes_LIB}
    )
else()
  target_link_libraries( JanusApp
    Qt5::Widgets
    Qt5::Quick
#    qt-demo # from QtWebrtc Install. To update to ${QTWEBRTC_LIBS} ASAP
    QtWebrtc
    ${WEBRTC_LIBRARIES}
  )
endif()
