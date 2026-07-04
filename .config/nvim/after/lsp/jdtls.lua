local lombok_jar = require("mason-registry").get_package("jdtls"):get_install_path() .. "/lombok.jar"

return {
	cmd = {
		"jdtls",
		"--jvm-arg=-javaagent:" .. lombok_jar,
	},
}
