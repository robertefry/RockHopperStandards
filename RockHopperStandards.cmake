
include(RockHopperStandards_Utils)
include(RockHopperStandards_BuildSystems)
include(RockHopperStandards_Compilers)
include(RockHopperStandards_Linkers)
include(RockHopperStandards_Generation)
include(RockHopperStandards_Tools_ClangTidy)
include(RockHopperStandards_Tools_Doxygen)

function(target_rockhopper_standards __target)

  if(NOT WIN32)
    string(ASCII 27 Esc)
    set(ColorReset      "${Esc}[m")
    set(ColorStandards  "${Esc}[32m")
  endif()

  _rockhopper_status("${ColorStandards}The target ${__target} is using RockHopper Standards${ColorReset}")

  set(ARGS_OPTIONAL
    # (optional) Enable prototyping mode.
    "PROTOTYPE"
    # (optional) Disable the creation of an execution command.
    "DISABLE_EXECUTION_COMMAND"
    # (optional) Disable promoting compiler warnings to errors.
    "DISABLE_WARNING_PROMOTION"
    # (optional) Disable link-time optimisations.
    "DISABLE_LINKER_OPTIMISATIONS"
    # (optional) Disable Clang-Tidy static analysis (not recomended).
    "DISABLE_CLANG_TIDY"
    # (optional) Enable compiler extensions.
    "ENABLE_COMPILER_EXTENSIONS"
    # (optional) Enable all-symbol export for library targets.
    "ENABLE_ALL_SYMBOL_EXPORT"
    )
  set(ARGS_SINGLE
    # (optional) A custom name for target-specific cache options.
    "CACHE_NAME"
    # (recommended) The output directory for generated documentation.
    "DOCUMENT_OUTPUT"
    # (optional) An unconfigured doxyfile.in file.
    "DOXYFILE_IN"
    # (optional) The export macro basename.
    "EXPORT_BASENAME"
    # (optional) The source-relative path to generate a symbol export header file.
    "EXPORT_HEADER_SOURCE"
    # (optional) The binary-relative path to generate a symbol export header file.
    "EXPORT_HEADER_BINARY"
    )
  set(ARGS_MULTIPLE
    # (optional) A list of additional sources to generate documentation from.
    "DOCUMENT_SOURCES"
    )

  _rockhopper_validate_target(${__target})
  _rockhopper_parse_exact_args(ARG "${ARGS_OPTIONAL}" "${ARGS_SINGLE}" "${ARGS_MULTIPLE}" ${ARGN})

  if(NOT ARG_CACHE_NAME)
    _rockhopper_cache_name(${__target} ARG_CACHE_NAME)
  endif()

  _target_rockhopper_buildsys_disallow_insource(
    ${__target}
    "${ARG_CACHE_NAME}"
    )

  option(
    ${ARG_CACHE_NAME}_ENABLE_PROTOTYPING_MODE
    "Enable prototyping mode."
    ${ARG_PROTOTYPE})

  _target_rockhopper_compiler_extensions(
    ${__target}
    "${ARG_CACHE_NAME}"
    "${ARG_ENABLE_COMPILER_EXTENSIONS}"
    )
  _target_rockhopper_compiler_warnings(
    ${__target}
    "${ARG_CACHE_NAME}"
    "${ARG_DISABLE_WARNING_PROMOTION}"
    )
  _target_rockhopper_linker_optimisations(
    ${__target}
    "${ARG_CACHE_NAME}"
    "${ARG_DISABLE_LINKER_OPTIMISATIONS}"
    )
  _target_rockhopper_linker_symbol_export(
    ${__target}
    "${ARG_CACHE_NAME}"
    "${ARG_ENABLE_ALL_SYMBOL_EXPORT}"
    )
  _target_rockhopper_generate_export_header(
    ${__target}
    "${ARG_CACHE_NAME}"
    "${ARG_EXPORT_BASENAME}"
    "${ARG_EXPORT_HEADER_SOURCE}"
    "${ARG_EXPORT_HEADER_BINARY}"
    )

  _target_rockhopper_buildsys_execution(
    ${__target}
    "${ARG_CACHE_NAME}"
    "${ARG_DISABLE_EXECUTION_COMMAND}"
    )

  _target_rockhopper_use_clang_tidy(
    ${__target}
    "${ARG_CACHE_NAME}"
    "${ARG_DISABLE_CLANG_TIDY}"
    )
  _target_rockhopper_use_doxygen(
    ${__target}
    "${ARG_CACHE_NAME}"
    "${ARG_DOXYFILE_IN}"
    "${ARG_DOCUMENT_SOURCES}"
    "${ARG_DOCUMENT_OUTPUT}"
    )

endfunction()
