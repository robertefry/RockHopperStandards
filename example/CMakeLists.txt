
cmake_minimum_required(VERSION 3.12)

# ---- project ----
project("RockHopper Standards Example" VERSION "1.0.0" LANGUAGES "CXX"
  HOMEPAGE_URL "https://github.com/robertefry/RockHopperStandards"
  DESCRIPTION "An example usage of RockHopper Standards.")

# ---- dependency management via cpm ----
include(.cmake/get_cpm.cmake)

# FIXME: TO GET THE EXAMPLE WORKING OUTSIDE OF THIS PROJECT, UNCOMMENT THIS!
# CPMAddPackage("gh:robertefry/RockHopperStandards@1.x.x")

# FIXME: TO GET THE EXAMPLE WORKING OUTSIDE OF THIS PROJECT, DELETE THESE TWO LINES!
list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_LIST_DIR}/..)
include(RockHopperStandards)

# ---- the library ----
set(BINARY_NAME "RockHopperStandardsExampleLibrary")
add_library(${BINARY_NAME} SHARED "")

target_rockhopper_standards(${BINARY_NAME}
  CACHE_NAME "EXAMPLE_LIBRARY"
  EXPORT_HEADER_SOURCE "gen/export.h")

target_include_directories(${BINARY_NAME}
  PUBLIC
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
    $<INSTALL_INTERFACE:include>
  PRIVATE
    ${CMAKE_CURRENT_SOURCE_DIR}/src)

target_sources(${BINARY_NAME} PRIVATE src/library.cc)

# ---- the executable ----
set(BINARY_NAME "RockHopperStandardsExampleBinary")
add_executable(${BINARY_NAME} "")

target_rockhopper_standards(${BINARY_NAME}
  CACHE_NAME "EXAMPLE_BINARY")

target_link_libraries(${BINARY_NAME} PRIVATE RockHopperStandardsExampleLibrary)

add_custom_target(run-${BINARY_NAME}
  COMMAND $<TARGET_FILE:${BINARY_NAME}>
  DEPENDS ${BINARY_NAME})

target_include_directories(${BINARY_NAME}
  PUBLIC
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
    $<INSTALL_INTERFACE:include>
  PRIVATE
    ${CMAKE_CURRENT_SOURCE_DIR}/src)

target_sources(${BINARY_NAME} PRIVATE src/main.cc)
