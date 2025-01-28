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

ls.config.set_config({
    history = false,
    enable_autosnippets = true,
    ext_base_prio = 300,
    ext_prio_increase = 1,
    update_events = "TextChanged,TextChangedI",
    delete_check_events = "TextChanged, CursorMoved",
    region_check_events = "CursorMoved",
    ext_opts = {
        [types.choiceNode] = {
            active = {
                virt_text = { { "choice node", "Comment" } },
            },
        },
    },
    store_selection_keys = "<Tab>"
})


local cmp = require("cmp")
lvim.builtin.cmp.mapping = cmp.mapping.preset.insert({
    ["<C-k>"] = cmp.mapping.select_prev_item(),
    ["<C-j>"] = cmp.mapping.select_next_item(),
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm({ select = false }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    ['<S-Tab>'] = cmp.mapping(function(fallback)
        if ls.jumpable(-1) then
            ls.jump(-1)
        else
            fallback()
        end
    end, {
        'i',
        's',
    }),
    ['<Tab>'] = cmp.mapping(function(fallback)
        if ls.expand_or_jumpable() then
            ls.expand_or_jump()
        else
            fallback()
        end
    end, {
        'i',
        's',
    }),
    ['<C-x>'] = cmp.mapping(function(fallback)
        if ls.choice_active() then
            ls.change_choice(1)
        else
            fallback()
        end
    end, { 'i', 's', }
    ),
})

-- Snippet functions
local rec_ls
rec_ls = function()
    return sn(
        nil,
        c(1, {
            -- Order is important, sn(...) first would cause infinite loop of expansion.
            t(""),
            sn(nil, { t({ "", "\t\\item " }), i(1), d(2, rec_ls, {}) }),
        })
    )
end

local tex = {}

tex.in_mathzone = function()
    return vim.fn['vimtex#syntax#in_mathzone']() == 1
end

tex.in_text = function()
    return not tex.in_mathzone()
end

--- LATEX SNIPPETS ---
ls.add_snippets("tex", {
    s(
        "docstart",
        fmt(
            [[
            \documentclass{{article}}
            \input{{preamble.tex}}

            \begin{{document}}
                \section{{{1}}}
            \end{{document}}
            ]],
            {
                i(1),
            }
        )
    ),
    s(
        "bafig",
        fmt(
            [[
                \begin{{figure}}[H]
                    \begin{{center}}
                        \includegraphics[width=0.95\textwidth]{{{1}}}
                    \end{{center}}
                    \caption{{{2}}}
                    \label{{fig:{3}}}
                \end{{figure}}
            ]],
            {
                i(1),
                i(2),
                rep(1)
            }
        )
    ),

    s(
        "codefig",
        fmt(
            [[
            \begin{{figure}}[H]
                \begin{{lstlisting}}
                {1}
                \end{{lstlisting}}
                \caption{{{2}}}
                \label{{fig:{3}}}
            \end{{figure}}
            ]],
            {
                i(1),
                i(2),
                i(3)
            }
        )
    ),

    s(
        "svgfig",
        fmt(
            [[
                \begin{{figure}}[H]
                    \centering
                        \def\svgwidth{{{1}\textwidth}}
                        \import{{./figures/}}{{{2}.pdf_tex}}
                    \caption{{{3}}}
                    \label{{fig:{4}}}
                \end{{figure}}
            ]],
            {
                i(1),
                i(2),
                i(3),
                rep(3)
            }
        )
    ),
    s(
        "bedef",
        fmt(
            [[
                \begin{{definition}}[{1}]
                    \label{{def:{2}}}
                    {3}
                \end{{definition}}
            ]],
            {
                i(1),
                rep(1),
                i(2)
            }
        )
    ),
    s(
        "bethm",
        fmt(
            [[
                \begin{{theorem}}[{1}]
                    \label{{thm:{2}}}
                    {3}
                \end{{theorem}}
            ]],
            {
                i(1),
                rep(1),
                i(2)
            }
        )
    ),
    s(
        "belem",
        fmt(
            [[
                \begin{{lemma}}[{1}]
                    \label{{lem:{2}}}
                    {3}
                \end{{lemma}}
            ]],
            {
                i(1),
                rep(1),
                i(2)
            }
        )
    ),
    s(
        "beprf",
        fmt(
            [[
                \begin{{proof}}[{1}]
                    \label{{proof:{2}}}
                    {3}
                \end{{proof}}
            ]],
            {
                i(1),
                rep(1),
                i(2)
            }
        )
    ),

    s("incfig", {
        -- t("\\incfig["),
        -- i(1),
        -- t("]{"),
        -- i(2),
        -- t("}"),
        f(function(_, snip)
            -- return snip.env.TM_SELECTED_TEXT[1] or {}
            local path = "~/inkscape-template/inkscape-figures/bin/inkscape-figures create " ..
                snip.env.TM_SELECTED_TEXT[1]
            return os.execute("python3 " .. path)
        end, {}),
    }, {}),

    s("batab",
        fmt([[
                \begin{{table}}{1}
                    \begin{{center}}
                        \begin{{tabular}}[c]{{{2}}}
                            \hline
                            {3} & {4} \\
                            {5} & {6} \\
                            \hline
                        \end{{tabular}}
                    \end{{center}}
                \end{{table}}
        ]],
            {
                c(1, { t("[H]"), t("") }),
                i(2),
                i(3),
                i(4),
                i(5),
                i(6),
            })),

    s(
        "preamble",
        fmt(
            [[
                \documentclass{{article}}
             	\usepackage{{caption}}
             	\usepackage{{subcaption}}
             	\makeatletter
             	\renewcommand{{\contentsname}}{{Innhold}}
             	\renewcommand{{\figurename}}{{Figur}}
             	\renewcommand{{\tablename}}{{Tabell}}
             	\renewcommand{{\chaptername}}{{Kapittel}}
             	\renewcommand{{\listfigurename}}{{Figurliste}}
             	\renewcommand{{\listtablename}}{{Tabelliste}}
             	\titleformat{{\chapter}}[display]
              		{{\normalfont\bfseries}}{{}}{{0pt}}{{\Huge}}
             	\graphicspath{{{1}}}
             	\author{{Kristian Sørdal}}
             	\makeatother
             	\doublespacing
             	\begin{{document}}
             	\title{{\textbf{{{{{2}}}}}
             	\maketitle
             	\newpage
             	\tableofcontents
             	\newpage
             	\listoffigures
             	\listoftables

                {3}

             	\end{{document}}

            ]],
            { i(1), i(2), i(3) }
        )
    ),
    s(
        "preamble 2",
        fmt(
            [[
            % Some basic packages
            \usepackage[utf8]{{inputenc}}
            \usepackage{{textcomp}}
            \usepackage{{url}}
            \usepackage{{graphicx}}
            \usepackage{{float}}
            \usepackage{{booktabs}}
            \usepackage{{enumitem}}

            % Hide page number when page is empty
            \usepackage{{emptypage}}
            \usepackage{{subcaption}}
            \usepackage{{multicol}}
            \usepackage{{xcolor}}

            % Math stuff
            \usepackage{{amsmath, amsfonts, mathtools, amsthm, amssymb}}
            % Fancy script capitals
            \usepackage{{mathrsfs}}
            \usepackage{{cancel}}

            % Bold math
            \usepackage{{bm}}

            % Some shortcuts
            \newcommand\N{{\ensuremath{{\mathbb{{N}}}}}}
            \newcommand\R{{\ensuremath{{\mathbb{{R}}}}}}
            \newcommand\Z{{\ensuremath{{\mathbb{{Z}}}}}}
            \renewcommand\O{{\ensuremath{{\emptyset}}}}
            \newcommand\Q{{\ensuremath{{\mathbb{{Q}}}}}}
            \newcommand\C{{\ensuremath{{\mathbb{{C}}}}}}

            %Make implies and impliedby shorter
            \let\implies\Rightarrow
            \let\impliedby\Leftarrow
            \let\iff\Leftrightarrow
            \let\epsilon\varepsilon

            % Add \contra symbol to denote contradiction
            % \usepackage{{stmaryrd}} % for \lightning
            % \newcommand\contra{{\scalebox{{1.5}}{{$\lightning$}}}}

            % \let\phi\varphi

            % Command for short corrections
            % Usage: 1+1=\correct{{3}}{{2}}

            \definecolor{{correct}}{{HTML}}{{009900}}
            \newcommand\correct[2]{{\ensuremath{{\:}}{{\color{{red}}{{#1}}}}\ensuremath{{\to }}{{\color{{correct}}{{#2}}}}\ensuremath{{\:}}}}
            \newcommand\green[1]{{{{\color{{correct}}{{#1}}}}}}

            % horizontal rule
            \newcommand\hr{{
                \noindent\rule[0.5ex]{{\linewidth}}{{0.5pt}}
            }}

            % hide parts
            \newcommand\hide[1]{{}}

            % Environments
            \makeatother
            % For box around Definition, Theorem, \ldots
            \usepackage{{mdframed}}
            \mdfsetup{{skipabove=1em,skipbelow=0em}}
            \theoremstyle{{definition}}

            \newmdtheoremenv[nobreak=true]{{definition}}{{Definition}}
            \newtheorem*{{eg}}{{Example}}
            \newtheorem*{{notation}}{{Notation}}
            \newtheorem*{{previouslyseen}}{{As previously seen}}
            \newtheorem*{{remark}}{{Remark}}
            \newtheorem*{{note}}{{Note}}
            \newtheorem*{{problem}}{{Problem}}
            \newtheorem*{{observe}}{{Observe}}
            \newtheorem*{{property}}{{Property}}
            \newtheorem*{{intuition}}{{Intuition}}
            \newmdtheoremenv[nobreak=true]{{prop}}{{Proposition}}
            \newmdtheoremenv[nobreak=true]{{theorem}}{{Theorem}}
            \newmdtheoremenv[nobreak=true]{{corollary}}{{Corollary}}

            % End example and intermezzo environments with a small diamond (just like proof
            % environments end with a small square)
            \usepackage{{etoolbox}}
            \AtEndEnvironment{{vb}}{{\null\hfill$\diamond$}}%
            \AtEndEnvironment{{intermezzo}}{{\null\hfill$\diamond$}}%
            % \AtEndEnvironment{{opmerking}}{{\null\hfill$\diamond$}}%

            % Fix some spacing
            % http://tex.stackexchange.com/questions/22119/how-can-i-change-the-spacing-before-theorems-with-amsthm
            \makeatletter
            \def\thm@space@setup{{%
              \thm@preskip=\parskip \thm@postskip=0pt
            }}


            % Exercise
            % Usage:
            % \oefening{{5}}
            % \suboefening{{1}}
            % \suboefening{{2}}
            % \suboefening{{3}}
            % gives
            % Oefening 5
            %   Oefening 5.1
            %   Oefening 5.2
            %   Oefening 5.3
            \newcommand{{\oefening}}[1]{{%
                \def\@oefening{{#1}}%
                \subsection*{{Oefening #1}}
            }}

            \newcommand{{\suboefening}}[1]{{%
                \subsubsection*{{Oefening \@oefening.#1}}
            }}


            % \lecture starts a new lecture (les in dutch)
            %
            % Usage:
            % \lecture{{1}}{{di 12 feb 2019 16:00}}{{Inleiding}}
            %
            % This adds a section heading with the number / title of the lecture and a
            % margin paragraph with the date.

            % I use \dateparts here to hide the year (2019). This way, I can easily parse
            % the date of each lecture unambiguously while still having a human-friendly
            % short format printed to the pdf.

            \usepackage{{xifthen}}
            \def\testdateparts#1{{\dateparts#1\relax}}
            \def\dateparts#1 #2 #3 #4 #5\relax{{
                \marginpar{{\small\textsf{{\mbox{{#1 #2 #3 #5}}}}}}
            }}

            \def\@lecture{{}}%
            \newcommand{{\lecture}}[3]{{
                \ifthenelse{{\isempty{{#3}}}}{{%
                    \def\@lecture{{Lecture #1}}%
                }}{{%
                    \def\@lecture{{Lecture #1: #3}}%
                }}%
                \subsection*{{\@lecture}}
                \marginpar{{\small\textsf{{\mbox{{#2}}}}}}
            }}



            % These are the fancy headers
            \usepackage{{fancyhdr}}
            \pagestyle{{fancy}}

            % LE: left even
            % RO: right odd
            % CE, CO: center even, center odd
            % My name for when I print my lecture notes to use for an open book exam.
            % \fancyhead[LE,RO]{{Gilles Castel}}

            \fancyhead[RO,LE]{{\@lecture}} % Right odd,  Left even
            \fancyhead[RE,LO]{{}}          % Right even, Left odd

            \fancyfoot[RO,LE]{{\thepage}}  % Right odd,  Left even
            \fancyfoot[RE,LO]{{}}          % Right even, Left odd
            \fancyfoot[C]{{\leftmark}}     % Center

            \makeatother

            % Todonotes and inline notes in fancy boxes
            \usepackage{{todonotes}}
            \usepackage{{tcolorbox}}

            % Make boxes breakable
            \tcbuselibrary{{breakable}}

            % Figure support as explained in my blog post.
            \usepackage{{import}}
            \usepackage{{xifthen}}
            \usepackage{{pdfpages}}
            \usepackage{{transparent}}
            \newcommand{{\incfig}}[1]{{%
                \def\svgwidth{{\columnwidth}}
                \import{{./figures/}}{{#1.pdf_tex}}
            }}

            % Fix some stuff
            % %http://tex.stackexchange.com/questions/76273/multiple-pdfs-with-page-group-included-in-a-single-page-warning
            \pdfsuppresswarningpagegroup=1

            \author{{Kristian Sørdal}}

            \begin{{document}}

            \end{{document}}
        ]], {}
        )
    )
}, { key = "tex" })


-- AUTOSNIPPETS
ls.add_snippets("tex", {
    -- MATH AUTOSNIPPETS

    s({ trig = "itm", wordTrig = true }, {
        t({ "\\item " })
    }, {}),

    s({ trig = "1;", wordTrig = false }, {
        t({ "æ" })
    }, {}),

    s({ trig = "2;", wordTrig = false }, {
        t({ "ø" })
    }, {}),

    s({ trig = "3;", wordTrig = false }, {
        t({ "å" })
    }, {}),

    -- Display math
    s("dm", {
        t({ "\\[" }),
        f(function(_, snip)
            return snip.env.TM_SELECTED_TEXT[1] or {}
        end, {}),
        i(1),
        t({ "\\]" }),
    }, { condition = tex.in_text }),

    -- s("im", {
    --     t({ "$" }),
    --     f(function(_, snip)
    --         return snip.env.TM_SELECTED_TEXT[1] or {}
    --     end, {}),
    --     i(1),
    --     t({ "$" }),
    -- }, { condition = tex.in_text }),

    -- Inline math
    s("mk", {
        t({ "\\(" }),
        f(function(_, snip)
            return snip.env.TM_SELECTED_TEXT[1] or {}
        end, {}),
        i(1),
        t({ "\\)" }),
    }, { condition = tex.in_text }),

    -- Multiply
    s("dot", {
        t({ "\\cdot " })
    }, { condition = tex.in_mathzone }),

    -- Times
    s("xx", {
        t({ "\\times " })
    }, { condition = tex.in_mathzone }),

    -- F of x
    s("fx", {
        t({ "f(x)" })
    }, { condition = tex.in_mathzone }),

    -- G of x
    s("gx", {
        t({ "g(x)" })
    }, { condition = tex.in_mathzone }),

    -- H of x
    s("hx", {
        t({ "h(x)" })
    }, { condition = tex.in_mathzone }),

    -- Percent
    ls.parser.parse_snippet(
        { trig = "pc", wordTrig = false },
        "\\%"
    ),

    -- Infinity
    s("inf", {
        t({ "\\infty" })
    }, { condition = tex.in_mathzone }),

    -- Negative Infinity
    s("minf", {
        t({ "-\\infty" })
    }, { condition = tex.in_mathzone }),


    -- Overline
    s("ovr", {
        t({ "\\overline{" }),
        i(1),
        t({ "}" })
    }, { condition = tex.in_mathzone }),

    -- Vector
    s({ trig = "(\\?%w-)(,%.)", regTrig = true }, {
        f(function(_, snip)
            if snip.captures[1] ~= "" then
                return "\\vec{" .. snip.captures[1] .. "}"
            else
                return "\\vec{}"
            end
        end, {})
    }, { condition = tex.in_mathzone }),

    s({ trig = "(\\?%w-)(%.,)", regTrig = true }, {
        f(function(_, snip)
            if snip.captures[1] ~= "" then
                return "\\vec{" .. snip.captures[1] .. "}"
            else
                return "\\vec{}"
            end
        end, {})
    }, { condition = tex.in_mathzone }),


    -- Square root
    s("st", {
        t({ "\\sqrt{" }),
        i(1),
        t({ "}" })
    }, { condition = tex.in_mathzone }),

    -- Range integral
    s("dint",
        fmt("\\int_{{{1}}}^{{{2}}} {3} d{4}",
            {
                i(1),
                i(2),
                i(3),
                c(4, { t("x"), t("y"), t("z"), t("t"), t("r"), t("\\theta") })
            })
        , { condition = tex.in_mathzone }),

    -- Normal integral sign
    s("int", {
        t({ "\\int" }),
    }, { condition = tex.in_mathzone }),

    -- Double integral
    s("2int", {
        t({ "\\iint" }),
    }, { condition = tex.in_mathzone }),

    -- Triple Integral
    s("3int", {
        t({ "\\iiint" }),
    }, { condition = tex.in_mathzone }),

    -- Close integral sign
    s("oint", {
        t({ "\\oint" }),
    }, { condition = tex.in_mathzone }),

    -- Arrow
    s("to", {
        t({ "\\rightarrow" }),
    }, { condition = tex.in_mathzone }),
    s("maps", {
        t({ "\\mapsto" }),
    }, { condition = tex.in_mathzone }),

    s("To", {
        t({ "\\Rightarrow" }),
    }, { condition = tex.in_mathzone }),

    -- Fraction
    s("//",
        fmt("\\frac{{{1}}}{{{2}}}",
            { i(1), i(2) })
        , { condition = tex.in_mathzone }),
    s("binom",
        fmt("\\binom{{{1}}}{{{2}}}",
            { i(1), i(2) })
        , { condition = tex.in_mathzone }),

    -- Fraction that allows for writing 5/4 and ending up with \frac{5}{4}
    s({ trig = "(%d-[\\]?%a-)/(%d-[\\]?%a-)%s", regTrig = true }, {
        f(function(_, snip)
            return "\\frac{" .. snip.captures[1] .. "}{" .. snip.captures[2] .. "} "
        end, {})
    }, { condition = tex.in_mathzone }),

    -- Approx
    s("apr", {
        t({ "\\approx" }),
    }, { condition = tex.in_mathzone }),

    -- Less than
    s("leq", {
        t({ "\\leq" }),
    }, { condition = tex.in_mathzone }),

    -- Greater than
    s("geq", {
        t({ "\\geq" }),
    }, { condition = tex.in_mathzone }),

    -- Not equal to
    s("!=", {
        t({ "\\neq" }),
    }, { condition = tex.in_mathzone }),

    s("iso", {
        t({ "\\cong" }),
    }, { condition = tex.in_mathzone }),

    s("andd", {
        t({ "\\wedge" }),
    }, { condition = tex.in_mathzone }),

    s("or", {
        t({ "\\vee" }),
    }, { condition = tex.in_mathzone }),

    -- Plus minus
    s("pmm", {
        t({ "\\pm" }),
    }, { condition = tex.in_mathzone }),

    -- Log
    s("log", {
        t({ "\\log" }),
    }, { condition = tex.in_mathzone }),

    -- Sum
    s("sum",
        fmt("\\sum_{{{1}}}^{{{2}}} {3}",
            {
                i(1),
                i(2),
                i(3),
            })
        , { condition = tex.in_mathzone }),

    s("lim",
        fmt("\\lim_{{n\\rightarrow\\infty}} {1}",
            {
                i(1),
            })
        , { condition = tex.in_mathzone }),

    s("0lim",
        fmt("\\lim_{{h\\rightarrow 0}} {1}",
            {
                i(1),
            })
        , { condition = tex.in_mathzone }),

    -- Curl
    s("curl",
        fmt(
            [[
            \nabla \times \vec{{F}} =
            \left|\begin{{bmatrix}}
            \vec{{i}} & \vec{{j}} & \vec{{k}} \\
            \partial_x & \partial_y & \partial_z \\
            {} & {} & {}
            \end{{bmatrix}}\right| = \vec{{i}}\left(\partial_y {} - \partial_z {} \right) -\vec{{j}}\left(\partial_x {} - \partial_z {} \right) + \vec{{k}}\left(\partial_x - {} \partial_y {} \right)
            ]],
            { i(1), i(2), i(3), i(4), i(5), i(6), i(7), i(8), i(9) })
        , { condition = tex.in_mathzone }),

    -- xy
    s({ trig = "zx", wordTrig = false }, {
        t({ "\\left(x,y\\right)" }),
    }, { condition = tex.in_mathzone }),
    -- xyz
    s({ trig = "zz", wordTrig = false }, {
        t({ "\\left(x,y,z\\right)" }),
    }, { condition = tex.in_mathzone }),

    -- ddt
    s("ddt",
        fmt("\\frac{{d {}}}{{dt}}",
            { i(1) })
        , { condition = tex.in_mathzone }),

    -- ddx
    s("ddx",
        fmt("\\frac{{d {}}}{{dx}}",
            { i(1) })
        , { condition = tex.in_mathzone }),

    -- ddy
    s("ddy",
        fmt("\\frac{{d {}}}{{dy}}",
            { i(1) })
        , { condition = tex.in_mathzone }),

    -- ddz
    s("ddz",
        fmt("\\frac{{d {}}}{{dz}}",
            { i(1) })
        , { condition = tex.in_mathzone }),

    s("dda",
        fmt("\\frac{{d {}}}{{d{}}}",
            { i(1), i(2) })
        , { condition = tex.in_mathzone }),

    -- Partials
    s({ trig = "part", wordTrig = false },
        t("\\partial")
        , { condition = tex.in_mathzone }),

    -- ppt
    s("ppt",
        fmt("\\frac{{\\partial {}}}{{\\partial t}}",
            { i(1) })
        , { condition = tex.in_mathzone }),

    -- ppx
    s("ppx",
        fmt("\\frac{{\\partial {}}}{{\\partial x}}",
            { i(1) })
        , { condition = tex.in_mathzone }),

    -- ppy
    s("ppy",
        fmt("\\frac{{\\partial {}}}{{\\partial y}}",
            { i(1) })
        , { condition = tex.in_mathzone }),

    -- ppz
    s("ppz",
        fmt("\\frac{{\\partial {}}}{{\\partial z}}",
            { i(1) })
        , { condition = tex.in_mathzone }),

    -- ppa
    s("ppa",
        fmt("\\frac{{\\partial {}}}{{\\partial {}}}",
            { i(1), i(2) })
        , { condition = tex.in_mathzone }),

    s("fsx",
        fmt("f_{{x}}",
            {})
        , { condition = tex.in_mathzone }),

    s("fsy",
        fmt("f_{{y}}",
            {})
        , { condition = tex.in_mathzone }),

    s("fsz",
        fmt("f_{{z}}",
            {})
        , { condition = tex.in_mathzone }),

    s("fssx",
        fmt("f_{{xx}}",
            {})
        , { condition = tex.in_mathzone }),

    s("fssy",
        fmt("f_{{yy}}",
            {})
        , { condition = tex.in_mathzone }),

    s("fssz",
        fmt("f_{{zz}}",
            {})
        , { condition = tex.in_mathzone }),

    s("fssxy",
        fmt("f_{{xy}}",
            {})
        , { condition = tex.in_mathzone }),

    s("fssyx",
        fmt("f_{{yx}}",
            {})
        , { condition = tex.in_mathzone }),

    s("fsxz",
        fmt("f_{{xz}}",
            {})
        , { condition = tex.in_mathzone }),

    -- Trigonometry
    s({ trig = "sin", wordTrig = false },
        t("\\sin")
        , { condition = tex.in_mathzone }),
    s({ trig = "msin", wordTrig = false },
        t("-\\sin")
        , { condition = tex.in_mathzone }),
    s({ trig = "cos", wordTrig = false },
        t("\\cos")
        , { condition = tex.in_mathzone }),
    s({ trig = "mcos", wordTrig = false },
        t("-\\cos")
        , { condition = tex.in_mathzone }),
    s({ trig = "tan", wordTrig = false },
        t("\\tan")
        , { condition = tex.in_mathzone }),
    s({ trig = "mtan", wordTrig = false },
        t("-\\tan")
        , { condition = tex.in_mathzone }),

    -- Ranges

    s({ trig = "0tpi", wordTrig = false }, {
        t({ "0 \\leq " }),
        i(1),
        t({ " \\leq 2\\pi" })
    }, { condition = tex.in_mathzone }),
    s({ trig = "hat", wordTrig = false }, {
        t({ "\\hat{" }),
        i(1),
        t({ "}" })
    }, { condition = tex.in_mathzone }),


    -- Left right parentheses
    s({ trig = "lrp", wordTrig = false }, {
        t({ "\\left( " }),
        f(function(_, snip)
            return snip.env.TM_SELECTED_TEXT[1] or {}
        end, {}),
        i(1),
        t({ " \\right)" }),
    }, { condition = tex.in_mathzone }),

    -- Left right brackets
    s({ trig = "lrb", wordTrig = false }, {
        t({ "\\left[ " }),
        f(function(_, snip)
            return snip.env.TM_SELECTED_TEXT[1] or {}
        end, {}),
        i(1),
        t({ " \\right]" }),
    }, { condition = tex.in_mathzone }),

    -- Left right curly braces
    s({ trig = "lrc", wordTrig = false }, {
        t({ "\\left\\{ " }),
        f(function(_, snip)
            return snip.env.TM_SELECTED_TEXT[1] or {}
        end, {}),
        i(1),
        t({ " \\right\\}" }),
    }, { condition = tex.in_mathzone }),

    s({ trig = "lrs", wordTrig = false }, {
        t({ "\\left[ " }),
        f(function(_, snip)
            return snip.env.TM_SELECTED_TEXT[1] or {}
        end, {}),
        i(1),
        t({ " \\right]_{" }),
        i(2),
        t({ "}" }),
        t({ "^{" }),
        i(3),
        t({ "}" }),
    }, { condition = tex.in_mathzone }),

    s("dint",
        fmt("\\int_{{{1}}}^{{{2}}} {3} d{4}",
            {
                i(1),
                i(2),
                i(3),
                c(4, { t("x"), t("y"), t("z"), t("t") })
            })
        , { condition = tex.in_mathzone }),

    s({ trig = "rsq", wordTrig = false }, {
        t("\\rightsquigarrow"),
    }),
    -- Absolute value
    s({ trig = "abs", wordTrig = false }, {
        t({ "\\left| " }),
        f(function(_, snip)
            return snip.env.TM_SELECTED_TEXT[1] or {}
        end, {}),
        i(1),
        t({ " \\right|" }),
    }, { condition = tex.in_mathzone }),

    -- Absolute value
    s({ trig = "cal", wordTrig = false }, {
        t({ "\\mathcal{" }),
        f(function(_, snip)
            return snip.env.TM_SELECTED_TEXT[1] or {}
        end, {}),
        i(1),
        t({ "}" }),
    }, { condition = tex.in_mathzone }),

    s("qu", {
        t({ "\\quad" }),
    }, { condition = tex.in_mathzone }),

    -- Power
    s({ trig = "pow", wordTrig = false }, {
        t("^{"),
        i(1),
        t("}")
    }, { condition = tex.in_mathzone }),

    s({ trig = "sr", wordTrig = false }, {
        t("^2")
    }, { condition = tex.in_mathzone }),

    s({ trig = "cub", wordTrig = false }, {
        t("^3")
    }, { condition = tex.in_mathzone }),

    -- Sub
    ls.parser.parse_snippet(
        { trig = "_", wordTrig = false },
        "_{$1}"
    ),

    s({ trig = "(%a)(%d)%s", regTrig = true }, {
        f(function(_, snip)
            return snip.captures[1] .. "_{" .. snip.captures[2] .. "} "
        end, {})
    }, { condition = tex.in_mathzone }),

    -- Cdots
    s("...", {
        t({ "\\dots " })
    }, { condition = tex.in_mathzone }),

    s("l...", {
        t({ "\\ldots " })
    }, { condition = tex.in_mathzone }),

    s("v...", {
        t({ "\\vdots " })
    }, { condition = tex.in_mathzone }),

    s("d...", {
        t({ "\\ddots " })
    }, { condition = tex.in_mathzone }),
    s("h...", {
        t({ "\\hdots " })
    }, { condition = tex.in_mathzone }),

    -- Matrix
    -- s("mat",
    --     fmt(
    --         [[
    --         \begin{{matrix}}
    --             {1} & {2} \\
    --             {3} & {4}
    --         \end{{matrix}}
    --         ]],
    --         { i(1), i(2), i(3), i(4) }),
    --     { condition = tex.in_mathzone }),

    s("3bmat",
        fmt(
            [[
            \begin{{bmatrix}}
                {1} & {2} & {3} \\
                {4} & {5} & {6} \\
                {7} & {8} & {9}
            \end{{bmatrix}}
            ]],
            { i(1), i(2), i(3), i(4), i(5), i(6), i(7), i(8), i(9) }),
        { condition = tex.in_mathzone }),

    -- Bracket matrix
    s("bmat",
        fmt(
            [[
            \begin{{bmatrix}}
                {1} & {2} \\
                {3} & {4}
            \end{{bmatrix}}
            ]],
            { i(1), i(2), i(3), i(4) }),
        { condition = tex.in_mathzone }),

    s("3bmat",
        fmt(
            [[
            \begin{{bmatrix}}
                {1} & {2} & {3} \\
                {4} & {5} & {6} \\
                {7} & {8} & {9}
            \end{{bmatrix}}
            ]],
            { i(1), i(2), i(3), i(4), i(5), i(6), i(7), i(8), i(9) }),
        { condition = tex.in_mathzone }),

    -- Parentheses matrix
    s("pmat",
        fmt(
            [[
            \begin{{pmatrix}}
                {1} & {2} \\
                {3} & {4}
            \end{{pmatrix}}
            ]],
            { i(1), i(2), i(3), i(4) }),
        { condition = tex.in_mathzone }),

    s("3pmat",
        fmt(
            [[
            begin{{pmatrix}}
                {1} & {2} & {3} \\
                {4} & {5} & {6} \\
                {7} & {8} & {9}
            \end{{pmatrix}}
            ]],
            { i(1), i(2), i(3), i(4), i(5), i(6), i(7), i(8), i(9) }),
        { condition = tex.in_mathzone }),

    -- Braces matrix
    s("cmat",
        fmt(
            [[
            \begin{{Bmatrix}}
                {1} & {2} \\
                {3} & {4}
            \end{{Bmatrix}}
            ]],
            { i(1), i(2), i(3), i(4) }),
        { condition = tex.in_mathzone }),

    s("3cmat",
        fmt(
            [[
            \begin{{Bmatrix}}
                {1} & {2} & {3} \\
                {4} & {5} & {6} \\
                {7} & {8} & {9}
            \end{{Bmatrix}}
            ]],
            { i(1), i(2), i(3), i(4), i(5), i(6), i(7), i(8), i(9) }),
        { condition = tex.in_mathzone }),

    -- Pipe matrix
    s("pimat",
        fmt(
            [[
            \begin{{vmatrix}}
                {1} & {2} \\
                {3} & {4}
            \end{{vmatrix}}
            ]],
            { i(1), i(2), i(3), i(4) }),
        { condition = tex.in_mathzone }),

    s("3pimat",
        fmt(
            [[
            \begin{{vmatrix}}
                {1} & {2} & {3} \\
                {4} & {5} & {6} \\
                {7} & {8} & {9}
            \end{{vmatrix}}
            ]],
            { i(1), i(2), i(3), i(4), i(5), i(6), i(7), i(8), i(9) }),
        { condition = tex.in_mathzone }),

    -- Double Pipe matrix
    s("dpmat",
        fmt(
            [[
            \begin{{Vmatrix}}
                {1} & {2} \\
                {3} & {4}
            \end{{Vmatrix}}
            ]],
            { i(1), i(2), i(3), i(4) }),
        { condition = tex.in_mathzone }),

    s("3pimat",
        fmt(
            [[
            \begin{{Vmatrix}}
                {1} & {2} & {3} \\
                {4} & {5} & {6} \\
                {7} & {8} & {9}
            \end{{Vmatrix}}
            ]],
            { i(1), i(2), i(3), i(4), i(5), i(6), i(7), i(8), i(9) }),
        { condition = tex.in_mathzone }),

    -- Set theory symbols
    s({ trig = "cup", wordTrig = true }, {
        t("\\cup"),
    }, { condition = tex.in_mathzone }),
    s({ trig = "cap", wordTrig = true }, {
        t("\\cap"),
    }, { condition = tex.in_mathzone }),
    s({ trig = "subeq", wordTrig = true }, {
        t("\\subseteq"),
    }, { condition = tex.in_mathzone }),
    s({ trig = "supeq", wordTrig = true }, {
        t("\\supseteq"),
    }, { condition = tex.in_mathzone }),
    s({ trig = "subs", wordTrig = true }, {
        t("\\subset"),
    }, { condition = tex.in_mathzone }),
    s({ trig = "sups", wordTrig = true }, {
        t("\\supset"),
    }, { condition = tex.in_mathzone }),
    s({ trig = "varn", wordTrig = true }, {
        t("\\varnothing"),
    }, { condition = tex.in_mathzone }),
    s({ trig = "cong", wordTrig = true }, {
        t("\\cong"),
    }, { condition = tex.in_mathzone }),
    s("inn", {
        t({ "\\in" })
    }, { condition = tex.in_mathzone }),
    s("ninn", {
        t({ "\\notin" })
    }, { condition = tex.in_mathzone }),
    s({ trig = "setm", wordTrig = false }, {
        t("\\setminus")
    }, { condition = tex.in_mathzone }),

    -- CS Snippets (Some)
    -- Pseudocode figure
    s(
        "pseudofig",
        fmt(
            [[
                \begin{{algorithm}}[H]
                    \caption{{{1}}}
                    \SetAlgoVlined
                    \SetKwInOut{{Input}}{{Input}}
                    \SetKwInOut{{Output}}{{Output}}
                    \Input{{{2}}}
                    \Output{{{3}\newline}}
                \end{{algorithm}}
            ]],
            {
                i(1),
                i(2),
                i(3)
            }
        )
    ),
    s({ trig = "suc", wordTrig = false }, {
        t("\\succ")
    }, { condition = tex.in_mathzone }),
    s({ trig = "pre", wordTrig = false }, {
        t("\\prec")
    }, { condition = tex.in_mathzone }),
    s("mc",
        fmt("\\mathcal{{{1}}}",
            {
                i(1),
            })
        , { condition = tex.in_mathzone }),
    s("on",
        fmt("\\mathcal{{O}}\\left({1}\\right)",
            {
                i(1),
            })
        , { condition = tex.in_mathzone }),

    -- Discrete Math Symbols
    s({ trig = "mid", wordTrig = false }, {
        t("\\mid")
    }, { condition = tex.in_mathzone }),
    s({ trig = "nid", wordTrig = false }, {
        t("\\nmid")
    }, { condition = tex.in_mathzone }),
    s({ trig = "gcd", wordTrig = false }, {
        t("\\text{gcd}"),
        t("("),
        i(1),
        t(", "),
        i(2),
        t(")")
    }, { condition = tex.in_mathzone }),
    s({ trig = "lcm", wordTrig = false }, {
        t("\\text{lcm}"),
        t("("),
        i(1),
        t(", "),
        i(2),
        t(")")
    }, { condition = tex.in_mathzone }),

    -- TEXT AUTOSNIPPETS
    -- Chapter
    s("chap", {
        t("\\chapter{"),
        f(function(_, snip)
            return snip.env.TM_SELECTED_TEXT[1] or {}
        end, {}),
        i(1),
        t("}")
    }, { condition = conds.line_begin }),

    -- Section
    s("sec", {
        t("\\section{"),
        f(function(_, snip)
            return snip.env.TM_SELECTED_TEXT[1] or {}
        end, {}),
        i(1),
        t("}")
    }, { condition = conds.line_begin }),

    -- Subsection
    s("sub", {
        t("\\subsection{"),
        f(function(_, snip)
            return snip.env.TM_SELECTED_TEXT[1] or {}
        end, {}),
        i(1),
        t("}")
    }, { condition = conds.line_begin }),

    -- Subsubsection
    s("ssub", {
        t("\\subsubsection{"),
        f(function(_, snip)
            return snip.env.TM_SELECTED_TEXT[1] or {}
        end, {}),
        i(1),
        t("}")
    }, { condition = conds.line_begin }),

    -- Paragraph
    s("parg", {
        t("\\paragraph{"),
        f(function(_, snip)
            return snip.env.TM_SELECTED_TEXT[1] or {}
        end, {}),
        i(1),
        t("}")
    }, { condition = conds.line_begin }),


    -- Newpage
    s("np", {
        t("\\newpage"),
    }, { condition = conds.line_begin }),

    -- Bigskip
    s("bs", {
        t("\\bigskip"),
    }, { condition = conds.line_begin }),

    -- Medskip
    s("ms", {
        t("\\medskip"),
    }, { condition = conds.line_begin }),

    -- Smallskip
    s("sms", {
        t("\\smallskip"),
    }, { condition = conds.line_begin }),

    -- Bold
    s("bf", {
        t("\\textbf{"),
        f(function(_, snip)
            return snip.env.TM_SELECTED_TEXT[1] or {}
        end, {}),
        i(1),
        t("}")
    }, { condition = tex.in_text }),

    s("ul", {
        t("\\underline{"),
        f(function(_, snip)
            return snip.env.TM_SELECTED_TEXT[1] or {}
        end, {}),
        i(1),
        t("}")
    }, { condition = tex.in_text }),

    -- Italic
    s("ita", {
        t("\\textit{"),
        f(function(_, snip)
            return snip.env.TM_SELECTED_TEXT[1] or {}
        end, {}),
        i(1),
        t("}")
    }, { condition = tex.in_text }),

    -- Verbatim / monospace
    s("vb", {
        t("\\verb!"),
        f(function(_, snip)
            return snip.env.TM_SELECTED_TEXT[1] or {}
        end, {}),
        i(1),
        t("!")
    }, { condition = tex.in_text }),

    s("typf", {
        t("\\texttt{"),
        f(function(_, snip)
            return snip.env.TM_SELECTED_TEXT[1] or {}
        end, {}),
        i(1),
        t("}")
    }, {}),

    -- Text
    s("tt", {
        t("\\text{"),
        f(function(_, snip)
            return snip.env.TM_SELECTED_TEXT[1] or {}
        end, {}),
        i(1),
        t("}")
    }, { condition = tex.in_mathzone }),

    -- FORMATTING AND FIGURES AUTOSNIPPETS
    s("parb",
        fmt(
            [[
            \medskip

            \begin{{center}}
                \fbox{{
                    \parbox{{{1}\textwidth}}{{
                        {2}
                    }}
                }}
            \end{{center}}
            \medskip
            ]],
            {
                c(1, { t("0.95"), t("0.45") }),
                i(2)
            }
        )
        , { condition = tex.in_text }),

    s("fref", {
        t("Figur \\ref{fig:"),
        f(function(_, snip)
            return snip.env.TM_SELECTED_TEXT[1] or {}
        end, {}),
        i(1),
        t("}")
    }, { condition = tex.in_text }),

    s("taref", {
        t("Tabell \\ref{tab:"),
        f(function(_, snip)
            return snip.env.TM_SELECTED_TEXT[1] or {}
        end, {}),
        i(1),
        t("}")
    }, { condition = tex.in_text }),
    s("dref", {
        t("Definition \\ref{def:"),
        f(function(_, snip)
            return snip.env.TM_SELECTED_TEXT[1] or {}
        end, {}),
        i(1),
        t("}")
    }, { condition = tex.in_text }),
    s("tref", {
        t("Theorem \\ref{thm:"),
        f(function(_, snip)
            return snip.env.TM_SELECTED_TEXT[1] or {}
        end, {}),
        i(1),
        t("}")
    }, { condition = tex.in_text }),
    s("lref", {
        t("Lemma \\ref{thm:"),
        f(function(_, snip)
            return snip.env.TM_SELECTED_TEXT[1] or {}
        end, {}),
        i(1),
        t("}")
    }, { condition = tex.in_text }),
    s("eqref", {
        t("Likning \\ref{eq:"),
        f(function(_, snip)
            return snip.env.TM_SELECTED_TEXT[1] or {}
        end, {}),
        i(1),
        t("}")
    }, { condition = tex.in_text }),
    -- ENVIRONMENTS
    s("beg",
        fmt(
            [[
                \begin{{{1}}}
                    {2}
                \end{{{3}}}
            ]],
            { i(1), i(2), rep(1) }
        ), { condition = tex.in_text and conds.line_begin }
    ),

    s("mulr", {
        t({ "\\multirow{" }),
        i(1),
        t("}"),
        t("{"),
        i(2),
        t("}"),
        t("["),
        i(3),
        t("]"),
        t("{"),
        f(function(_, snip)
            return snip.env.TM_SELECTED_TEXT[1] or {}
        end, {}),
        t("}"),
    }, { condition = tex.in_text }),

    s("12mulr", {
        t({ "\\multirow{1}{*}[-1.2em]" }),
        t("{"),
        f(function(_, snip)
            return snip.env.TM_SELECTED_TEXT[1] or {}
        end, {}),
        t("}"),
    }, { condition = tex.in_text }),

    s("05mulr", {
        t({ "\\multirow{1}{*}[-0.5em]" }),
        t("{"),
        f(function(_, snip)
            return snip.env.TM_SELECTED_TEXT[1] or {}
        end, {}),
        t("}"),
    }, { condition = tex.in_text }),

    -- GREEK LETTERS
    s({ trig = "alph", wordTrig = false }, {
        t("\\alpha"),
    }, { condition = tex.in_mathzone }),


    ls.parser.parse_snippet(
        { trig = "pc", wordTrig = false },
        "\\%"
    ),

    s({ trig = "beta", wordTrig = false }, {
        t("\\beta"),
    }, { condition = tex.in_mathzone }),

    s({ trig = "gam", wordTrig = false }, {
        t("\\gamma"),
    }, { condition = tex.in_mathzone }),

    s({ trig = "Gam", wordTrig = false }, {
        t("\\Gamma"),
    }, { condition = tex.in_mathzone }),

    s({ trig = "del", wordTrig = false }, {
        t("\\delta"),
    }, { condition = tex.in_mathzone }),

    s({ trig = "Del", wordTrig = false }, {
        t("\\Delta"),
    }, { condition = tex.in_mathzone }),

    s({ trig = "eps", wordTrig = false }, {
        t("\\epsilon"),
    }, { condition = tex.in_mathzone }),

    s({ trig = "veps", wordTrig = false }, {
        t("\\varepsilon"),
    }, { condition = tex.in_mathzone }),

    s({ trig = "zet", wordTrig = false }, {
        t("\\zeta"),
    }, { condition = tex.in_mathzone }),

    s({ trig = "tht", wordTrig = false }, {
        t("\\theta"),
    }, { condition = tex.in_mathzone }),

    s({ trig = "Tht", wordTrig = false }, {
        t("\\Theta"),
    }, { condition = tex.in_mathzone }),

    s({ trig = "vtht", wordTrig = false }, {
        t("\\vartheta"),
    }, { condition = tex.in_mathzone }),

    s({ trig = "iota", wordTrig = false }, {
        t("\\iota"),
    }, { condition = tex.in_mathzone }),

    s({ trig = "kap", wordTrig = false }, {
        t("\\kappa"),
    }, { condition = tex.in_mathzone }),

    s({ trig = "lam", wordTrig = false }, {
        t("\\lambda"),
    }, { condition = tex.in_mathzone }),

    s({ trig = "tar", wordTrig = false }, {
        t("\\star"),
    }, { condition = tex.in_mathzone }),

    s({ trig = "Lam", wordTrig = false }, {
        t("\\Lambda"),
    }, { condition = tex.in_mathzone }),

    s({ trig = "mu", wordTrig = false }, {
        t("\\mu"),
    }, { condition = tex.in_mathzone }),

    s({ trig = "nu", wordTrig = false }, {
        t("\\nu"),
    }, { condition = tex.in_mathzone }),

    s({ trig = "xi", wordTrig = false }, {
        t("\\Xi"),
    }, { condition = tex.in_mathzone }),

    s({ trig = "pi", wordTrig = false }, {
        t("\\pi"),
    }, { condition = tex.in_mathzone }),

    s({ trig = "Pi", wordTrig = false }, {
        t("\\Pi"),
    }, { condition = tex.in_mathzone }),

    s({ trig = "rho", wordTrig = false }, {
        t("\\rho"),
    }, { condition = tex.in_mathzone }),

    s({ trig = "vrho", wordTrig = false }, {
        t("\\varrho"),
    }, { condition = tex.in_mathzone }),

    s({ trig = "tau", wordTrig = false }, {
        t("\\tau"),
    }, { condition = tex.in_mathzone }),

    s({ trig = "ups", wordTrig = false }, {
        t("\\upsilon"),
    }, { condition = tex.in_mathzone }),

    s({ trig = "Ups", wordTrig = false }, {
        t("\\Upsilon"),
    }, { condition = tex.in_mathzone }),

    s({ trig = "ph", wordTrig = false }, {
        t("\\phi"),
    }, { condition = tex.in_mathzone }),

    s({ trig = "Ph", wordTrig = false }, {
        t("\\Phi"),
    }, { condition = tex.in_mathzone }),

    s({ trig = "vphi", wordTrig = false }, {
        t("\\varphi"),
    }, { condition = tex.in_mathzone }),

    s({ trig = "chi", wordTrig = false }, {
        t("\\chi"),
    }, { condition = tex.in_mathzone }),

    s({ trig = "psi", wordTrig = false }, {
        t("\\psi"),
    }, { condition = tex.in_mathzone }),

    s({ trig = "Psi", wordTrig = false }, {
        t("\\psi"),
    }, { condition = tex.in_mathzone }),

    s({ trig = "omg", wordTrig = false }, {
        t("\\omega"),
    }, { condition = tex.in_mathzone }),

    s({ trig = "Omg", wordTrig = false }, {
        t("\\Omega"),
    }, { condition = tex.in_mathzone }),

    s({ trig = "sig", wordTrig = false }, {
        t("\\sigma"),
    }, { condition = tex.in_mathzone }),

    s({ trig = "Sig", wordTrig = false }, {
        t("\\Sigma"),
    }, { condition = tex.in_mathzone }),

    s({ trig = "nabl", wordTrig = false }, {
        t("\\nabla"),
    }, { condition = tex.in_mathzone }),

    s({ trig = "deg", wordTrig = false }, {
        t("^{\\circ}"),
    }, { condition = tex.in_mathzone }),

    s({ trig = "tild", wordTrig = false }, {
        t("\\tilde{"),
        i(1),
        t("}"),
    }, { condition = tex.in_mathzone }),

    s({ trig = "ov", wordTrig = false }, {
        t("\\overline{"),
        i(1),
        t("}"),
    }, { condition = tex.in_mathzone }),


    s("sd", {
        t("->"),
    }),
    s("ds", {
        t("<-"),
    }),
    s("neg", {
        t("\\neg"),
    }, { condition = tex.in_mathzone }),
    s("fra", {
        t("\\forall"),
    }, { condition = tex.in_mathzone }),
    s("ex", {
        t("\\exists"),
    }, { condition = tex.in_mathzone }),

    s("xor", {
        t("\\oplus"),
    }, { condition = tex.in_mathzone }),
    s("iff", {
        t("\\iff"),
    }, { condition = tex.in_mathzone }),
    s("rar", {
        t("\\rightarrow"),
    }, { condition = tex.in_mathzone }),
    s("lar", {
        t("\\leftarrow"),
    }, { condition = tex.in_mathzone }),
    s("tbs", {
        t("\\textbackslash"),
    }),
    s("eq", {
        t("\\equiv"),
    }, { condition = tex.in_mathzone }),
    s("aeq", {
        t("&\\equiv"),
    }, { condition = tex.in_mathzone }),
    s("Sd", {
        t("=>"),
    }),
    s({ trig = "vda", wordTrig = false }, {
        t("\\vdash"),
    }),
}, {
    type = "autosnippets",
    key = "tex_auto"
})
