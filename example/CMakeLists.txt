
cmake_minimum_required(VERSION 3.12)

# ---- project ----
project("RockHopper Standards Example" VERSION "1.0.0" LANGUAGES "CXX"
  HOMEPAGE_URL "https://github.com/robertefry/RockHopperStandards"
  DESCRIPTION "An example usage of RockHopper Standards.")

# ---- dependency management via cpm ----
include(.cmake/get_cpm.cmake)

# ---- the only target ----
CPMAddPackage("gh:robertefry/RockHopperStandards@1.3.1")

set(BINARY_NAME "RockHopperStandardsExample")
add_executable(${BINARY_NAME} "")
target_rockhopper_standards(${BINARY_NAME})

add_custom_target(run-${BINARY_NAME}
  COMMAND $<TARGET_FILE:${BINARY_NAME}>
  DEPENDS ${BINARY_NAME})

target_include_directories(${BINARY_NAME}
  PUBLIC
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
    $<INSTALL_INTERFACE:include>
  PRIVATE
    ${CMAKE_CURRENT_SOURCE_DIR}/src)

file(GLOB_RECURSE BINARY_SOURCES
  "src/*.c" "src/*.cc" "src/*.cpp" "src/*.cxx")
target_sources(${BINARY_NAME} PRIVATE ${BINARY_SOURCES})
