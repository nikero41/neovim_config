---@class ExternalTool
---@field cmd string
---@field name string?
---@field required boolean
---@field info string

---@class HealthCheck
---@field external_tools table<integer, ExternalTool>
---@field language_tools table<integer, ExternalTool>
---@field check_external_tools fun(self: HealthCheck)
---@field check_language_tools fun(self: HealthCheck)
---@field check_terminal fun(self: HealthCheck)
---@field check_mason_tools fun(self: HealthCheck)
---@field check_colorscheme fun(self: HealthCheck)
---@field check_performance fun(self: HealthCheck)
---@field check fun(self: HealthCheck)
local HealthCheck = {
	external_tools = {
		-- Core tools
		{ cmd = "git", required = true, info = "Version control" },
		{ cmd = "rg", name = "ripgrep", required = true, info = "Fast grep for Snacks picker" },

		-- Optional tools
		{ cmd = "fd", required = false, info = "Fast file finder for Snacks picker" },
		{ cmd = "lazygit", required = false, info = "Terminal UI for git" },
		{ cmd = "sad", required = false, info = "Search and replace (sad.nvim)" },
		{ cmd = "delta", required = false, info = "Git diff viewer" },
	},
	language_tools = {
		{ cmd = "node", required = false, info = "JavaScript runtime" },
		{ cmd = "npm", required = false, info = "Node package manager" },
		{ cmd = "go", required = false, info = "Go compiler" },
		{ cmd = "cargo", required = false, info = "Rust package manager" },
		{ cmd = "python3", required = false, info = "Python interpreter" },
	},
}

---Get tool version if available
---@param cmd string
---@return string|nil
local function get_version(cmd)
	local version_flags = { "--version", "-v", "-V", "version" }
	for _, flag in ipairs(version_flags) do
		local result = vim.system({ cmd, flag }, { text = true }):wait()
		if result.code == 0 and result.stdout then
			local version = result.stdout:match("[%d]+%.[%d]+[%.%d]*")
				or result.stdout:match("[%d]+%.[%d]+")
			if version then return version end
		end
	end
	return nil
end

function HealthCheck:check_external_tools()
	vim.health.start("External Dependencies")

	for _, tool in ipairs(self.external_tools) do
		local name = tool.name or tool.cmd
		if vim.fn.executable(tool.cmd) == 1 then
			local version = get_version(tool.cmd)
			local msg = version and ("%s v%s"):format(name, version) or name
			if tool.info then msg = msg .. " - " .. tool.info end
			vim.health.ok(msg)
		elseif tool.required then
			vim.health.error(("%s not found - %s"):format(name, tool.info or "required"))
		else
			vim.health.warn(("%s not found (optional) - %s"):format(name, tool.info or ""))
		end
	end
end

function HealthCheck:check_language_tools()
	vim.health.start("Language Tools")

	for _, tool in ipairs(self.language_tools) do
		local name = tool.name or tool.cmd
		if vim.fn.executable(tool.cmd) == 1 then
			local version = get_version(tool.cmd)
			local msg = version and ("%s v%s"):format(name, version) or name

			if tool.info then msg = msg .. " - " .. tool.info end
			vim.health.ok(msg)
		else
			vim.health.warn(("%s not found (optional) - %s"):format(name, tool.info or ""))
		end
	end
end

