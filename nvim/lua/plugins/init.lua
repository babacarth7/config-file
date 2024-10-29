return {
  {
    "stevearc/conform.nvim",
    opts = require "configs.conform",
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      require "configs.lspconfig"
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "css",
        "dart",
        "go",
        "html",
        "java",
        "javascript",
        "sql",
        "typescript",
        "vim",
        "vimdoc"
      },
    },
  },

  {
    "christoomey/vim-tmux-navigator",
    lazy = false,
    cmd = {
      "TmuxNavigateLeft",
      "TmuxNavigateDown",
      "TmuxNavigateUp",
      "TmuxNavigateRight",
      "TmuxNavigatePrevious",
    },
    keys = {
      { "<c-h>",  "<cmd><C-U>TmuxNavigateLeft<cr>" },
      { "<c-j>",  "<cmd><C-U>TmuxNavigateDown<cr>" },
      { "<c-k>",  "<cmd><C-U>TmuxNavigateUp<cr>" },
      { "<c-l>",  "<cmd><C-U>TmuxNavigateRight<cr>" },
      { "<c-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>" },
    },
  },

  {
    "mfussenegger/nvim-dap",
    event = "VeryLazy",
  },
  {
    "nvim-neotest/nvim-nio"
  },
  {
    "rcarriga/nvim-dap-ui",
    event = "VeryLazy",
    dependencies = {
      "mfussenegger/nvim-dap",
      "nvim-neotest/nvim-nio"
    },
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")
      dapui.setup()
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end
    end
  },
  -- For Go debugging
  {
    "leoluz/nvim-dap-go",
    ft = "go",
    dependencies = "mfussenegger/nvim-dap",
    config = function(_, opts)
      require("dap-go").setup(opts)
    end
  },
  -- For Dart/Flutter debugging
  {
    "mfussenegger/nvim-dap",
    config = function()
      local dap = require("dap")
      dap.adapters.dart = {
        type = "executable",
        command = "dart",
        args = { "debug_adapter" }
      }
      dap.configurations.dart = {
        {
          type = "dart",
          request = "launch",
          name = "Launch Dart Program",
          program = "${file}",
          cwd = "${workspaceFolder}",
        },
        {
          type = "dart",
          request = "launch",
          name = "Launch Flutter Program",
          program = "lib/main.dart",
          flutterMode = "debug"
        }
      }
    end
  },
  -- For Java debugging
  {
    "mfussenegger/nvim-jdtls",
    dependencies = { "mfussenegger/nvim-dap" },
    ft = "java",
  },
  -- For JavaScript/TypeScript debugging
  {
    "mxsdev/nvim-dap-vscode-js",
    dependencies = { "mfussenegger/nvim-dap" },
    config = function()
      require("dap-vscode-js").setup({
        debugger_path = vim.fn.stdpath("data") .. "/mason/packages/node-debug2-adapter",
        adapters = { 'pwa-node', 'pwa-chrome', 'pwa-msedge', 'node-terminal', 'pwa-extensionHost' },
      })
    end
  },

  {
    'nvim-java/nvim-java',
    config = false,
    dependencies = {
      {
        'neovim/nvim-lspconfig',
        opts = {
          servers = {
            jdtls = {
            },
          },
          setup = {
            jdtls = function()
              require('java').setup({
              })
            end,
          },
        },
      },
    },
  },

  {
    "JavaHello/spring-boot.nvim",
    ft = "java",
    dependencies = {
      "mfussenegger/nvim-jdtls",
      "ibhagwan/fzf-lua",
    },
  },

  {
    "folke/trouble.nvim",
    dependencies = "nvim-tree/nvim-web-devicons",
    config = function()
      require("trouble").setup()
    end,
  },

  {
    "akinsho/flutter-tools.nvim",
    lazy = false,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "stevearc/dressing.nvim",
    },
    config = true,
  },
  {
    "hexdigest/go-enhanced-treesitter.nvim",
    build = ":TSInstall go sql",
    ft = "go",
  },

  {
    "nvimtools/none-ls.nvim",
    lazy = true,
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    config = function()
      local null_ls = require("null-ls")
      local formatting = null_ls.builtins.formatting
      local diagnostics = null_ls.builtins.diagnostics

      null_ls.setup({
        debug = true,
        sources = {
          -- Go
          formatting.gofmt,
          formatting.goimports_reviser,
          formatting.golines,
          formatting.gofumpt,
          diagnostics.golangci_lint,

          -- TypeScript/JavaScript/Angular
          formatting.prettier.with({
            extra_args = {
              "--single-quote",
              "--jsx-single-quote",
              "--trailing-comma", "es5",
              "--arrow-parens", "avoid",
            },
          }),

          -- Dart/Flutter
          formatting.dart_format,

          -- Java
          formatting.google_java_format,

          -- SQL
          formatting.sql_formatter,
        },
        on_attach = function(client, bufnr)
          if client.supports_method("textDocument/formatting") then
            vim.api.nvim_create_autocmd("BufWritePre", {
              buffer = bufnr,
              callback = function()
                vim.lsp.buf.format({
                  async = false,
                  timeout_ms = 10000,
                })
              end,
            })
          end
        end,
      })
    end,
  }
}
