return {
	filetypes = { "razor", "cshtml", "cs" },
	settings = {
		["csharp|background_analysis"] = {
			dotnet_analyzer_diagnostics_scope = "fullSolution",
			dotnet_compiler_diagnostics_scope = "fullSolution",
		},
	},
}
