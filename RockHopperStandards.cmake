
include(RockHopperUtils)


function(_target_rockhopper_warnings __target __cache_name)

  option(
    ${__cache_name}_ENABLE_ROCKHOPPER_STANDARD_WARNINGS
    "Enable RockHopper Standards' set of compiler warnings."
    ON)

  if(NOT ${${__cache_name}_ENABLE_ROCKHOPPER_STANDARD_WARNINGS})

    message(NOTICE "Disabling RockHopper Standards' set of compiler warnings is not recommended.")

  else()

    if (CMAKE_CXX_COMPILER_ID STREQUAL "GNU" OR
        CMAKE_CXX_COMPILER_ID STREQUAL "Clang")

      target_compile_options(${__target} PUBLIC -Werror -Wall -Wextra)
      target_compile_options(${__target} PUBLIC -Wpedantic -Wconversion -Wshadow -Weffc++)
      target_compile_options(${__target} PUBLIC -Wno-unused)

    elseif(CMAKE_CXX_COMPILER_ID STREQUAL "MSVC")

      target_compile_options(${__target} PUBLIC /WX /Wall)

    else()
      message(NOTICE "Unsupported compiler ${CMAKE_CXX_COMPILER_ID}\
        Cannot set RockHopper Standards' set of compiler warnings.")
    endif()

  endif()

endfunction()


function(target_rockhopper_standards __target)

  _rockhopper_validate_target(${__target})
  _rockhopper_parse_exact_args(ARG "" "CACHE_NAME" "" ${ARGN})

  if(NOT ARG_CACHE_NAME)
    _rockhopper_cache_name(${__target} ARG_CACHE_NAME)
  endif()

  _target_rockhopper_warnings(${__target} ${ARG_CACHE_NAME})

endfunction()
