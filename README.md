# tutorial_webrtc


### CMake Tutorial ###

This example is to show the basics of CMake and how to compile a C++ file
We introduce these concepts

* project () 
* add_executable ()
* Configure with cmake ..
* Cross-platform compiling with cmake --build .

Steps :

```cd CMakeTutorial
cd MYBUILD
cmake ..
cmake --build .
```


### WebRTC simple app ###

This example is to show the basics of CMake
We introduce these concepts

* project ()
* add_executable ()
* Configure with cmake ..
* Cross-platform compiling with cmake --build .

```
cd SimpleApp
cd MYBUILD
cmake -G "Visual Studio 14 2015 Win64" ..
cmake --build .
```


### Qt5 App ###

This example is to show the basics of Qt5
We introduce these concepts

* QApplication object
* find_package(Qt5 COMPONENTS Widgets)
* qt5 link with module

```
cd QtHelloWorld
cd MYBUILD
cmake -DQt5_DIR=Path_to_Qt5 -G "Visual Studio 14 2015 Win64" ..
cmake --build .
```


