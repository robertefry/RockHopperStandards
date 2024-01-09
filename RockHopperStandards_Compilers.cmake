
function(_target_rockhopper_compiler_extensions
  __target
  __cache_name
  )

  get_property(_project_languages GLOBAL PROPERTY ENABLED_LANGUAGES)
  foreach(LANG ${_project_languages})

    option(
      ${__cache_name}_ENABLE_${LANG}_EXTENSIONS
      "Enable the use of ${LANG} compiler extensions. (Not recomended; may lead to warning clashes)"
      OFF)

    if(${__cache_name}_ENABLE_${LANG}_EXTENSIONS)
      message(NOTICE "Enabling ${LANG} extensions is not recomended.")
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

    message(NOTICE "Disabling RockHopper Standards' set of compiler warnings is not recommended.")
    return()

  endif()

  option(
    ${__cache_name}_ENABLE_ROCKHOPPER_STANDARDS_WARNING_PROMOTION
    "Disable promoting compiler warnings to errors."
    $<NOT:${__disable_warning_promotion}>)

  if (CMAKE_CXX_COMPILER_ID STREQUAL "GNU" OR
      CMAKE_CXX_COMPILER_ID STREQUAL "Clang")

    if(${__cache_name}_ENABLE_ROCKHOPPER_STANDARDS_WARNING_PROMOTION)
      target_compile_options(${__target} PUBLIC -Werror)
    endif()

    target_compile_options(${__target} PUBLIC -Wall -Wextra -Wpedantic)
    target_compile_options(${__target} PUBLIC -Wshadow)
    target_compile_options(${__target} PUBLIC -Wnon-virtual-dtor)
    target_compile_options(${__target} PUBLIC -Woverloaded-virtual)

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

    message(NOTICE "The MSVC compiler is partially supported by RockHopper Standards")

    if(${__cache_name}_ENABLE_ROCKHOPPER_STANDARDS_WARNING_PROMOTION)
      target_compile_options(${__target} PUBLIC /WX)
    endif()

    target_compile_options(${__target} PUBLIC /Wall)

  else()
    message(NOTICE "Unsupported compiler ${CMAKE_CXX_COMPILER_ID}\
      Cannot set RockHopper Standards' set of compiler warnings.")
  endif()

endfunction()


function(_target_rockhopper_compiler_optimisations
  __target
  __cache_name)

  option(
    ${__cache_name}_ENABLE_ROCKHOPPER_STANDARDS_LTO
    "Enable inter-process link time optimisations."
    ON)

  if(${__cache_name}_ENABLE_ROCKHOPPER_STANDARDS_LTO
    AND NOT CMAKE_BUILD_TYPE MATCHES "Debug"
  )

    include(CheckIPOSupported)
    check_ipo_supported(RESULT _lto_supported OUTPUT _lto_error)

    if(_lto_supported)
      set_property(TARGET ${__target} PROPERTY INTERPROCEDURAL_OPTIMIZATION TRUE)
    else()
      message(NOTICE "Cannot enable inter-process link-time optimisiations.")
    endif()

  endif()

endfunction()


function(_target_rockhopper_compiler_symbol_export
  __target
  __cache_name
  __all_symbol_export)

  get_target_property(_target_type ${__target} TYPE)
  if(NOT _target_type MATCHES ".*_LIBRARY")

    if(__all_symbol_export)
      message(FATAL_ERROR "Cannot enable all symbol export for non-library targets.")
    endif()

    return()

  endif()

  option(
    ${__cache_name}_ENABLE_ROCKHOPPER_STANDARDS_ALL_SYMBOL_EXPORT
    "Enable the linker export of all library symbols."
    ${__all_symbol_export})

  if(${__cache_name}_ENABLE_ROCKHOPPER_STANDARDS_ALL_SYMBOL_EXPORT)

    message(NOTICE "Enabling all symbol export is not recommended.")

    set_target_properties(${__target} PROPERTIES WINDOWS_EXPORT_ALL_SYMBOLS ON)

  else()

    set_target_properties(${__target} PROPERTIES CXX_VISIBILITY_PRESET "hidden")
    set_target_properties(${__target} PROPERTIES VISIBILITY_INLINES_HIDDEN ON)

  endif()

endfunction()
