
cmake_minimum_required(VERSION 3.25)
project(TestRockHopperStandards LANGUAGES C CXX)

list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_LIST_DIR}/../..)
include(RockHopperStandards)

# Add a library compiled with RockHopper's standards.
add_library(TestCompileFlags blank.cc)
target_rockhopper_standards(TestCompileFlags)

# Check the libraries compile options match RockHopper's standards.
get_target_property(_compile_options TestCompileFlags COMPILE_OPTIONS)
#
macro(require_compile_option __option)
  if(NOT "${_compile_options}" MATCHES ${__option})
    message(FATAL_ERROR "Not compiling with \"${__option}\"")
  endif()
endmacro()
#
if (CMAKE_CXX_COMPILER_ID STREQUAL "GNU" OR
    CMAKE_CXX_COMPILER_ID STREQUAL "Clang")

  require_compile_option("-Werror")
  require_compile_option("-Wall")
  require_compile_option("-Wextra")
  require_compile_option("-Wpedantic")
  require_compile_option("-Wconversion")
  require_compile_option("-Wshadow")
  require_compile_option("-Weffc\\\\+\\\\+")

endif()

# Check that RockHopper Standards' warnings option is defined and ON
if(NOT TEST_COMPILE_FLAGS_ENABLE_ROCKHOPPER_STANDARD_WARNINGS STREQUAL ON)
  message(FATAL_ERROR "Expected the cache option for RockHopper Standards' compiler warnings.")
endif()

# Check target_rockhopper_standards supports custom cache names
add_library(TestCacheNameCompileFlags blank.cc)
target_rockhopper_standards(TestCacheNameCompileFlags CACHE_NAME "TWCNCF")
#
if(NOT TWCNCF_ENABLE_ROCKHOPPER_STANDARD_WARNINGS STREQUAL ON)
  message(FATAL_ERROR "Expected the cache option for RockHopper Standards' compiler warnings.")
endif()
