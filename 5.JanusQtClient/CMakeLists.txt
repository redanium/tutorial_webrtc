cmake_minimum_required( VERSION 3.2.0 FATAL_ERROR )
project( JanusApp )

find_package( libwebrtc REQUIRED )
find_package( QtWebrtc  REQUIRED )

include_directories("${QtWebrtc_INCLUDE_DIRS}")
include_directories("${QtWebrtc_INCLUDE_BINARIES}")


find_file( QtWebrtcShared NAMES QtWebrtc HINTS ${QtWebrtc_BINARIES})
find_library( QtWebrtcStatic NAMES QtWebrtc PATHS ${QtWebrtc_LIBRARIES})

message (STATUS "lib ${QtWebrtcShared}")
message (STATUS "path ${QtWebrtc_BINARIES}")


find_package( Qt5 COMPONENTS Quick Widgets REQUIRED )

if( UNIX AND NOT APPLE )
  find_package( X11 REQUIRED )
  include_directories( ${X11_INCLUDE_DIR} )
endif()

set( CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -DQT_QML_DEBUG" )
# Not needed on Windows
#set( CMAKE_AUTOMOC_MOC_OPTIONS "-f${QtWebrtc_MOC_DEPS}" )
set( CMAKE_AUTOMOC ON )
set( CMAKE_AUTORCC ON )

add_executable( JanusApp main.cpp qml.qrc )
if( UNIX AND NOT APPLE )
  target_link_libraries( JanusApp
    Qt5::Widgets
    Qt5::Quick
    QtWebrtc
    ${WEBRTC_LIBRARIES}
    ${X11_LIBRARIES}
    ${X11_Xcomposite_LIB}
    ${X11_Xdamage_LIB}
    ${X11_Xfixes_LIB}
    )
else()
  target_link_libraries (JanusApp 
    Qt5::Widgets 
    Qt5::Quick 
    ${QtWebrtcStatic}
    ${WEBRTC_LIBRARIES} )
endif()

#-------------------------------------------------------------------------------
# only runtime items, this is not a dev package
#
include( InstallRequiredSystemLibraries )

if( WIN32 AND NOT CMAKE_CROSSCOMPILING AND NOT CMAKE_VERSION VERSION_LESS 3.1 )
  # Handling flags for windeployqt
  # -- handle Debug / Release dlls
  get_target_property (QT_QMAKE_EXECUTABLE Qt5::qmake IMPORTED_LOCATION)

  get_filename_component (QT_BIN_DIR "${QT_QMAKE_EXECUTABLE}" DIRECTORY)
  message (STATUS "${QT_QMAKE_EXECUTABLE}")
  # --- locate the windeployqt tool
  find_program( QT_WINDEPLOYQT_EXECUTABLE windeployqt HINTS "${QT_BIN_DIR}" )
  message (STATUS "${QT_BIN_DIR}")
  message (STATUS "${QT_WINDEPLOYQT_EXECUTABLE} ")
  if( CMAKE_BUILD_TYPE STREQUAL Debug )
    list( APPEND JanusApp_WINDEPLOYQT_FLAGS --debug )
  else()
    list( APPEND JanusApp_WINDEPLOYQT_FLAGS --release )
  endif()
  list (APPEND JanusApp_WINDEPLOYQT_FLAGS --no-compiler-runtime)
  list (APPEND JanusApp_WINDEPLOYQT_FLAGS --qmldir ${CMAKE_SOURCE_DIR})

  # Deploying
  add_custom_command(
    TARGET JanusApp 
    COMMAND ${QT_WINDEPLOYQT_EXECUTABLE} ${JanusApp_WINDEPLOYQT_FLAGS} JanusApp.exe
    )
endif()

enable_testing()
# --
# -- Configurating the test
add_test (JanusQtClient ${CMAKE_CTEST_COMMAND} 
    --build-and-test  "${CMAKE_SOURCE_DIR}"
                      "${CMAKE_BINARY_DIR}"
    --build-generator ${CMAKE_GENERATOR}
    --build-makeprogram ${CMAKE_MAKE_PROGRAM}
    --build-project JanusApp
    --test-command JanusApp
    )
set_property (TEST JanusQtClient
              PROPERTY ENVIRONMENT Qt5_DIR=${Qt5_DIR})