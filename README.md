
# RockHopper Standards

CMake scripts to enable high-performance and reliability in C++ codebases.

<details>
<summary>Table of Contents</summary>

- [Features](#features)
    - [Compiler Warnings](#compiler-warnings)
- [Getting Started](#getting-started)
- [In Development](#features-in-development)

</details>

The `target_rockhopper_standards` function is used to configure a CMake target by enabling the set of RockHopper Standards.

```cmake
target_rockhopper_standards(
    # The name of the target you want compliant with RockHopper Standards.
    <your_target>
    # A (optional) custom name for target-specific cache options.
    CACHE_NAME <your_target_name>
)
```

## Features

- **[Compiler Warnings](#compiler-warnings)**:<p>
    The minimal set of compiler warnings for maximum safety.<p>

## Getting Started

To use RockHopper Standards in your project, simply add the following to your `CMakeLists.txt`.

```cmake
include(FetchContent)

FetchContent_Declare(
    RockHopperStandards
    GIT_REPOSITORY https://github.com/robertefry/RockHopperStandards.git
    GIT_TAG v1.1.0 )
FetchContent_MakeAvailable(RockHopperStandards)

target_rockhopper_standards(<your_target>)
```

Alternatively, if you are using [CPM](https://github.com/cpm-cmake/CPM.cmake), add the following to your `CMakeLists.txt`
```cmake
CPMAddPackage("gh:robertefry/RockHopperStandards@1.1.0")

target_rockhopper_standards(<your_target>)
```

## Features In Development

- Compiler extensions disabled.
- Static analysis (Clang-Tidy and CppCheck)
- Linker (ABI) safety and optimisation.
- Sanitizer testing.
- Fuzz testing.
- Automatic test targets and build commands.
- Automatic documentation generation (Doxygen).
- (?) Code formatting (Clang-Format)
- (?) Code Generation (where necessary).

## More detail about the features.

### Compiler Warnings

Using the following flags can improve code reliability and maintainability but may generate numerous warnings that require review and resolution. These flags help enhance code quality, and catch various issues such as errors, non-standard code, unwanted type conversions, variable shadowing, and encourage adherence to best practices.

<details>
<summary>GNU/Clang Warnigs</summary>

- `-Werror` treats all warnings as errors, compelling the coder to address warnings during compilation, which promotes stricter code quality, consistency, early bug detection, and prevention of silent bugs.

- `-Wall` and `-Wextra` enable a wide range of warning messages, helping you catch potential issues in your code.

- `-Wpedantic` enforces strict adherence to the C++ language standard, flagging non-standard code constructs.

- `-Wconversion` warns about implicit type conversions that might lead to data loss or unexpected behavior.

- `-Wshadow` alerts you to variable shadowing, where a local variable hides another variable in an outer scope.

- `-Weffc`++ enforces some guidelines from the “Effective C++” book by Scott Meyers, promoting best practices for C++ code.

</details>

You can use a provided cache option to control whether you want to enable or disable the Rockhopper standard compiler warnings. If your target is called `MyTarget_1`, the name of the cache option is:
```
MY_TARGET_1_ENABLE_ROCKHOPPER_STANDARD_WARNINGS
```
If you set this option to `OFF`, it will generate an extra warning during the configuration process, advising against disabling the RockHopper standard warnings.