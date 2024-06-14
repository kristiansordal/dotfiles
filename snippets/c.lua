local ls = require("luasnip")
local t = ls.text_node
local s = ls.snippet
local i = ls.insert_node
local fmt = require("luasnip.extras.fmt").fmt
local rep = require("luasnip.extras").rep

-- for (int {2} = 0; {2} < {1}; {2}++) {
-- \t{3}
-- }
ls.add_snippets("c", {
    s(
        "fori",
        fmt(
            [[
            for (int {2} = {5}; {3} < {1}; {4}++) {{
                {6}
            }}
            ]],
            {
                i(1, 'n'),
                i(2, 'i'),
                rep(2),
                rep(2),
                i(3, '0'),
                i(4)

            }
        )
    ),
}, { key = "c", })
ls.add_snippets("c", {
    s({ trig = "sd", wordTrig = false }, {
        t({ "->" }),
    }),
}, {
    type = "autosnippets",
    key = "c_auto",
})
