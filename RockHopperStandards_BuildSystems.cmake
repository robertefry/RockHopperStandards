
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
    message("################################################################")
    message("WARNING: In-source builds are explicitly disallowed.")
    message("Please create a separate build directory and run CMake from there.")
    message("################################################################")
    message(FATAL_ERROR "Quitting configuration.")
  endif()

endfunction()
