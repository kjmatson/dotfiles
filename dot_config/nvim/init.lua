vim.opt.winborder = "rounded"
vim.o.number = true
vim.o.relativenumber = true
vim.o.wrap = false
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
vim.g.mapleader = " "
vim.o.termguicolors = true
vim.opt.completeopt = { "menuone", "noselect", "popup" }

vim.pack.add({
	{ src = "https://github.com/sainnhe/sonokai" },
	{ src = "https://github.com/neovim/nvim-lspconfig" },
	{ src = "https://github.com/stevearc/oil.nvim" },
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter", lazy = false, build = ":TSUpdate" },
	{ src = "https://github.com/chomosuke/typst-preview.nvim" },
	{ src = "https://github.com/nvim-telescope/telescope.nvim" },
	{ src = "https://github.com/nvim-lua/plenary.nvim" },
	{ src = "https://github.com/diepm/vim-rest-console" },
})

require "nvim-treesitter".setup({
	ensure_installed = { "python", "html", "javascript" },
	highlight = { enable = true }
})

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


vim.lsp.enable({ "lua_ls", "basedpyright", "tinymist" })
vim.lsp.inlay_hint.enable(true)

vim.keymap.set('n', '<leader>lf', vim.lsp.buf.format)

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
