cmake_minimum_required( VERSION 3.2.0 FATAL_ERROR )
project( QMLApp )

find_package( Qt5 COMPONENTS Quick Widgets REQUIRED )
set( CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -DQT_QML_DEBUG ")
set( CMAKE_AUTORCC ON )

add_executable( QMLApp main.cpp qml.qrc )
target_link_libraries( QMLApp Qt5::Widgets Qt5::Quick )
