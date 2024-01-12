
function(_target_rockhopper_linker_optimisations
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


function(_target_rockhopper_linker_symbol_export
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
    $<BOOL:${__all_symbol_export}>)

  if(${__cache_name}_ENABLE_ROCKHOPPER_STANDARDS_ALL_SYMBOL_EXPORT)

    message(NOTICE "Enabling all symbol export is not recommended.")

    set_target_properties(${__target} PROPERTIES WINDOWS_EXPORT_ALL_SYMBOLS ON)

  else()

    set_target_properties(${__target} PROPERTIES CXX_VISIBILITY_PRESET "hidden")
    set_target_properties(${__target} PROPERTIES VISIBILITY_INLINES_HIDDEN ON)

  endif()

endfunction()
