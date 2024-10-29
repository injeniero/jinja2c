#include "basic_interface.h"
#include "shared_internal.h"

#include <jinja2cpp/template.h>

render_result_t jinja2_render_tpl(jinja2::Template &tpl, const char *json_model);

render_result_t jinja2cpp_render(const char *tpl_content, const char *json_model)
{
    jinja2::Template tpl;
    auto parseResult = tpl.Load(tpl_content);
    if (!parseResult.has_value())
    {
        return {nullptr, string_to_c(parseResult.error().ToString())};
    }
    return jinja2_render_tpl(tpl, json_model);
}

render_result_t jinja2cpp_render_file(const char *tpl_file, const char *json_model)
{
    jinja2::Template tpl;
    auto parseResult = tpl.LoadFromFile(tpl_file);
    if (!parseResult.has_value())
    {
        return {nullptr, string_to_c(parseResult.error().ToString())};
    }
    return jinja2_render_tpl(tpl, json_model);
}

render_result_t jinja2_render_tpl(jinja2::Template &tpl, const char *json_model)
{
    auto modelParseResult = parse_json(json_model);
    if (!modelParseResult.has_value())
    {
        return {nullptr, string_to_c(modelParseResult.error().ToString())};
    }

    auto renderResult = tpl.RenderAsString(modelParseResult.value());
    if (!renderResult.has_value())
    {
        return {nullptr, string_to_c(renderResult.error().ToString())};
    }
    return {string_to_c(renderResult.value()), nullptr};
}
