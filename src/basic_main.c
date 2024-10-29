#include "basic_interface.h"
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

int main()
{
    printf("Starting\n");
    const char *template_content = "Hello {{ name }}!";
    const char *model_json = "{\"name\": \"Simon\"}";

    printf("About to call jinja2cpp_render\n");
    render_result_t render_result = jinja2cpp_render(template_content, model_json);
    if (render_result.error)
    {
        printf("Error: %s\n", render_result.error);
        return 1;
    }
    else if (!render_result.result)
    {
        printf("Error: result is null\n");
        return 1;
    }
    else
    {
        printf("Output: %s\n", render_result.result);
    }

    FILE * f = fopen("test.tpl", "w");
    if (!f)
    {
        printf("Error: could not open file\n");
        return 1;
    }
    fwrite(template_content, 1, strlen(template_content), f);
    fclose(f);

    printf("About to call jinja2cpp_render_file\n");
    render_result_t render_result_file = jinja2cpp_render_file("test.tpl", model_json);
    remove("test.tpl");
    if (render_result_file.error)
    {
        printf("Error: %s\n", render_result_file.error);
        free((void *)render_result.error);
        return 1;
    }
    else
    {
        printf("Output: %s\n", render_result_file.result);
        free((void *)render_result_file.result);
        return 0;
    }
}
