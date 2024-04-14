
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
        dependencies = {
            "nvim-telescope/telescope.nvim",
            "nvim-lua/plenary.nvim",
            {
                "nvim-telescope/telescope-live-grep-args.nvim",
                version = "^1.0.0",
            },
        }
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
    --"gsuuon/llm.nvim",
})

-- color schemes
require("tokyonight")
--require("tokyonight").setup({})
vim.o.background = "dark"
vim.cmd("colorscheme tokyonight-night")

-- https://github.com/nvim-telescope/telescope-live-grep-args.nvim/blob/master/lua/telescope-live-grep-args/shortcuts.lua
local get_visual = function()
  local _, ls, cs = unpack(vim.fn.getpos("v"))
  local _, le, ce = unpack(vim.fn.getpos("."))

  ls, le = math.min(ls, le), math.max(ls, le)
  cs, ce = math.min(cs, ce), math.max(cs, ce)

  return vim.api.nvim_buf_get_text(0, ls - 1, cs - 1, le - 1, ce, {})
end

-- https://github.com/nvim-telescope/telescope-live-grep-args.nvim/blob/master/lua/telescope-live-grep-args/shortcuts.lua
local grep_under_default_opts = {
  postfix = " -F ",
  quote = true,
  trim = true,
}

-- https://github.com/nvim-telescope/telescope-live-grep-args.nvim/blob/master/lua/telescope-live-grep-args/shortcuts.lua
local process_grep_under_text = function(value, opts)
  opts = opts or {}

  if opts.trim then
    value = vim.trim(value)
  end

  if opts.quote then
    value = helpers.quote(value, opts)
  end

  if opts.postfix then
    value = value .. opts.postfix
  end

  return value
end

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


local telescope_builtin = require('telescope.builtin')
local prompt = require('telescope.themes').get_dropdown({ shorten_path = true })
local myfindfiles = function()
    return telescope_builtin.find_files(prompt)
end
local mylivegrep = function()
    return require("telescope").extensions.live_grep_args.live_grep_args(prompt)
end
local mylivegrep_visual_selection = function()
    local opts = {}
    local visual = get_visual()
    local text = visual[1] or ""
    text = process_grep_under_text(text, opts)
    opts.default_text = text
    opts = vim.tbl_extend("force", opts, prompt)
    return require("telescope").extensions.live_grep_args.live_grep_args(opts)
end
local mybuffers = function()
    return telescope_builtin.buffers(prompt)
end
local mylspreferences = function()
    return telescope_builtin.lsp_references(prompt)
end
local mytags = function()
    -- this should always exist because of gutentags
    local opts = { ctags_file = vim.fn.getcwd() .. "/tags" }
    opts = vim.tbl_extend("force", opts, prompt)
    return telescope_builtin.tags(opts)
end
local myfilebrowser = function()
    local opts = { path = "%:p:h", select_buffer = true }
    opts = vim.tbl_extend("force", opts, prompt)
    return require('telescope').extensions.file_browser.file_browser(opts)
end
vim.keymap.set('n', '<leader>f', myfindfiles, {})
vim.keymap.set('n', '<leader>g', mylivegrep, {})
vim.keymap.set('v', '<leader>g', mylivegrep_visual_selection, {})
vim.keymap.set('n', '<leader>b', mybuffers, {})
vim.keymap.set('n', '<leader>h', telescope_builtin.help_tags, {})
vim.keymap.set('n', '<leader>c', mytags, {})
vim.keymap.set('n', '<leader>n', myfilebrowser, {})
vim.keymap.set('n', '<leader>r', mylspreferences, {})
--vim.keymap.set('n', '<leader>n', file_browser, {})
--vim.keymap.set('n', '<leader>c', ":CtrlPTag<CR>", {})
--vim.keymap.set('n', 'gd', ":tag <C-r><C-w><CR>", {})
--vim.keymap.set('n', 'gD', ":tselect <C-r><C-w>", {})

