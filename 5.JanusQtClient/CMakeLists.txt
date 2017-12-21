cmake_minimum_required( VERSION 3.2.0 FATAL_ERROR )
project( JanusApp )

find_package( libwebrtc REQUIRED )
find_package( QtWebrtc  REQUIRED )
set( QtWebrtc_MOC_DEPS "/usr/local/include/moc_deps.h" )
set( QtWebrtc_LIBRARIES "QtWebrtc" )

find_package( Qt5 COMPONENTS Quick Widgets REQUIRED )
set( CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -DQT_QML_DEBUG" )
set( CMAKE_AUTOMOC_MOC_OPTIONS "-f${QtWebrtc_MOC_DEPS}" )
set( CMAKE_AUTOMOC ON )
set( CMAKE_AUTORCC ON )

add_executable( JanusApp main.cpp qml.qrc )
target_link_libraries( JanusApp Qt5::Widgets Qt5::Quick ${QtWebrtc_LIBRARIES} )
