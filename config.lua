vim.opt.shortmess:append "W"
vim.opt.shortmess:append "I"
lvim.format_on_save         = true
lvim.transparent_window     = true
lvim.lsp.document_highlight = false
vim.cmd("set bg=dark")
vim.cmd("set nocursorline")
vim.cmd("set rnu")
vim.opt.shortmess:append "S"
vim.opt.shortmess:append "W"
vim.opt.shortmess:append "I"
vim.g.python3_host_prog = vim.fn.exepath 'python3'
vim.g.loaded_python3_provider = nil
vim.cmd('runtime! plugin/rplugin.vim')

lvim.plugins = {
    {
        "lervag/vimtex",
        config = function()
        end,
    },
    { 'tpope/vim-surround' },
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
    { 'meuter/lualine-so-fancy.nvim' },
    {
        "folke/zen-mode.nvim",
        opts = {
            window = { height = 0.9 }
        }
    },
    {
        "folke/todo-comments.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        opts = {
            -- your configuration comes here
            -- or leave it empty to use the default settings
            -- refer to the configuration section below
        }
    },
    { 'MunifTanjim/nui.nvim' },
    {
        "folke/noice.nvim",
        dependencies = {
            -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
            "MunifTanjim/nui.nvim",
            "rcarriga/nvim-notify"
        }

    },
    {
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
    { 'folke/tokyonight.nvim' },
    { 'Civitasv/cmake-tools.nvim' },
    { 'untitled-ai/jupyter_ascending.vim' },
    {
        'alexghergh/nvim-tmux-navigation',
        config = function()
            require 'nvim-tmux-navigation'.setup {
                disable_when_zoomed = true, -- defaults to false
                keybindings = {
                    left = "<C-h>",
                    down = "<C-j>",
                    up = "<C-k>",
                    right = "<C-l>",
                    last_active = "<C-\\>",
                    next = "<C-Space>",
                }
            }
        end
    }
}


---------- KEYBINDS ------------
lvim.leader                         = "space"
lvim.keys.normal_mode["<leader>gt"] = ":zenmode<cr>"
lvim.keys.normal_mode["<leader>zz"] = ":wqa<cr>"
lvim.keys.normal_mode["<c-s>"]      = ":w<cr>"
lvim.keys.normal_mode["<leader>j"]  = "<Plug>(VM-Add-Cursor-Down)"
lvim.keys.normal_mode["<leader>k"]  = "<Plug>(VM-Add-Cursor-Up)"
lvim.keys.normal_mode["<s-l>"]      = ":bn<cr>"
lvim.keys.normal_mode["<s-h>"]      = ":bp<cr>"
lvim.keys.normal_mode[";"]          = "$"
lvim.keys.normal_mode['gd']         = ":lua vim.lsp.buf.definition()<cr>"
lvim.keys.normal_mode['<f1>']       = ":lua require'dap'.continue()<cr>"
lvim.keys.normal_mode['<f2>']       = ":lua require'dap'.step_over()<cr>"
lvim.keys.normal_mode['<f3>']       = ":lua require'dap'.step_into()<cr>"
lvim.keys.normal_mode['<f4>']       = ":lua require'dap'.toggle_breakpoint()<cr>"
lvim.keys.normal_mode['<c-h>']      = { "<cmd>NvimTmuxNavigateLeft<cr>", silent = true }
lvim.keys.normal_mode['<c-j>']      = { "<cmd>NvimTmuxNavigateDown<cr>", silent = true }
lvim.keys.normal_mode['<c-k>']      = { "<cmd>NvimTmuxNavigateUp<cr>", silent = true }
lvim.keys.normal_mode['<c-l>']      = { "<cmd>NvimTmuxNavigateRight<cr>", silent = true }
---------------------------------
---
---
-- Function to launch Jupyter Notebook for the current file in a new iTerm window
local function launch_jupyter_notebook()
    local current_file = vim.fn.expand("%:r") .. ".ipynb"
    local command = "source ~/.virtualenvs/machinelearning/bin/activate && python3 -m jupyter notebook " .. current_file
    local script = [[
  tell application "iTerm 2"
      create window with default profile
      tell current session of current window
          write text "]] .. command .. [[" & return
      end tell
  end tell
  ]]

    -- Execute the AppleScript command to open a new iTerm window and run the command
    os.execute('osascript -e \'' .. script .. '\'')
