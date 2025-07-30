return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"williamboman/mason-lspconfig.nvim",
		"hrsh7th/cmp-nvim-lsp", -- Necesario para las capacidades mejoradas
		{
			"folke/lazydev.nvim",
			ft = "lua",
			opts = {
				library = {
					{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
				},
			},
		},
	},
	config = function()
		local lspconfig = require("lspconfig")
		local mason_lspconfig = require("mason-lspconfig")
		local cmp_nvim_lsp = require("cmp_nvim_lsp")
		local k = vim.keymap

		-- 1. Capacidades base de Neovim
		local base_capabilities = vim.lsp.protocol.make_client_capabilities()

		-- 2. Mejorar con capacidades de nvim-cmp
		local capabilities = cmp_nvim_lsp.default_capabilities(base_capabilities)

		-- 3. Personalización adicional (opcional)
		capabilities.textDocument.completion.completionItem.snippetSupport = true

		-- Configuración de signos de diagnóstico
		vim.diagnostic.config({
			signs = {
				text = {
					[vim.diagnostic.severity.ERROR] = "",
					[vim.diagnostic.severity.WARN] = "",
					[vim.diagnostic.severity.HINT] = "󰠠",
					[vim.diagnostic.severity.INFO] = "",
				},
			},
		})


		k.set("n", "<leader>gd", "<cmd>lua vim.lsp.buf.definition()<CR>", { desc = "Ir a la definicion" })
		k.set("n", "<leader>gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", { desc = "Ir a las declaraciones" })
		k.set("n", "<leader>gr", "<cmd>lua vim.lsp.buf.references()<CR>", { desc = "Ir a las referencias" })

		local on_attach = function(client)
			print("[LSP] Attached to", client.name)
		end

		mason_lspconfig.setup({
			ensure_installed = {
				"ts_ls",
				"html",
				"cssls",
				"tailwindcss",
				"lua_ls",
				"prismals",
				"rust_analyzer",
				"clangd",
				"intelephense",
				"phpactor",
				"kotlin_language_server",
        "emmet_ls",
			},
			automatic_installation = true,
			handlers = {
				function(server_name)
					lspconfig[server_name].setup({
						capabilities = capabilities,
						on_attach = on_attach,
					})
				end,

				["lua_ls"] = function()
					lspconfig.lua_ls.setup({
						capabilities = capabilities,
						on_attach = on_attach,
						settings = {
							Lua = {
								runtime = { version = "LuaJIT" },
								diagnostics = { globals = { "vim" } },
								workspace = {
									library = vim.api.nvim_get_runtime_file("", true),
									checkThirdParty = false,
								},
								telemetry = { enable = false },
							},
						},
					})
				end,

				-- Configuración específica para PHP
				["intelephense"] = function()
					lspconfig.intelephense.setup({
						capabilities = capabilities,
						init_options = {
							licenceKey = os.getenv("INTELEPHENSE_LICENCE"), -- Opcional
							globalStoragePath = os.getenv("HOME") .. "/.intelephense",
						},
						settings = {
							intelephense = {
								files = {
									maxSize = 5000000, -- 5MB
								},
								diagnostics = {
									enable = true,
									undefinedTypes = true,
									undefinedFunctions = true,
									undefinedConstants = true,
									undefinedClassConstants = true,
									undefinedMethods = true,
									undefinedProperties = true,
									undefinedVariables = true,
								},
								environment = {
									includePaths = {
										-- Añade rutas de inclusión si es necesario
									},
								},
								format = {
									enable = false, -- Desactiva formateo (usaremos otros)
								},
							},
						},
						on_attach = function(client, bufnr)
							on_attach(client, bufnr)
							-- Análisis estricto para archivos individuales
							vim.api.nvim_create_autocmd("BufWritePost", {
								buffer = bufnr,
								callback = function()
									vim.lsp.buf.format({ async = true })
									vim.lsp.codelens.refresh()
								end,
							})
						end,
					})
				end,

				-- PHP CodeSniffer para análisis de calidad de código
				["phpcs"] = function()
					lspconfig.phpcs.setup({
						capabilities = capabilities,
						settings = {
							phpcs = {
								standard = "PSR12", -- Estándar estricto
								severity = 1, -- Muestra todos los errores
								lintOnSave = true, -- Ejecutar al guardar
								lintOnFileOpen = true, -- Ejecutar al abrir archivo
							},
						},
						on_attach = function(client, bufnr)
							on_attach(client, bufnr)
							-- Configurar para que muestre todos los errores posibles
							vim.api.nvim_buf_set_option(bufnr, "phpcs_standard", "PSR12")
							vim.api.nvim_buf_set_option(bufnr, "phpcs_severity", 1)
						end,
					})
				end,

				["kotlin_language_server"] = function()
					lspconfig.kotlin_language_server.setup({
						capabilities = capabilities,
						on_attach = on_attach,
						cmd = { "kotlin-language-server" },
						filetypes = { "kotlin", "kts" },
						root_dir = require("lspconfig.util").root_pattern(
							"settings.gradle",
							"settings.gradle.kts",
							"build.gradle",
							"build.gradle.kts",
							".git"
						),
						init_options = {
							compilerOptions = {
								jvm = { target = "11" },
							},
						},
					})
				end,

      ["emmet_ls"] = function()
        -- configure emmet language server
        lspconfig["emmet_ls"].setup({
          capabilities = capabilities,
          filetypes = { "html", "typescriptreact", "javascriptreact", "css", "sass", "scss", "less", "svelte" },
        })
      end,

			},
		})
	end,
}
