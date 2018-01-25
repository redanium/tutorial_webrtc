cmake_minimum_required( VERSION 3.2.0 FATAL_ERROR )
project( JanusApp )

set( BUILD_SHARED_LIBS True )

find_package( libwebrtc REQUIRED )
find_package( QtWebrtc  REQUIRED )

# NOTE ALEX: should be done in the UseQtWebrtc.cmake
if( WIN32 )
  find_library( QtWebrtcExportLib NAMES QtWebrtc PATHS ${QtWebrtc_LIBRARIES})

else( UNIX )
  message( STATUS ${QtWebrtc_SHARED_LIB} )
  message( STATUS ${QtWebrtc_STATIC_LIB} )
  if( BUILD_SHARED_LIBS )
    if( QtWebrtc_SHARED_LIB )
      set( QtWebrtc_LIBRARIES ${QtWebrtc_SHARED_LIB} )
    else()
      message( ERROR "You want a shared build, but i don't have QtWebrtc shared lib." )
    endif()
  else( )
    if( QtWebrtc_STATIC_LIB )
      set( QtWebrtc_LIBRARIES ${QtWebrtc_STATIC_LIB} )
    else()
      message( ERROR "You want a static build, but i don't have QtWebrtc static lib." )
    endif()
  endif( ) 
endif()

find_package( Qt5 COMPONENTS Quick Widgets REQUIRED )

# NOTE ALEX: this should not be needed, double check on linux
if( UNIX AND NOT APPLE )
  find_package( X11 REQUIRED )
  include_directories( ${X11_INCLUDE_DIR} )
endif()

set( CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -DQT_QML_DEBUG" )
if( NOT WIN32 )
  set( CMAKE_AUTOMOC_MOC_OPTIONS "-f${QtWebrtc_MOC_DEPS}" )
endif()
set( CMAKE_AUTOMOC ON )
set( CMAKE_AUTORCC ON )

add_executable( JanusApp main.cpp qml.qrc )
target_link_libraries( JanusApp 
  Qt5::Widgets
  Qt5::Quick
  ${WEBRTC_LIBRARIES}
 )
if( WIN32 )
  target_link_libraries( JanusApp ${QtWebrtcExportLib} )
  # Copy the Qt Wrapper dll
  add_custom_command(
    TARGET JanusApp POST_BUILD
    COMMAND ${CMAKE_COMMAND} -E copy
            "${QtWebrtc_BINARIES}/QtWebrtc.dll"
            $<TARGET_FILE_DIR:JanusApp>
  )
elseif( UNIX )
  target_link_libraries( JanusApp ${QtWebrtc_LIBRARIES} )
elseif( UNIX AND NOT APPLE )
  target_link_libraries( JanusApp
    ${X11_LIBRARIES}
    ${X11_Xcomposite_LIB}
    ${X11_Xdamage_LIB}
    ${X11_Xfixes_LIB}
  )
else()
  message( WARNING "You should not be here." )
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
include( CTest )

# -- Configurating the test
# add_test( JanusQtClient ${CMAKE_CTEST_COMMAND} 
#  --build-and-test  "${CMAKE_SOURCE_DIR}"
#                    "${CMAKE_BINARY_DIR}"
#  --build-generator ${CMAKE_GENERATOR}
#  --build-makeprogram ${CMAKE_MAKE_PROGRAM}
#  --build-project JanusApp
#  --test-command JanusApp
#  )
# set_property(
#  TEST JanusQtClient
#  PROPERTY ENVIRONMENT Qt5_DIR=${Qt5_DIR}
#  )
# target_link_libraries( JanusApp Qt5::Widgets Qt5::Quick ${QtWebrtc_LIBRARIES} )

add_test( TestJanusApp JanusApp )