end
lvim.builtin.which_key.mappings.w = nil
local wk                          = require("which-key")
wk.register({
    r = {
        d = { "<cmd>CMakeDebug<CR>", "Debug CMake Project" },
        r = { "<cmd>CMakeRun<CR>", "Run CMake Project" },
        b = { "<cmd>CMakeBuild<CR>", "Build CMake Project" },
        c = { "<cmd>CMakeClean<CR>", "Clean CMake Project" },
        w = { "<cmd>CMakeSelectCwd<CR>", "Select CMake Work Directory" },
        p = { "<cmd>CMakeGenerate<CR>", "Generate CMake Project" },
        l = { "<cmd>CMakeSelectLaunchTarget<CR>", "Select CMake Launch Target" },
        a = { "<cmd>CMakeSelectBuildTarget<CR>", "Select CMake Build Target" },
        t = { "<cmd>CMakeSelectBuildType<CR>", "Select CMake Build Type" }
    },
    w = { "<cmd>silent write<CR>", "Save" },
    l = {
        h = { "<cmd>lua vim.lsp.buf.hover()<cr>", "See Definition" }
    },
    t = {
        e = { "<Plug>JupyterExecute<CR>", "Execute cell" },
        a = { "<Plug>JupyterExecuteAll<CR>", "Execute all cells" },
        r = { "<Plug>JupyterRestart<CR>", "Restart Jupyter" },
        s = { launch_jupyter_notebook, "Launch Jupyter Notebook in browser" }
    }
}, { prefix = "<leader>" })

------------ lunarvim ------------
lvim.builtin.alpha.active               = true
lvim.builtin.alpha.mode                 = "dashboard"
lvim.builtin.terminal.active            = true
lvim.builtin.nvimtree.setup.view.side   = "left"
lvim.builtin.autopairs.disable_filetype = { "*.tex" }
lvim.builtin.project.manual_mode        = true
lvim.builtin.lualine.options            = {
    icons_enabled = true,
    section_separators = { left = '', right = '' },
    component_separators = { left = '|', right = '|' },
    always_divide_middle = false,
}
lvim.builtin.lualine.sections           = {
    --
    lualine_a = { { 'mode', separator = { left = '', right = '' }, icon = "" } },
    lualine_b = { 'fancy_branch', 'fancy_diff', { 'diagnostics', sources = { 'nvim_lsp', 'coc' } } },
    lualine_c = { 'filename', 'fancy_macro' },
    lualine_x = {
        {
            require("noice").api.status.message.get,
            cond = require("noice").api.status.message.has,
        },
        {
            require("noice").api.status.command.get,
            cond = require("noice").api.status.command.has,
        },
        {
            require("noice").api.status.mode.get,
            cond = require("noice").api.status.mode.has,
        },
        {
            require("noice").api.status.search.get,
            cond = require("noice").api.status.search.has,
        },
        'fancy_filetype' },
    lualine_y = { 'fancy_progress' },
    lualine_z = { 'fancy_location', 'fancy_searchcount' },
}
---------------------------------

------------ telescope setup ------------
lvim.builtin.telescope                  = {
    active = true,
    defaults = {
        previewer = true,
        layout_strategy = "horizontal",
        path_display = { truncate = 2 }
    },
    pickers = {
        find_files = {
            layout_strategy = "horizontal",
        },
        git_files = {
            layout_strategy = "horizontal",
        }
    }

}

------------ LSP SETUP ------------
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
-----------------------------------

------------ COPILOT SETUP ------------
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
lvim.keys.normal_mode["<leader>sg"] = "<cmd>lua require('copilot.suggestion').toggle_auto_trigger()<CR>"
---------------------------------------


