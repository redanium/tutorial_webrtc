cmake_minimum_required( VERSION 3.2.0 FATAL_ERROR )
project( QMLApp )

# --- CMake specific variable to support Qt
find_package(Qt5 COMPONENTS Quick Widgets Qml REQUIRED)
# --- CMake specific variable to support Qt
set( CMAKE_INCLUDE_CURRENT_DIR ON )
set( CMAKE_AUTOMOC ON )
set( CMAKE_AUTOUIC ON )
set( CMAKE_AUTORCC ON )

add_executable( QMLApp 
  main.cpp
  )


target_link_libraries(QMLApp
  Qt5::Widgets
  Qt5::Quick
  )