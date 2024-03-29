
function(_target_rockhopper_compiler_extensions
  __target
  __cache_name
  __enabled
  )

  get_property(_project_languages GLOBAL PROPERTY ENABLED_LANGUAGES)
  foreach(LANG ${_project_languages})

    option(
      ${__cache_name}_ENABLE_${LANG}_EXTENSIONS
      "Enable the use of ${LANG} compiler extensions. (Not recommended; may lead to warning clashes)"
      ${__enabled})

    if(${__cache_name}_ENABLE_${LANG}_EXTENSIONS)
      _rockhopper_warning("Enabling ${LANG} extensions is not recomended.")
    endif()

    target_compile_definitions(${__target} PUBLIC
      ${LANG}_EXTENSIONS=${${__cache_name}_ENABLE_${LANG}_EXTENSIONS})

  endforeach()

endfunction()


function(_target_rockhopper_compiler_warnings
  __target
  __cache_name
  __disable_warning_promotion
  )

  option(
    ${__cache_name}_ENABLE_ROCKHOPPER_STANDARDS_WARNINGS
    "Enable RockHopper Standards' set of compiler warnings."
    ON)

  if(NOT ${${__cache_name}_ENABLE_ROCKHOPPER_STANDARDS_WARNINGS})

    _rockhopper_warning("Disabling RockHopper Standards' set of compiler warnings is not recommended.")
    return()

  endif()

  option(
    ${__cache_name}_DISABLE_ROCKHOPPER_STANDARDS_WARNING_PROMOTION
    "Disable promoting compiler warnings to errors."
    ${__disable_warning_promotion})

  if (CMAKE_CXX_COMPILER_ID STREQUAL "GNU" OR
      CMAKE_CXX_COMPILER_ID STREQUAL "Clang")

    if(NOT ${__cache_name}_DISABLE_ROCKHOPPER_STANDARDS_WARNING_PROMOTION)
      target_compile_options(${__target} PUBLIC -Werror)
    endif()

    target_compile_options(${__target} PUBLIC -Wall -Wextra -Wpedantic)
    target_compile_options(${__target} PUBLIC -Wshadow)
    target_compile_options(${__target} PUBLIC -Wnon-virtual-dtor)
    target_compile_options(${__target} PUBLIC -Woverloaded-virtual)
    target_compile_options(${__target} PUBLIC -Wno-ignored-optimization-argument)

    if(NOT ${__cache_name}_ENABLE_PROTOTYPING_MODE)
      target_compile_options(${__target} PUBLIC -Wunused)
      target_compile_options(${__target} PUBLIC -Wconversion)
      target_compile_options(${__target} PUBLIC -Wsign-conversion)
      target_compile_options(${__target} PUBLIC -Wold-style-cast)
      target_compile_options(${__target} PUBLIC -Wcast-align)
      target_compile_options(${__target} PUBLIC -Wdouble-promotion)
      target_compile_options(${__target} PUBLIC -Weffc++)
      target_compile_options(${__target} PUBLIC -Wnull-dereference)
    endif()

  elseif(CMAKE_CXX_COMPILER_ID STREQUAL "MSVC")

    _rockhopper_warning("The MSVC compiler is partially supported by RockHopper Standards")

    if(${__cache_name}_ENABLE_ROCKHOPPER_STANDARDS_WARNING_PROMOTION)
      target_compile_options(${__target} PUBLIC /WX)
    endif()

    target_compile_options(${__target} PUBLIC /Wall)

  else()
    _rockhopper_warning("Unsupported compiler ${CMAKE_CXX_COMPILER_ID}\
      Cannot set RockHopper Standards' set of compiler warnings.")
  endif()

endfunction()