------------ DEBUGGER SETUP ------------
---
require("lvim.lsp.manager").setup("pyright", opts)
-- require('dap-python').setup('/opt/homebrew/bin/python3')
require('dap-python').setup('~/.local/share/lvim/mason/packages/debugpy/venv/bin/python')
-- require('dap-python').setup('~/.virtualenvs/debugpy/bin/python')
local formatters = require "lvim.lsp.null-ls.formatters"
formatters.setup {
    {
        name = "black",
        args = { "-l", 100, "--preview" }
    },
}

local dap = require('dap')

dap.adapters.codelldb = {
    type = 'server',
    host = '127.0.0.1',
    port = "${port}",
    executable = {
        command = '/Users/kristiansordal/.local/share/lvim/mason/packages/codelldb/codelldb',
        args = { "--port", "${port}" },

    },
    -- runInTerminal = false
}

-- dap.configurations.cpp = {
--     {
--         name = "C++ Debug And Run",
--         type = "codelldb",
--         request = "launch",
--         program = function()
--             local cwd = vim.fn.getcwd()

--             local function file_exists(path)
--                 local f = io.open(path, "r")
--                 if f then f:close() end
--                 return f ~= nil
--             end

--             if file_exists(cwd .. "/CMakeLists.txt") then
--                 -- Use cmake-tools to build the project
--                 require("cmake-tools").build({})

--                 -- Assuming the executable is in the build directory, adjust as needed
--                 local build_dir = vim.fn.getcwd() .. "/build"
--                 local executable_name = vim.fn.input("Enter the name of the executable: ")
--                 return build_dir .. "/" .. executable_name
--             else
--                 -- Handle as a regular C++ project
--                 local fileName = vim.fn.expand("%:t:r")
--                 os.execute("mkdir -p " .. "bin")
--                 local cmd =
--                     "!/opt/homebrew/Cellar/gcc/14.1.0_2/bin/g++-14 -std=c++20 -Wno-psabi -ld_classic -g % -o bin/" ..
--                     fileNameO
--                 vim.cmd(cmd)
--                 return vim.fn.getcwd() .. "/bin/" .. fileName
--             end
--         end,
--         cwd = "${workspaceFolder}",
--         stopOnEntry = false,
--         runInTerminal = false,
--         console = "integratedTerminal",
--     },
-- }
-- setup for cmake tools, apart of cpp debugging
local osys = require("cmake-tools.osys")

