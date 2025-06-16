return {
  {
    "rcarriga/nvim-dap-ui",
    lazy = true,
    opts = {
      layouts = {
        {
          elements = {
            {
              id = "scopes",
              size = 0.25,
            },
            {
              id = "breakpoints",
              size = 0.25,
            },
            {
              id = "stacks",
              size = 0.25,
            },
            {
              id = "watches",
              size = 0.25,
            },
          },
          position = "right",
          size = 70,
        },
        {
          elements = {
            {
              id = "repl",
              size = 0.5,
            },
            {
              id = "console",
              size = 0.5,
            },
          },
          position = "bottom",
          size = 10,
        },
      },
    }
  },
  {
    "leoluz/nvim-dap-go",
    lazy = true,
    ft = "go",
  },
  {
    "mfussenegger/nvim-dap",
    lazy = true,
    dependencies = {
      "nvim-neotest/nvim-nio",
    },

    config = function()
      local dap, dapui = require("dap"), require("dapui")

      require("dap-go").setup({})
      dap.set_log_level("TRACE")

      dap.adapters["pwa-node"] = {
        type = "server",
        host = "localhost",
        port = "${port}",
        executable = {
          command = "node",
          args = { "/home/oung/.config/js-debug/src/dapDebugServer.js", "${port}" },
        },
      }
      dap.adapters["rust-gdb"] = {
        type = "executable",
        command = "rust-gdb",
        args = { "--interpreter=dap", "--eval-command", "set print pretty on" },
      }

      dap.configurations.javascript = {
        {
          type = "pwa-node",
          request = "launch",
          name = "Launch file",
          program = "${file}",
          cwd = "${workspaceFolder}",
        },
      }
      dap.configurations.typescript = {
        {
          type = "pwa-node",
          request = "launch",
          name = "Launch file",
          runtimeExecutable = "deno",
          runtimeArgs = {
            "run",
            "--inspect-wait",
            "--allow-all",
          },
          program = "${file}",
          cwd = "${workspaceFolder}",
          attachSimplePort = 9229,
        },
      }
      dap.configurations.rust = {
        {
          name = "Launch",
          type = "rust-gdb",
          request = "launch",
          program = function()
            return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
          end,
          -- https://github.com/mfussenegger/nvim-dap/wiki/Debug-Adapter-installation
          cwd = "${workspaceFolder}",
          stopAtBeginningOfMainSubprogram = false,
        },
        {
          name = "Select and attach to process",
          type = "rust-gdb",
          request = "attach",
          program = function()
            return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
          end,
          pid = function()
            local name = vim.fn.input("Executable name (filter): ")
            return require("dap.utils").pick_process({ filter = name })
          end,
          cwd = "${workspaceFolder}",
        },
      }

      dap.listeners.before.attach.dapui_config = function()
        dapui.open()
      end
      dap.listeners.before.launch.dapui_config = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated.dapui_config = function()
        dapui.close()
      end
      dap.listeners.before.event_exited.dapui_config = function()
        dapui.close()
      end
    end,

    keys = {
      { "<leader>d", "<Nop>", desc = "Debugger" },
      {
        "<leader>db",
        function()
          require("dap").toggle_breakpoint()
        end,
        desc = "Toggle Breakpoint",
      },
      {
        "<leader>dc",
        function()
          require("dap").continue()
        end,
        desc = "Continue",
      },
      {
        "<leader>dt",
        function()
          require("dap").terminate()
        end,
        desc = "Terminate",
      },
      {
        "<leader>dB",
        function()
          require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
        end,
        desc = "Breakpoint Condition",
      },
      {
        "<leader>du",
        function()
          require("dapui").toggle()
        end,
        desc = "Toggle Debugger UI",
      },
      {
        "<leader>dl",
        function()
          require("dapui").float_element("scopes", { enter = true })
        end,
        desc = "Locals Float Window",
      },
      {
        "<leader>de",
        function()
          require("dapui").float_element("watches", { enter = true })
        end,
        desc = "Expressions Float Window",
      },
      {
        "<leader>dL",
        function()
          require("dapui").float_element("breakpoints", { enter = true })
        end,
        desc = "Breakpoints Float Window",
      },
      {
        "<leader>ds",
        function()
          require("dapui").float_element("stacks", { enter = true })
        end,
        desc = "Stacks Float Window",
      },
    },
  },
}
