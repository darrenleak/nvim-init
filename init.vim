"Plugins
call plug#begin()

Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/nvim-cmp'

Plug 'morhetz/gruvbox'
Plug 'sainnhe/edge'
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-telescope/telescope-fzy-native.nvim'
Plug 'kyazdani42/nvim-web-devicons'
Plug 'https://github.com/vim-airline/vim-airline'
Plug 'nvim-treesitter/nvim-treesitter', { 'do': ':TSUpdate' }
Plug 'nvim-treesitter/playground'
Plug 'APZelos/blamer.nvim'
Plug 'dominikduda/vim_current_word'
Plug 'arzg/vim-colors-xcode'
Plug 'simrat39/rust-tools.nvim'
Plug 'folke/trouble.nvim'  

call plug#end()

"Color schemes
colorscheme xcodelight
set termguicolors
syntax on
" set background=light

"Set
set tabstop=2
set softtabstop=2
set shiftwidth=2
set expandtab
set autoindent
set copyindent
set termguicolors
set noswapfile
set nu
set rnu
set nohlsearch
set hidden
set noerrorbells
"set nowrap
set incsearch
set scrolloff=10
set colorcolumn=80
set signcolumn=yes
set completeopt=menu,menuone,noselect
set mouse=a
set hidden

let g:blamer_enabled = 1
let g:blamer_delay = 0

"Commands
let mapleader = " "
nnoremap <leader>vd :lua vim.lsp.buf.definition()<CR>
nnoremap <leader>vi :lua vim.lsp.buf.implementation()<CR>
nnoremap <leader>vsh :lua vim.lsp.buf.signature_help()<CR>
nnoremap <leader>vrr :lua vim.lsp.buf.references()<CR>
nnoremap <leader>vrn :lua vim.lsp.buf.rename()<CR>
nnoremap <leader>vh :lua vim.lsp.buf.hover()<CR>
nnoremap <leader>vca :lua vim.lsp.buf.code_action()<CR>
nnoremap <leader>vn :lua vim.lsp.buf.goto_next()<CR>
nnoremap <leader>vp :lua vim.lsp.buf.goto_previous()<CR>

" Telescope commands
nnoremap <leader>pf :lua require('telescope.builtin').find_files()<cr>
nnoremap <leader>ps :lua require('telescope.builtin').grep_string({ search = vim.fn.input("Grep for > ")})<CR>
nnoremap <leader>ph :lua require('telescope.builtin').help_tags()<cr>
nnoremap <leader>pd :lua require('telescope.builtin').lsp_definitions()<cr>
nnoremap <leader>pi :lua require('telescope.builtin').lsp_implementations()<cr>
nnoremap <leader>pgb :lua require('telescope.builtin').git_branches()<cr>
nnoremap <leader>plg :lua require('telescope.builtin').live_grep()<cr>
nnoremap <leader>pbr :lua require('telescope.builtin').file_browser()<cr>
nnoremap <leader>pbb :lua require('telescope.builtin').buffers()<cr>

nnoremap <leader>tdd :Trouble lsp_document_diagnostics<cr>
nnoremap <leader>tar :Trouble lsp_references<cr>
nnoremap <leader>tqf :Trouble quickfix<cr>
nnoremap <leader>tll :Trouble loclist<cr>

" nvim-cmp setup
lua <<EOF
  -- Setup nvim-cmp.
  local cmp = require'cmp'

  cmp.setup({
    snippet = {
      -- REQUIRED - you must specify a snippet engine
      expand = function(args)
        vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
        -- require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
        -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
        -- require'snippy'.expand_snippet(args.body) -- For `snippy` users.
      end,
    },
    mapping = {
      ['<C-d>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
      ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
      ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
      ['<C-y>'] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
      ['<C-e>'] = cmp.mapping({
        i = cmp.mapping.abort(),
        c = cmp.mapping.close(),
      }),
      ['<CR>'] = cmp.mapping.confirm({ select = true }),
    },
    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
      { name = "path" },
      { name = "buffer", keyword_length = 1 },
    }), 
    experimental = {
      native_menu = false,
      ghost_text = true,
    }
  })
EOF

"Language servers

lua << EOF
require'lspconfig'.tsserver.setup{}
require'lspconfig'.gopls.setup{}
require'lspconfig'.jsonls.setup{}
require'lspconfig'.eslint.setup{}
require'lspconfig'.html.setup{}
require'lspconfig'.cssls.setup{}
require'lspconfig'.pyright.setup{}
require'lspconfig'.ccls.setup{}

require("trouble").setup {}

local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
EOF

lua << EOF
  local actions = require('telescope.actions')
  require('telescope').setup {
    defaults = {
      file_sorter = require('telescope.sorters').get_fzy_sorter,
      prompt_previx = ' >',
      color_devicons = true,

      file_previewer = require('telescope.previewers').vim_buffer_cat.new,
      grep_previewer = require('telescope.previewers').vim_buffer_vimgrep.new,
      qflist_previewer = require('telescope.previewers').vim_buffer_qflist.new,

      mappings = {
        i = {
          ["<C-x>"] = false,
          ["<C-q>"] = actions.send_to_qflist,
        }
      }

    }, 
    extensions = {
        fzy_native = {
            override_generic_sorter = false,
            override_file_sorter = true,
        }
    }
  }

  require('telescope').load_extension('fzy_native')
EOF
