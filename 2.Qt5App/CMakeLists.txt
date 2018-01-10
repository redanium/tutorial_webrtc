cmake_minimum_required( VERSION 3.2.0 FATAL_ERROR )
project( QtFirstApp )

find_package(Qt5 COMPONENTS Widgets REQUIRED)

add_executable( QtFirstApp main.cpp )
target_link_libraries( QtFirstApp Qt5::Widgets )
