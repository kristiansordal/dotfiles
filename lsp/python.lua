require("lvim.lsp.manager").setup("pyright", opts)
require('dap-python').setup('/opt/homebrew/bin/python3')
local formatters = require "lvim.lsp.null-ls.formatters"
formatters.setup {
    {
        name = "black",
        args = { "-l", 100, "--preview" }
    },
}
local test_runners = require('dap-python').test_runners

-- `test_runners` is a table. The keys are the runner names like `unittest` or `pytest`.
-- The value is a function that takes three arguments:
-- The classname, a methodname and the opts
-- (The `opts` are coming passed through from either `test_method` or `test_class`)
-- The function must return a module name and the arguments passed to the module as list.
test_runners.your_runner = function(classname, methodname, opts)
    local args = { classname, methodname }
    return 'modulename', args
end
