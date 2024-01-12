
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
    $<BOOL:${__disabled}>)

  if(NOT ${__cache_name}_DISABLE_EXECUTION_COMMAND)

    add_custom_target(run-${__target}
      COMMAND $<TARGET_FILE:${__target}>
      DEPENDS ${__target})

  endif()

endfunction()
