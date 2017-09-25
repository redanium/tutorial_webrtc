cmake_minimum_required( VERSION 3.2.0 FATAL_ERROR )
project( JanusApp )

find_package( libwebrtc REQUIRED )

find_package( Qt5 COMPONENTS Quick Widgets REQUIRED )
set( CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -DQT_QML_DEBUG ")

set( CMAKE_AUTORCC ON )

set( CMAKE_AUTOMOC_MOC_OPTIONS "-f/usr/local/include/moc_deps.h")
set( CMAKE_AUTOMOC ON )

include_directories( "/usr/local/include" )

add_executable( JanusApp
  main.cpp
  qml.qrc
  )
target_link_libraries( JanusApp
  Qt5::Widgets
  Qt5::Quick
  qt-demo
  )
