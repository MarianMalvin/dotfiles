vim.cmd([[
let mapleader=" "
set termguicolors
set autoindent
set backspace=indent,eol,start
set expandtab
set hidden
set history=1000
set hlsearch
set ignorecase
set incsearch
set laststatus=2
set matchpairs
set fileformat=unix
set nobackup
set noswapfile
set nowrap
set number
set numberwidth=4
set signcolumn=yes:1
set relativenumber
set ruler
set scrolloff=10
set shiftwidth=4
set shiftwidth=4
set showmatch
set updatetime=100
set showmode
set smartcase
set softtabstop=4
set tabstop=4
syntax on

vnoremap < <gv
vnoremap > >gv

imap jj <esc>

filetype plugin on
call plug#begin()
  Plug 'vim-airline/vim-airline-themes'
  Plug 'jiangmiao/auto-pairs'
  Plug 'preservim/nerdcommenter'
  Plug 'kaicataldo/material.vim', { 'branch': 'main' }
  Plug 'tpope/vim-surround'
  Plug 'tpope/vim-fugitive'
  Plug 'AndrewRadev/splitjoin.vim'
  Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
  Plug 'ryanoasis/vim-devicons'
  Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
  Plug 'BurntSushi/ripgrep'
  Plug 'nvim-lua/plenary.nvim'
  Plug 'nvim-telescope/telescope.nvim'
  Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }
  Plug 'lewis6991/gitsigns.nvim'
call plug#end()

colorscheme material
let g:airline_theme = 'material'
let g:material_terminal_italics = 1
let g:WebDevIconsUnicodeDecorateFolderNodes = v:true


vnoremap K :m '<-2<CR>gv=gv
vnoremap J :m '>+1<CR>gv=gv

nnoremap zj mzyyP`z
nnoremap zk mzyyP`zk

nnoremap <leader>h <C-w>h
nnoremap <leader>j <C-w>j
nnoremap <leader>k <C-w>k
nnoremap <leader>l <C-w>l

nmap <leader>q :bd<CR>
noremap <Leader>s :update<CR>

" Enable to copy to clipboard for operations like yank, delete, change and put
if has('unnamedplus')
  set clipboard^=unnamed
  set clipboard^=unnamedplus
endif

" This enables us to undo files even if you exit Vim.
if has('persistent_undo')
  set undofile
  set undodir=~/.config/vim/tmp/undo//
endif

" vim-go
let g:go_fmt_command = "goimports"
let g:go_autodetect_gopath = 1
let g:go_list_type = "quickfix"

let g:go_highlight_types = 1
let g:go_highlight_fields = 1
let g:go_highlight_functions = 1
let g:go_highlight_function_calls = 1
let g:go_highlight_extra_types = 1
let g:go_highlight_generate_tags = 1

" Open :GoDeclsDir with ctrl-g
nmap <C-g> :GoDeclsDir<cr>
imap <C-g> <esc>:<C-u>GoDeclsDir<cr>


augroup go
  autocmd!

  " Show by default 4 spaces for a tab
  autocmd BufNewFile,BufRead *.go setlocal noexpandtab tabstop=4 shiftwidth=4

  " :GoTest
  autocmd FileType go nmap <leader>t  <Plug>(go-test)

  " :GoRun
  autocmd FileType go nmap <leader>r  <Plug>(go-run)

  " :GoDoc
  autocmd FileType go nmap <Leader>d <Plug>(go-doc)

  " :GoCoverageToggle
  autocmd FileType go nmap <Leader>c <Plug>(go-coverage-toggle)

  " :GoInfo
  autocmd FileType go nmap <Leader>i <Plug>(go-info)

  " :GoAlternate  commands :A, :AV, :AS and :AT
  autocmd Filetype go command! -bang A call go#alternate#Switch(<bang>0, 'edit')
  autocmd Filetype go command! -bang AV call go#alternate#Switch(<bang>0, 'vsplit')
  autocmd Filetype go command! -bang AS call go#alternate#Switch(<bang>0, 'split')
  autocmd Filetype go command! -bang AT call go#alternate#Switch(<bang>0, 'tabe')
augroup END

nmap gp <Plug>(GitGutterPreviewHunk)
nmap gu <Plug>(GitGutterUndoHunk)
nmap gs <Plug>(GitGutterStageHunk)
nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
]])

