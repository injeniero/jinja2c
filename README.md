# jinja2c
A [jinja2cpp](https://github.com/jinja2cpp/Jinja2Cpp) interface for C.

# Building
You can build a static lib with: `$make shared` or `$make static`. This wrapper was tested against [Jinja2Cpp 1.3.2](https://github.com/jinja2cpp/Jinja2Cpp/tree/1.3.2)

# API
The exported API is split in two groups: Basic and Advanced.

## Basic
It is meant for quick use, please refer to [basic_interface.h](src/basic_interface.h) and its example use [basic_main.c](src/basic_main.c).

## Advanced
It is optimized by providing a pointer to already parsed templates, that is quite expensive.

Please refer to [advanced_interface.h](src/advanced_interface.h) and its example use [advanced_main.c](src/advanced_main.c).

