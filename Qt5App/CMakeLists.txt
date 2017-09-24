cmake_minimum_required( VERSION 3.2.0 FATAL_ERROR )
project( QtFirstApp )

message( STATUS “Qt5 Dir: ${Qt5Core_DIR}.” )
find_package(Qt5 COMPONENTS Widgets)
message( STATUS “Qt5 Dir: ${Qt5Core_DIR}.” )

add_executable( QtFirstApp main.cpp )
target_link_libraries( QtFirstApp Qt5::Widgets )