require("cmake-tools").setup {
    cmake_command = "cmake",                                          -- this is used to specify cmake command path
    ctest_command = "ctest",                                          -- this is used to specify ctest command path
    cmake_regenerate_on_save = true,                                  -- auto generate when save CMakeLists.txt
    cmake_generate_options = { "-DCMAKE_EXPORT_COMPILE_COMMANDS=1" }, -- this will be passed when invoke `CMakeGenerate`
    cmake_build_options = {},                                         -- this will be passed when invoke `CMakeBuild`
    cmake_build_directory = "build/${variant:buildType}",             -- this is used to specify generate directory for cmake, allows macro expansion, relative to vim.loop.cwd()
    cmake_soft_link_compile_commands = true,                          -- this will automatically make a soft link from compile commands file to project root dir
    cmake_compile_commands_from_lsp = false,                          -- this will automatically set compile commands file location using lsp, to use it, please set `cmake_soft_link_compile_commands` to false
    cmake_kits_path = nil,                                            -- this is used to specify global cmake kits path, see CMakeKits for detailed usage
    cmake_variants_message = {
        short = { show = true },                                      -- whether to show short message
        long = { show = true, max_length = 40 },                      -- whether to show long message
    },
    cmake_dap_configuration = {                                       -- debug settings for cmake
        name = "Launch File",
        type = "codelldb",
        request = "launch",
        stopOnEntry = false,
        runInTerminal = false,
        console = "integratedTerminal",
    },

    cmake_executor = {                          -- executor to use
        name = "quickfix",                      -- name of the executor
        opts = {},                              -- the options the executor will get, possible values depend on the executor type. See `default_opts` for possible values.
        default_opts = {                        -- a list of default and possible values for executors
            quickfix = {
                show = "always",                -- "always", "only_on_error"
                position = "belowright",        -- "vertical", "horizontal", "leftabove", "aboveleft", "rightbelow", "belowright", "topleft", "botright", use `:h vertical` for example to see help on them
                size = 10,
                encoding = "utf-8",             -- if encoding is not "utf-8", it will be converted to "utf-8" using `vim.fn.iconv`
                auto_close_when_success = true, -- typically, you can use it with the "always" option; it will auto-close the quickfix buffer if the execution is successful.
            },
            overseer = {
                new_task_opts = {
                    strategy = {
                        "toggleterm",
                        direction = "horizontal",
                        autos_croll = true,
                        quit_on_exit = "success"
                    }
                }, -- options to pass into the `overseer.new_task` command
                on_new_task = function(task)
                    require("overseer").open(
                        { enter = false, direction = "right" }
                    )
                end, -- a function that gets overseer.Task when it is created, before calling `task:start`
            },
            terminal = {
                name = "Main Terminal",
                prefix_name = "[CMakeTools]: ", -- This must be included and must be unique, otherwise the terminals will not work. Do not use a simple spacebar " ", or any generic name
                split_direction = "horizontal", -- "horizontal", "vertical"
                split_size = 11,

                -- Window handling
                single_terminal_per_instance = true,  -- Single viewport, multiple windows
                single_terminal_per_tab = true,       -- Single viewport per tab
                keep_terminal_static_location = true, -- Static location of the viewport if avialable

                -- Running Tasks
                start_insert = false,       -- If you want to enter terminal with :startinsert upon using :CMakeRun
                focus = false,              -- Focus on terminal when cmake task is launched.
                do_not_add_newline = false, -- Do not hit enter on the command inserted when using :CMakeRun, allowing a chance to review or modify the command before hitting enter.
            },                              -- terminal executor uses the values in cmake_terminal
        },
    },
    cmake_runner = {                     -- runner to use
        name = "terminal",               -- name of the runner
        opts = {},                       -- the options the runner will get, possible values depend on the runner type. See `default_opts` for possible values.
        default_opts = {                 -- a list of default and possible values for runners
            quickfix = {
                show = "always",         -- "always", "only_on_error"
                position = "belowright", -- "bottom", "top"
                size = 10,
                encoding = "utf-8",
                auto_close_when_success = true, -- typically, you can use it with the "always" option; it will auto-close the quickfix buffer if the execution is successful.
            },
            overseer = {
                new_task_opts = {
                    strategy = {
                        "toggleterm",
                        direction = "horizontal",
                        autos_croll = true,
                        quit_on_exit = "success"
                    }
                },   -- options to pass into the `overseer.new_task` command
                on_new_task = function(task)
                end, -- a function that gets overseer.Task when it is created, before calling `task:start`
            },
            terminal = {
                name = "Main Terminal",
                prefix_name = "[CMakeTools]: ", -- This must be included and must be unique, otherwise the terminals will not work. Do not use a simple spacebar " ", or any generic name
                split_direction = "horizontal", -- "horizontal", "vertical"
                split_size = 11,

                -- Window handling
                single_terminal_per_instance = true,  -- Single viewport, multiple windows
                single_terminal_per_tab = true,       -- Single viewport per tab
                keep_terminal_static_location = true, -- Static location of the viewport if avialable

                -- Running Tasks
                start_insert = false,       -- If you want to enter terminal with :startinsert upon using :CMakeRun
                focus = false,              -- Focus on terminal when cmake task is launched.
                do_not_add_newline = false, -- Do not hit enter on the command inserted when using :CMakeRun, allowing a chance to review or modify the command before hitting enter.
            },
        },
    },
    cmake_notifications = {
        runner = { enabled = true },
        executor = { enabled = true },
        spinner = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }, -- icons used for progress display
        refresh_rate_ms = 100, -- how often to iterate icons
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


-- LSP CONFIG
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

require("lvim.lsp.manager").setup("clangd", opts)
require("lvim.lsp.manager").setup("omnisharp", csopts)



-- PLUGINS

---------- NOTIFY -------------
require("notify").setup({
    background_colour = "#000000",
})

require("telescope").load_extension("noice")
---------- NOICE --------------

require("noice").setup({
    cmdline = {
        view = "cmdline_popup", -- view for rendering the cmdline. Change to `cmdline` to get a classic cmdline at the bottom
        format = {
            cmdline = { pattern = "^:", icon = "|>", lang = "", title = "" },
        }
    },
    views = {
        cmdline_popup = {
            position = {
                row = 5,
                col = "50%",
            },
            size = {
                width = 40,
                height = "auto",
            },
        },
        popupmenu = {
            relative = "editor",
            position = {
                row = 8,
                col = "50%",
            },
            size = {
                width = 40,
                height = 10,
            },
            border = {
                style = "rounded",
                padding = { 0, 1 },
            },
            win_options = {
                winhighlight = { Normal = "Normal", FloatBorder = "DiagnosticInfo" },
            },
        },
    },
    presets = {
        bottom_search = true,         -- use a classic bottom cmdline for search
        long_message_to_split = true, -- long messages will be sent to a split
        inc_rename = false,           -- enables an input dialog for inc-rename.nvim
        lsp_doc_border = true,        -- add a border to hover docs and signature help
    },
    lsp = { progress = { enabled = false }, hover = { enabled = false }, signature = { enabled = false } },
    notify = { enabled = false },
    errors = { enabled = false },
    routes = {
        {
            filter = {
                event = "msg_show",
                find = "Code actions",
            },
            view = "mini",
        },

        {
            filter = {
                event = "msg_show",
                find = "Select the kernel to launch:",
            },
            view = "mini",
        },
        {
            filter = {
                event = "msg_show",
                find = "Exited with code 0",
            },
            view = "mini",
        },
        {
            filter = {
                event = "msg_show",
                find = "Configuration",
            },
            view = "mini",
        },
        {
            filter = {
                event = "msg_show",
                find = "Please select",
            },
            view = "mini",
        },
        {
            filter = {
                event = "msg_show",
                find = "Select launch target",
            },
            view = "mini",
        },
        {
            filter = {
                event = "msg_show",
                find = "Select test to run",
            },
            view = "mini",
        },
        {
            filter = {
                event = "msg_show",
                find = "Select build type",
            },
            view = "mini",
        },
        {
            filter = {
                event = "msg_show",
                find = "Select build target",
            },
            view = "mini",
        },
        {
            filter = { event = "msg_show", kind = "confirm_sub" },
            opts = { skip = true },
        },
        {
            filter = { event = "msg_show", kind = "confirm" },
            opts = { skip = true },
        },
        {
            filter = { event = "msg_show", kind = "info" },
            opts = { skip = true },
        },
        {
            filter = { event = "msg_show", kind = "emsg" },
            opts = { skip = true },
        },
        {
            filter = { event = "msg_show", kind = "echo" },
            opts = { skip = true },
        },
        {
            filter = { event = "msg_show", kind = "echomsg" },
            opts = { skip = true },
        },
        {
            filter = { event = "msg_show", kind = "echoerr" },
            opts = { skip = true },
        },
        {
            filter = { event = "msg_show", kind = "lua_error" },
            opts = { skip = true },
        },
        {
            filter = { event = "msg_show", kind = "rpc_error" },
            opts = { skip = true },
        },
        {
            filter = { event = "msg_show", kind = "return_prompt" },
            opts = { skip = true },
        },
        {
            filter = { event = "msg_show", kind = "quickfix" },
            opts = { skip = true },
        },
        {
            filter = { event = "msg_show", kind = "search_count" },
            opts = { skip = true },
        },
        {
            filter = { event = "msg_show", kind = "wmsg" },
            opts = { skip = true },
        },
        {
            -- view = "cmdline_popup",
            filter = { event = "msg_show", kind = "" },
            opts = { skip = true },
        },
    }
})


-- GRUVBOX COLOR SCHEME SETUP
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
        IlluminatedWordText = { underline = true, bold = true },
        IlluminatedWordRead = { underline = true, bold = true },
        IlluminatedWordWrite = { underline = true, bold = true },

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
        markdownBold = { bold = true, fg = colors.aqua },
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
-- vim.cmd('set conceallevel=1')
-- -- vim.cmd('map <kj> <Nop>')
-- -- vim.cmd('map <jk> <Nop>')
-- vim.cmd('set expandtab')
-- vim.cmd('set shiftwidth=4')
-- vim.cmd('set tabstop=4')
-- vim.cmd("call vimtex#init()")
-- vim.cmd("let g:tex_flavour='latex'")
-- vim.cmd("let g:vimtex_quickfix_mode=0")
-- vim.cmd("let g:tex_conceal='abdmg'")
-- vim.cmd("let g:vimtex_view_method='zathura'")
-- -- vim.cmd("let g:vimtex_view_skim_sync=1")
-- -- vim.cmd("let g:vimtex_view_general_options = '-reuse-instance -forward-serach @tex @line @pdf'")
-- vim.cmd("let g:tex_fold_enabled=1")
-- vim.cmd("let g:vimtex_compiler_method = 'latexmk'")
-- -- vim.cmd("let g:vimtex_view_general_options = {'options': ['-shell-escape']}")

-- Set conceal level to 1
vim.opt.conceallevel = 1
vim.opt.expandtab = true -- Use spaces instead of tabs
vim.opt.shiftwidth = 4   -- Indentation amount for < and >
vim.opt.tabstop = 4      -- Number of spaces tabs count for
vim.cmd("call vimtex#init()")
vim.g.tex_flavour = 'latex'
vim.g.tex_conceal = 'abdmg'
vim.g.vimtex_view_method = 'skim'
vim.g.vimtex_view_skim_sync = 1
vim.g.vimtex_view_general_options = '-reuse-instance -forward-search @tex @line @pdf -shell-escape'
vim.g.vimtex_compiler_method = 'latexmk'
vim.g.vimtex_quickfix_mode = 0
vim.g.vimtex_log_verbose = 1
-- Snippets
local ls = require("luasnip")

-- some shorthands
local types = require("luasnip.util.types")

ls.config.set_config({
    history = true,
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

lvim.builtin.lualine.options.theme = function()
    -- local luacolors = {
    --     darkgray = "#3c3836", -- Gruvbox dark gray
    --     gray = "#928374",     -- Gruvbox gray
    --     innerbg = nil,        -- Transparent
    --     outerbg = nil,        -- Transparent
    --     normal = "#fabd2f",   -- Gruvbox yellow (for normal mode)
    --     insert = "#b8bb26",   -- Gruvbox green (for insert mode)
    --     visual = "#fe8019",   -- Gruvbox orange (for visual mode)
    --     replace = "#fb4934",  -- Gruvbox red (for replace mode)
    --     command = "#83a598",  -- Gruvbox aqua (for command mode)
    -- }
    return {
        inactive = {
            a = { fg = colors.gray, bg = colors.outerbg, gui = "bold" },
            b = { fg = colors.gray, bg = colors.outerbg },
            c = { fg = colors.gray, bg = colors.innerbg },
        },
        visual = {
            a = { fg = colors.darkgray, bg = colors.visual, gui = "bold" },
            b = { fg = colors.gray, bg = colors.outerbg },
            c = { fg = colors.gray, bg = colors.innerbg },
        },
        replace = {
            a = { fg = colors.darkgray, bg = colors.replace, gui = "bold" },
            b = { fg = colors.gray, bg = colors.outerbg },
            c = { fg = colors.gray, bg = colors.innerbg },
        },
        normal = {
            a = { fg = colors.darkgray, bg = colors.normal, gui = "bold" },
            b = { fg = colors.gray, bg = colors.outerbg },
            c = { fg = colors.gray, bg = colors.innerbg },
        },
        insert = {
            a = { fg = colors.darkgray, bg = colors.insert, gui = "bold" },
            b = { fg = colors.gray, bg = colors.outerbg },
            c = { fg = colors.gray, bg = colors.innerbg },
        },
        command = {
            a = { fg = colors.darkgray, bg = colors.command, gui = "bold" },
            b = { fg = colors.gray, bg = colors.outerbg },
            c = { fg = colors.gray, bg = colors.innerbg },
        },
    }
end
