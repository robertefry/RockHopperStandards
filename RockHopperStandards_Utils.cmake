cmake_minimum_required(VERSION 3.25)

macro(_rockhopper_validate_target __target)

  # Check if __target is a defined target
  if(NOT __target)
    message(FATAL_ERROR "Missing the target argument.")
  elseif(NOT TARGET ${__target})
    message(FATAL_ERROR "Argument ${__target} is not a defined target.")
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
    message(FATAL_ERROR "Bad arguments: ${${PARSE_PREFIX}_UNPARSED_ARGUMENTS}.")
  endif()
  if(${PARSE_PREFIX}_KEYWORDS_MISSING_VALUES)
    message(FATAL_ERROR "Missing values for: ${${PARSE_PREFIX}_KEYWORDS_MISSING_VALUES}}.")
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
