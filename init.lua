
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = "\\" -- Make sure to set `mapleader` before lazy so your mappings are correct
vim.cmd("let g:python3_host_prog = $HOME . '/venv/default/bin/python'")

require("lazy").setup({
	{
	  "folke/which-key.nvim",
	  event = "VeryLazy",
	  init = function()
		vim.o.timeout = true
		vim.o.timeoutlen = 300
	  end,
	  opts = {
		-- your configuration comes here
		-- or leave it empty to use the default settings
		-- refer to the configuration section below
	  },
	},
	{ "folke/neoconf.nvim", cmd = "Neoconf" },
	"folke/neodev.nvim",
    {
    'nvim-telescope/telescope.nvim', tag = '0.1.3',
      dependencies = { 'nvim-lua/plenary.nvim' }
    },
	"ludovicchabant/vim-gutentags",
	"flazz/vim-colorschemes",
	"neovim/nvim-lspconfig",
    {
        "nvim-telescope/telescope-file-browser.nvim",
        dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" }
    },
	"neovim/nvim-lspconfig",
    --"kien/ctrlp.vim",
    {
        "ray-x/go.nvim",
        dependencies = {  -- optional packages
        "ray-x/guihua.lua",
        "neovim/nvim-lspconfig",
        "nvim-treesitter/nvim-treesitter",
        },
        config = function()
        require("go").setup()
        end,
        event = {"CmdlineEnter"},
        ft = {"go", 'gomod'},
        build = ':lua require("go.install").update_all_sync()' -- if you need to install/update all binaries
    },
    --"navarasu/onedark.nvim",
    "tpope/vim-surround",
    "scrooloose/nerdcommenter",
    { "folke/tokyonight.nvim", priority = 1000 },
    {
      "ray-x/go.nvim",
      dependencies = {  -- optional packages
        "ray-x/guihua.lua",
        "neovim/nvim-lspconfig",
        "nvim-treesitter/nvim-treesitter",
      },
      config = function()
        require("go").setup()
      end,
      event = {"CmdlineEnter"},
      ft = {"go", 'gomod'},
      build = ':lua require("go.install").update_all_sync()' -- if you need to install/update all binaries
    },
    --"averms/black-nvim",
    "tpope/vim-fugitive",
})

-- color schemes
require("tokyonight")
--require("tokyonight").setup({})
vim.o.background = "dark"
vim.cmd("colorscheme tokyonight-night")


require("telescope").setup {
  extensions = {
    file_browser = {
      --theme = "onedark",
      -- disables netrw and use telescope-file-browser in its place
      hijack_netrw = true,
    },
  },
}
-- require("telescope").setup({
  -- extensions = {
    -- lazy = {
      -- -- Optional theme (the extension doesn't set a default theme)
      -- theme = "ivy",
      -- -- Whether or not to show the icon in the first column
      -- show_icon = true,
      -- -- Mappings for the actions
      -- mappings = {
        -- open_in_browser = "<C-o>",
        -- open_in_file_browser = "<leader>nn",
        -- open_in_find_files = "<leader>f",
        -- open_in_live_grep = "<C-g>",
        -- open_plugins_picker = "<C-b>", -- Works only after having called first another action
        -- open_lazy_root_find_files = "<C-r>f",
        -- open_lazy_root_live_grep = "<C-r>g",
      -- },
      -- -- Other telescope configuration options
    -- },
    -- file_browser = {},
  -- },
-- })


local builtin = require('telescope.builtin')
local mytags = function()
    -- this should always exist because of gutentags
    local tagspath = vim.fn.getcwd() .. "/tags"
    return builtin.tags({ ctags_file = tagspath })
end
local file_browser = require('telescope').extensions.file_browser.file_browser
local myfilebrowser = function()
    local opts = { path = "%:p:h", select_buffer = true }
    return file_browser(opts)
end
vim.keymap.set('n', '<leader>f', builtin.find_files, {})
vim.keymap.set('n', '<leader>g', builtin.live_grep, {})
vim.keymap.set('n', '<leader>b', builtin.buffers, {})
vim.keymap.set('n', '<leader>h', builtin.help_tags, {})
vim.keymap.set('n', '<leader>c', mytags, {})
vim.keymap.set('n', '<leader>n', myfilebrowser, {})
--vim.keymap.set('n', '<leader>n', file_browser, {})
--vim.keymap.set('n', '<leader>c', ":CtrlPTag<CR>", {})
--vim.keymap.set('n', 'gd', ":tag <C-r><C-w><CR>", {})
--vim.keymap.set('n', 'gD', ":tselect <C-r><C-w>", {})

-- Setup language servers.
require('lspconfig').pyright.setup{
    theme = "tokyonight-night"
}
vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = "*.py",
  callback = function(ev)
      local cwd = vim.fn.getcwd()
      local filepath = cwd .. "/" .. ev.file
      local isort_cmd = 'python -m isort "' .. filepath .. '" --profile=black'
      local black_cmd = 'python -m black "' .. filepath .. '"'
      --print(isort_cmd)
      vim.fn.system(isort_cmd)
      --print(black_cmd)
      vim.fn.system(black_cmd)
      vim.cmd "e"
  end,
  --group = format_sync_grp,
})

