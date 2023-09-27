
cmake_minimum_required(VERSION 3.25)

function(make_test)
  cmake_parse_arguments(ARG "" "NAME;LISTDIR" "" ${ARGN})
  file(MAKE_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/${ARG_LISTDIR})
  add_test(NAME ${ARG_NAME}
    COMMAND ${CMAKE_COMMAND} ${CMAKE_CURRENT_SOURCE_DIR}/${ARG_LISTDIR}
    WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/${ARG_LISTDIR})
endfunction()

make_test(NAME RockHopperStandards LISTDIR standards FAIL)
