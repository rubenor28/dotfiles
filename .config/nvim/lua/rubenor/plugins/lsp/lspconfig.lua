return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"hrsh7th/cmp-nvim-lsp",
		{ "antosha417/nvim-lsp-file-operations", config = true },
		{ "folke/neodev.nvim", opts = {} },
	},
	config = function()
		-- import lspconfig plugin
		local lspconfig = require("lspconfig")

		-- import mason_lspconfig plugin
		local mason_lspconfig = require("mason-lspconfig")

		-- import cmp-nvim-lsp plugin
		local cmp_nvim_lsp = require("cmp_nvim_lsp")

		local keymap = vim.keymap -- for conciseness

		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("UserLspConfig", {}),
			callback = function(ev)
				-- Buffer local mappings.
				-- See `:help vim.lsp.*` for documentation on any of the below functions
				local opts = { buffer = ev.buf, silent = true }

				-- set keybinds
				opts.desc = "Show LSP references"
				keymap.set("n", "gR", "<cmd>Telescope lsp_references<CR>", opts) -- show definition, references

				opts.desc = "Go to declaration"
				keymap.set("n", "gD", vim.lsp.buf.declaration, opts) -- go to declaration

				opts.desc = "Show LSP definitions"
				keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts) -- show lsp definitions

				opts.desc = "Show LSP implementations"
				keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts) -- show lsp implementations

				opts.desc = "Show LSP type definitions"
				keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts) -- show lsp type definitions

				opts.desc = "See available code actions"
				keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts) -- see available code actions, in visual mode will apply to selection

				opts.desc = "Smart rename"
				keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts) -- smart rename

				opts.desc = "Show buffer diagnostics"
				keymap.set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", opts) -- show  diagnostics for file

				opts.desc = "Show line diagnostics"
				keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts) -- show diagnostics for line

				opts.desc = "Go to previous diagnostic"
				keymap.set("n", "[d", vim.diagnostic.goto_prev, opts) -- jump to previous diagnostic in buffer

				opts.desc = "Go to next diagnostic"
				keymap.set("n", "]d", vim.diagnostic.goto_next, opts) -- jump to next diagnostic in buffer

				opts.desc = "Show documentation for what is under cursor"
				keymap.set("n", "K", vim.lsp.buf.hover, opts) -- show documentation for what is under cursor

				opts.desc = "Restart LSP"
				keymap.set("n", "<leader>rs", ":LspRestart<CR>", opts) -- mapping to restart lsp if necessary
			end,
		})

		-- used to enable autocompletion (assign to every lsp server config)
		local capabilities = cmp_nvim_lsp.default_capabilities()

		-- Change the Diagnostic symbols in the sign column (gutter)
		-- (not in youtube nvim video)
		local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
		for type, icon in pairs(signs) do
			local hl = "DiagnosticSign" .. type
			vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
		end

		mason_lspconfig.setup_handlers({
			-- default handler for installed servers
			function(server_name)
				lspconfig[server_name].setup({
					capabilities = capabilities,
				})
			end,
			["svelte"] = function()
				-- configure svelte server
				lspconfig["svelte"].setup({
					capabilities = capabilities,
					on_attach = function(client, bufnr)
						vim.api.nvim_create_autocmd("BufWritePost", {
							pattern = { "*.js", "*.ts" },
							callback = function(ctx)
								-- Here use ctx.match instead of ctx.file
								client.notify("$/onDidChangeTsOrJsFile", { uri = ctx.match })
							end,
						})
					end,
				})
			end,
			["graphql"] = function()
				-- configure graphql language server
				lspconfig["graphql"].setup({
					capabilities = capabilities,
					filetypes = { "graphql", "gql", "svelte", "typescriptreact", "javascriptreact" },
				})
			end,
			["emmet_ls"] = function()
				-- configure emmet language server
				lspconfig["emmet_ls"].setup({
					capabilities = capabilities,
					filetypes = {
						"html",
						"typescriptreact",
						"javascriptreact",
						"css",
						"sass",
						"scss",
						"less",
						"svelte",
					},
				})
			end,
			["lua_ls"] = function()
				-- configure lua server (with special settings)
				lspconfig["lua_ls"].setup({
					capabilities = capabilities,
					settings = {
						Lua = {
							-- make the language server recognize "vim" global
							diagnostics = {
								globals = { "vim" },
							},
							completion = {
								callSnippet = "Replace",
							},
						},
					},
				})
			end,

			["intelephense"] = function()
				-- configure intelephense (PHP)
				lspconfig["intelephense"].setup({
					capabilities = capabilities,
					settings = {
						intelephense = {
							files = {
								maxSize = 5000000, -- Máximo tamaño de archivo en bytes
							},
						},
					},
				})
			end,

			["pyright"] = function()
				-- configure pyright (Python)
				lspconfig["pyright"].setup({
					capabilities = capabilities,
					settings = {
						python = {
							analysis = {
								typeCheckingMode = "basic", -- O puede ser "strict" para mayor precisión
							},
						},
					},
				})
			end,

			["rust_analyzer"] = function()
				-- configure rust-analyzer (Rust)
				lspconfig["rust_analyzer"].setup({
					capabilities = capabilities,
					settings = {
						["rust_analyzer"] = {
							assist = { -- Asistir con el autocompletado
								importGranularity = "crate",
							},
						},
					},
				})
			end,

			["clangd"] = function()
				-- configure clangd (C, C++)
				lspconfig["clangd"].setup({
					capabilities = capabilities,
					cmd = { "clangd", "--compile-commands-dir=build" }, -- Si tienes un directorio build
					on_attach = function(client, bufnr)
						-- Puedes agregar acciones personalizadas si lo necesitas
					end,
				})
			end,

			["jdtls"] = function()
				-- Obtener ruta de instalación de jdtls desde Mason
				local mason_registry = require("mason-registry")
				local jdtls_pkg = mason_registry.get_package("jdtls")
				local jdtls_path = jdtls_pkg:get_install_path()

				-- Ruta automática a lombok.jar
				local lombok_path = jdtls_path .. "/lombok.jar"

				-- Configurar cmd con argumentos necesarios
				local cmd = {
					"java",
					"-Declipse.application=org.eclipse.jdt.ls.core.id1",
					"-Dosgi.bundles.defaultStartLevel=4",
					"-Declipse.product=org.eclipse.jdt.ls.core.product",
					"-Dlog.protocol=true",
					"-Dlog.level=ALL",
					"-Xmx4G",
					"--add-modules=ALL-SYSTEM",
					"--add-opens",
					"java.base/java.util=ALL-UNNAMED",
					"--add-opens",
					"java.base/java.lang=ALL-UNNAMED",
					"-javaagent:" .. lombok_path, -- ¡Clave para Lombok!
					"-jar",
					vim.fn.glob(jdtls_path .. "/plugins/org.eclipse.equinox.launcher_*.jar"),
					"-configuration",
					jdtls_path .. "/config_linux", -- Ajustar para Win/Mac
					"-data",
					vim.fn.stdpath("data") .. "/jdtls_workspace",
				}

				lspconfig["jdtls"].setup({
					cmd = cmd, -- Sobrescribe el comando por defecto
					capabilities = capabilities,
					settings = {
						java = {
							configuration = {
								annotationProcessing = {
									enabled = true, -- Procesamiento de anotaciones
								},
							},
							completion = {
								favoriteStaticMembers = {
									"org.junit.Assert.*",
									"org.hamcrest.Matcher.*",
								},
							},
						},
					},
				})
			end,

			["omnisharp"] = function()
				-- Configura omnisharp y especifica la ruta del binario
				lspconfig["omnisharp"].setup({
					capabilities = capabilities,
					cmd = { "/usr/bin/omnisharp" }, -- Ruta al binario de omnisharp
					on_attach = function(client, bufnr)
						-- Aquí puedes agregar configuraciones específicas de attach
					end,
					settings = {
						omnisharp = {
							enableRoslynAnalyzers = true,
							organizeImports = true,
							enableEditorConfigSupport = true,
						},
					},
				})
			end,
		})
	end,
}
