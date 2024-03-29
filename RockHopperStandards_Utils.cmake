cmake_minimum_required(VERSION 3.25)


function(_rockhopper_debug __message)

  if(NOT WIN32)
    string(ASCII 27 Esc)
    set(ColorReset    "${Esc}[m")
    set(ColorWarning  "${Esc}[35m")
  endif()

  message(NOTICE "${ColorWarning}${__message}${ColorReset}")

endfunction()


function(_rockhopper_status __message)

  message(STATUS "${__message}")

endfunction()


function(_rockhopper_warning __message)

  if(NOT WIN32)
    string(ASCII 27 Esc)
    set(ColorReset    "${Esc}[m")
    set(ColorWarning  "${Esc}[33m")
  endif()

  message(NOTICE "${ColorWarning}WARNING: ${__message}${ColorReset}")

endfunction()


function(_rockhopper_error __message)

  if(NOT WIN32)
    string(ASCII 27 Esc)
    set(ColorReset  "${Esc}[m")
    set(ColorError  "${Esc}[1;31m")
  endif()

  message(NOTICE "${ColorError}ERROR: ${__message}${ColorReset}")

endfunction()


function(_rockhopper_fatal __message)

  if(NOT WIN32)
    string(ASCII 27 Esc)
    set(ColorReset  "${Esc}[m")
    set(ColorFatal  "${Esc}[1;31m")
  endif()

  if(__message)
    message(NOTICE "${ColorFatal}FATAL: ${__message}${ColorReset}")
  endif()

  message(FATAL_ERROR "${ColorFatal}Quitting configuration.${ColorReset}")

endfunction()


macro(_rockhopper_validate_target __target)

  # Check if __target is a defined target
  if(NOT __target)
    _rockhopper_fatal("Missing the target argument.")
  elseif(NOT TARGET ${__target})
    _rockhopper_fatal("Argument ${__target} is not a defined target.")
  endif()

  # Check if the target is an alias, and get the real target name
  get_target_property(_target_alias_name ${__target} ALIAS)
  if(_target_alias_name)
    set(${__target} ${_target_alias_name})
  endif()

endmacro()


macro(_rockhopper_parse_exact_args
  PARSE_PREFIX
  PARSE_OPTIONALS
  PARSE_POSITIONAL_SINGLES
  PARSE_POSITIONAL_MULTIPLES
)

  cmake_parse_arguments(
    "${PARSE_PREFIX}"
    "${PARSE_OPTIONALS}"
    "${PARSE_POSITIONAL_SINGLES}"
    "${PARSE_POSITIONAL_MULTIPLES}"
    ${ARGN})

  # Check there are no extra or erroneous arguments
  if(${PARSE_PREFIX}_UNPARSED_ARGUMENTS)
    _rockhopper_fatal("Bad arguments: ${${PARSE_PREFIX}_UNPARSED_ARGUMENTS}.")
  endif()
  if(${PARSE_PREFIX}_KEYWORDS_MISSING_VALUES)
    _rockhopper_fatal("Missing values for: ${${PARSE_PREFIX}_KEYWORDS_MISSING_VALUES}}.")
  endif()

endmacro()


function(_rockhopper_snake_name __in __out_name)

  string(REGEX REPLACE "([a-z0-9])([A-Z])" "\\1_\\2" _no_camel ${__in})
  string(REGEX REPLACE "\\W" "_" _snake_mixed ${_no_camel})
  string(TOLOWER ${_snake_mixed} ${__out_name})

  return(PROPAGATE ${__out_name})

endfunction()


function(_rockhopper_cache_name __in __out_name)

  _rockhopper_snake_name(${__in} _snake_name)
  string(TOUPPER ${_snake_name} ${__out_name})

  return(PROPAGATE ${__out_name})

endfunction()


function(_rockhopper_directory_from_filepath __in __out_name)

  string(REGEX MATCH "(.*/)" _directory ${__in})
  set(${__out_name} ${_directory})

  return(PROPAGATE ${__out_name})

endfunction()


function(_rockhopper_find_program_once __in_name __out_name)

  _rockhopper_cache_name(${__in_name} _cache_name)

  if(NOT _ROCKHOPPER_STANDARDS_SEARCHED_${_cache_name})

    find_program(${__out_name} ${__in_name} ${ARGN})

    set(_ROCKHOPPER_STANDARDS_SEARCHED_${_cache_name} ON CACHE BOOL
      "Flag to indicate whether RockHopper Standards has searched for ${__in_name}."
      FORCE)
    mark_as_advanced(FORCE _ROCKHOPPER_STANDARDS_SEARCHED_${_cache_name})

  endif()

  return(PROPAGATE ${__out_name})

endfunction()


function(_rockhopper_find_file_once __in_name __out_name)

  _rockhopper_cache_name(${__in_name} _cache_name)

  if(NOT _ROCKHOPPER_STANDARDS_SEARCHED_${_cache_name})

    find_file(${__out_name} ${__in_name} ${ARGN})

    set(_ROCKHOPPER_STANDARDS_SEARCHED_${_cache_name} ON CACHE BOOL
      "Flag to indicate whether RockHopper Standards has searched for ${__in_name}."
      FORCE)
    mark_as_advanced(FORCE _ROCKHOPPER_STANDARDS_SEARCHED_${_cache_name})

  endif()

  return(PROPAGATE ${__out_name})

endfunction()
