cmake_minimum_required(VERSION 3.10)

set(CMAKE_CXX_STANDARD 11)

project(SitlRtspProxy)

add_definitions("-std=c++11 -Wall -Wextra -Werror")

find_package(PkgConfig)
pkg_check_modules(GST REQUIRED gstreamer-1.0>=1.4 gstreamer-rtsp-server-1.0>=1.4)

add_executable(sitl_rtsp_proxy main.cpp)

target_include_directories(sitl_rtsp_proxy SYSTEM PRIVATE
    ${GST_INCLUDE_DIRS}
)

target_link_libraries(sitl_rtsp_proxy
    ${GST_LIBRARIES}
)