-- Setup language servers.
require('lspconfig').pyright.setup{
    theme = "tokyonight-night",
    settings = {
        python = {
            analysis = {
                diagnosticMode = 'workspace',
            },
        },
    },
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
-- some terminal emulators mess up mouse integration- uncomment the following
set.mouse = nil
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

--require('tabnine').setup({
  --disable_auto_comment=true,
  --accept_keymap="<C-]>",
  --dismiss_keymap = "<C-[>",
  --debounce_ms = 800,
  --suggestion_color = {gui = "#808080", cterm = 244},
  --exclude_filetypes = {"TelescopePrompt", "NvimTree"},
  --log_file_path = nil, -- absolute path to Tabnine log file
--})

--require('llm.providers.openai').initialize({
  --url = "http://localhost:8515/",
  --max_tokens = 120,
  --temperature = 0.6,
  --model = "ggml-gpt4all-j.bin",
--})

-- credit: https://thevaluable.dev/vim-create-text-objects/
function select_indent()
    local start_indent = vim.fn.indent(vim.fn.line('.'))
    local blank_line_pattern = '^%s*$'

    if string.match(vim.fn.getline('.'), blank_line_pattern) then
        return
    end

    if vim.v.count > 0 then
        start_indent = start_indent - vim.o.shiftwidth * (vim.v.count - 1)
        if start_indent < 0 then
            start_indent = 0
        end
    end

    local prev_line = vim.fn.line('.') - 1
    local prev_blank_line = function(line) return string.match(vim.fn.getline(line), blank_line_pattern) end
    while prev_line > 0 and (prev_blank_line(prev_line) or vim.fn.indent(prev_line) >= start_indent) do
        vim.cmd('-')
        prev_line = vim.fn.line('.') - 1
    end
    vim.cmd('-')

    vim.cmd('normal! 0V')

    local next_line = vim.fn.line('.') + 1
    local next_blank_line = function(line) return string.match(vim.fn.getline(line), blank_line_pattern) end
    local last_line = vim.fn.line('$')
    while next_line <= last_line and (next_blank_line(next_line) or vim.fn.indent(next_line) >= start_indent) do
        vim.cmd('+')
        next_line = vim.fn.line('.') + 1
    end
    local buf = vim.api.nvim_get_current_buf()
    vim.api.nvim_buf_set_mark(buf, "<", prev_line, 0, {})
    vim.api.nvim_buf_set_mark(buf, ">", next_line, 0, {})
    vim.cmd('+')
end

vim.keymap.set("n", "vip", select_indent, nil)

local function get_visual_selection()
    local buf = vim.api.nvim_get_current_buf()
    local line_start = vim.api.nvim_buf_get_mark(buf, "<")[1]
    if line_start > 0 then
        line_start = line_start - 1
    end
    local line_stop = vim.api.nvim_buf_get_mark(buf, ">")[1]
    local lines = vim.api.nvim_buf_get_lines(buf, line_start, line_stop, true)
    local result = ""
    for _, line in pairs(lines) do
        result = result .. line .. "\n"
    end
    return result
end

local function display_string_in_buf(s)
    local lines = {}
    for line in string.gmatch(s .. "\n", "(.-)\n") do
        line = line:gsub("\r", "")
        table.insert(lines, line);
    end
    vim.cmd('vsplit')
    local win = vim.api.nvim_get_current_win()
    local buf = vim.api.nvim_create_buf(true, true)
    vim.api.nvim_win_set_buf(win, buf)
    vim.api.nvim_buf_set_lines(buf, 0, 0, true, lines)
end

--local curl = require("llm.curl")
--function call_localai(model, prompt, temperature)
    --display_string_in_buf(prompt)
    --local opts = {
        --url = "http://localhost:8515/chat/completions",
        --method = "POST",
        --headers = { [ "Content-Type" ] = "application/json" },
        --body = { 
            --model = model,
            --messages = { { role = "user", content = prompt }, },
            --temperature = temperature,
        --},
    --}
    --local function on_complete(stdout)
        ---- decode response
        --local out_json = vim.json.decode(stdout)
        ---- get content of response
        ---- TODO make this more dynamic
        --local response_str = out_json["choices"][1]["message"]["content"]
        ---- display content of response
        --display_string_in_buf(response_str)
        ---- apply formatting
        --local line = vim.fn.line("$")
        --while line > 0 do
            --vim.cmd(tostring(line))
            --vim.cmd.normal("gqq")
            --line = line - 1
        --end
    --end
    --local function on_error(stderr)
        --print("Error: " .. stderr)
    --end
    --curl.request(opts, on_complete, on_error)
--end

--function localai_review(args)
    --local visual_selection = get_visual_selection()
    --local prompt = "Please review the following code:\n```\n" .. visual_selection .. "```"
    --call_localai("WizardCoder-15B-1.0.ggmlv3.q4_1.bin", prompt, 0.1)
--end

--function localai_write_code(args)
    --local visual_selection = get_visual_selection()
    --local language = ""
    --if vim.bo.filetype == "lua" then
        --language = "lua"
    --elseif vim.bo.filetype == "python" then
        --language = "python"
    --elseif vim.bo.filetype == "c" or vim.bo.filetype == "h" then
        --language = "c"
    --elseif vim.bo.filetype == "cpp" or vim.bo.filetype == "hpp" then
        --language = "c++"
    --elseif vim.bo.filetype == "go" then
        --language = "golang"
    --elseif vim.bo.filetype == "sh" then
        --language = "bash"
    --else
        --print("Could not determine language!")
        --return
    --end
    --local prompt = "Please write code in " .. language .. " that does the following:\n" .. visual_selection
    --call_localai("WizardCoder-15B-1.0.ggmlv3.q4_1.bin", prompt, 0.2)
--end

--vim.keymap.set("n", "<leader>ar", localai_review, nil)
--vim.keymap.set("v", "<leader>ar", localai_review, nil)

--vim.keymap.set("n", "<leader>ac", localai_write_code, nil)
--vim.keymap.set("v", "<leader>ac", localai_write_code, nil)
