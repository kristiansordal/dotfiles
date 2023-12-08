lvim.log.evel = "warn"
lvim.format_on_save = true
lvim.transparent_window = true
vim.cmd("set bg=dark")

-- keymappings [view all the defaults by pressing <leader>Lk]
lvim.leader = "space"
lvim.keys.normal_mode["<leader>gt"] = ":ZenMode<cr>"
lvim.keys.normal_mode["<leader>zz"] = ":wqa<cr>"
lvim.keys.normal_mode["<C-s>"] = ":w<cr>"
lvim.keys.normal_mode["<leader>j"] = "<Plug>(VM-Add-Cursor-Down)"
lvim.keys.normal_mode["<leader>tt"] = ":!zathura %:r.pdf&;disown<cr>"
lvim.keys.normal_mode["<leader>tc"] = ":!typst compile %:r.typ<cr>"
lvim.keys.normal_mode["<leader>k"] = "<Plug>(VM-Add-Cursor-Up)"
lvim.keys.normal_mode["<S-l>"] = ":bn<CR>"
lvim.keys.normal_mode["<S-h>"] = ":bp<CR>"
lvim.keys.normal_mode[";"] = "$"
lvim.keys.normal_mode['gd'] = ":lua vim.lsp.buf.definition()<CR>"
lvim.keys.normal_mode['<F1>'] = ":lua require'dap'.continue()<CR>"
lvim.keys.normal_mode['<F2>'] = ":lua require'dap'.step_over()<CR>"
lvim.keys.normal_mode['<F3>'] = ":lua require'dap'.step_into()<CR>"
lvim.keys.normal_mode['<F4>'] = ":lua require'dap'.toggle_breakpoint()<CR>"


lvim.builtin.alpha.active = true
lvim.builtin.alpha.mode = "dashboard"
lvim.builtin.terminal.active = true
lvim.builtin.nvimtree.setup.view.side = "left"
lvim.builtin.autopairs.disable_filetype = { "*.tex" }
lvim.builtin.project.manual_mode = true


lvim.builtin.telescope = {
    active = true,
    defaults = {
        previewer = true,
        layout_strategy = "horizontal",
        path_display = { truncate = 2 }
    },
    pickers = {
        find_files = {
            layout_strategy = "horizontal",
            -- previewer = true
        },
        git_files = {
            layout_strategy = "horizontal",
            -- previewer = true
        }
    }

}

vim.list_extend(lvim.lsp.automatic_configuration.skipped_servers, { "omnisharp", "csharp_ls" })

lvim.builtin.treesitter.ensure_installed = {
    "bash",
    "c",
    "javascript",
    "json",
    "lua",
    "python",
    "typescript",
    "tsx",
    "css",
    "rust",
    "java",
    "yaml",
    "cpp",
}

local ok, copilot = pcall(require, "copilot")
if not ok then
    return
end

copilot.setup {
    suggestion = {
        keymap = {
            accept = "<c-l>",
            next = "<c-j>",
            prev = "<c-k>",
            dismiss = "<c-h>",
        },
    },
}

local opts = { noremap = true, silent = true }
lvim.keys.normal_mode["<leader>sg"] = "<cmd>lua require('copilot.suggestion').toggle_auto_trigger()<CR>"



lvim.lsp.document_highlight = false


-- DAP CONFIG:
local dap = require('dap')
dap.adapters.codelldb = {
    type = 'server',
    port = "${port}",
    executable = {
        -- CHANGE THIS to your path!
        command = '/Users/kristiansordal/nvim-debug/codelldb-aarch64-darwin/extension/adapter/codelldb',
        args = { "--port", "${port}" },

    },
    runInTerminal = true
}

-- Config for debugging C++ using Vscode-CPPTools
dap.adapters.cppdbg = {
    id = 'cppdbg',
    type = 'executable',
    command = '/Users/kristiansordal/nvim-debug/extension/debugAdapters/bin/OpenDebugAD7',
    externalTerminal = true
}

