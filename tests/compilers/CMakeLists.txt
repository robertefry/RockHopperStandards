
cmake_minimum_required(VERSION 3.25)
project(TestRockHopperStandards_Compiler LANGUAGES C CXX)

list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_LIST_DIR}/../..)
include(RockHopperStandards)

# Add a library compiled with RockHopper's standards.
add_library(TRHS_Compilers_Flags blank.cc)
target_rockhopper_standards(TRHS_Compilers_Flags)

# Check that language extensions are disabled
foreach(LANG C CXX OBJC OBJCXX CUDA HIP)
  get_target_property(EXTENSTION_ENABLED TRHS_Compilers_Flags ${LANG}_EXTENSIONS)
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
get_target_property(_compile_options TRHS_Compilers_Flags COMPILE_OPTIONS)
#
macro(require_compile_option __option)
  if(NOT "${_compile_options}" MATCHES ${__option})
    message(FATAL_ERROR "Not compiling with \"${__option}\"")
  endif()
endmacro()
#
if (CMAKE_CXX_COMPILER_ID STREQUAL "GNU" OR
    CMAKE_CXX_COMPILER_ID STREQUAL "Clang")

  # require_compile_option("-Werror")
  require_compile_option("-Wall")
  require_compile_option("-Wextra")
  require_compile_option("-Wpedantic")
  require_compile_option("-Wconversion")
  require_compile_option("-Wshadow")
  require_compile_option("-Weffc\\\\+\\\\+")

endif()

# Check that RockHopper Standards' warnings option is defined and ON
if(NOT TRHS_COMPILERS_FLAGS_ENABLE_ROCKHOPPER_STANDARDS_WARNINGS)
  message(FATAL_ERROR "Expected the cache option for RockHopper Standards' compiler warnings.")
endif()

# Check target_rockhopper_standards supports custom cache names
add_library(TRHS_Compilers_FlagNames blank.cc)
target_rockhopper_standards(TRHS_Compilers_FlagNames CACHE_NAME "TRHSCFN")
#
if(NOT TRHSCFN_ENABLE_ROCKHOPPER_STANDARDS_WARNINGS)
  message(FATAL_ERROR "Expected the cache option for RockHopper Standards' compiler warnings.")
endif()
