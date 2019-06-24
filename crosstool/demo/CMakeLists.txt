cmake_minimum_required(VERSION 3.13)
project(demo)

set(CMAKE_CXX_STANDARD 14)

set(CMAKE_CXX_FLAGS "-static ${CMAKE_CXX_FLAGS}")

add_executable(demo
        hello.cpp)
