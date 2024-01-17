local ls = require("luasnip")
local t = ls.text_node
local s = ls.snippet
local i = ls.insert_node
ls.add_snippets("c", {
    s({ trig = "sd", wordTrig = false }, {
        t({ "->" }),
    }),
}, {
    type = "autosnippets",
    key = "cpp_auto",
})
