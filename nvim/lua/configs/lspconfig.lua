-- load defaults i.e lua_lsp
require("nvchad.configs.lspconfig").defaults()

local lspconfig = require "lspconfig"

-- EXAMPLE
local servers = {
    "cssls",
    "gopls",
    "html",
    "jdtls",
    "sqlls",
    "ts_ls",
}
local nvlsp = require "nvchad.configs.lspconfig"

-- lsps with default config
for _, lsp in ipairs(servers) do
    lspconfig[lsp].setup {
        on_attach = nvlsp.on_attach,
        on_init = nvlsp.on_init,
        capabilities = nvlsp.capabilities,
    }
end

-- configuring single server, example: typescript
lspconfig.ts_ls.setup {
    on_attach = nvlsp.on_attach,
    on_init = nvlsp.on_init,
    capabilities = nvlsp.capabilities,
}

lspconfig.gopls.setup({
    settings = {
        gopls = {
            analyses = {
                unusedparam = true,
                shadow = true,
            },
            staticcheck = true,
            completeUnimported = true,
            usePlaceholders = true,
            experimentalPostfixCompletions = true,
            gofumpt = true,
            codelenses = {
                tidy = true,
                vendor = true,
                upgrade_dependency = true,
            },
        },
    },
})

lspconfig.jdtls.setup({
    on_attach = nvlsp.on_attach,
    capabilities = nvlsp.capabilities, -- Fixed typo in 'capabilities'
    settings = {
        java = {
            -- Enable annotation processing
            settings = {
                java = {
                    compile = {
                        nullAnalysis = { mode = "automatic" },
                    },
                    configuration = {
                        updateBuildConfiguration = "automatic",
                        -- Enable Lombok support
                        runtimes = {
                            {
                                name = "JavaSE-23",
                                path = "/usr/local/Cellar/openjdk/23",
                                default = true
                            },
                        },
                    },
                    maven = {
                        downloadSources = true,
                    },
                    implementationsCodeLens = {
                        enabled = true,
                    },
                    referencesCodeLens = {
                        enabled = true,
                    },
                    -- Lombok specific settings
                    sources = {
                        organizeImports = {
                            starThreshold = 9999,
                            staticStarThreshold = 9999,
                        },
                    },
                    -- Enable annotation processing (important for Lombok)
                    compiler = {
                        annotationProcessing = {
                            enabled = true,
                        },
                    },
                    -- Enable more detailed completion
                    completion = {
                        favoriteStaticMembers = {
                            "org.junit.Assert.*",
                            "org.junit.Assume.*",
                            "org.junit.jupiter.api.Assertions.*",
                            "org.junit.jupiter.api.Assumptions.*",
                            "org.junit.jupiter.api.DynamicContainer.*",
                            "org.junit.jupiter.api.DynamicTest.*",
                            "org.mockito.Mockito.*",
                            "org.mockito.ArgumentMatchers.*",
                            "org.mockito.Answers.*"
                        },
                        importOrder = {
                            "java",
                            "javax",
                            "com",
                            "org"
                        },
                    },
                    -- Better decompiler for viewing dependencies
                    contentProvider = {
                        preferred = 'fernflower'
                    },
                },
            },
        },
    },
})
