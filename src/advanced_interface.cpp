#include "advanced_interface.h"
#include "shared_internal.h"

#include <jinja2cpp/template.h>

parse_result_t jinja2cpp_parse(const char *template_content)
{
    auto tpl = new jinja2::Template();
    auto parseResult = tpl->Load(template_content);
    if (!parseResult.has_value())
    {
        return {nullptr, string_to_c(parseResult.error().ToString())};
    }
    return {tpl, nullptr};
}

parse_result_t jinja2cpp_parse_from_file(const char *template_file)
{
    auto tpl = new jinja2::Template();
    auto parseResult = tpl->LoadFromFile(template_file);
    if (!parseResult.has_value())
    {
        return {nullptr, string_to_c(parseResult.error().ToString())};
    }
    return {tpl, nullptr};
}

void jinja2cpp_free_pointer(void *template_pointer)
{
    auto tpl = static_cast<jinja2::Template *>(template_pointer);
    delete tpl;
}

render_result_t jinja2cpp_render_pointer(void *template_pointer, const char *json_model)
{
    auto tpl = static_cast<jinja2::Template *>(template_pointer);

    auto modelParseResult = parse_json(json_model);
    if (!modelParseResult.has_value())
    {
        return {nullptr, string_to_c(modelParseResult.error().ToString())};
    }

    auto renderResult = tpl->RenderAsString(modelParseResult.value());
    if (!renderResult.has_value())
    {
        return {nullptr, string_to_c(renderResult.error().ToString())};
    }
    return {string_to_c(renderResult.value()), nullptr};
}
