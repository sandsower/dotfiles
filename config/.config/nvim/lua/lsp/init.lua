-- Source: https://jose-elias-alvarez.medium.com/configuring-neovims-lsp-client-for-typescript-development-5789d58ea9c
-- inspo: https://github.com/GudjonGeir/dotfiles/blob/master/nvim/lua/lsp.lua
local buf_map = function(bufnr, mode, lhs, rhs, opts)
    vim.api.nvim_buf_set_keymap(bufnr, mode, lhs, rhs, opts or {
        silent = true,
    })
end

-- local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())

local on_attach = function(client, bufnr)
    require "lsp_signature".on_attach()

    vim.cmd("command! LspDef lua vim.lsp.buf.definition()")
    vim.cmd("command! LspFormatting lua vim.lsp.buf.formatting()")
    vim.cmd("command! LspCodeAction lua vim.lsp.buf.code_action()")
    vim.cmd("command! LspHover lua vim.lsp.buf.hover()")
    vim.cmd("command! LspRename lua vim.lsp.buf.rename()")
    vim.cmd("command! LspOrganize lua lsp_organize_imports()")
    vim.cmd("command! LspRefs lua vim.lsp.buf.references()")
    vim.cmd("command! LspTypeDef lua vim.lsp.buf.type_definition()")
    vim.cmd("command! LspImplementation lua vim.lsp.buf.implementation()")
    vim.cmd("command! LspDiagPrev lua vim.diagnostic.goto_prev()")
    vim.cmd("command! LspDiagNext lua vim.diagnostic.goto_next()")
    vim.cmd("command! LspDiagLine lua vim.diagnostic.open_float()")
    vim.cmd("command! LspSignatureHelp lua vim.lsp.buf.signature_help()")
    vim.cmd("command! RefPrintVar lua require('refactoring.debug.printvar({})<CR>'");
    vim.cmd("command! RefPrintFunc lua require('refactoring.debug.printf({below = true})<CR>'");
    vim.cmd("command! RefCleanup lua require('refactoring.debug.cleanup({})<CR>'");
    buf_map(bufnr, "n", "K", ":LspHover<CR>")
    buf_map(bufnr, "n", "[a", ":LspDiagPrev<CR>")
    buf_map(bufnr, "n", "]a", ":LspDiagNext<CR>")
    buf_map(bufnr, "n", "ga", ":LspCodeAction<CR>")
    buf_map(bufnr, "n", "<Leader>a", ":LspDiagLine<CR>")
    buf_map(bufnr, "i", "<C-x><C-x>", "<cmd> LspSignatureHelp<CR>")
        -- goto bindings
    buf_map(bufnr, "n", "<localleader>gg", ":LspDef<CR>", {silent = true})
    buf_map(bufnr, "n", "<localleader>gr", ":LspRefs<CR>", {silent = true})
    -- help and info bindings
    buf_map(bufnr, "n", "<localleader>hd", ":LspTypeDef<CR>", {silent = true})
    buf_map(bufnr, "n", "<localleader>hh", ":LspHover<CR>", {silent = true})

    buf_map(bufnr, "n", "<localleader>dp", ":LspDiagPrev<CR>", {silent = true})
    buf_map(bufnr, "n", "<localleader>n", ":LspDiagNext<CR>", {silent = true})
    buf_map(bufnr, "n", "<localleader>dl", ":LspDiagLine<CR>", {silent = true})

    buf_map(bufnr, "n", "<localleader>a", ":LspCodeAction<CR>", {silent = true})

    buf_map(bufnr, "n", "<localleader>=", ":LspFormatting<CR>", {silent = true})

    -- refactor bindings
    buf_map(bufnr, "n", "<localleader>rr", ":LspRename<CR>", {silent = true})
    buf_map(bufnr, "n", "<localleader>rf", ":TSLspRenameFile<CR>")
    buf_map(bufnr, "n", "<localleader>ri", ":TSLspImportAll<CR>")
    buf_map(bufnr, "n", "<localleader>ro", ":LspOrganize<CR>", {silent = true})

    vim.api.nvim_set_keymap(
      "n",
      "<leader>rp",
      ":lua require('refactoring').debug.printf({below = false})<CR>",
      { noremap = true }
    )
    vim.api.nvim_set_keymap("v", "<leader>rv", ":lua require('refactoring').debug.print_var({})<CR>", { noremap = true })
    vim.api.nvim_set_keymap("v", "<leader>re", [[ <Esc><Cmd>lua require('refactoring').refactor('Extract Function')<CR>]], {noremap = true, silent = true, expr = false})
    vim.api.nvim_set_keymap("n", "<leader>rc", ":lua require('refactoring').debug.cleanup({})<CR>", { noremap = true })


    -- buf_map(bufnr, "n", "<Leader>rp", ":RefPrintFunc<CR>", {noremap = true})
    -- buf_map(bufnr, "v", "<Leader>rv", ":RefPrintVar<CR>", {noremap = true})
    -- buf_map(bufnr, "n", "<Leader>rc", ":RefPrintCleanup<CR>", {noremap = true})
    if client.resolved_capabilities.document_formatting then
        vim.cmd("autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync()")
    end
end

for _, server in ipairs({
  "gopls",
  "null-ls",
  "tsserver",
}) do
  require("lsp." .. server).setup(on_attach, capabilities)
end


