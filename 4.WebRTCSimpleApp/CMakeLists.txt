cmake_minimum_required( VERSION 3.3 )
project( SimpleApp )

# --- this does an incredible amount of magic
find_package( libwebrtc REQUIRED )

# --- The simple App
add_executable( SimpleApp SimpleApp.cc )
target_link_libraries( SimpleApp ${WEBRTC_LIBRARIES} )