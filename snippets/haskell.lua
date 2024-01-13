local ls = require("luasnip")
local t = ls.text_node
local s = ls.snippet
ls.add_snippets("haskell", {
    s({ trig = "sd", wordTrig = true }, {
        t("->"),
    }),
    s({ trig = "ds", wordTrig = true }, {
        t("<-"),
    }),
    s({ trig = "Sd", wordTrig = true }, {
        t("=>"),
    }),
    s("bn", {
        t(">>="),
    }),
    s("nb", {
        t("=<<"),
    }),

    s("emb", {
        t(">=>"),
    }),

    s("chc", {
        t("<|>")
    }),
    s("fmm", {
        t("<$>"),
    }),

    s("dv", {
        t("`div`"),
    }),
    s("md", {
        t("`mod`"),
    }),
    s("usz", {
        t("ℤ"),
    }),
    s("usb", {
        t("𝔹"),
    }),

}, {
    type = "autosnippets",
    key = "hs_auto",
})
