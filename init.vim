:set number
:set relativenumber
:set smartindent
:set tabstop=4
:set shiftwidth=4
:set smarttab
:set softtabstop=4
:set mouse=a
:set splitbelow
:set splitright
:set termguicolors
:set background=dark
:let mapleader=","
:set autoread

inoremap " ""<left>
inoremap ' ''<left>
inoremap ( ()<left>
inoremap [ []<left>
inoremap { {}<left>
inoremap {<CR> {<CR>}<ESC>O
inoremap {;<CR> {<CR>};<ESC>O

call plug#begin()
Plug 'vim-airline/vim-airline'
Plug 'http://github.com/tpope/vim-surround'
Plug 'https://github.com/ryanoasis/vim-devicons'
Plug 'https://github.com/tc50cal/vim-terminal'
Plug 'https://github.com/terryma/vim-multiple-cursors'
Plug 'mattn/emmet-vim'
Plug 'catppuccin/nvim', { 'as': 'catppuccin' }
Plug 'windwp/nvim-autopairs'
Plug 'junegunn/fzf.vim'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'https://github.com/digitaltoad/vim-pug.git'
Plug 'voldikss/vim-floaterm'
Plug 'kdheepak/lazygit.nvim'
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
Plug 'github/copilot.vim'
Plug 'williamboman/mason.nvim'
Plug 'williamboman/mason-lspconfig.nvim'
Plug 'neovim/nvim-lspconfig'

Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-vsnip'
Plug 'hrsh7th/vim-vsnip'
Plug 'nvim-tree/nvim-web-devicons'
Plug 'nvim-tree/nvim-tree.lua'

Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
call plug#end()

colorscheme catppuccin

nnoremap <silent> <Leader>T :NvimTreeToggle<CR>
nnoremap <silent> <Leader>F :NvimTreeFindFile<CR>
nnoremap <silent> <C-p> :GFiles<CR>
nnoremap <silent> <Leader>/ :BLines<CR>
nnoremap <silent> <Leader>L :LazyGit<CR>
nnoremap <C-.> :tabnext<CR>
nnoremap <C-,> :tabprevious<CR>

let g:user_emmet_mode='a'
let g:user_emmet_leader_key='<C-Z>,'
let g:python3_host_prog = '/opt/homebrew/bin/python3'
let g:python_host_prog = '/Users/suryaherdiyanto/.pyenv/shims/python'

function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction


" Configuration example
let g:floaterm_keymap_new    = '<F7>'
let g:floaterm_keymap_prev   = '<F8>'
let g:floaterm_keymap_next   = '<F9>'
let g:floaterm_keymap_toggle = '<F12>'

lua <<EOF
vim.diagnostic.config({ virtual_text = true })
-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

require("mason").setup()
require("mason-lspconfig").setup({
	ensure_installed = { "gopls", "templ", "pyright", "eslint", "html", "cssls", "intelephense", "vuels", "stimulus_ls" },
})

local lspconfig = require("lspconfig")
local capabilities = require('cmp_nvim_lsp').default_capabilities()

lspconfig.gopls.setup {
	capabilities = capabilities,
	settings = {
		gopls = {
			usePlaceholders = true,
		}
	}
}
lspconfig.pyright.setup {}
lspconfig.eslint.setup { capabilities = capabilities }
lspconfig.html.setup { capabilities = capabilities }
lspconfig.cssls.setup {}
lspconfig.intelephense.setup { capabilities = capabilities }
lspconfig.vuels.setup { capabilities = capabilities }
lspconfig.stimulus_ls.setup { capabilities = capabilities }
lspconfig.templ.setup {}

-- Set up nvim-cmp.
  local cmp = require'cmp'

  cmp.setup({
    snippet = {
      -- REQUIRED - you must specify a snippet engine
      expand = function(args)
        vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
      end,
    },
    window = {
      -- completion = cmp.config.window.bordered(),
      -- documentation = cmp.config.window.bordered(),
    },
    mapping = cmp.mapping.preset.insert({
      ['<C-b>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-Space>'] = cmp.mapping.complete(),
      ['<C-e>'] = cmp.mapping.abort(),
      ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    }),
    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
      { name = 'vsnip' }, -- For vsnip users.
      -- { name = 'luasnip' }, -- For luasnip users.
      -- { name = 'ultisnips' }, -- For ultisnips users.
      -- { name = 'snippy' }, -- For snippy users.
    }, {
      { name = 'buffer' },
    })
  })


  -- Treesitter setup
  require'nvim-treesitter.configs'.setup {
	  -- A list of parser names, or "all" (the listed parsers MUST always be installed)
	  ensure_installed = { "c", "lua", "php", "html", "css", "vue", "templ", "javascript", "vim", "vimdoc", "query", "markdown", "markdown_inline" },

	  -- Install parsers synchronously (only applied to `ensure_installed`)
	  sync_install = false,

	  auto_install = true,

	  highlight = {
		enable = true,

		disable = { "c", "rust" },
		-- Or use a function for more flexibility, e.g. to disable slow treesitter highlight for large files
		disable = function(lang, buf)
			local max_filesize = 100 * 1024 -- 100 KB
			local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
			if ok and stats and stats.size > max_filesize then
				return true
			end
		end,

		additional_vim_regex_highlighting = false,
	  },
	  indent = { enable = true }
	}
  local parser_config = require "nvim-treesitter.parsers".get_parser_configs()
	parser_config.blade = {
	  install_info = {
		url = "https://github.com/EmranMR/tree-sitter-blade",
		files = {"src/parser.c"},
		branch = "main",
	  },
	  filetype = "blade"
	}

	-- Vimtree
	require("nvim-tree").setup({
	  sort_by = "case_sensitive",
	  view = {
		width = 30,
	  },
	  renderer = {
		group_empty = true,
	  },
	  filters = {
		dotfiles = false,
		custom = { ".git", "node_modules", ".cache", "vendor" },
	  },
	})
EOF
" Set the *.blade.php file to be filetype of blade 
augroup BladeFiltypeRelated
  au BufNewFile,BufRead *.blade.php set ft=blade
augroup END
