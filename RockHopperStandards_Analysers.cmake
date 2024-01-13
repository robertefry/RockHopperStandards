
function(_target_rockhopper_analyser_clang_tidy
  __target
  __cache_name
  )

  # https://clang.llvm.org/extra/clang-tidy/checks/list.html
  #
  set(_ROCKHOPPER_STANDARDS_CLANG_TIDY_CHECKS
  " -*"
  " cppcoreguidelines-*"
  " hicpp-*"
  "   -hicpp-braces-around-statements"
  "   -hicpp-named-parameter"
  " modernize-*"
  "   -modernize-use-trailing-return-type"
  " bugprone-*"
  " cert-*"
  " misc-*"
  "   -misc-use-anonymous-namespace"
  " concurrency-*"
  " performance-*"
  " portability-*"
  " readability-*"
  "   -readability-named-parameter"
  "   -readability-redundant-member-init"
  " clang-analyzer-*"

  " llvm-namespace-comment"
  )
  string(JOIN "," _ROCKHOPPER_STANDARDS_CLANG_TIDY_CHECKS ${_ROCKHOPPER_STANDARDS_CLANG_TIDY_CHECKS})
  string(REPLACE " " "" _ROCKHOPPER_STANDARDS_CLANG_TIDY_CHECKS ${_ROCKHOPPER_STANDARDS_CLANG_TIDY_CHECKS})
  #
  set(_ROCKHOPPER_STANDINGS_CLANG_TIDY_OPTIONS
  "{key: cppcoreguidelines-explicit-virtual-functions.IgnoreDestructors, value: 'true'}"
  "{key: modernize-use-override.IgnoreDestructors, value: 'true'}"
  "{key: hicpp-use-override, value: 'true'}"
  "{key: misc-non-private-member-variables-in-classes.IgnoreClassesWithAllMemberVariablesBeingPublic, value: 'true'}"
  "{key: readability-braces-around-statements.ShortStatementLines, value: '1'}"
  )
  string(JOIN ", " _ROCKHOPPER_STANDINGS_CLANG_TIDY_OPTIONS ${_ROCKHOPPER_STANDINGS_CLANG_TIDY_OPTIONS})
  #
  set(_ROCKHOPPER_STANDARDS_CLANG_TIDY_ARGS
  "-checks=${_ROCKHOPPER_STANDARDS_CLANG_TIDY_CHECKS}"
  "-config={CheckOptions: [${_ROCKHOPPER_STANDINGS_CLANG_TIDY_OPTIONS}]}"
  )
  string(JOIN "," _ROCKHOPPER_STANDARDS_CLANG_TIDY_ARGS ${_ROCKHOPPER_STANDARDS_CLANG_TIDY_ARGS})

  if(NOT CLANG_TIDY AND NOT _ROCKHOPPER_STANDARDS_SEARCHED_CLANG_TIDY)

    find_program(CLANG_TIDY NAMES "clang-tidy")

    if(CLANG_TIDY)
      message(STATUS "Found Clang-Tidy: ${CLANG_TIDY}")
    else()
      message(NOTICE "Cannot enable Clang-Tidy, executable not found!")
    endif()

    set(_ROCKHOPPER_STANDARDS_SEARCHED_CLANG_TIDY ON CACHE BOOL
      "Flag to indicate whether RockHopper Standards has searched for Clang-Tidy."
      FORCE)
    mark_as_advanced(FORCE _ROCKHOPPER_STANDARDS_SEARCHED_CLANG_TIDY)

  endif()

  if(CLANG_TIDY)

    option(
      ${__cache_name}_ENABLE_CLANG_TIDY
      "Enable the use of Clang-Tidy static analysis."
      ON)

    if(${__cache_name}_ENABLE_CLANG_TIDY)

      foreach(LANG "C" "CXX" "OBJC" "OBJCXX")
        set_target_properties(${__target} PROPERTIES ${LANG}_CLANG_TIDY
          "${CLANG_TIDY};${_ROCKHOPPER_STANDARDS_CLANG_TIDY_ARGS}")
      endforeach()

    endif()

  endif()

endfunction()
