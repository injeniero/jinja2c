#include "shared_internal.h"

#include <jinja2cpp/binding/rapid_json.h>
#include <rapidjson/error/en.h>

using JsonDocumentType = rapidjson::GenericDocument<rapidjson::UTF8<>>;

jinja2::Result<jinja2::ValuesMap> parse_json(const char *json_model)
{
    auto jsonDoc = JsonDocumentType();
    rapidjson::ParseResult res = jsonDoc.Parse(json_model);
    if (!res)
    {
        jinja2::ErrorInfoTpl<char>::Data errorData;
        errorData.code = jinja2::ErrorCode::MetadataParseError;
        std::string jsonError = rapidjson::GetParseError_En(res.Code());
        errorData.extraParams.push_back(jinja2::Value(std::move(jsonError)));
        return nonstd::make_unexpected(jinja2::ErrorInfoTpl<char>(errorData));
    }
    jinja2::ValuesMap vMap = {};
    auto gMap = std::move(nonstd::get<jinja2::GenericMap>(jinja2::Reflect(jsonDoc).data()));
    for (auto const &x : gMap.GetKeys())
    {
        vMap[x] = gMap[x];
    }
    auto result = std::move(vMap);
    return result;
}

char *string_to_c(const std::string &str)
{
    char *cStr = new char[str.length() + 1];
    strcpy(cStr, str.c_str());
    return cStr;
}