-- local file = require("utils.file")
dap.configurations.cpp = {
    {
        name = "C++ Debug And Run",
        type = "codelldb",
        request = "launch",
        program = function()
            -- First, check if exists CMakeLists.txt
            local cwd = vim.fn.getcwd()
            -- if file.exists(cwd, "CMakeLists.txt") then
            -- Then invoke cmake commands
            -- Then ask user to provide execute file
            -- return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
            -- else
            local fileName = vim.fn.expand("%:t:r")
            -- create this directory
            os.execute("mkdir -p " .. "bin")
            -- local cmd = "!/opt/homebrew/Cellar/gcc/13.2.0/bin/g++-13 -std=c++20 -ld_classic -g % -o bin/" .. fileName
            local cmd = "!/opt/homebrew/Cellar/gcc/13.2.0/bin/g++-13 -std=c++20 -Wno-psabi -ld_classic -g % -o bin/" ..
                fileName

            -- First, compile it
            vim.cmd(cmd)
            -- Then, return it
            return "${fileDirname}/bin/" .. fileName
            -- end
        end,
        cwd = "${workspaceFolder}",
        stopOnEntry = false,
        runInTerminal = true,
        console = "integratedTerminal",
    },
}

dap.configurations.java = {
    {
        name = "Debug (Attach) - Remote",
        type = "java",
        request = "attach",
        hostName = "127.0.0.1",
        port = 5005,
    },
    {
        name = "Debug Non-Project class",
        type = "java",
        request = "launch",
        program = "${file}",
    },
}


local clangd_flags = {
    "--fallback-style=google",
    "--background-index",
    "-j=12",
    "--all-scopes-completion",
    "--pch-storage=disk",
    "--clang-tidy",
    "--log=error",
    "--completion-style=detailed",
    "--header-insertion=iwyu",
    "--header-insertion-decorators",
    "--enable-config",
    "--offset-encoding=utf-16",
    "--ranking-model=heuristics",
    "--folding-ranges",
}



local clangd_bin = "clangd"

local opts = {
    cmd = { clangd_bin, unpack(clangd_flags) },
}

require("lvim.lsp.manager").setup("clangd", opts)
require('lspconfig')['marksman'].setup {
    filetypes = { 'md' }
}
require('lspconfig')['hls'].setup {
    filetypes = { 'haskell', 'lhaskell', 'cabal' },
}


local csopts = {
    cmd = { '/Users/kristiansordal/.local/share/nvim/mason/packages/omnisharp-mono/run' },
}
lvim.lsp.on_attach_callback = function(client, bufnr)
    if client.name == "omnisharp" then
        client.server_capabilities.semanticTokensProvider = {
            full = vim.empty_dict(),
            legend = {
                tokenModifiers = { "static_symbol" },
                tokenTypes = {
                    "comment",
                    "excluded_code",
                    "identifier",
                    "keyword",
                    "keyword_control",
                    "number",
                    "operator",
                    "operator_overloaded",
                    "preprocessor_keyword",
                    "string",
                    "whitespace",
                    "text",
                    "static_symbol",
                    "preprocessor_text",
                    "punctuation",
                    "string_verbatim",
                    "string_escape_character",
                    "class_name",
                    "delegate_name",
                    "enum_name",
                    "interface_name",
                    "module_name",
                    "struct_name",
                    "type_parameter_name",
                    "field_name",
                    "enum_member_name",
                    "constant_name",
                    "local_name",
                    "parameter_name",
                    "method_name",
                    "extension_method_name",
                    "property_name",
                    "event_name",
                    "namespace_name",
                    "label_name",
                    "xml_doc_comment_attribute_name",
                    "xml_doc_comment_attribute_quotes",
                    "xml_doc_comment_attribute_value",
                    "xml_doc_comment_cdata_section",
                    "xml_doc_comment_comment",
                    "xml_doc_comment_delimiter",
                    "xml_doc_comment_entity_reference",
                    "xml_doc_comment_name",
                    "xml_doc_comment_processing_instruction",
                    "xml_doc_comment_text",
                    "xml_literal_attribute_name",
                    "xml_literal_attribute_quotes",
                    "xml_literal_attribute_value",
                    "xml_literal_cdata_section",
                    "xml_literal_comment",
                    "xml_literal_delimiter",
                    "xml_literal_embedded_expression",
                    "xml_literal_entity_reference",
                    "xml_literal_name",
                    "xml_literal_processing_instruction",
                    "xml_literal_text",
                    "regex_comment",
                    "regex_character_class",
                    "regex_anchor",
                    "regex_quantifier",
                    "regex_grouping",
                    "regex_alternation",
                    "regex_text",
                    "regex_self_escaped_character",
                    "regex_other_escape",
                },
            },
            range = true,
        }
    end
