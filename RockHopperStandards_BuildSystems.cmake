
function(_target_rockhopper_buildsys_execution
  __target
  __cache_name
  __disabled)

  get_target_property(_target_type ${__target} TYPE)
  if(NOT _target_type MATCHES "EXECUTABLE")
    return()
  endif()

  option(${__cache_name}_DISABLE_EXECUTION_COMMAND
    "Disable creation of a command to run the built binary"
    ${__disabled})

  if(NOT ${__cache_name}_DISABLE_EXECUTION_COMMAND)

    add_custom_target(run-${__target}
      COMMAND $<TARGET_FILE:${__target}>
      DEPENDS ${__target})

  endif()

endfunction()


function(_target_rockhopper_buildsys_disallow_insource
  __target
  __cache_name)

  get_target_property(_target_srcdir ${__target} SOURCE_DIR)
  get_filename_component(_target_srcpath ${_target_srcdir} REALPATH)

  get_target_property(_target_bindir ${__target} BINARY_DIR)
  get_filename_component(_target_binpath ${_target_bindir} REALPATH)

  if(${_target_srcpath} STREQUAL ${_target_binpath})
    _rockhopper_error("################################################################")
    _rockhopper_error(" In-source builds are explicitly disallowed.")
    _rockhopper_error(" Please run CMake from a separate build directory.")
    _rockhopper_error("################################################################")
    _rockhopper_fatal()
  endif()

endfunction()
