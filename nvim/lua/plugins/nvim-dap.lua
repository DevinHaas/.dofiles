return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "mxsdev/nvim-dap-vscode-js",
      "jay-babu/mason-nvim-dap.nvim",
      "rcarriga/nvim-dap-ui",
      "theHamsta/nvim-dap-virtual-text",
      "nvim-neotest/nvim-nio",
      "mason-org/mason.nvim",
    },
    config = function()
      local dap = require("dap")

      dap.adapters["pwa-node"] = {
        type = "server",
        host = "localhost",
        port = "${port}",
        executable = {
          command = "node", -- This will be available via Mason
          args = { "~/.local/share/nvim/lazy/vscode-js-debug/out/src/dapDebugServer.js", "${port}" },
        },
      }
      require("dap-vscode-js").setup({
        debugger_path = vim.fn.stdpath("data") .. "/lazy/vscode-js-debug",
        adapters = { "pwa-node", "pwa-chrome", "pwa-msedge", "node-terminal", "pwa-extensionHost" },
      })

      for _, language in ipairs({ "typescript", "typescriptreact", "javascript" }) do
        dap.configurations[language] = {
          -- attach to a node process that has been started with
          -- `--inspect` for longrunning tasks or `--inspect-brk` for short tasks
          -- npm script -> `node --inspect-brk ./node_modules/.bin/vite dev`
          {
            -- use nvim-dap-vscode-js's pwa-node debug adapter
            type = "pwa-node",
            -- attach to an already running node process with --inspect flag
            -- default port: 9222
            request = "attach",
            -- allows us to pick the process using a picker
            processId = require("dap.utils").pick_process,
            -- name of the debug action you have to select for this config
            name = "Attach debugger to existing `node --inspect` process",
            -- for compiled languages like TypeScript or Svelte.js
            sourceMaps = true,
            -- resolve source maps in nested locations while ignoring node_modules
            resolveSourceMapLocations = {
              "${workspaceFolder}/**",
              "!**/node_modules/**",
            },
            -- path to src in vite based projects (and most other projects as well)
            cwd = "${workspaceFolder}/src",
            -- we don't want to debug code inside node_modules, so skip it!
            skipFiles = { "${workspaceFolder}/node_modules/**/*.js" },
          },
          {
            type = "pwa-chrome",
            name = "Launch Chrome to debug client",
            request = "launch",
            url = "http://localhost:5173",
            sourceMaps = true,
            protocol = "inspector",
            port = 9222,
            webRoot = "${workspaceFolder}/src",
            -- skip files from vite's hmr
            skipFiles = { "**/node_modules/**/*", "**/@vite/*", "**/src/client/*", "**/src/*" },
          },
          -- only if language is javascript, offer this debug action
          language == "javascript"
              and {
                -- use nvim-dap-vscode-js's pwa-node debug adapter
                type = "pwa-node",
                -- launch a new process to attach the debugger to
                request = "launch",
                -- name of the debug action you have to select for this config
                name = "Launch file in new node process",
                -- launch current file
                program = "${file}",
                cwd = "${workspaceFolder}",
              }
            or nil,
        }
      end
      -- Keybindings for Debugging
      vim.keymap.set("n", "<leader>db", function()
        require("dap").toggle_breakpoint()
      end, { desc = "Toggle Breakpoint" })

      vim.keymap.set("n", "<leader>dc", function()
        require("dap").continue()
      end, { desc = "Continue Debugging" })

      vim.keymap.set("n", "<leader>dT", function()
        require("dap").terminate()
      end, { desc = "Terminate Debugging" })

      vim.keymap.set("n", "<leader>du", function()
        require("dapui").toggle({})
      end, { desc = "Toggle DAP UI" })
    end,
  },

  {
    "jay-babu/mason-nvim-dap.nvim",
    dependencies = {
      "mfussenegger/nvim-dap",
      "mason-org/mason.nvim",
    },
    opts = {
      ensure_installed = {
        "bash",
        "chrome",
        "python",
        "js-debug", -- Install js-debug for `pwa-node`
      },
    },
  },

  {
    "rcarriga/nvim-dap-ui",
    dependencies = { "mfussenegger/nvim-dap" },
    config = true,
  },

  {
    "theHamsta/nvim-dap-virtual-text",
    dependencies = { "mfussenegger/nvim-dap" },
    config = true,
  },
}