local format_sync_grp = vim.api.nvim_create_augroup("GoFormat", {})
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.go",
  callback = function()
   require('go.format').goimport()
  end,
  group = format_sync_grp,
})
require("go").setup{}
require("lspconfig").gopls.setup{}

require("lspconfig").ccls.setup{}


-- Global mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist)

-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    -- Enable completion triggered by <c-x><c-o>
    vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'
    vim.keymap.set('i', '<C-p>', vim.lsp.omnifunc, {})

    -- Buffer local mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local opts = { buffer = ev.buf }
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
    vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
    vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
    vim.keymap.set('n', '<space>wl', function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, opts)
    vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
    vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
    vim.keymap.set({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    vim.keymap.set('n', '<space>f', function()
      vim.lsp.buf.format { async = true }
    end, opts)
  end,
})

-- start of my own options
-- spellcheck
vim.cmd "setlocal spell spelllang=en_us"
vim.cmd "hi clear SpellBad"
vim.cmd "hi SpellBad cterm=underline"
-- show line on insert mode
vim.cmd "autocmd InsertEnter * set cursorline"
vim.cmd "autocmd InsertLeave * set nocursorline"

local set = vim.opt
set.ttimeout = true
set.ttimeoutlen = 1
set.ttyfast = true
-- basics
set.number = true
set.tabstop = 4
set.softtabstop = 4
set.shiftwidth = 4
set.expandtab = true
-- instant search
set.incsearch = true
set.hlsearch = true
-- case insensitive searching
-- need both of the following for smartcase to work
set.ignorecase = true
set.smartcase = true
-- avoid frustrations
set.autoread = true
set.scrolloff = 6
-- autoindent works weirdly sometimes
-- set.autoindent = true
vim.keymap.set("n", "gtl", ":tabn<cr>")
vim.keymap.set("n", "gth", ":tabp<cr>")
vim.keymap.set("n", "gt0", ":tabfirst<cr>")
-- move tabs with gt<S-motion>
vim.keymap.set("n", "gtL", ":execute 'silent! tabmove ' . tabpagenr()<cr>")
vim.keymap.set("n", "gtH", ":execute 'silent! tabmove ' . (tabpagenr()-2)<cr>")
-- new tab
vim.keymap.set("n", "gtn", ":tabedit<cr>")
-- previous tab
vim.keymap.set("n", "gb", ":bprevious<cr>")
vim.keymap.set("n", "gn", ":bnext<cr>")
-- switch windows using g<movement> rather than <C-W><movement>
vim.keymap.set("n", "gwh", "<C-W>h")
vim.keymap.set("n", "gwl", "<C-W>l")
vim.keymap.set("n", "gwj", "<C-W>j")
vim.keymap.set("n", "gwk", "<C-W>k")
-- tags
--vim.keymap.set("n", "<leader>c", ":lt ")

--local deltagsoffile = function(file)
    --local cwd = vim.fn.getcwd()
    --local tagpath = cwd .. "/tags"
    --local frelative = vim.fn.substitute(file, cwd .. "/", "", "")
    --frelative = vim.fn.escape(frelative, "./")
    --local cmd = 'sed -i "/' .. frelative .. '/d" "' .. tagpath .. '"'
    --vim.fn.system(cmd)
--end

--vim.api.nvim_create_autocmd(
  --{"BufWritePost"},
  --{
    --pattern = {"*.py", "*.go"},
    --callback = function(ev)
      ----print(string.format('event fired: %s', vim.inspect(ev)))
      --local f = ev.file
      --deltagsoffile(f)
      --local tagpath = vim.fn.getcwd() .. "/tags"
      --local cmd = 'ctags -a -f "' .. tagpath .. '" "' .. f .. '"'
      --vim.fn.system(cmd)
    --end
  --}
--)
