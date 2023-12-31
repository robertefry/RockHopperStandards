
# RockHopper Standards

CMake scripts to enable high-performance and reliability in C++ codebases.

<details>
<summary>Table of Contents</summary>

- [Getting Started](#getting-started)
- [Compiler Features](#compiler-features)
    - [Compiler Warnings](#compiler-warnings)
    - [Static Analysis](#static-analysis)
    - [Language Extensions Disabled](#language-extensions)
- [Linker Features](#linker-features)
    - [Symbol Export Control](#symbol-export-control)
    - [Link-Time Optimisations](#link-time-optimisations)
- [In Development](#features-in-development)

</details>

The `target_rockhopper_standards` function is used to configure a CMake target by enabling the set of standards from RockHopper Standards.

```cmake
target_rockhopper_standards(
    # The name of the cmake target to be compliant with RockHopper Standards.
    <the_target>
    # (optional) Enable prototyping mode.
    PROTOTYPE
    # (optional) A custom name for target-specific cache options.
    CACHE_NAME <the_target_name>
    # (optional) Disable promoting compiler warnings to errors.
    DISABLE_WARNING_PROMOTION
    # (optional) The source-relative path to generate a symbol export header file.
    EXPORT_HEADER_SOURCE "some/source/relative/path"
    # (optional) The binary-relative path to generate a symbol export header file.
    EXPORT_HEADER_BINARY "some/binary/relative/path"
)
```

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
CPMAddPackage("gh:robertefry/RockHopperStandards@1.x.x")

target_rockhopper_standards(<the_target>)
```

For further reference, see the included `example` project.

## Features

#### Compiler Features

- **[Enhanced Compiler Warnings](#compiler-warnings)**:

    The minimal set of compiler flags to enforce rigorous, high-quality, error-free code.

- **[Static Analysis](#static-analysis)**:

    Examine code for potential errors, vulnerabilities, and adherence to coding standards without compiling.

- **[Language Extensions Disabled](#language-extensions)**

    Language extensions are non-standard compiler-specific extra features; disabling them ensures consistent and strict coding.

#### Linker Features

- **[Symbol Export Control](#linker-symbol-export-control)**:

    Control symbol visibility and export behaviour.

- **[Link-Time Optimisations](#link-time-optimisations)**:

    Perform program-wide optimization during the linking phase.

## Planned Features In Development

- Code Quality
    - CppCheck (yes, as well as Clang-Tidy).
    - Documentation generation (Doxygen).
    - (?) Code formatting (Clang-Format).
- Testing
    - Sanitized testing.
    - Unit tests run in Release and Debug modes.
    - Fuzz testing.
    - Automatic test targets and run commands.

## Features In Detail

### Compiler Warnings

Using the following flags can improve code reliability and maintainability but may generate numerous warnings that require review and resolution. These flags help enhance code quality, and catch various issues such as errors, non-standard code, unwanted type conversions, variable shadowing, and encourage adherence to best practices.

<details>
<summary>GNU/Clang Warnings</summary>

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

### Static Analysis

Using the following static analysis checks improve enforcement of good coding standards, code quality, and early-identification of potential issues, with a focus on performance, security, quality, and readability.

<details>
<summary>Clang-Tidy Checks</summary>

#### Improvements to performance.

```
  concurrency-*,
  performance-*,
  portability-*,

```

#### Improvements to security and safety.

```
  bugprone-*,
  cert-*,
```

#### Improvements to quality.

```
  cppcoreguidelines-*,
  hicpp-*,
  modernize-*,
  misc-*,
```

#### Improvements to readability.

```
  readability-*,
  clang-analyzer-*,
  llvm-namespace-comment,
```

</details>

<details>
<summary>Cache Options</summary>

- To enable/disable clang-tidy analysis.
    ```
    ${__cache_name}_ENABLE_CLANG_TIDY
    ```

</details>

### Language Extensions

Compiler extensions are added language features beyond standard rules, often tied to specific compilers. In stringent code bases, turning them off is essential because it promotes code consistency, enforces language standards, and reduces the risk of unexpected issues.

<details>
<summary>Cache Options</summary>

- To enable/disable language extensions.
  ```
  ${TARGET_CACHE_NAME}_ENABLE_${LANG}_EXTENSIONS
  ```

</details>

### Linker Symbol Export Control

Control the symbol export configuration, defaulting to where symbols are not exported unless explicitly specified in the code. Though not recommended, it offers the option (as a cache variable) to enable export of all symbols. Optionally, a symbol export header can be automatically generated at compile-time, which defines the recommended set of symbol export macros.

### Link-Time Optimisations

Link-Time optimisation is a compiler optimization technique that enhances program performance and potentially reduces code size by optimizing the compiled machine code across different compilation units during the linking phase. This feature is disabled during Debug builds because the additional optimisations may interfere with debug symbols.

<details>
<summary>Cache Options</summary>

- To enable/disable link-time optimisations.
    ```
    ${__cache_name}_ENABLE_ROCKHOPPER_STANDARDS_LTO
    ```

</details>
