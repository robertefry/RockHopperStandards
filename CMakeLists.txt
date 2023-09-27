
cmake_minimum_required(VERSION 3.25)
project(RockHopperStandards VERSION 1.0.0 LANGUAGES NONE)

list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR})
include(RockHopperStandards)

enable_testing()
add_subdirectory(tests)
