
function(_target_rockhopper_generate_export_header
  __target
  __cache_name
  __export_basename
  __export_header_source
  __export_header_binary)

  get_target_property(_target_type ${__target} TYPE)
  if(NOT _target_type MATCHES ".*_LIBRARY")

    if(__export_header_source OR __export_header_binary)
      message(FATAL_ERROR "Cannot use symbol export generation for non-library targets.")
    endif()

    return()

  endif()

  if(__export_header_source AND __export_header_binary)
    message(FATAL_ERROR "EXPORT_HEADER_SOURCE and EXPORT_HEADER_BINARY cannot be used together.")
  endif()

  if(NOT __export_basename)
    set(__export_basename ${__cache_name})
  endif()

  set(${__cache_name}_ROCKHOPPER_STANDARDS_EXPORT_BASENAME
    "${__export_basename}"
    CACHE STRING "The basename for generated export macros.")

  set(${__cache_name}_ROCKHOPPER_STANDARDS_EXPORT_HEADER_SOURCE_PATH
    "${__export_header_source}"
    CACHE STRING "The source-relative filepath to generate a symbol export header file.")

  set(${__cache_name}_ROCKHOPPER_STANDARDS_EXPORT_HEADER_BINARY_PATH
    "${__export_header_binary}"
    CACHE STRING "The binary-relative filepath to generate a symbol export header file.")

  if(${__cache_name}_ROCKHOPPER_STANDARDS_EXPORT_HEADER_SOURCE_PATH)

    message(STATUS "Generating export header for ${__target}: ${CMAKE_CURRENT_SOURCE_DIR}/${__export_header_source}")

    include(GenerateExportHeader)
    generate_export_header(${__target}
      BASE_NAME ${${__cache_name}_ROCKHOPPER_STANDARDS_EXPORT_BASENAME}
      EXPORT_FILE_NAME ${CMAKE_CURRENT_SOURCE_DIR}/${__export_header_source})

    _rockhopper_directory_from_filepath(${__export_header_source} _export_header_source_directory)
    target_include_directories(${__target} SYSTEM PUBLIC
      $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/${_export_header_source_directory}>
      $<INSTALL_INTERFACE:${_export_header_source_directory}>)

    return()

  endif()

  if(${__cache_name}_ROCKHOPPER_STANDARDS_EXPORT_HEADER_BINARY_PATH)

    message(STATUS "Generating export header for ${__target}: ${CMAKE_CURRENT_BINARY_DIR}/${__export_header_binary}")

    include(GenerateExportHeader)
    generate_export_header(${__target}
      BASE_NAME ${${__cache_name}_ROCKHOPPER_STANDARDS_EXPORT_BASENAME}
      EXPORT_FILE_NAME ${CMAKE_CURRENT_BINARY_DIR}/${__export_header_binary})

    _rockhopper_directory_from_filepath(${__export_header_binary} _export_header_binary_directory)
    target_include_directories(${__target} SYSTEM PUBLIC
      $<BUILD_INTERFACE:${CMAKE_CURRENT_BINARY_DIR}/${_export_header_binary_directory}>
      $<INSTALL_INTERFACE:${_export_header_binary_directory}>)

    return()

  endif()

endfunction()
