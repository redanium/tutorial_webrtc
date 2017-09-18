include (installQtApp.cmake)

cmake_minimum_required( VERSION 3.2.0 FATAL_ERROR )
project( QtFirstApp )

# --- CMake specific variable to support Qt
set(CMAKE_INCLUDE_CURRENT_DIR ON)
set(CMAKE_AUTOMOC ON)

find_package(Qt5 COMPONENTS Widgets)

add_executable( QtFirstApp main.cpp)
qt5_use_modules( QtFirstApp Widgets )

target_link_libraries(QtFirstApp 
  Qt5::Widgets
  )

# --- Add the macro to deploy
installQtApp(QtFirstApp)