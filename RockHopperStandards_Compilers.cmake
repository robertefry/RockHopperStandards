
function(_target_rockhopper_compiler_extensions
  __target
  __cache_name
  )

  get_property(_project_languages GLOBAL PROPERTY ENABLED_LANGUAGES)
  foreach(LANG ${_project_languages})

    option(
      ${__cache_name}_ENABLE_${LANG}_EXTENSIONS
      "Enable the use of ${LANG} compiler extensions. (Not recomended; may lead to warning clashes)"
      OFF)

    if(${__cache_name}_ENABLE_${LANG}_EXTENSIONS)
      message(NOTICE "Enabling ${LANG} extensions is not recomended.")
    endif()

    target_compile_definitions(${__target} PUBLIC
      ${LANG}_EXTENSIONS=${${__cache_name}_ENABLE_${LANG}_EXTENSIONS})

  endforeach()

endfunction()


function(_target_rockhopper_compiler_warnings
  __target
  __cache_name
  __disable_warning_promotion
  )

  option(
    ${__cache_name}_ENABLE_ROCKHOPPER_STANDARDS_WARNINGS
    "Enable RockHopper Standards' set of compiler warnings."
    ON)

  if(NOT ${${__cache_name}_ENABLE_ROCKHOPPER_STANDARDS_WARNINGS})

    message(NOTICE "Disabling RockHopper Standards' set of compiler warnings is not recommended.")
    return()

  endif()

  option(
    ${__cache_name}_ENABLE_ROCKHOPPER_STANDARDS_WARNING_PROMOTION
    "Disable promoting compiler warnings to errors."
    $<NOT:${__disable_warning_promotion}>)

  if (CMAKE_CXX_COMPILER_ID STREQUAL "GNU" OR
      CMAKE_CXX_COMPILER_ID STREQUAL "Clang")

    if(${__cache_name}_ENABLE_ROCKHOPPER_STANDARDS_WARNING_PROMOTION)
      target_compile_options(${__target} PUBLIC -Werror)
    endif()

    target_compile_options(${__target} PUBLIC -Wall -Wextra -Wpedantic)
    target_compile_options(${__target} PUBLIC -Wshadow)
    target_compile_options(${__target} PUBLIC -Wnon-virtual-dtor)
    target_compile_options(${__target} PUBLIC -Woverloaded-virtual)

    if(NOT ${__cache_name}_ENABLE_PROTOTYPING_MODE)
      target_compile_options(${__target} PUBLIC -Wunused)
      target_compile_options(${__target} PUBLIC -Wconversion)
      target_compile_options(${__target} PUBLIC -Wsign-conversion)
      target_compile_options(${__target} PUBLIC -Wold-style-cast)
      target_compile_options(${__target} PUBLIC -Wcast-align)
      target_compile_options(${__target} PUBLIC -Wdouble-promotion)
      target_compile_options(${__target} PUBLIC -Weffc++)
      target_compile_options(${__target} PUBLIC -Wnull-dereference)
    endif()

  elseif(CMAKE_CXX_COMPILER_ID STREQUAL "MSVC")

    message(NOTICE "The MSVC compiler is partially supported by RockHopper Standards")

    if(${__cache_name}_ENABLE_ROCKHOPPER_STANDARDS_WARNING_PROMOTION)
      target_compile_options(${__target} PUBLIC /WX)
    endif()

    target_compile_options(${__target} PUBLIC /Wall)

  else()
    message(NOTICE "Unsupported compiler ${CMAKE_CXX_COMPILER_ID}\
      Cannot set RockHopper Standards' set of compiler warnings.")
  endif()

endfunction()


function(_target_rockhopper_compiler_optimisations
  __target
  __cache_name)

  option(
    ${__cache_name}_ENABLE_ROCKHOPPER_STANDARDS_LTO
    "Enable inter-process link time optimisations."
    ON)

  if(${__cache_name}_ENABLE_ROCKHOPPER_STANDARDS_LTO
    AND NOT CMAKE_BUILD_TYPE MATCHES "Debug"
  )

    include(CheckIPOSupported)
    check_ipo_supported(RESULT _lto_supported OUTPUT _lto_error)

    if(_lto_supported)
      set_property(TARGET ${__target} PROPERTY INTERPROCEDURAL_OPTIMIZATION TRUE)
    else()
      message(NOTICE "Cannot enable inter-process link-time optimisiations.")
    endif()

  endif()

endfunction()


function(_target_rockhopper_compiler_symbol_export
  __target
  __cache_name
  __export_header_source
  __export_header_binary)

  option(
    ${__cache_name}_ENABLE_ROCKHOPPER_STANDARDS_ALL_SYMBOL_EXPORT
    "Enable the linker export of all library symbols."
    OFF)

  if(${__cache_name}_ENABLE_ROCKHOPPER_STANDARDS_SYMBOL_EXPORT)
    set_target_properties(${__target} PROPERTIES WINDOWS_EXPORT_ALL_SYMBOLS ON)
  else()
    set_target_properties(${__target} PROPERTIES CXX_VISIBILITY_PRESET "hidden")
    set_target_properties(${__target} PROPERTIES VISIBILITY_INLINES_HIDDEN ON)
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

  if(${__export_header_source} and ${__export_header_binary})
    message(FATAL_ERROR "EXPORT_HEADER_SOURCE and EXPORT_HEADER_BINARY cannot be used together.")
  endif()

  if(_export_header_path)

    include(GenerateExportHeader)
    generate_export_header(${__target} EXPORT_FILE_NAME ${_export_header_path})

    _rockhopper_directory_from_filepath(${__export_header_source} _export_header_source_directory)
    _rockhopper_directory_from_filepath(${__export_header_binary} _export_header_binary_directory)

    target_include_directories(${__target} SYSTEM PUBLIC
      $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/${_export_header_source_directory}>
      $<BUILD_INTERFACE:${CMAKE_CURRENT_BINARY_DIR}/${_export_header_binary_directory}>
      $<INSTALL_INTERFACE:generated>)

  endif()

endfunction()
