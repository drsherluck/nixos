local lspconfig = require('lspconfig')
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

local on_attach = function(_, bufnr)
    local bufmap = function(keys, func)
        vim.keymap.set('n', keys, func, { buffer = bufnr })
    end
    bufmap('<leader>r', vim.lsp.buf.rename)
    bufmap('gd', vim.lsp.buf.definition)
    bufmap('gD', vim.lsp.buf.declaration)
    bufmap('gi', vim.lsp.buf.implementation)
    bufmap('<leader>D', vim.lsp.buf.type_definition)
    bufmap('K', vim.lsp.buf.hover)

    vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
        vim.lsp.buf.format()
    end, {})
end


lspconfig.lua_ls.setup {
    on_attach = on_attach,
    capabilities = capabilities,
    settings = {
        Lua = {
            runtime = {
                version = 'LuaJIT'
            },
            diagnostics = {
                globals = { 'vim' }
            },
            workspace = {
                library = { vim.env.VIMRUNTIME }
            },
            telemetry = {
                enable = false
            }
        }
    }
}

lspconfig.pylsp.setup {
    on_attach = on_attach,
    capabilities = capabilities,
    plugins = {
        ruff = {
            enabled = true
        },
        pycodestyle = {
            enabled = true
        },
    }
}

lspconfig.rust_analyzer.setup {
    on_attach = on_attach,
    capabilities = capabilities,
}

lspconfig.clangd.setup {
    on_attach = on_attach,
    capabilities = capabilities,
}

lspconfig.terraformls.setup {
    on_attach = on_attach,
    capabilities = capabilities,
}

lspconfig.nil_ls.setup {
    on_attach = on_attach,
    capabilities = capabilities,
}

lspconfig.gopls.setup {
    on_attach = on_attach,
    capabilities = capabilities,
}

lspconfig.zls.setup {
    on_attach = on_attach,
    capabilities = capabilities,
}

lspconfig.typst_lsp.setup {
    on_attach = on_attach,
    capabilities = capabilities,
    settings = {
        exportPdf = "never",
    },
}
