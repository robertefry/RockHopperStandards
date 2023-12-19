
include(RockHopperStandards_Utils)
include(RockHopperStandards_Compilers)

function(target_rockhopper_standards __target)

  message(STATUS "The target ${__target} is using RockHopper Standards.")

  set(ARGS_OPTIONAL
    # (optional) Enable prototyping mode.
    "PROTOTYPE"
    # (optional) Disable promoting compiler warnings to errors.
    "DISABLE_WARNING_PROMOTION"
    )
  set(ARGS_SINGLE
    # (optional) A custom name for target-specific cache options.
    "CACHE_NAME"
    )
  set(ARGS_MULTIPLE
    )

  _rockhopper_validate_target(${__target})
  _rockhopper_parse_exact_args(ARG "${ARGS_OPTIONAL}" "${ARGS_SINGLE}" "${ARGS_MULTIPLE}" ${ARGN})

  if(NOT ARG_CACHE_NAME)
    _rockhopper_cache_name(${__target} ARG_CACHE_NAME)
  endif()

  option(
    ${__cache_name}_ENABLE_PROTOTYPING_MODE
    "Enable prototyping mode."
    ${ARG_PROTOTYPE})

  _target_rockhopper_compiler_extensions(
    ${__target}
    ${ARG_CACHE_NAME}
    )
  _target_rockhopper_compiler_warnings(
    ${__target}
    ${ARG_CACHE_NAME}
    ${ARG_DISABLE_WARNING_PROMOTION}
    )

endfunction()
