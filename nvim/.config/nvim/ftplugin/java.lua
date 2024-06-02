local config = {
    cmd = {
        "/usr/bin/jdtls",
        '--add-opens', 'java.base/java.lang=ALL-UNNAMED',
    },

    root_dir = vim.fs.dirname(vim.fs.find({ "gradlew", ".git", "mvnw" }, { upward = true })[1]),
}

require("jdtls").start_or_attach(config)

