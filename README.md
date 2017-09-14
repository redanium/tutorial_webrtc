# tutorial_webrtc


### Hello World ###

This example is to show the basics of CMake and how to compile a C++ file
    - project () 
    - add_executable ()
    - Configure with cmake ..
    - Cross-platform compiling with cmake --build .

cd HelloWorld
mkdir MYBUILD && cd MYBUILD
cmake ..
cmake --build .


### Simple App ###

This example is to show the basics of CMake
project ()
add_executable ()
Configure with cmake ..
Cross-platform compiling with cmake --build .

cd SimpleApp
mkdir MYBUILD && cd MYBUILD
cmake -G "Visual Studio 14 2015 Win64" ..
cmake --build .
