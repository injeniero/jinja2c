#ifndef SHARED_INTERNAL_H
#define SHARED_INTERNAL_H

#include <jinja2cpp/template.h>

jinja2::Result<jinja2::ValuesMap> parse_json(const char *json_model);

char *string_to_c(const std::string &str);

#endif // SHARED_INTERNAL_H