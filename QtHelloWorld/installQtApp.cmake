macro (installQtApp APPNAME)

#--------------------------------------------------------------
# Configure the Install Directories
#
# QT_DEMO_INSTALL_BIN_DIR          - binary dir (executables)
# QT_DEMO_INSTALL_LIB_DIR          - library dir (libs)
# QT_DEMO_INSTALL_DATA_DIR         - share dir (say, examples, data, etc)
# QT_DEMO_INSTALL_INCLUDE_DIR      - include dir (headers)
# QT_DEMO_INSTALL_CMAKE_DIR        - cmake files (cmake)

if( NOT QT_DEMO_INSTALL_BIN_DIR )
  set( QT_DEMO_INSTALL_BIN_DIR "bin" )
endif()
if( NOT QT_DEMO_INSTALL_LIB_DIR )
  set( QT_DEMO_INSTALL_LIB_DIR "lib" )
endif()
if( NOT QT_DEMO_INSTALL_DATA_DIR )
  set( QT_DEMO_INSTALL_DATA_DIR "share" )
endif()
if( NOT QT_DEMO_INSTALL_INCLUDE_DIR )
  set( QT_DEMO_INSTALL_INCLUDE_DIR "include" )
endif( )
if( NOT QT_DEMO_INSTALL_CMAKE_DIR )
  set( QT_DEMO_INSTALL_CMAKE_DIR "cmake" )
endif( )

install(
  TARGETS ${APPNAME} ${APPNAME}
  RUNTIME DESTINATION ${QT_DEMO_INSTALL_BIN_DIR}
  LIBRARY DESTINATION ${QT_DEMO_INSTALL_LIB_DIR} 
  COMPONENT Runtime   
  )



#-------------------------------------------------------------------------------
# Versioning
#
set( QT_DEMO_MAJOR_VERSION ${QT_DEMO_LATEST_RELEASE} )
set( QT_DEMO_MINOR_VERSION ${COMMITS_SINCE_RELEASE} )
set( QT_DEMO_BUILD_VERSION 0 ) # no patch for now
set( QT_DEMO_VERSION
  ${QT_DEMO_MAJOR_VERSION}.${QT_DEMO_MINOR_VERSION}.${QT_DEMO_BUILD_VERSION}
  )
set( QT_DEMO_API_VERSION
  # This is ITK/VTK style where SOVERSION is two numbers...
  "${QT_DEMO_MAJOR_VERSION}.${QT_DEMO_MINOR_VERSION}"
  )
set( QT_DEMO_LIBRARY_PROPERTIES ${QT_DEMO_LIBRARY_PROPERTIES}
  VERSION "${QT_DEMO_VERSION}"
  SOVERSION "${QT_DEMO_API_VERSION}"
  )

#-------------------------------------------------------------------------------
# only runtime items, this is not a dev package
#
include( InstallRequiredSystemLibraries )


#-------------------------------------------------------------------------------
if (WIN32 AND NOT CMAKE_CROSSCOMPILING AND NOT CMAKE_VERSION VERSION_LESS 3.1)
  # http://stackoverflow.com/a/24676432
  get_target_property (QT_QMAKE_EXECUTABLE Qt5::qmake IMPORTED_LOCATION)
  get_filename_component (QT_BIN_DIR "${QT_QMAKE_EXECUTABLE}" DIRECTORY)
  find_program (QT_WINDEPLOYQT_EXECUTABLE windeployqt HINTS "${QT_BIN_DIR}")
  if (QT_WINDEPLOYQT_EXECUTABLE)
    file (TO_NATIVE_PATH "${QT_BIN_DIR}" QT_BIN_DIR_NATIVE)
    # It's safer to use `\` separateors in the Path, but we need to escape them
    string (REPLACE "\\" "\\\\" QT_BIN_DIR_NATIVE "${QT_BIN_DIR_NATIVE}")

    list (APPEND QT_WINDEPLOYQT_FLAGS --no-compiler-runtime)
    list (APPEND QT_WINDEPLOYQT_FLAGS --qmldir ${CMAKE_SOURCE_DIR})

    install (CODE "
      message (STATUS \"Running Qt Deploy Tool...\")
      if (CMAKE_INSTALL_CONFIG_NAME STREQUAL \"Debug\")
        list (APPEND QT_WINDEPLOYQT_FLAGS --debug)
      else ()
        list (APPEND QT_WINDEPLOYQT_FLAGS --release)
      endif ()
      execute_process (
        COMMAND
         \"${QT_WINDEPLOYQT_EXECUTABLE}\"
         \${QT_WINDEPLOYQT_FLAGS}
   \"\${CMAKE_SOURCE_DIR}\\\\${APPNAME}.exe\"
      )
    ")
  
  endif ()
endif ()

add_custom_command(
    TARGET QtFirstApp
    POST_BUILD
    COMMAND ${CMAKE_COMMAND} --build ${CMAKE_BINARY_DIR} --target install
    )

endmacro(installQtApp)