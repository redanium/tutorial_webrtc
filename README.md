# tutorial_webrtc


### Hello World ###

This example is to show the basics of CMake and how to compile a C++ file
We introduce these concepts

* project () 
* add_executable ()
* Configure with cmake ..
* Cross-platform compiling with cmake --build .

Steps :

```cd HelloWorld
mkdir MYBUILD && cd MYBUILD
cmake ..
cmake --build .
```


### Simple App ###

This example is to show the basics of CMake
We introduce these concepts

* project ()
* add_executable ()
* Configure with cmake ..
* Cross-platform compiling with cmake --build .

```
cd SimpleApp
mkdir MYBUILD && cd MYBUILD
cmake -G "Visual Studio 14 2015 Win64" ..
cmake --build .
```


### Qt Hello World ###

This example is to show the basics of Qt5
We introduce these concepts

* QApplication object
* find_package(Qt5 COMPONENTS Widgets)
* qt5_use_modules
* deployment on Windows

```
cd QtHelloWorld
mkdir MYBUILD && cd MYBUILD
cmake -DQt5_DIR=Path_to_Qt5 -G "NMake Makefiles" ..
nmake
```


