vim.opt.winborder = "rounded"
vim.o.number = true
vim.o.relativenumber = true
vim.o.wrap = true
vim.o.showbreak="↪"
vim.o.tabstop = 2
vim.o.swapfile = false
vim.o.signcolumn = "yes"
vim.o.clipboard = "unnamedplus"

if vim.env.SSH_TTY ~= nil then
	vim.g.clipboard = {
		name = 'OSC 52',
		copy = {
			['+'] = require('vim.ui.clipboard.osc52').copy('+'),
			['*'] = require('vim.ui.clipboard.osc52').copy('*'),
		},
		paste = {
			['+'] = require('vim.ui.clipboard.osc52').paste('+'),
			['*'] = require('vim.ui.clipboard.osc52').paste('*'),
		},
	}
end

vim.keymap.set("n", "<leader>ww", function() vim.o.wrap = not vim.o.wrap end)
vim.g.mapleader = " "
vim.o.termguicolors = true
vim.opt.completeopt = { "menuone", "noselect", "popup" }

vim.diagnostic.config({
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = '●',
			[vim.diagnostic.severity.WARN]  = '●',
			[vim.diagnostic.severity.HINT]  = '⚑',
			[vim.diagnostic.severity.INFO]  = '»',
		},
	},
})

vim.pack.add({
	{ src = "https://github.com/sainnhe/sonokai" },
	{ src = "https://github.com/neovim/nvim-lspconfig" },
	{ src = "https://github.com/stevearc/oil.nvim" },
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter", lazy = false, build = ":TSUpdate" },
	{ src = "https://github.com/chomosuke/typst-preview.nvim" },
	{ src = "https://github.com/nvim-telescope/telescope.nvim" },
	{ src = "https://github.com/nvim-lua/plenary.nvim" },
	{ src = "https://github.com/diepm/vim-rest-console" },
	{ src = "https://github.com/lewis6991/gitsigns.nvim" },
  { src = "https://github.com/hrsh7th/nvim-cmp" },
  { src = "https://github.com/hrsh7th/cmp-nvim-lsp" },
  { src = "https://github.com/hrsh7th/cmp-buffer" },
  { src = "https://github.com/hrsh7th/cmp-path" },
  { src = "https://github.com/hrsh7th/cmp-cmdline" },
  { src = "https://github.com/L3MON4D3/LuaSnip" },
  { src = "https://github.com/saadparwaiz1/cmp_luasnip" },
})

local cmp = require("cmp")
local luasnip = require("luasnip")

cmp.setup({
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
    ["<C-f>"] = cmp.mapping.scroll_docs(4),
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<C-e>"] = cmp.mapping.abort(),
    ["<CR>"] = cmp.mapping.confirm({ select = true }),
    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { "i", "s" }),
    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { "i", "s" }),
  }),
  sources = cmp.config.sources({
    { name = "nvim_lsp" },
    { name = "luasnip" },
  }, {
    { name = "buffer" },
    { name = "path" },
  }),
})

-- `/` and `?` search completion
cmp.setup.cmdline({ "/", "?" }, {
  mapping = cmp.mapping.preset.cmdline(),
  sources = { { name = "buffer" } },
})

-- `:` command-line completion
cmp.setup.cmdline(":", {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = "path" },
  }, {
    { name = "cmdline" },
  }),
})

-- Tell LSP servers about cmp capabilities
local capabilities = require("cmp_nvim_lsp").default_capabilities()
require "nvim-treesitter".setup({
	ensure_installed = { "python", "html", "javascript" },
	highlight = { enable = true }
})


----------------------------------------------------------------------


-- sonokai but with vague's background color
vim.cmd("colorscheme sonokai")
vim.api.nvim_command('highlight Normal guibg=#141415 ctermbg=50')

vim.api.nvim_create_autocmd('LspAttach', {
	callback = function(ev)
		local client = vim.lsp.get_client_by_id(ev.data.client_id)
		if client:supports_method('textDocument/completion') then
			vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
		end
	end,
})


vim.lsp.enable({ "lua_ls", "basedpyright", "tinymist", "ruff" })
vim.lsp.inlay_hint.enable(true)

vim.keymap.set('n', '<leader>lf', vim.lsp.buf.format)
vim.keymap.set('v', '<leader>lf', vim.lsp.buf.format)

require "oil".setup({ view_options = { show_hidden = true, } })
vim.keymap.set('n', '<leader>e', ":Oil<CR>")

vim.keymap.set('n', '<leader>w', "<C-w>w")

vim.keymap.set('n', '<leader>o', "<cmd>put = ''<CR>", { desc = "Insert new line below" })

-- VRC
vim.g.vrc_output_buffer_name = '__VRC_OUTPUT.json'
vim.g.vrc_auto_format_response_patterns = {
	json = 'jq .'
}

-- Turn on auto-format (it's on by default; keep here for clarity)
vim.g.vrc_auto_format_response_enabled = 1

-- If your API responses omit headers, tell VRC to assume JSON
vim.g.vrc_response_default_content_type = 'application/json'


-- Tyspt
require('typst-preview').setup({
	-- Use Windows start command via cmd.exe
	open_cmd = "cmd.exe /c start %s",
})

vim.lsp.config('tinymist', {
	settings = {
		exportPdf = "onSave",
		outputPath = "$root/$dir/pdf/$name",
		-- Optional: additional settings like root markers
		root_markers = { 'main.typ' },
	}
})


-- Telescope
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })
vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope help tags' })

require('telescope').setup{
  defaults = {
    mappings = {
      i = {
        ["<C-x>"] = "file_vsplit",
      },
    },
  }
}

vim.keymap.set('n', 'gl', '<cmd>lua vim.diagnostic.open_float()<CR>')


require("gitsigns").setup()
