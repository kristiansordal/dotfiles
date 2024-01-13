local tex = {}

tex.in_mathzone = function()
    return vim.fn['vimtex#syntax#in_mathzone']() == 1
end

tex.in_text = function()
    return not tex.in_mathzone()
end
local ls = require("luasnip")

local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local rep = require("luasnip.extras").rep
local fmt = require("luasnip.extras.fmt").fmt
local types = require("luasnip.util.types")
local conds = require("luasnip.extras.expand_conditions")

function math_zone()
    local cursor = vim.api.nvim_win_get_cursor(0)
    local line = vim.api.nvim_get_current_line()

    local before_cursor = line:sub(1, cursor[2])
    local after_cursor = line:sub(cursor[2] + 1)

    local _, start_idx = before_cursor:find("%$")
    local end_idx, _ = after_cursor:find("%$")

    return start_idx and end_idx
end

ls.add_snippets("markdown", {


    s("binom",
        fmt("\\binom{{{1}}}{{{2}}}",
            { i(1), i(2) })
        , { condition = math_zone }),

    s("st", {
        t({ "\\sqrt{" }),
        i(1),
        t({ "}" })
    }, { condition = math_zone }),

    s("mbb", {
        t({ "\\mathbb{" }),
        i(1),
        t({ "}" })
    }, { condition = math_zone }),

    -- GREEK LETTERS
    s({ trig = "alph", wordTrig = false }, {
        t("\\alpha"),
    }, { condition = math_zone }),


    ls.parser.parse_snippet(
        { trig = "pc", wordTrig = false },
        "\\%"
    ),

    s({ trig = "beta", wordTrig = false }, {
        t("\\beta"),
    }, { condition = math_zone }),

    s({ trig = "gam", wordTrig = false }, {
        t("\\gamma"),
    }, { condition = math_zone }),

    s({ trig = "Gam", wordTrig = false }, {
        t("\\Gamma"),
    }, { condition = math_zone }),

    s({ trig = "del", wordTrig = false }, {
        t("\\delta"),
    }, { condition = math_zone }),

    s({ trig = "Del", wordTrig = false }, {
        t("\\Delta"),
    }, { condition = math_zone }),

    s({ trig = "eps", wordTrig = false }, {
        t("\\epsilon"),
    }, { condition = math_zone }),

    s({ trig = "veps", wordTrig = false }, {
        t("\\varepsilon"),
    }, { condition = math_zone }),

    s({ trig = "zet", wordTrig = false }, {
        t("\\zeta"),
    }, { condition = math_zone }),

    s({ trig = "tht", wordTrig = false }, {
        t("\\theta"),
    }, { condition = math_zone }),

    s({ trig = "Tht", wordTrig = false }, {
        t("\\Theta"),
    }, { condition = math_zone }),

    s({ trig = "vtht", wordTrig = false }, {
        t("\\vartheta"),
    }, { condition = math_zone }),

    s({ trig = "iota", wordTrig = false }, {
        t("\\iota"),
    }, { condition = math_zone }),

    s({ trig = "kap", wordTrig = false }, {
        t("\\kappa"),
    }, { condition = math_zone }),

    s({ trig = "lam", wordTrig = false }, {
        t("\\lambda"),
    }, { condition = math_zone }),

    s({ trig = "tar", wordTrig = false }, {
        t("\\star"),
    }, { condition = math_zone }),

    s({ trig = "Lam", wordTrig = false }, {
        t("\\Lambda"),
    }, { condition = math_zone }),

    s({ trig = "mu", wordTrig = false }, {
        t("\\mu"),
    }, { condition = math_zone }),

    s({ trig = "nu", wordTrig = false }, {
        t("\\nu"),
    }, { condition = math_zone }),

    s({ trig = "xi", wordTrig = false }, {
        t("\\Xi"),
    }, { condition = math_zone }),

    s({ trig = "pi", wordTrig = false }, {
        t("\\pi"),
    }, { condition = math_zone }),

    s({ trig = "Pi", wordTrig = false }, {
        t("\\Pi"),
    }, { condition = math_zone }),

    s({ trig = "rho", wordTrig = false }, {
        t("\\rho"),
    }, { condition = math_zone }),

    s({ trig = "vrho", wordTrig = false }, {
        t("\\varrho"),
    }, { condition = math_zone }),

    s({ trig = "tau", wordTrig = false }, {
        t("\\tau"),
    }, { condition = math_zone }),

    s({ trig = "ups", wordTrig = false }, {
        t("\\upsilon"),
    }, { condition = math_zone }),

    s({ trig = "Ups", wordTrig = false }, {
        t("\\Upsilon"),
    }, { condition = math_zone }),

    s({ trig = "ph", wordTrig = false }, {
        t("\\phi"),
    }, { condition = math_zone }),

    s({ trig = "Ph", wordTrig = false }, {
        t("\\Phi"),
    }, { condition = math_zone }),

    s({ trig = "vphi", wordTrig = false }, {
        t("\\varphi"),
    }, { condition = math_zone }),

    s({ trig = "chi", wordTrig = false }, {
        t("\\chi"),
    }, { condition = math_zone }),

    s({ trig = "psi", wordTrig = false }, {
        t("\\psi"),
    }, { condition = math_zone }),

    s({ trig = "Psi", wordTrig = false }, {
        t("\\psi"),
    }, { condition = math_zone }),

    s({ trig = "omg", wordTrig = false }, {
        t("\\omega"),
    }, { condition = math_zone }),

    s({ trig = "Omg", wordTrig = false }, {
        t("\\Omega"),
    }, { condition = math_zone }),

    s({ trig = "sig", wordTrig = false }, {
        t("\\sigma"),
    }, { condition = math_zone }),

    s({ trig = "Sig", wordTrig = false }, {
        t("\\Sigma"),
    }, { condition = math_zone }),


    s("iff", {
        t("\\iff"),
    }, { condition = math_zone }),
    -- Infinity
    s("inf", {
        t({ "\\infty" })
    }, { condition = math_zone }),
    s("iinf", {
        t({ "∞" })
    }),

    -- Negative Infinity
    s("minf", {
        t({ "-\\infty" })
    }, { condition = math_zone }),

    s({ trig = "tht", wordTrig = false }, {
        t("\\theta"),
    }, { condition = math_zone }),

    s({ trig = "Tht", wordTrig = false }, {
        t("\\Theta"),
    }, { condition = math_zone }),

    s("qu", {
        t({ "\\quad" }),
    }, { condition = math_zone }),

    s("To", {
        t({ "\\Rightarrow" }),
    }, { condition = math_zone }),
    s("to", {
        t({ "\\rightarrow" }),
    }, { condition = math_zone }),

    -- Cdots
    s("c...", {
        t({ "\\cdots " })
    }, { condition = math_zone }),

    s("l...", {
        t({ "\\ldots " })
    }, { condition = math_zone }),

    s("v...", {
        t({ "\\vdots " })
    }, { condition = math_zone }),

    s("d...", {
        t({ "\\ddots " })
    }, { condition = math_zone }),
    s("...", {
        t({ "\\dots " })
    }, { condition = math_zone }),
    -- Less than
    s("leq", {
        t({ "\\leq" }),
    }, { condition = math_zone }),

    -- Greater than
    s("geq", {
        t({ "\\geq" }),
    }, { condition = math_zone }),

    -- Not equal to
    s("!=", {
        t({ "\\neq" }),
    }, { condition = math_zone }),
    -- Left right brackets
    s({ trig = "lrb", wordTrig = false }, {
        t({ "\\left[ " }),
        f(function(_, snip)
            return snip.env.TM_SELECTED_TEXT[1] or {}
        end, {}),
        i(1),
        t({ " \\right]" }),
    }, { condition = math_zone }),

    -- Left right curly braces
    s({ trig = "lrc", wordTrig = false }, {
        t({ "\\left\\{ " }),
        f(function(_, snip)
            return snip.env.TM_SELECTED_TEXT[1] or {}
        end, {}),
        i(1),
        t({ " \\right\\}" }),
    }, { condition = math_zone }),
    s({ trig = "(%a)(%d)%s", regTrig = true }, {
        f(function(_, snip)
            return snip.captures[1] .. "_{" .. snip.captures[2] .. "} "
        end, {})
    }, { condition = math_zone }),
    -- Square
    s({ trig = "sr", wordTrig = false }, {
        t("^2")
    }, { condition = math_zone }),

    -- Cube
    s({ trig = "cub", wordTrig = false }, {
        t("^3")
    }, { condition = math_zone }),
    -- Log
    s("log", {
        t({ "\\log" }),
    }, { condition = math_zone }),
    -- Fraction that allows for writing 5/4 and ending up with \frac{5}{4}
    s({ trig = "(%d-[\\]?%a-)/(%d-[\\]?%a-)%s", regTrig = true }, {
        f(function(_, snip)
            return "\\frac{" .. snip.captures[1] .. "}{" .. snip.captures[2] .. "} "
        end, {})
    }, { condition = math_zone }),
    -- Fraction
    s("//",
        fmt("\\frac{{{1}}}{{{2}}}",
            { i(1), i(2) })
        , { condition = math_zone }),
    -- Multiply
    s("dot", {
        t({ "\\cdot " })
    }, { condition = math_zone }),
    s("link", {
        t("["),
        i(1),
        t("]("),
        i(2),
        t(")")
    }),
    s("km", {
        t("`"),
        f(function(_, snip)
            return snip.env.TM_SELECTED_TEXT[1] or {}
        end, {}),
        i(1),
        t("`")
    }, { condition = tex.in_text }),

    -- Set theory symbols
    s({ trig = "cup", wordTrig = true }, {
        t("\\cup"),
    }, { condition = math_zone }),
    s({ trig = "cap", wordTrig = true }, {
        t("\\cap"),
    }, { condition = math_zone }),
    s({ trig = "subeq", wordTrig = true }, {
        t("\\subseteq"),
    }, { condition = math_zone }),
    s({ trig = "supeq", wordTrig = true }, {
        t("\\supseteq"),
    }, { condition = math_zone }),
    s({ trig = "subs", wordTrig = true }, {
        t("\\subset"),
    }, { condition = math_zone }),
    s({ trig = "sups", wordTrig = true }, {
        t("\\supset"),
    }, { condition = math_zone }),
    s({ trig = "varn", wordTrig = true }, {
        t("\\varnothing"),
    }, { condition = math_zone }),
    s({ trig = "cong", wordTrig = true }, {
        t("\\cong"),
    }, { condition = math_zone }),
    s("inn", {
        t({ "\\in" })
    }, { condition = math_zone }),
    s("minn", {
        t({ "∈" })
    }),
    s("mninn", {
        t({ "∉" })
    }),
    s("fra", {
        t("\\forall"),
    }, { condition = math_zone }),
    s("mfra", {
        t("∀"),
    }),
    s("emset", {
        t("⦰"),
    }),
    s("msubeq", {
        t("⊆"),
    }),
    s({ trig = "setm", wordTrig = false }, {
        t("\\setminus")
    }, { condition = math_zone }),

    -- Bold
    s("bf", {
        t("**"),
        f(function(_, snip)
            return snip.env.TM_SELECTED_TEXT[1] or {}
        end, {}),
        i(1),
        t("**")
    }, { condition = tex.in_text }),
    s("ul", {
        t("_"),
        f(function(_, snip)
            return snip.env.TM_SELECTED_TEXT[1] or {}
        end, {}),
        i(1),
        t("_")
    }, { condition = tex.in_text }),


    -- Power
    s({ trig = "pow", wordTrig = false }, {
        t("^{"),
        i(1),
        t("}")
    }, { condition = math_zone }),

    -- Absolute value
    s({ trig = "abs", wordTrig = false }, {
        t({ "\\left| " }),
        f(function(_, snip)
            return snip.env.TM_SELECTED_TEXT[1] or {}
        end, {}),
        i(1),
        t({ " \\right|" }),
    }, { condition = math_zone }),

    -- Big o runtime
    s("on",
        fmt("\\mathcal{{O}}\\left({1}\\right)",
            {
                i(1),
            })
        , { condition = math_zone }),

    -- Text in math zone
    s("tt", {
        t("\\text{"),
        f(function(_, snip)
            return snip.env.TM_SELECTED_TEXT[1] or {}
        end, {}),
        i(1),
        t("}")
    }, { condition = math_zone }),
    -- Italic
    s("ita", {
        t("*"),
        f(function(_, snip)
            return snip.env.TM_SELECTED_TEXT[1] or {}
        end, {}),
        i(1),
        t("*")
    }, { condition = tex.in_text }),
    s({ trig = "lam", wordTrig = false }, {
        t("\\lambda"),
    }),
    s("dm", {
        t({ "$$" }),
        f(function(_, snip)
            return snip.env.TM_SELECTED_TEXT[1] or {}
        end, {}),
        i(1),
        t({ "$$" }),
    }),
    s("mk", {
        t({ "$" }),
        f(function(_, snip)
            return snip.env.TM_SELECTED_TEXT[1] or {}
        end, {}),
        i(1),
        t({ "$" }),
    }),
    s({ trig = "lrp", wordTrig = false }, {
        t({ "\\left( " }),
        f(function(_, snip)
            return snip.env.TM_SELECTED_TEXT[1] or {}
        end, {}),
        i(1),
        t({ " \\right)" }),
    }),
    s({ trig = "Gam", wordTrig = false }, {
        t("\\Gamma"),
    }),
    s({ trig = "vd", wordTrig = false }, {
        t("\\vdash"),
    }),
    s({ trig = "rsq", wordTrig = false }, {
        t("\\rightsquigarrow"),
    }),
    s("sd", {
        t("->"),
    }),
    s("ds", {
        t("<-"),
    }),
    s("Sd", {
        t("=>"),
    }),
    s({ trig = "1;", wordTrig = false }, {
        t({ "æ" })
    }, {}),

    s({ trig = "2;", wordTrig = false }, {
        t({ "ø" })
    }, {}),

    s({ trig = "3;", wordTrig = false }, {
        t({ "å" })
    }, {}),
}, {
    type = "autosnippets",
    key = "md_auto",
})
