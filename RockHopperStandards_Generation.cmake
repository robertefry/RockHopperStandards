
function(_target_rockhopper_generate_export_header
  __target
  __cache_name
  __export_header_source
  __export_header_binary)

  get_target_property(_target_type ${__target} TYPE)
  if(NOT _target_type MATCHES ".*_LIBRARY")

    if(__export_header_source or __export_header_binary)
      message(FATAL_ERROR "Cannot use symbol export generation for non-library targets.")
    endif()

    return()

  endif()

  set(${__cache_name}_ROCKHOPPER_STANDARDS_EXPORT_HEADER_SOURCE_PATH
    ${__export_header_source}
    CACHE STRING "The source-relative filepath to generate a symbol export header file.")

  set(${__cache_name}_ROCKHOPPER_STANDARDS_EXPORT_HEADER_BINARY_PATH
    ${__export_header_binary}
    CACHE STRING "The binary-relative filepath to generate a symbol export header file.")

  set(__export_header_source ${${__cache_name}_ROCKHOPPER_STANDARDS_EXPORT_HEADER_SOURCE_PATH})
  if(NOT _export_header_path)
    set(_export_header_path ${__export_header_source})
  endif()

  set(__export_header_binary ${${__cache_name}_ROCKHOPPER_STANDARDS_EXPORT_HEADER_BINARY_PATH})
  if(NOT _export_header_path)
    set(_export_header_path ${__export_header_binary})
  endif()

  if(__export_header_source AND __export_header_binary)
    message(FATAL_ERROR "EXPORT_HEADER_SOURCE and EXPORT_HEADER_BINARY cannot be used together.")
  endif()

  if(_export_header_path)

    include(GenerateExportHeader)
    generate_export_header(${__target} EXPORT_FILE_NAME ${_export_header_path})

    if(__export_header_binary)
      _rockhopper_directory_from_filepath(${_export_header_binary_directory} _export_header_binary_directory)
      target_include_directories(${__target} SYSTEM PUBLIC
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/${_export_header_binary_directory}>
        $<INSTALL_INTERFACE:${_export_header_binary_directory}>)
    endif()

    _rockhopper_directory_from_filepath("${__export_header_binary}" _export_header_binary_directory)

    target_include_directories(${__target} SYSTEM PUBLIC
      $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/${_export_header_source_directory}>
      $<BUILD_INTERFACE:${CMAKE_CURRENT_BINARY_DIR}/${_export_header_binary_directory}>
      $<INSTALL_INTERFACE:generated>)

  endif()

endfunction()
