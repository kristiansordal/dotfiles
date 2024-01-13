local ls = require("luasnip")
local t = ls.text_node
local s = ls.snippet
ls.add_snippets("python", {
    s({ trig = "sd", wordTrig = true }, {
        t("->"),
    }),
    s({ trig = "intin", wordTrig = true }, {
        t("int(input())"),
    }),
    s({ trig = "mapin", wordTrig = true }, {
        t("map(int, input().split())"),
    }),
    s({ trig = "mapfl", wordTrig = true }, {
        t("map(float, input().split())"),
    }),
}, {
    type = "autosnippets",
    key = "all_auto",
})
