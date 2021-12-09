-- https://github.com/scalameta/nvim-metals/discussions/39
local present, metals = pcall(require, "metals")

if not present then
   return
end

metals_config = metals.bare_config()

-- Example of settings
metals_config.settings = {
  showImplicitArguments = true,
  showInferredType = true,
  excludedPackages = { "akka.actor.typed.javadsl", "com.github.swagger.akka.javadsl" },
  serverVersion = "SNAPSHOT",
}

-- Example of how to ovewrite a handler
metals_config.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
  virtual_text = { prefix = "" },
})

metals_config.init_options.statusBarProvider = "on"

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

metals_config.capabilities = capabilities

-- https://github.com/scalameta/nvim-metals/discussions/39
-- LSP
vim.cmd([[augroup lsp]])
vim.cmd([[autocmd!]])
vim.cmd([[autocmd FileType scala setlocal omnifunc=v:lua.vim.lsp.omnifunc]])
vim.cmd([[autocmd FileType scala,sbt lua require("metals").initialize_or_attach(metals_config)]])
-- otherwise this doesn't work
-- https://github.com/ray-x/lsp_signature.nvim/issues/1
-- https://vi.stackexchange.com/questions/31820/bufreadpre-and-reading-viminfo-file#comment58592_31820
vim.cmd([[autocmd BufReadPre,FileReadPre *.scala lua require("lsp_signature").on_attach()]])
vim.cmd([[augroup end]])

-- Need for symbol highlights to work correctly
vim.cmd([[hi! link LspReferenceText CursorColumn]])
vim.cmd([[hi! link LspReferenceRead CursorColumn]])
vim.cmd([[hi! link LspReferenceWrite CursorColumn]])

-- Should link to something to see your code lenses
vim.cmd([[hi! link LspCodeLens CursorColumn]])
-- Should link to something so workspace/symbols are highlighted
vim.cmd([[hi! link LspReferenceText CursorColumn]])
vim.cmd([[hi! link LspReferenceRead CursorColumn]])
vim.cmd([[hi! link LspReferenceWrite CursorColumn]])

-- If you want a :Format command this is useful
vim.cmd([[command! Format lua vim.lsp.buf.formatting()]])