end

require("lvim.lsp.manager").setup("omnisharp", csopts)



-- Additional Plugins
lvim.plugins = {
    {
        "lervag/vimtex",
        config = function()
        end,
    },
    { 'tpope/vim-surround' },
    { 'dracula/vim' },
    { 'mg979/vim-visual-multi' },
    { 'honza/vim-snippets' },
    { 'sainnhe/everforest' },
    { 'preservim/vim-markdown' },
    { 'godlygeek/tabular' },
    { 'sainnhe/gruvbox-material' },
    { 'mfussenegger/nvim-dap' },
    { 'mfussenegger/nvim-jdtls' },
    { 'mrjones2014/nvim-ts-rainbow' },
    { 'ellisonleao/gruvbox.nvim' },
    { "mfussenegger/nvim-dap-python" },
    {
        'nvim-neotest/neotest',
        -- config = function()
        --     require("ntest").config()
        -- end,
        -- dependencies = {
        --     { "nvim-neotest/neotest-plenary" },
        -- },
    },
    -- { "nvim-neotest/neotest-python", event = { "BufEnter *.py" } },
    -- { 'jay-babu/mason-nvim-dap.nvim' },
    -- { 'abecodes/tabout.nvim' }
    {
        "folke/zen-mode.nvim",
        opts = {
            window = { height = 0.9 }
        }
    },
    {
        "folke/twilight.nvim",
        opts = {
            dimming = {
                alpha = 0.5, -- amount of dimming
                -- we try to get the foreground from the highlight groups or fallback color
                color = { "Normal", "#ffffff" },
                term_bg = "#000000", -- if guibg=NONE, this will be used to calculate text color
                inactive = false,    -- when true, other windows will be fully dimmed (unless they contain the same buffer)
            },
            context = 15,            -- amount of lines we will try to show around the current line
            treesitter = true,       -- use treesitter when available for the filetype
            -- treesitter is used to automatically expand the visible text,
            -- but you can further control the types of nodes that should always be fully expanded
            expand = { -- for treesitter, we we always try to expand to the top-most ancestor with these types
                "function",
                "method",
                "table",
                "if_statement",
            },
            exclude = {}, -- exclude these filetypes
        }
    },

    { "kaarmu/typst.vim" },
    {
        "folke/todo-comments.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        opts = {
            -- your configuration comes here
            -- or leave it empty to use the default settings
            -- refer to the configuration section below
        }
    }, {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
},
    {
        "zbirenbaum/copilot-cmp",
        after = { "copilot.lua" },
        config = function()
            require("copilot_cmp").setup()
        end,
    },
}

require 'lspconfig'.typst_lsp.setup {
    settings = {
        exportPdf = "onType" -- Choose onType, onSave or never.
        -- serverPath = "" -- Normally, there is no need to uncomment it.
    }
}