function HealthCheck:check_terminal()
	vim.health.start("Terminal & Environment")

	if vim.g.have_nerd_font then
		vim.health.ok("Nerd Font enabled (vim.g.have_nerd_font = true)")
	else
		vim.health.warn("Nerd Font not configured - some icons may not display correctly")
	end

	local term_program = vim.env.TERM_PROGRAM or "unknown"
	local term = vim.env.TERM or "unknown"
	vim.health.info(("Terminal: %s (TERM=%s)"):format(term_program, term))

	-- Multiplexer detection (for smart-splits)
	local mux_detected = false
	if term_program:lower() == "tmux" or vim.env.TMUX then
		vim.health.ok("tmux detected - smart-splits integration available")
		mux_detected = true
	end
	if term_program:lower() == "wezterm" or vim.env.WEZTERM_PANE then
		vim.health.ok("WezTerm detected - smart-splits integration available")
		mux_detected = true
	end
	if vim.env.KITTY_LISTEN_ON then
		vim.health.ok("Kitty detected - smart-splits integration available")
		mux_detected = true
	end
	if not mux_detected then
		vim.health.info("No terminal multiplexer detected (tmux/wezterm/kitty)")
	end

	if vim.env.COLORTERM == "truecolor" or vim.env.COLORTERM == "24bit" then
		vim.health.ok("True color support detected (COLORTERM=" .. vim.env.COLORTERM .. ")")
	else
		vim.health.warn("True color may not be supported - colors might look off")
	end
end

function HealthCheck:check_mason_tools()
	vim.health.start("Mason Tools")

	local mason_ok, mason_registry = pcall(require, "mason-registry")
	if not mason_ok then return vim.health.warn("Mason not loaded - run :Mason to initialize") end

	local lazy_ok, lazy_config = pcall(require, "lazy.core.config")
	if not lazy_ok then
		return vim.health.warn("lazy.nvim not loaded - cannot check mason-tool-installer config")
	end

	local mason_tool_installer = lazy_config.plugins["mason-tool-installer.nvim"]
	if not mason_tool_installer or not mason_tool_installer.opts then
		return vim.health.warn("mason-tool-installer.nvim config not found")
	end

	local installed = mason_registry.get_installed_package_names()
	local missing = vim.tbl_filter(
		function(tool) return not vim.tbl_contains(installed, tool) end,
		mason_tool_installer.opts.ensure_installed or {}
	)

	if #missing == 0 then
		vim.health.ok("All ensured packages are installed")
	else
		for _, tool in ipairs(missing) do
			vim.health.warn(tool .. " not installed - run :MasonToolsInstall")
		end
	end
end

function HealthCheck:check_colorscheme()
	vim.health.start("Colorscheme")

	if not vim.g.colorscheme then
		vim.health.warn("vim.g.colorscheme not set")
		return
	end

	vim.health.info("Configured colorscheme: " .. vim.g.colorscheme)

	-- Check if catppuccin is available (used for custom highlights)
	local catppuccin_ok = pcall(require, "catppuccin.palettes")
	if catppuccin_ok then
		vim.health.ok("catppuccin.nvim loaded - custom highlights available")
	else
		vim.health.warn("catppuccin.nvim not loaded - some custom highlights may not work")
	end

	if vim.g.colorscheme ~= vim.g.colors_name then
		vim.health.error("Configured colorscheme does not match active colorscheme")
	end
end

function HealthCheck:check_performance()
	vim.health.start("Performance")

	local clients = vim.lsp.get_clients()
	if #clients > 5 then
		vim.health.warn(("Many LSP clients active: %d (may impact performance)"):format(#clients))
	else
		vim.health.ok(("Active LSP clients: %d"):format(#clients))
	end

	local lazy_ok, lazy_config = pcall(require, "lazy.core.config")
	if lazy_ok then
		local loaded_plugins = vim.tbl_filter(
			function(plugin) return plugin._.loaded end,
			lazy_config.plugins
		)
		vim.health.info(
			("Plugins: %d loaded / %d total"):format(#loaded_plugins, vim.tbl_count(lazy_config.plugins))
		)
	end

	vim.health.info("Run :Lazy profile for detailed startup timing")
end

function HealthCheck.check()
	vim.health.start("nikero.nvim")
	vim.health.info("Custom Neovim configuration health check")

	HealthCheck:check_external_tools()
	HealthCheck:check_language_tools()
	HealthCheck:check_terminal()
	HealthCheck:check_mason_tools()
	HealthCheck:check_colorscheme()
	HealthCheck:check_performance()
end

return HealthCheck
