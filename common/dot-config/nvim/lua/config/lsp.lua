-- LSP & Autocompletion Configuration using Native Neovim LSP + Mason + blink.cmp

local has_mason, mason = pcall(require, 'mason')
local has_blink, blink = pcall(require, 'blink.cmp')
local has_lspconfig, lspconfig = pcall(require, 'lspconfig')
local has_mason_lspconfig, mason_lspconfig = pcall(require, 'mason-lspconfig')

if not (has_mason and has_blink and has_lspconfig and has_mason_lspconfig) then
  return
end

-- 1. Setup Mason for managing LSP servers and tools
mason.setup({
  ui = {
    icons = {
      package_installed = "✓",
      package_pending = "➜",
      package_uninstalled = "✗",
    },
  },
})

-- 2. Setup blink.cmp for autocompletion
blink.setup({
  keymap = {
    preset = 'super-tab',
  },
  appearance = {
    nerd_font_variant = 'mono',
  },
  sources = {
    default = { 'lsp', 'path', 'snippets', 'buffer' },
  },
  signature = {
    enabled = true,
  },
})

-- 3. Diagnostic display configuration
vim.diagnostic.config({
  virtual_text = true,
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
})

-- 4. LSP Keybindings on LspAttach
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', { clear = true }),
  callback = function(event)
    local opts = { buffer = event.buf, silent = true }

    -- Navigation
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'gy', vim.lsp.buf.type_definition, opts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)

    -- Actions & refactoring
    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
    vim.keymap.set({ 'n', 'x' }, '<leader>f', function()
      vim.lsp.buf.format({ async = true })
    end, opts)
    vim.keymap.set({ 'n', 'x' }, '<leader>a', vim.lsp.buf.code_action, opts)
    vim.keymap.set('n', '<leader>ac', vim.lsp.buf.code_action, opts)
    vim.keymap.set('n', '<leader>qf', vim.lsp.buf.code_action, opts)

    -- Document highlight on cursor hold
    local client = vim.lsp.get_client_by_id(event.data.client_id)
    if client and client.supports_method('textDocument/documentHighlight') then
      local highlight_augroup = vim.api.nvim_create_augroup('lsp_highlight', { clear = false })
      vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
        buffer = event.buf,
        group = highlight_augroup,
        callback = vim.lsp.buf.document_highlight,
      })
      vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
        buffer = event.buf,
        group = highlight_augroup,
        callback = vim.lsp.buf.clear_references,
      })
    end
  end,
})

-- 5. Diagnostic navigation and symbol search mappings
vim.keymap.set('n', '[c', vim.diagnostic.goto_prev, { silent = true })
vim.keymap.set('n', ']c', vim.diagnostic.goto_next, { silent = true })
vim.keymap.set('n', '<space>a', vim.diagnostic.setloclist, { silent = true })
vim.keymap.set('n', '<space>o', vim.lsp.buf.document_symbol, { silent = true })
vim.keymap.set('n', '<space>s', vim.lsp.buf.workspace_symbol, { silent = true })

-- User command :Format
vim.api.nvim_create_user_command('Format', function()
  vim.lsp.buf.format({ async = true })
end, {})

-- 6. Setup mason-lspconfig with handlers
local capabilities = blink.get_lsp_capabilities()

mason_lspconfig.setup({
  ensure_installed = {
    'pyright',
    'jsonls',
    'rust_analyzer',
  },
  handlers = {
    function(server_name)
      lspconfig[server_name].setup({
        capabilities = capabilities,
      })
    end,
    ['jsonls'] = function()
      lspconfig.jsonls.setup({
        capabilities = capabilities,
        filetypes = { 'json', 'jsonc' },
      })
    end,
  },
})
