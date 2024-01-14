
function(_target_rockhopper_use_doxygen
  __target
  __cache_name
  __doxyfile_in
  __sources
  __output_dir)

  _rockhopper_find_program_once("doxygen" DOXYGEN)

  if(DOXYGEN)
    _rockhopper_status("Found Doxygen: ${DOXYGEN}")
  else()
    _rockhopper_warning("Cannot enable Doxygen, executable not found!")
    return()
  endif()

  set(${__cache_name}_ROCKHOPPER_DOCUMENT_DIRECTORY
    "${__output_dir}"
    CACHE STRING "The output directory for generated documentation.")

  if(${__cache_name}_ROCKHOPPER_DOCUMENT_DIRECTORY STREQUAL "")

    _rockhopper_warning("No configured output directory for generated documentation.")
    return()

  endif()

  option(
    ${__cache_name}_DISABLE_DOCUMENT_GENERATION
    "Disable the use of Doxygen to automatically generate documentation."
    OFF)

  if(${__cache_name}_DISABLE_DOCUMENT_GENERATION)

    _rockhopper_warning("Using RockHopper Standards without Doxygen is not recommended!")
    return()

  endif()

  set(_target_doxygen_inputs "")

  if(__sources)
    foreach(_source ${__sources})

      string(APPEND _target_doxygen_inputs " \"${_source}\"")

    endforeach()
  endif()

  get_target_property(_target_sources ${__target} SOURCES)

  if(_target_sources)
    foreach(_target_source_file ${_target_sources})

      get_property(_target_source_path TARGET ${__target} PROPERTY SOURCE_DIR)
      string(APPEND _target_doxygen_inputs " \"${_target_source_path}/${_target_source_file}\"")

    endforeach()
  endif()

  get_target_property(_target_headers ${__target} HEADERS)

  if(_target_headers)
    foreach(_target_header_file ${_target_headers})

      get_property(_target_source_path TARGET ${__target} PROPERTY SOURCE_DIR)
      string(APPEND _target_doxygen_inputs " \"${_target_header_path}\"")

    endforeach()
  endif()

  set(DOXYGEN_PROJECT_NAME "${PROJECT_NAME} (${__target})")
  set(DOXYGEN_PROJECT_VERSION "${PROJECT_VERSION}")
  set(DOXYGEN_PROJECT_DESCRIPTION "${PROJECT_DESCRIPTION}")
  set(DOXYGEN_INPUTS "${_target_doxygen_inputs}")
  set(DOXYGEN_OUTPUT_DIR ${${__cache_name}_ROCKHOPPER_DOCUMENT_DIRECTORY})

  if("${_doxyfile_in}" STREQUAL "")
    _rockhopper_find_file_once("rockhopper.doxyfile.in" _doxyfile_in PATHS ${CMAKE_MODULE_PATH})
  endif()

  set(_target_doxyfile ${CMAKE_BINARY_DIR}/${__target}.doxyfile)
  configure_file(${_doxyfile_in} ${_target_doxyfile} @ONLY)

  add_custom_target(${__target}-docs ALL
    COMMENT "Generating doxygen documentation for ${__target}..."
    COMMAND ${CMAKE_COMMAND} -E make_directory ${DOXYGEN_OUTPUT_DIR}
    COMMAND ${CMAKE_COMMAND} -E chdir ${DOXYGEN_OUTPUT_DIR} ${DOXYGEN} -q ${_target_doxyfile}
    VERBATIM)

  if(CMAKE_BUILD_TYPE STREQUAL "Release" OR CMAKE_CONFIGURATION_TYPES)
    add_dependencies(${__target} $<$<CONFIG:"Release">:${__target}-docs>)
  endif()

endfunction()
