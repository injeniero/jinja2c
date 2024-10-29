#include "shared.h"

#ifdef __cplusplus
extern "C"
{
#endif
    typedef struct parse_result_t
    {
        void *template_pointer;
        const char *error;
    } parse_result_t;

    parse_result_t jinja2cpp_parse(const char *template_content);

    parse_result_t jinja2cpp_parse_from_file(const char *template_file);

    void jinja2cpp_free_pointer(void *template_pointer);

    render_result_t jinja2cpp_render_pointer(void *template_pointer, const char *json_model);
#ifdef __cplusplus
}
#endif