vim.opt.encoding="UTF-8"

require('packer').startup(function()

  use {
      'wbthomason/packer.nvim',
      'vim-airline/vim-airline',
      'williamboman/nvim-lsp-installer',
      'neovim/nvim-lspconfig',
      'hrsh7th/nvim-cmp',
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-vsnip',
      'hrsh7th/vim-vsnip',
  }

  use {
  'nvim-tree/nvim-tree.lua',
  requires = {
    'nvim-tree/nvim-web-devicons',
  },
}

end)

require'nvim-treesitter.configs'.setup{
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
}

require'telescope'.setup({
  defaults = {
    sorting_strategy = 'ascending',
    layout_strategy = 'horizontal',
    layout_config = {
      width = 0.99,
      height = 0.99, 
      prompt_position = 'top',
      scroll_speed = 3,
      preview_width = 0.7
      -- other layout configuration here
    },
    -- other defaults configuration here
  },
  -- other configuration values here
})
require('telescope').load_extension('fzf')
require('gitsigns').setup{
  on_attach = function(bufnr)
    local gs = package.loaded.gitsigns
    vim.keymap.set({'n', 'v'}, '<leader>gr', ':Gitsigns reset_hunk<CR>')
    vim.keymap.set('n', '<leader>gp', gs.preview_hunk)
    vim.keymap.set('n', '<leader>gd', gs.diffthis)

  end
}

 -- Setup nvim-cmp.
local cmp = require'cmp'

cmp.setup({
  snippet = {
    -- REQUIRED - you must specify a snippet engine
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
    end,
  },
  window = {
   completion = cmp.config.window.bordered(),
   documentation = cmp.config.window.bordered(),
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<Tab>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'vsnip' }, -- For vsnip users.
  }, {
    { name = 'buffer' },
  })
})



-- LSP config
require("nvim-lsp-installer").setup {}

-- Mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
local opts = { noremap=true, silent=true }
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  local bufopts = { noremap=true, silent=true, buffer=bufnr }
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
  vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
  vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts)
  vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
  vim.keymap.set('n', '<space>f', vim.lsp.buf.formatting, bufopts)
end

local lsp_flags = {
  -- This is the default in Nvim 0.7+
  debounce_text_changes = 150,
}
local capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())
--local handlers = {
--       ["textDocument/publishDiagnostics"] = vim.lsp.with(
--         vim.lsp.diagnostic.on_publish_diagnostics, {
--          -- Disable virtual_text
--          virtual_text = false
--         }
--      )
--  }
local config = {
      virtual_text = false,
      float = {
          focusable = false,
          style = 'minimal',
          border = 'rounded',
          sources = 'always',
          header = '',
          prefix = '',
      }
  }

vim.diagnostic.config(config)
require('lspconfig')['gopls'].setup{
    on_attach = on_attach,
    flags = lsp_flags,
    capabilities = capabilities,
    --handlers = handlers,
}
require('lspconfig')['pyright'].setup{
    on_attach = on_attach,
    flags = lsp_flags,
    capabilities = capabilities,
    --handlers = handlers,
}
require('lspconfig')['sumneko_lua'].setup{
    on_attach = on_attach,
    flags = lsp_flags,
    capabilities = capabilities,
    --handlers = handlers,
}
-- NVIM TREE CONFIG --

-- disable netrw at the very start of your init.lua (strongly advised)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- set termguicolors to enable highlight groups
vim.opt.termguicolors = true

require("nvim-tree").setup({
  sort_by = "case_sensitive",
  view = {
    adaptive_size = true,
  },
  renderer = {
    group_empty = true,
  },
  filters = {
    dotfiles = false,
  },
})
vim.api.nvim_set_keymap('n', '<leader>n', ':NvimTreeFocus<CR>', {noremap = true, silent = true})

