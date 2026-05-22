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
    bufmap('gr', require('telescope.builtin').lsp_references)

    vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
        vim.lsp.buf.format()
    end, {})
end

local lspconfig = function(name, config)
    vim.lsp.config(name, config)
    vim.lsp.enable(name)
end


lspconfig('lua_ls', {
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
})

lspconfig('pylsp', {
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
})

lspconfig('rust_analyzer', {
    on_attach = on_attach,
    capabilities = capabilities,
})

lspconfig('clangd', {
    on_attach = on_attach,
    capabilities = capabilities,
})

lspconfig('terraformls', {
    on_attach = on_attach,
    capabilities = capabilities,
})

lspconfig('nil_ls', {
    on_attach = on_attach,
    capabilities = capabilities,
})

lspconfig('gopls', {
    on_attach = on_attach,
    capabilities = capabilities,
})

lspconfig('zls', {
    on_attach = on_attach,
    capabilities = capabilities,
})

lspconfig('tinymist', {
    on_attach = on_attach,
    capabilities = capabilities,
    settings = {
        exportPdf = "never",
    },
})
