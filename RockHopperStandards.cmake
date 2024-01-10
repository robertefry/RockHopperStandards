
include(RockHopperStandards_Utils)
include(RockHopperStandards_Compilers)
include(RockHopperStandards_Analysers)
include(RockHopperStandards_Generation)

function(target_rockhopper_standards __target)

  message(STATUS "The target ${__target} is using RockHopper Standards.")

  set(ARGS_OPTIONAL
    # (optional) Enable prototyping mode.
    "PROTOTYPE"
    # (optional) Disable promoting compiler warnings to errors.
    "DISABLE_WARNING_PROMOTION"
    # (optional) Enable all-symbol export for library targets.
    "ENABLE_ALL_SYMBOL_EXPORT"
    )
  set(ARGS_SINGLE
    # (optional) A custom name for target-specific cache options.
    "CACHE_NAME"
    # (optional) The export macro basename.
    "EXPORT_BASENAME"
    # (optional) The source-relative path to generate a symbol export header file.
    "EXPORT_HEADER_SOURCE"
    # (optional) The binary-relative path to generate a symbol export header file.
    "EXPORT_HEADER_BINARY"
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
    "${ARG_DISABLE_WARNING_PROMOTION}"
    )
  _target_rockhopper_compiler_optimisations(
    ${__target}
    ${ARG_CACHE_NAME}
    )
  _target_rockhopper_compiler_symbol_export(
    ${__target}
    ${ARG_CACHE_NAME}
    "${ARG_EXABLE_ALL_SYMBOL_EXPORT}"
    )
  _target_rockhopper_generate_export_header(
    ${__target}
    ${ARG_CACHE_NAME}
    "${ARG_EXPORT_BASENAME}"
    "${ARG_EXPORT_HEADER_SOURCE}"
    "${ARG_EXPORT_HEADER_BINARY}"
    )
  _target_rockhopper_analyser_clang_tidy(
    ${__target}
    ${ARG_CACHE_NAME}
    )

endfunction()
