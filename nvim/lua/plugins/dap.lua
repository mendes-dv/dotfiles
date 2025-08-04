local function rebuild_project(co, path)
  local spinner = require("easy-dotnet.ui-modules.spinner").new()
  spinner:start_spinner "Building"
  vim.fn.jobstart(string.format("dotnet build %s", path), {
    on_exit = function(_, return_code)
      if return_code == 0 then
        spinner:stop_spinner "Built successfully"
      else
        spinner:stop_spinner("Build failed with exit code " .. return_code, vim.log.levels.ERROR)
        error "Build failed"
      end
      coroutine.resume(co)
    end,
  })
  coroutine.yield()
end

return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      {
        "rcarriga/nvim-dap-ui",
        dependencies = { "nvim-neotest/nvim-nio" },
        config = function()
          local dap = require("dap")
          local dapui = require("dapui")
          
          dapui.setup({
            icons = { expanded = "▾", collapsed = "▸", current_frame = "▸" },
            mappings = {
              expand = { "<CR>", "<2-LeftMouse>" },
              open = "o",
              remove = "d",
              edit = "e",
              repl = "r",
              toggle = "t",
            },
            layouts = {
              {
                elements = {
                  { id = "scopes", size = 0.25 },
                  "breakpoints",
                  "stacks",
                  "watches",
                },
                size = 40,
                position = "left",
              },
              {
                elements = {
                  "repl",
                  "console",
                },
                size = 0.25,
                position = "bottom",
              },
            },
            controls = {
              enabled = true,
              element = "repl",
              icons = {
                pause = "",
                play = "",
                step_into = "",
                step_over = "",
                step_out = "",
                step_back = "",
                run_last = "↻",
                terminate = "□",
              },
            },
            floating = {
              max_height = nil,
              max_width = nil,
              border = "single",
              mappings = {
                close = { "q", "<Esc>" },
              },
            },
            windows = { indent = 1 },
            render = {
              max_type_length = nil,
              max_value_lines = 100,
            }
          })
          -- Auto open/close dapui
          dap.listeners.after.event_initialized["dapui_config"] = function()
            dapui.open()
          end
          dap.listeners.before.event_terminated["dapui_config"] = function()
            dapui.close()
          end
          dap.listeners.before.event_exited["dapui_config"] = function()
            dapui.close()
          end
        end,
      },
      
      -- Virtual text during debugging
      {
        "theHamsta/nvim-dap-virtual-text",
        config = function()
          require("nvim-dap-virtual-text").setup({
            enabled = true,
            enabled_commands = true,
            highlight_changed_variables = true,
            highlight_new_as_changed = false,
            show_stop_reason = true,
            commented = false,
            only_first_definition = true,
            all_references = false,
            clear_on_continue = false,
            virt_text_pos = "eol",
            all_frames = false,
            virt_lines = false,
            virt_text_win_col = nil
          })
        end,
      },
      -- Mason integration for DAP
      {
        "jay-babu/mason-nvim-dap.nvim",
        dependencies = { "williamboman/mason.nvim" },
        config = function()
          require("mason-nvim-dap").setup({
            automatic_installation = true,
            ensure_installed = {
              "coreclr", -- .NET Core debugger
              "js-debug-adapter", -- JavaScript/TypeScript
              "python", -- Python debugger
              "node2", -- Node.js debugger
            },
            handlers = {},
          })
        end,
      },
    },
    
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")
      
      -- Check if easy-dotnet is available
      local has_easy_dotnet, dotnet = pcall(require, "easy-dotnet")
      local has_netcoredbg, _ = pcall(require, "easy-dotnet.netcoredbg")
      
      if has_netcoredbg then
        -- .NET specific setup using `easy-dotnet`
        require("easy-dotnet.netcoredbg").register_dap_variables_viewer()
      end
      
      local debug_dll = nil

      local function ensure_dll()
        if not has_easy_dotnet then
          return nil
        end
        if debug_dll ~= nil then
          return debug_dll
        end
        local dll = dotnet.get_debug_dll(true)
        debug_dll = dll
        return dll
      end

      -- .NET Core adapter configuration
      dap.adapters.coreclr = {
        type = "executable",
        command = "netcoredbg",
        args = { "--interpreter=vscode" },
      }

      -- .NET configurations for C# and F#
      for _, value in ipairs({ "cs", "fsharp" }) do
        local configs = {}
        
        if has_easy_dotnet then
          -- Enhanced configurations with easy-dotnet
          configs = {
            {
              type = "coreclr",
              name = "Program (Auto)",
              request = "launch",
              env = function()
                local dll = ensure_dll()
                if dll then
                  local vars = dotnet.get_environment_variables(dll.project_name, dll.relative_project_path)
                  return vars or nil
                end
                return nil
              end,
              program = function()
                local dll = ensure_dll()
                if dll then
                  local co = coroutine.running()
                  rebuild_project(co, dll.project_path)
                  return dll.relative_dll_path
                end
                return vim.fn.input('Path to dll: ', vim.fn.getcwd() .. '/bin/Debug/', 'file')
              end,
              cwd = function()
                local dll = ensure_dll()
                if dll then
                  return dll.relative_project_path
                end
                return vim.fn.getcwd()
              end
            },
            {
              type = "coreclr",
              name = "Test",
              request = "attach",
              processId = function()
                local res = require("easy-dotnet").experimental.start_debugging_test_project()
                return res.process_id
              end
            }
          }
        end
        
        -- Always add manual configuration as fallback
        table.insert(configs, {
          type = "coreclr",
          name = "Launch - Manual",
          request = "launch",
          program = function()
            return vim.fn.input('Path to dll: ', vim.fn.getcwd() .. '/bin/Debug/', 'file')
          end,
          cwd = "${workspaceFolder}",
          stopAtEntry = false,
        })
        
        dap.configurations[value] = configs
      end

      -- Reset debug_dll after each terminated session (only if easy-dotnet is available)
      if has_easy_dotnet then
        dap.listeners.before['event_terminated']['easy-dotnet'] = function()
          debug_dll = nil
        end
      end

      -- JavaScript/TypeScript configuration
      dap.configurations.javascript = {
        {
          type = "pwa-node",
          request = "launch",
          name = "Launch file",
          program = "${file}",
          cwd = "${workspaceFolder}",
        },
        {
          type = "pwa-node",
          request = "attach",
          name = "Attach",
          processId = require'dap.utils'.pick_process,
          cwd = "${workspaceFolder}",
        }
      }
      dap.configurations.typescript = dap.configurations.javascript
      
      -- Python configuration
      dap.adapters.python = function(cb, config)
        if config.request == 'attach' then
          local port = (config.connect or config).port
          local host = (config.connect or config).host or '127.0.0.1'
          cb({
            type = 'server',
            port = assert(port, '`connect.port` is required for a python `attach` configuration'),
            host = host,
            options = {
              source_filetype = 'python',
            },
          })
        else
          cb({
            type = 'executable',
            command = 'python',
            args = { '-m', 'debugpy.adapter' },
            options = {
              source_filetype = 'python',
            },
          })
        end
      end
      dap.configurations.python = {
        {
          type = 'python',
          request = 'launch',
          name = "Launch file",
          program = "${file}",
          pythonPath = function()
            local cwd = vim.fn.getcwd()
            if vim.fn.executable(cwd .. '/venv/bin/python') == 1 then
              return cwd .. '/venv/bin/python'
            elseif vim.fn.executable(cwd .. '/.venv/bin/python') == 1 then
              return cwd .. '/.venv/bin/python'
            else
              return '/usr/bin/python'
            end
          end,
        },
      }
      
      -- Enhanced keymaps with .NET specific shortcuts
      local keymap = vim.keymap.set
      
      -- Core debugging keymaps
      keymap("n", "<Leader>db", dap.toggle_breakpoint, { desc = "Debug: Toggle Breakpoint" })
      keymap("n", "<Leader>dB", function()
        dap.set_breakpoint(vim.fn.input('Breakpoint condition: '))
      end, { desc = "Debug: Set Conditional Breakpoint" })
      keymap("n", "<Leader>dc", dap.continue, { desc = "Debug: Start/Continue" })
      keymap("n", "<Leader>dC", dap.run_to_cursor, { desc = "Debug: Run to Cursor" })
      keymap("n", "<Leader>dd", dap.disconnect, { desc = "Debug: Disconnect" })
      keymap("n", "<Leader>dg", dap.session, { desc = "Debug: Get Session" })
      keymap("n", "<Leader>di", dap.step_into, { desc = "Debug: Step Into" })
      keymap("n", "<Leader>do", dap.step_over, { desc = "Debug: Step Over" })
      keymap("n", "<Leader>du", dap.step_out, { desc = "Debug: Step Out" })
      keymap("n", "<Leader>dp", dap.pause, { desc = "Debug: Pause" })
      keymap("n", "<Leader>dr", dap.repl.toggle, { desc = "Debug: Toggle REPL" })
      keymap("n", "<Leader>ds", dap.restart, { desc = "Debug: Restart" })
      keymap("n", "<Leader>dt", dap.terminate, { desc = "Debug: Terminate" })
      keymap("n", "<Leader>dw", function()
        require("dap.ui.widgets").hover()
      end, { desc = "Debug: Widgets" })
      
      -- Function key shortcuts (as per guide)
      keymap("n", "<F5>", dap.continue, { desc = "Start/continue debugging" })
      keymap("n", "<F10>", dap.step_over, { desc = "Step over" })
      keymap("n", "<F11>", dap.step_into, { desc = "Step into" })
      keymap("n", "<F12>", dap.step_out, { desc = "Step out" })
      keymap("n", "<leader>b", dap.toggle_breakpoint, { desc = "Toggle breakpoint" })
      keymap("n", "<leader>dO", dap.step_over, { desc = "Step over (alt)" })
      keymap("n", "<leader>dj", dap.down, { desc = "Go down stack frame" })
      keymap("n", "<leader>dk", dap.up, { desc = "Go up stack frame" })
      
      -- Terminate and clear breakpoints (from guide)
      keymap("n", "q", function()
        dap.terminate()
        dap.clear_breakpoints()
      end, { desc = "Terminate and clear breakpoints" })
      
      -- DAP UI keymaps
      keymap("n", "<Leader>dU", dapui.toggle, { desc = "Debug: Toggle UI" })
      keymap("v", "<Leader>de", dapui.eval, { desc = "Debug: Evaluate selection" })
      keymap("n", "<Leader>de", dapui.eval, { desc = "Debug: Evaluate expression" })
      
      -- Signs for breakpoints
      vim.fn.sign_define('DapBreakpoint', {
        text = '🟥',
        texthl = 'DapBreakpoint',
        linehl = '',
        numhl = ''
      })
      vim.fn.sign_define('DapBreakpointCondition', {
        text = '🟨',
        texthl = 'DapBreakpointCondition',
        linehl = '',
        numhl = ''
      })
      vim.fn.sign_define('DapLogPoint', {
        text = '🟦',
        texthl = 'DapLogPoint',
        linehl = '',
        numhl = ''
      })
      vim.fn.sign_define('DapStopped', {
        text = '▶️',
        texthl = 'DapStopped',
        linehl = 'DapStoppedLine',
        numhl = ''
      })
      vim.fn.sign_define('DapBreakpointRejected', {
        text = '🚫',
        texthl = 'DapBreakpointRejected',
        linehl = '',
        numhl = ''
      })
    end,
  },
}

