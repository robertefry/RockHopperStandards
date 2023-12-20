
cmake_minimum_required(VERSION 3.25)
project(TestRockHopperAnalysers LANGUAGES C CXX)

list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_LIST_DIR}/../..)
include(RockHopperStandards)

# Add a library compiled with RockHopper's standards.
add_library(TestAnalysers blank.cc)
target_rockhopper_standards(TestAnalysers)