local colors = {
    dark_brown = "#3b3307",
    dark_green = "#142a03",
    dark_red = "#431313",
    dark_yellow = "#4d520d",
    dark0_hard = "#1d2021",
    dark0 = "#282828",
    dark0_soft = "#32302f",
    dark1 = "#3c3836",
    dark2 = "#504945",
    dark3 = "#665c54",
    dark4 = "#7c6f64",
    light_brown = "#fdd69b",
    light_green = "#d5e958",
    light_red = "#ffb3a2",
    light_yellow = "#ffdb57",
    light0_hard = "#f9f5d7",
    light0 = "#fbf1c7",
    light0_soft = "#f2e5bc",
    light1 = "#ebdbb2",
    light2 = "#d5c4a1",
    light3 = "#bdae93",
    light4 = "#a89984",
    bright_red = "#fb4934",
    bright_green = "#b8bb26",
    bright_yellow = "#fabd2f",
    bright_blue = "#83a598",
    bright_purple = "#d3869b",
    bright_aqua = "#8ec07c",
    bright_orange = "#fe8019",
    neutral_red = "#cc241d",
    neutral_green = "#98971a",
    neutral_yellow = "#d79921",
    neutral_blue = "#458588",
    neutral_purple = "#b16286",
    neutral_aqua = "#689d6a",
    neutral_orange = "#d65d0e",
    faded_red = "#9d0006",
    faded_green = "#79740e",
    faded_yellow = "#b57614",
    faded_blue = "#076678",
    faded_purple = "#8f3f71",
    faded_aqua = "#427b58",
    faded_orange = "#af3a03",
    gray = "#928374",
}

require('gruvbox').setup {
    contrast = 'hard',
    italic = {
        strings = false,
        operators = false,
        comments = true
    },
    undercurl = true,
    bold = true,
    overrides = {
        -- For highlighting matching parentheses
        MatchParen = { bg = "", fg = "#fe8019", bold = true },
        -- Change color of parentheses
        Delimiter = { bg = "", fg = "#bdae93" },

        -- Change the way hovered variables are highlighted
        IlluminatedWordText = { undercurl = true, bold = true },
        IlluminatedWordRead = { undercurl = true, bold = true },
        IlluminatedWordWrite = { undercurl = true, bold = true },

        -- Change color of operators
        Operator = { bg = "", fg = "#83a598", bold = false, italic = false },
        Function = { bg = "", fg = "#b8bb26", bold = false },
        String = { bg = "", fg = "#8ec07c", bold = false },
        Keyword = { fg = "#fb4934", italic = true },
        GruvboxRedUnderline = { bold = true, undercurl = false, sp = colors.red },
        GruvboxGreenUnderline = { bold = true, undercurl = false, sp = colors.green },
        GruvboxYellowUnderline = { bold = true, undercurl = false, sp = colors.yellow },
        GruvboxBlueUnderline = { bold = true, undercurl = false, sp = colors.blue },
        GruvboxPurpleUnderline = { bold = true, undercurl = false, sp = colors.purple },
        GruvboxAquaUnderline = { bold = true, undercurl = false, sp = colors.aqua },
        GruvboxOrangeUnderline = { bold = true, undercurl = false, sp = colors.orange },
        markdownBold = { bold = true, bg = "", fg = colors.aqua },
        luaTable = { bg = "", fg = "#bdae93" }
    },
    invert_selection = false,
    transparent_mode = true
}

lvim.colorscheme = "gruvbox"

lvim.builtin.treesitter.highlight.enabled = true
-- Folds
vim.opt["foldmethod"] = "expr"
vim.opt["foldenable"] = false
vim.opt["foldlevel"] = 99
vim.opt["foldexpr"] = "nvim_treesitter#foldexpr()"


vim.api.nvim_create_autocmd("BufWinEnter", {
    pattern = '*.hs',
    command = "setlocal tabstop=2",
})

vim.api.nvim_create_autocmd("BufEnter", {
    pattern = '*.hs',
    command = "setlocal shiftwidth=2",
})

vim.api.nvim_create_autocmd("BufWinEnter", {
    pattern = '*.tex',
    command = "set wrap",
})

