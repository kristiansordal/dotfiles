local ls = require("luasnip")
local t = ls.text_node
local s = ls.snippet
local i = ls.insert_node
ls.add_snippets("cpp", {
    s({ trig = "scout", wordTrig = false }, {
        t({ "std::cout << " }),
        -- i(1),
        -- t({ " << std::endl;" })

    }),
    s({ trig = "cout", wordTrig = false }, {
        t({ "cout << " }),

    }),
    s({ trig = "endl", wordTrig = false }, {
        t({ "<< endl " }),

    }),
    s({ trig = "sout", wordTrig = false }, {
        t({ "cout << " }),
        i(1),
        t({ "<< \" \";" })

    }),
    s({ trig = "fout", wordTrig = false }, {
        t({ "cout << " }),
        i(1),
        t({ ";" })
    }),
    s({ trig = "flush", wordTrig = false }, {
        t({ "cout << endl;" }),
    }),
    s({ trig = "sflush", wordTrig = false }, {
        t({ "std::cout << std::endl;" }),
    }),
    s({ trig = "usingnam", wordTrig = false }, {
        t({ "using namespace std;" }),

    }),

    s({ trig = "std", wordTrig = false }, {
        t({ "std::" }),
    }),
    s({ trig = "scin", wordTrig = true }, {
        t({ "std::cin >> " }),
    }),
    s({ trig = "cin", wordTrig = true }, {
        t({ "cin >> " }),
    }),
    s({ trig = "sarray", wordTrig = false }, {
        t({ "std::array<" }),
        i(1),
        t({ "," }),
        i(2),
        t({ ">" }),

    }),
    s({ trig = "array", wordTrig = false }, {
        t({ "array<" }),
        i(1),
        t({ "," }),
        i(2),
        t({ ">" }),

    }),
    s({ trig = "svec", wordTrig = false }, {
        t({ "std::vector<" }),
        i(1),
        t({ ">" }),

    }),

    s({ trig = "vvec", wordTrig = false }, {
        t({ "vector<" }),
        i(1),
        t({ ">" }),

    }),
    s({ trig = "sarr", wordTrig = false }, {
        t({ "std::array<" }),
        i(1),
        t({ "," }),
        i(2),
        t({ ">" }),

    }),

    s({ trig = "sd", wordTrig = false }, {
        t({ "->" }),
    }),

}, {
    type = "autosnippets",
    key = "cpp_auto",
})
