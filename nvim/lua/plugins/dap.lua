local function rebuild_project(co, path)
	local spinner = require("easy-dotnet.ui-modules.spinner").new()
	spinner:start_spinner("Building")
	vim.fn.jobstart(string.format("dotnet build %s", path), {
		on_exit = function(_, return_code)
			if return_code == 0 then
				spinner:stop_spinner("Built successfully")
			else
				spinner:stop_spinner("Build failed with exit code " .. return_code, vim.log.levels.ERROR)
				error("Build failed")
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
				dependencies = { "nvim-neotest/nvim-nio", "leoluz/nvim-dap-go" },
				config = function()
					local dap = require("dap")
					local dapui = require("dapui")
					require("dap-go").setup({
						dap_configurations = {
							{
								type = "go",
								name = "Attach remote",
								mode = "remote",
								request = "attach",
							},
						},
					})

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
									{ id = "scopes", size = 0.25, icons = "▸" },
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
						},
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
						virt_text_win_col = nil,
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
							"delve", -- Go debugger
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
									local vars =
										dotnet.get_environment_variables(dll.project_name, dll.relative_project_path)
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
								return vim.fn.input("Path to dll: ", vim.fn.getcwd() .. "/bin/Debug/", "file")
							end,
							cwd = function()
								local dll = ensure_dll()
								if dll then
									return dll.relative_project_path
								end
								return vim.fn.getcwd()
							end,
						},
						{
							type = "coreclr",
							name = "Test",
							request = "attach",
							processId = function()
								local res = require("easy-dotnet").experimental.start_debugging_test_project()
								return res.process_id
							end,
						},
					}
				end

				table.insert(configs, {
					type = "coreclr",
					name = "Launch (from launchSettings.json)",
					request = "launch",
					program = function()
						local dll = ensure_dll()
						if dll then
							local co = coroutine.running()
							rebuild_project(co, dll.project_path)
							return dll.relative_dll_path
						end
						return vim.fn.input("Path to dll: ", vim.fn.getcwd() .. "/bin/Debug/", "file")
					end,
					cwd = function()
						local dll = ensure_dll()
						if dll then
							return dll.relative_project_path
						end
						return vim.fn.getcwd()
					end,
					env = function()
						local dll = ensure_dll()
						if dll then
							return dotnet.get_launch_profile_env(dll.project_name, dll.relative_project_path)
						end
						return nil
					end,
					args = function()
						local dll = ensure_dll()
						if dll then
							return dotnet.get_launch_profile_args(dll.project_name, dll.relative_project_path)
						end
						return {}
					end,
				})

				table.insert(configs, {
					type = "netcoredbg",
					name = "Launch OpticsFlow",
					request = "launch",
					program = function()
						-- Build synchronously so DLL exists before debugger launches
						local result = vim.fn.systemlist({
							"dotnet",
							"run",
							"--project",
							"apps/backend/src/Api",
							"--launch-profile",
							"Api",
						})
						for _, line in ipairs(result) do
							vim.notify("[dotnet build] " .. line, vim.log.levels.INFO)
						end

						return vim.fn.getcwd() .. "/apps/backend/src/Api/bin/Debug/net9.0/Api.dll"
					end,
					cwd = "${workspaceFolder}/src/Api",
					env = {
						ASPNETCORE_ENVIRONMENT = "Development",
					},
					args = { "--urls", "https://localhost:7073;http://localhost:7071" },
					stopAtEntry = false,
					logging = {
						engineLogging = true,
						moduleLoad = true,
						trace = true,
					},
				})

				table.insert(configs, {
					type = "netcoredbg",
					name = "launch - netcoredbg",
					request = "launch",
					program = function()
						return vim.fn.input("DLL: ", vim.fn.getcwd() .. "/bin/Debug/net9.0/", "file")
					end,
					cwd = "${workspaceFolder}",
					console = "integratedTerminal",
				})
				table.insert(configs, {
					type = "coreclr",
					name = "Launch API with Profile",
					request = "launch",
					program = "dotnet",
					args = { "run", "--launch-profile", "Api" },
					cwd = "${workspaceFolder}/src/Api",
					stopAtEntry = false,
					console = "integratedTerminal",
				})

				dap.configurations[value] = configs
			end

			-- Reset debug_dll after each terminated session (only if easy-dotnet is available)
			if has_easy_dotnet then
				dap.listeners.before["event_terminated"]["easy-dotnet"] = function()
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
					processId = require("dap.utils").pick_process,
					cwd = "${workspaceFolder}",
				},
			}
			dap.configurations.typescript = dap.configurations.javascript

			-- Python configuration with virtual environment support
			local pythonPath = function()
				local cwd = vim.loop.cwd()
				local venv_python = cwd .. "/.venv/bin/python"
				if vim.fn.executable(venv_python) == 1 then
					return venv_python
				end
				return "python3" -- fallback
			end

			local set_python_dap = function()
				-- Check if dap-python is available and set it up first
				local has_dap_python, dap_python = pcall(require, "dap-python")
				if has_dap_python then
					dap_python.setup() -- Setup defaults ready to be replaced
				end

				dap.configurations.python = {
					{
						type = "python",
						request = "launch",
						name = "Launch file",
						program = "${file}",
						pythonPath = pythonPath(),
					},
					{
						type = "python",
						request = "launch",
						name = "Django Server",
						program = vim.loop.cwd() .. "/manage.py",
						args = { "runserver", "127.0.0.1:8000", "--noreload" },
						pythonPath = pythonPath(),
						django = true,
						justMyCode = true,
						console = "integratedTerminal",
						cwd = vim.loop.cwd(),
						env = function()
							local env = {}
							-- Copy current environment
							for k, v in pairs(vim.fn.environ()) do
								env[k] = v
							end
							-- Ensure Django settings are available
							if not env.DJANGO_SETTINGS_MODULE then
								-- Try to auto-detect Django settings module
								local settings_files = vim.fn.glob(vim.loop.cwd() .. "/*/settings.py", true, true)
								if #settings_files > 0 then
									local settings_path = settings_files[1]
									local project_name = settings_path:match(".*/(.+)/settings.py")
									if project_name then
										env.DJANGO_SETTINGS_MODULE = project_name .. ".settings"
									end
								end
							end
							return env
						end,
					},
					{
						type = "python",
						request = "launch",
						name = "Django Shell",
						program = vim.loop.cwd() .. "/manage.py",
						args = { "shell" },
						pythonPath = pythonPath(),
						console = "integratedTerminal",
						cwd = vim.loop.cwd(),
					},
					{
						type = "python",
						request = "attach",
						name = "Attach remote",
						connect = function()
							return {
								host = "127.0.0.1",
								port = 8000,
							}
						end,
					},
					{
						type = "python",
						request = "launch",
						name = "Launch file with arguments",
						program = "${file}",
						args = function()
							local args_string = vim.fn.input("Arguments: ")
							return vim.split(args_string, " +")
						end,
						console = "integratedTerminal",
						pythonPath = pythonPath(),
						cwd = vim.loop.cwd(),
					},
				}

				dap.adapters.python = {
					type = "executable",
					command = pythonPath(),
					args = { "-m", "debugpy.adapter" },
					options = {
						source_filetype = "python",
					},
				}
			end

			-- Set up Python DAP
			set_python_dap()

			-- Update Python configuration when directory changes
			vim.api.nvim_create_autocmd({ "DirChanged" }, {
				callback = function()
					set_python_dap()
				end,
			})

			dap.configurations.go = vim.list_extend(dap.configurations.go or {}, {
				{
					type = "go",
					name = "Debug cmd/main.go",
					request = "launch",
					program = "${workspaceFolder}/cmd/main.go",
					outputMode = "remote",
				},
				{
					type = "go",
					name = "Debug API Server",
					request = "launch",
					program = "${workspaceFolder}/cmd/api/main.go",
					console = "integratedTerminal",
					showLog = true,
					logOutput = "dap",
				},
				{
					type = "go",
					name = "Debug Worker",
					request = "launch",
					program = "${workspaceFolder}/cmd/worker/main.go",
					console = "integratedTerminal",
					showLog = true,
					logOutput = "dap",
				},
				{
					type = "go",
					name = "Debug with External Terminal",
					request = "launch",
					program = "${workspaceFolder}/cmd/main.go",
					console = "externalTerminal",
					showLog = true,
					logOutput = "dap",
				},
			})

			-- Enhanced keymaps with .NET specific shortcuts
			local keymap = vim.keymap.set

			-- Core debugging keymaps
			keymap("n", "<Leader>db", dap.toggle_breakpoint, { desc = "Debug: Toggle Breakpoint" })
			keymap("n", "<Leader>dB", function()
				dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
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
			vim.fn.sign_define("DapBreakpoint", {
				text = "🟥",
				texthl = "DapBreakpoint",
				linehl = "",
				numhl = "",
			})
			vim.fn.sign_define("DapBreakpointCondition", {
				text = "🟨",
				texthl = "DapBreakpointCondition",
				linehl = "",
				numhl = "",
			})
			vim.fn.sign_define("DapLogPoint", {
				text = "🟦",
				texthl = "DapLogPoint",
				linehl = "",
				numhl = "",
			})
			vim.fn.sign_define("DapStopped", {
				text = "▶️",
				texthl = "DapStopped",
				linehl = "DapStoppedLine",
				numhl = "",
			})
			vim.fn.sign_define("DapBreakpointRejected", {
				text = "🚫",
				texthl = "DapBreakpointRejected",
				linehl = "",
				numhl = "",
			})
		end,
	},
}