vim.api.nvim_create_autocmd("BufWinEnter", {
    pattern = '*.tex',
    command = "set foldexpr=vimtex#fold#level(v:lnum)",
})

vim.api.nvim_create_autocmd("BufWinEnter", {
    pattern = '*.tex',
    command = "set foldtext=vimtex#fold#text()",
})


-- LaTeX Settings
vim.cmd('set conceallevel=1')
vim.cmd('map <kj> <Nop>')
vim.cmd('map <jk> <Nop>')
vim.cmd('set expandtab')
vim.cmd('set shiftwidth=4')
vim.cmd('set tabstop=4')
vim.cmd("call vimtex#init()")
vim.cmd("let g:tex_flavour='latex'")
vim.cmd("let g:vimtex_quickfix_mode=0")
vim.cmd("let g:tex_conceal='abdmg'")
vim.cmd("let g:vimtex_view_method='skim'")
vim.cmd("let g:vimtex_view_general_viewer='skim'")
vim.cmd("let g:vimtex_view_general_options = '-reuse-instance -forward-serach @tex @line @pdf'")
vim.cmd("let g:tex_fold_enabled=1")
vim.cmd("let g:vimtex_compiler_method = 'latexmk'")
vim.cmd("let g:vimtex_view_general_options = {'options': ['-shell-escape']}")

-- Typst Settings
vim.cmd("let g:typst_pdf_viewer='zathura'")

-- Lualine
lvim.builtin.lualine.options = {
    disabled_filetypes = { "", "tex" }
}
-- lvim.builtin.lualine.options.section_separators = w
-- Snippets
local ls = require("luasnip")
require("luasnip.loaders.from_lua").load({ paths = "~/.config/lvim/snippets/" })

-- some shorthands
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local r = ls.restore_node
local l = require("luasnip.extras").lambda
local rep = require("luasnip.extras").rep
local p = require("luasnip.extras").partial
local m = require("luasnip.extras").match
local n = require("luasnip.extras").nonempty
local dl = require("luasnip.extras").dynamic_lambda
local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta
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
        t({ "\\[ " }),
        f(function(_, snip)
            return snip.env.TM_SELECTED_TEXT[1] or {}
        end, {}),
        i(1),
        t({ " \\]" }),
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
        t({ "\\( " }),
        f(function(_, snip)
            return snip.env.TM_SELECTED_TEXT[1] or {}
        end, {}),
        i(1),
        t({ " \\)" }),
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
        fmt("\\sum_{{n={1}}}^{{{2}}} {3}",
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
        t({ "\\cdots " })
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
    s("mat",
        fmt(
            [[
            \begin{{matrix}}
                {1} & {2} \\
                {3} & {4}
            \end{{matrix}}
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

function math_zone()
    local cursor = vim.api.nvim_win_get_cursor(0)
    local line = vim.api.nvim_get_current_line()

    local before_cursor = line:sub(1, cursor[2])
    local after_cursor = line:sub(cursor[2] + 1)

    local _, start_idx = before_cursor:find("%$")
    local end_idx, _ = after_cursor:find("%$")

    return start_idx and end_idx
end

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

ls.add_snippets("markdown", {

    s("st", {
        t({ "\\sqrt{" }),
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
ls.add_snippets("cpp", {
    s({ trig = "scout", wordTrig = false }, {
        t({ "std::cout << " }),
        i(1),
        t({ " << std::endl;" })

    }),
    s({ trig = "cout", wordTrig = false }, {
        t({ "cout << " }),
        i(1),
        t({ " << endl;" })

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

    -- s({ trig = "vec", wordTrig = false }, {
    --     t({ "vector<" }),
    --     i(1),
    --     t({ ">" }),

    -- }),
    s({ trig = "sd", wordTrig = false }, {
        t({ "->" }),
    }),

}, {
    type = "autosnippets",
    key = "cpp_auto",
})
