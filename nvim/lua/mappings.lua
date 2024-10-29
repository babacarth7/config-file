require "nvchad.mappings"

local map = vim.keymap.set

-- Default mappings
map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

-- Java specific mappings
map("n", "<leader>jc", function()
    require("java").compile()
end, { desc = "Java Compile" })

map("n", "<leader>jt", function()
    require("java-test").test()
end, { desc = "Java Test" })

map("n", "<leader>jr", function()
    require("java").run()
end, { desc = "Java Run" })

map("n", "<leader>ji", function()
    require("java").organize_imports()
end, { desc = "Organize Imports" })

map("n", "<leader>jf", function()
    vim.lsp.buf.format()
end, { desc = "Format Java" })

-- Debugger mappings
map("n", "<leader>db", "<cmd> DapToggleBreakpoint <CR>", { desc = "Add breakpoint at line" })
map("n", "<leader>dr", "<cmd> DapContinue <CR>", { desc = "Start or continue debugger" })
map("n", "<leader>dt", function()
    require("dapui").toggle()
end, { desc = "Toggle debugging UI" })
map("n", "<leader>do", "<cmd> DapStepOver <CR>", { desc = "Step Over" })
map("n", "<leader>di", "<cmd> DapStepInto <CR>", { desc = "Step Into" })
map("n", "<leader>dO", "<cmd> DapStepOut <CR>", { desc = "Step Out" })
map("n", "<leader>dx", "<cmd> DapTerminate <CR>", { desc = "Terminate Debug Session" })

-- Language specific debug mappings
-- For Java
map("n", "<leader>jd", function()
    require("jdtls.dap").setup_dap_main_class_configs()
end, { desc = "Setup Java Debug" })

-- For Go
map("n", "<leader>gd", function()
    require("dap-go").debug_test()
end, { desc = "Debug Go Test" })

-- For JavaScript/TypeScript
map("n", "<leader>td", function()
    require("dap").continue({
        type = "pwa-node",
        request = "launch",
        name = "Launch file",
        program = "${file}",
        cwd = "${workspaceFolder}",
    })
end, { desc = "Debug TypeScript/JavaScript" })

-- For Flutter/Dart
map("n", "<leader>fd", function()
    require("dap").continue({
        type = "dart",
        request = "launch",
        name = "Launch Flutter",
        program = "lib/main.dart",
        flutterMode = "debug"
    })
end, { desc = "Debug Flutter" })
