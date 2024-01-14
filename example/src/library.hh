/**
 * @file library.hh
 *
 * A basic GetHelloWorld library function for demonstrating the build-system.
 */

#ifndef EXAMPLE_LIBRARY_HH
#define EXAMPLE_LIBRARY_HH

#include <string>

#include "export.h"

/**
 * @brief Returns the "Hello, World!" message.
 * @return A std::string containing the "Hello, World!" message.
 */
EXAMPLE_LIBRARY_EXPORT
auto GetHelloWorld() -> std::string;

#endif // EXAMPLE_LIBRARY_HH
