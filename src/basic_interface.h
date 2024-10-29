#include "shared.h"

#ifdef __cplusplus
extern "C"
{
#endif

    render_result_t jinja2cpp_render(const char *tpl_content, const char *json_model);
    render_result_t jinja2cpp_render_file(const char *tpl_file, const char *json_model);
#ifdef __cplusplus
}
#endif