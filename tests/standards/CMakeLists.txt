
cmake_minimum_required(VERSION 3.25)
project(TestRockHopperStandards LANGUAGES C CXX)

list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_LIST_DIR}/../..)
include(RockHopperStandards)

# Add a library compiled with RockHopper's standards.
add_library(TestCompileFlags blank.cc)
target_rockhopper_standards(TestCompileFlags)

# Check that language extensions are disabled
foreach(LANG C CXX OBJC OBJCXX CUDA HIP)
  get_target_property(EXTENSTION_ENABLED TestCompileFlags ${LANG}_EXTENSIONS)
  if(EXTENSTION_ENABLED)
    message(FATAL_ERROR "${LANG} extensions are enabled.")
  endif()
endforeach()

# Check that the enable extensions options exist.
get_property(_project_languages GLOBAL PROPERTY ENABLED_LANGUAGES)
foreach(LANG ${_project_languages})
  if(TEST_COMPILE_FLAGS_ENABLE_${LANG}_EXTENSIONS)
    message(FATAL_ERROR "Expected ${LANG} language extensions to be off.")
  endif()
endforeach()

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
if(NOT TEST_COMPILE_FLAGS_ENABLE_ROCKHOPPER_STANDARD_WARNINGS)
  message(FATAL_ERROR "Expected the cache option for RockHopper Standards' compiler warnings.")
endif()

# Check target_rockhopper_standards supports custom cache names
add_library(TestCacheNameCompileFlags blank.cc)
target_rockhopper_standards(TestCacheNameCompileFlags CACHE_NAME "TWCNCF")
#
if(NOT TWCNCF_ENABLE_ROCKHOPPER_STANDARD_WARNINGS)
  message(FATAL_ERROR "Expected the cache option for RockHopper Standards' compiler warnings.")
endif()
