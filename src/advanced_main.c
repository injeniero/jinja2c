#include "advanced_interface.h"

#include <stdlib.h>
#include <stdio.h>
#include <string.h>

int test_template(void *template_pointer, const char *model_json);

int main()
{
    printf("Starting\n");
    const char *template_content = "Hello {{ name }}!";
    const char *model_json = "{\"name\": \"Simon\"}";

    printf("About to call jinja2cpp_parse\n");
    parse_result_t parse_result = jinja2cpp_parse(template_content);
    if (parse_result.error)
    {
        printf("Error: %s\n", parse_result.error);
        free((void *)parse_result.error);
        return 1;
    }
    int ret = test_template(parse_result.template_pointer, model_json);
    if (ret != 0)
    {
        return ret;
    }

    FILE *f = fopen("test.tpl", "w");
    if (!f)
    {
        printf("Error: could not open file\n");
        return 1;
    }
    fwrite(template_content, 1, strlen(template_content), f);
    fclose(f);

    printf("About to call jinja2cpp_parse_from_file\n");
    parse_result = jinja2cpp_parse_from_file("test.tpl");
    remove("test.tpl");
    if (parse_result.error)
    {
        printf("Error: %s\n", parse_result.error);
        free((void *)parse_result.error);
        return 1;
    }
    ret = test_template(parse_result.template_pointer, model_json);
    if (ret != 0)
    {
        return ret;
    }

    return 0;
}

int test_template(void *template_pointer, const char *model_json)
{
    if (!template_pointer)
    {
        printf("Error: template_pointer is null\n");
        return 1;
    }

    printf("About to call jinja2cpp_render_pointer\n");
    render_result_t render_result = jinja2cpp_render_pointer(template_pointer, model_json);
    if (render_result.error)
    {
        printf("Error: %s\n", render_result.error);
        free((void *)render_result.error);
        return 1;
    }
    else
    {
        printf("Output: %s\n", render_result.result);
        free((void *)render_result.result);
    }

    printf("About to call jinja2cpp_free_pointer\n");
    jinja2cpp_free_pointer(template_pointer);

    return 0;
}
