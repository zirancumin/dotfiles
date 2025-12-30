--[[
-- Some useful tips
:Tutor
:help nvim-from-vim
:help starting
:help config
:help lua-guide
:help user_05.txt
:help base-directory
:help $XDG_CONFIG_HOME
:help startup
:help $MYVIMRC
:help option-list
:help cmdline
:help vim-function-list
:help lua-stdlib
:help map-overview
:help map-commands
--]]

-- configs
vim.o.number = true
vim.o.tabstop = 2
vim.o.shiftwidth = 2
vim.o.expandtab = true
vim.o.autoindent = true
vim.o.smartindent = true
vim.o.mouse = 'a'
vim.o.undofile = true
vim.g.mapleader = ' '

vim.api.nvim_create_autocmd("FileType", {
  pattern = "make",
  callback = function()
    vim.o.tabstop = 4
    vim.o.shiftwidth = 4
    vim.o.expandtab = false
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "sh",
  callback = function()
    vim.o.tabstop = 4
    vim.o.shiftwidth = 4
    vim.o.expandtab = true
  end,
})

vim.api.nvim_create_autocmd("BufReadPost", {
  pattern = "*",
  callback = function()
    if vim.fn.line("'\"") > 1 and vim.fn.line("'\"") <= vim.fn.line("$") then
      vim.cmd('normal! g`"')
    end
  end,
})

-- ============================== Plugins ================================
--[[
Using vim-plugin(https://github.com/junegunn/vim-plug) to manage plugins, run 
  sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
to install vim-plug.
]]--
vim.call('plug#begin')
vim.call('plug#', 'hrsh7th/nvim-cmp')
vim.call('plug#', 'hrsh7th/cmp-nvim-lsp')
vim.call('plug#', 'hrsh7th/cmp-buffer')
vim.call('plug#', 'hrsh7th/cmp-path')
vim.call('plug#', 'onsails/lspkind.nvim')
vim.call('plug#', 'nvim-treesitter/nvim-treesitter')
vim.call('plug#', 'folke/tokyonight.nvim')
vim.call('plug#', 'nvim-tree/nvim-tree.lua')
vim.call('plug#', 'nvim-tree/nvim-web-devicons')
vim.call('plug#end')

-- ============================== LSP ====================================
-- Note: Nvim provides an LSP client, but the servers are provided by third parties.
-- So an LSP server such as clangd should be manually installed.
local function on_attach(client, bufnr)
  local keymap = function(mode, lhs, rhs, desc)
    vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, silent = true, desc = desc })
  end

  keymap('n', 'gd', vim.lsp.buf.definition,      "goto definition")
  keymap('n', 'gD', vim.lsp.buf.declaration,     "goto declaration")
  keymap('n', 'gi', vim.lsp.buf.implementation,  "goto implementation")
  keymap('n', 'gr', vim.lsp.buf.references,      "search references")
  keymap('n', 'K',  vim.lsp.buf.hover,           "hover")
  keymap('n', '<leader>rn', vim.lsp.buf.rename,  "rename symbols")
  keymap('n', '<leader>ca', vim.lsp.buf.code_action, "code action")
end

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "c", "cpp", "objc", "objcpp" },
  group = vim.api.nvim_create_augroup("ClangdLspStart", { clear = true }),
  callback = function(ev)
    local bufnr = ev.buf
    -- TODO: Look at what 'vim.lsp.start' do
    local client_id = vim.lsp.start({
      name = "clangd",
      cmd = { "clangd" },  -- optional parameters
      capabilities = vim.lsp.protocol.make_client_capabilities(),
      on_attach = on_attach,
    })

    -- If lsp client failed to start, warning
    if not client_id then
      vim.notify("Failed to start clangd", vim.log.levels.WARN)
    end
  end,
})

-- ===================== cmp (completion engine) ======================
local cmp_ok, cmp = pcall(require, "cmp")
if cmp_ok then
  cmp.setup({
    sources = cmp.config.sources({
      { name = "nvim_lsp" },
      { name = "buffer" },
      { name = "path" },
    }),
    mapping = cmp.mapping.preset.insert({
      ["<C-Space>"] = cmp.mapping.complete(),
      ["<CR>"]      = cmp.mapping.confirm({ select = true }),
      ["<Tab>"]     = cmp.mapping.select_next_item(),
      ["<S-Tab>"]   = cmp.mapping.select_prev_item(),
      ["<C-e>"]     = cmp.mapping.abort(),
    }),
    formatting = {  -- lspkind (optional)
      format = function(entry, vim_item)
        local lspkind_ok, lspkind = pcall(require, "lspkind")
        if lspkind_ok then
          return lspkind.cmp_format({ mode = "symbol_text", maxwidth = 50 })(entry, vim_item)
        end
        return vim_item
      end,
    },
    window = {
      completion = cmp.config.window.bordered(),
      documentation = cmp.config.window.bordered(),
    },
  })
end

local ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if ok then
  cmp_nvim_lsp.setup({})
end

-- =========================== nvim-treesitter =============================
-- Note: nvim-treesitter needs tree-sitter cli to be installed. Then run :TSInstall <language>
local ok, ts_configs = pcall(require, "nvim-treesitter.configs")
if ok then
  ts_configs.setup({
    ensure_installed = { "c", "cpp", "make", "lua", "bash" },

    highlight = {
      enable = true,
      disable = {},
    },
  })
end

-- ==================== Color Theme ====================
vim.cmd([[colorscheme tokyonight]])

-- ========================= Side Bar ==============================
local ok, nvim_tree = pcall(require, "nvim-tree")
if ok then
  nvim_tree.setup({
    view = {
      side = "left",
      width = 30,
    },
    renderer = {
      highlight_git = true,
      icons = {
        show = { git = true },
      },
    },
  })
end

vim.keymap.set('n', '<leader>e', ':NvimTreeToggle<CR>', { desc = "Toggle side bar" })
