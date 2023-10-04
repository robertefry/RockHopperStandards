
# RockHopper Standards

CMake scripts to enable high-performance and reliability in C++ codebases.

<details>
<summary>Table of Contents</summary>

- [Features](#features)
    - [Language Extensions](#language-extensions)
    - [Compiler Warnings](#compiler-warnings)
- [Getting Started](#getting-started)
- [In Development](#features-in-development)

</details>

The `target_rockhopper_standards` function is used to configure a CMake target by enabling the set of standards from RockHopper Standards.

```cmake
target_rockhopper_standards(
    # The name of the cmake target the developer wants compliant with RockHopper Standards.
    <the_target>
    # (optional) Enable prototyping mode.
    PROTOTYPE
    # (optional) A custom name for target-specific cache options.
    CACHE_NAME <the_target_name>
    # (optional) Disable promoting compiler warnings to errors.
    DISABLE_WARNING_PROMOTION
)
```

## Features

- **[Language Extensions](#language-extensions)**

    Language extensions are non-standard compiler-specific extra features; disabling them ensures consistent and strict coding.

- **[Compiler Warnings](#compiler-warnings)**:

    The minimal set of compiler flags to enforce rigorous, high-quality, error-free code.

## Getting Started

To use RockHopper Standards in a project, simply add the following to the relevant `CMakeLists.txt`.

```cmake
include(FetchContent)

FetchContent_Declare(
    RockHopperStandards
    GIT_REPOSITORY https://github.com/robertefry/RockHopperStandards.git
    GIT_TAG v1.x.x )
FetchContent_MakeAvailable(RockHopperStandards)

target_rockhopper_standards(<the_target>)
```

Alternatively, if the build system is using [CPM](https://github.com/cpm-cmake/CPM.cmake), add the following to the relevant `CMakeLists.txt`
```cmake
CPMAddPackage("gh:robertefry/RockHopperStandards@1.1.0")

target_rockhopper_standards(<the_target>)
```

## Features In Development

- Static analysis (Clang-Tidy and CppCheck)
- Linker (ABI) safety and optimisation.
- Sanitizer testing.
- Fuzz testing.
- Automatic test targets and build commands.
- Automatic documentation generation (Doxygen).
- (?) Code formatting (Clang-Format)
- (?) Code Generation (where necessary).

## More detail about the features.

### Language Extensions

Compiler extensions are added language features beyond standard rules, often tied to specific compilers. In stringent code bases, turning them off is essential because it promotes code consistency, enforces language standards, and reduces the risk of unexpected issues.

<details>
<summary>Cache Options</summary>

- To enable/disable language extensions.
  ```
  ${TARGET_CACHE_NAME}_ENABLE_${LANG}_EXTENSIONS
  ```

</details>

### Compiler Warnings

Using the following flags can improve code reliability and maintainability but may generate numerous warnings that require review and resolution. These flags help enhance code quality, and catch various issues such as errors, non-standard code, unwanted type conversions, variable shadowing, and encourage adherence to best practices.

<details>
<summary>GNU/Clang Warnigs</summary>

- `-Werror` treats all warnings as errors.

- `-Wall` and `-Wextra` enable a wide range of warning messages.

- `-Wpedantic` enforces strict adherence to the language standard.

- `-Wconversion` warns about implicit type conversions, which may lead to unexpected behaviour.

- `-Wshadow` warns about variable shadowing, where a local variable hides another variable in an outer scope.

- `-Weffc++` enforces some guidelines from the “Effective C++” book by Scott Meyers.

</details>

<details>
<summary>Cache Options</summary>

- To enable/disable Rockhopper Standards' compiler warnings per-target;
  ```
  ${TARGET_CACHE_NAME}_ENABLE_ROCKHOPPER_STANDARD_WARNINGS
  ```
  Setting this option to `OFF` is not recommended, and will warn the developer during the configuration process.

- To enable/disable RockHopper Standards' promotion of compiler warnings to errors;
  ```
  ${TARGET_CACHE_NAME}_ENABLE_ROCKHOPPER_STANDARD_WARNING_PROMOTION
  ```

</details>
