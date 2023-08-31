local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end

-- set leader
vim.g.mapleader = " "

-- setting vim options
vim.opt.rtp:prepend(lazypath)
vim.opt.termguicolors = true
vim.opt.relativenumber = true
vim.opt.completeopt = { "menu", "menuone", "noselect" }

-- setup plugins with lazy.nvim
require("lazy").setup({
  "nvim-tree/nvim-tree.lua",
  "nvim-tree/nvim-web-devicons",
  "christoomey/vim-tmux-navigator",
  "nmac427/guess-indent.nvim",
  "norcalli/nvim-colorizer.lua",
  { "projekt0n/github-nvim-theme", lazy = false, priority = 1000 },
  { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
  {
    "nvim-lualine/lualine.nvim",
    opts = {
      options = {
        theme = "auto",
      },
    },
  },
  -- Telescope
  "nvim-lua/plenary.nvim",
  "nvim-telescope/telescope.nvim",
  -- lsp, linters, formatters plugins
  "williamboman/mason.nvim",
  "williamboman/mason-lspconfig.nvim",
  "neovim/nvim-lspconfig",
  "hrsh7th/nvim-cmp",
  "hrsh7th/cmp-nvim-lsp",
  "hrsh7th/cmp-buffer",
  "hrsh7th/cmp-path",
  "L3MON4D3/LuaSnip",
  "saadparwaiz1/cmp_luasnip",
  "mhartington/formatter.nvim",
  "mfussenegger/nvim-lint",
  "mfussenegger/nvim-dap",
  "rcarriga/nvim-dap-ui",
  "folke/trouble.nvim",
  "WhoIsSethDaniel/mason-tool-installer.nvim",
  -- mini.nvim plugins
  { "echasnovski/mini.starter", version = false },
  { "echasnovski/mini.comment", version = false },
  { "echasnovski/mini.pairs", version = false },
  { "echasnovski/mini.clue", version = false },
  { "echasnovski/mini.animate", version = false },
})

-- configuration of plugins start here
-- buffer keybindings

vim.keymap.set("n", "<leader>bn", "<cmd>bnext<cr>", {})
vim.keymap.set("n", "<leader>bp", "<cmd>bprevious<cr>", {})

-- nvim-tree setup
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

require("nvim-tree").setup {
  view = {
    side = "right"
  }
}

vim.keymap.set("n", "<leader>ee", "<cmd>NvimTreeToggle<cr>", {})
vim.keymap.set("n", "<leader>ef", "<cmd>NvimTreeFocus<cr>", {})

-- set colorscheme
require("github-theme").setup({
  options = {
    transparent = false,
  },
})
vim.cmd("colorscheme github_light")

-- colorizer setup
require("colorizer").setup()

-- mini plugins setup
require("mini.starter").setup()
require("mini.comment").setup()
require("mini.pairs").setup()
require("mini.clue").setup()
require("mini.animate").setup()

-- guess-indent setup
require("guess-indent").setup({})

-- configure telescope
local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>ff", builtin.find_files, {})
vim.keymap.set("n", "<leader>fg", builtin.live_grep, {})
vim.keymap.set("n", "<leader>fb", builtin.buffers, {})
vim.keymap.set("n", "<leader>fh", builtin.help_tags, {})

-- configure treesitter
local treesitter_config = require("nvim-treesitter.configs")
treesitter_config.setup({
  ensure_installed = {
    "css",
    "lua",
    "typescript",
    "tsx",
    "jsdoc",
    "graphql",
    "yaml",
    "javascript",
    "html",
    "bash",
    "dockerfile",
    "go",
    "gomod",
    "gosum",
    "jq",
    "python",
    "scss",
    "sql",
    "toml",
  },
  highlight = { enable = true },
  indent = { enable = true },
})

-- LSP
local cmp = require("cmp")
local capabilities = require("cmp_nvim_lsp").default_capabilities()
local lspconfig = require("lspconfig")
local luasnip = require("luasnip")

local lsp_list = {
  "lua_ls",
  "rust_analyzer",
  "clangd",
  "dockerls",
  "docker_compose_language_service",
  "gopls",
  "pyright",
  "tsserver",
  "yamlls",
  "ansiblels",
  "emmet_ls",
  "sqlls",
  "jsonls",
  "efm",
  "awk_ls",
  "bashls",
  "cssls",
  "grammarly",
  "graphql",
  "html",
  "marksman",
  "tailwindcss",
}

local formatters_linters_list = {
  -- formatters
  "black", -- python
  "stylua", -- lua
  "prettier", -- js/ts
  "yamlfmt", -- yaml
  "sqlfmt", -- sql
  -- linters
  "pylint", -- python
  "eslint", -- js/ts
  "vale", -- markdown
  "markdownlint", -- markdown
  "sqlfluff", -- sql
}

require("mason").setup()
require("mason-lspconfig").setup({
  ensure_installed = lsp_list,
})
require("mason-tool-installer").setup({
  ensure_installed = formatters_linters_list,
})

local on_attach = function()
  -- lsp
  vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = 0 })
  vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = 0 })
  vim.keymap.set("n", "gt", vim.lsp.buf.type_definition, { buffer = 0 })
  vim.keymap.set("n", "gi", vim.lsp.buf.implementation, { buffer = 0 })
  vim.keymap.set("n", "<leader>r", vim.lsp.buf.rename, { buffer = 0 })

  -- diagnostic
  vim.keymap.set("n", "<leader>dn", vim.diagnostic.goto_next, { buffer = 0 })
  vim.keymap.set("n", "<leader>dp", vim.diagnostic.goto_prev, { buffer = 0 })
  vim.keymap.set("n", "<leader>dl", "<cmd>Telescope diagnostics<cr>", { buffer = 0 })

  -- trouble plugin which displays diagnostics
  vim.keymap.set("n", "<leader>xx", "<cmd>TroubleToggle<cr>")
  vim.keymap.set("n", "<leader>xw", function()
    require("trouble").open("workspace_diagnostics")
  end)
  vim.keymap.set("n", "<leader>xd", function()
    require("trouble").open("document_diagnostics")
  end)
  vim.keymap.set("n", "<leader>xq", function()
    require("trouble").open("quickfix")
  end)
  vim.keymap.set("n", "<leader>xl", function()
    require("trouble").open("loclist")
  end)
  vim.keymap.set("n", "gR", function()
    require("trouble").open("lsp_references")
  end)

  -- code action
  vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { buffer = 0 })

  -- format
  vim.keymap.set("n", "<leader>cf", vim.lsp.buf.format, { buffer = 0 })
end

-- Configure netrw
-- vim.g.loaded_netrw = 1
-- vim.g.loaded_netrwPlugin = 1

local has_words_before = function()
  unpack = unpack or table.unpack
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

cmp.setup({
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
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
      elseif has_words_before() then
        cmp.complete()
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
  }),
})

for _, lsp_name in pairs(lsp_list) do
  if lsp_name == "gopls" then
    lspconfig.gopls.setup({
      on_attach = on_attach,
      capabilities = capabilities,
      settings = {
        gopls = {
          experimentalPostfixCompletions = true,
          analyses = {
            unusedparams = true,
            shadow = true,
          },
          staticcheck = true,
        },
      },
    })
  else
    lspconfig[lsp_name].setup({
      on_attach = on_attach,
      capabilities = capabilities,
    })
  end
end

-- formatter
require("formatter").setup({
  logging = true,
  log_level = vim.log.levels.WARN,
  filetype = {
    lua = {
      require("formatter.filetypes.lua").stylua,
    },
    typescript = {
      require("formatter.filetypes.typescript").prettier,
    },
    typescriptreact = {
      require("formatter.filetypes.typescript").prettier,
    },
    toml = {
      require("formatter.filetypes.toml").taplo,
    },
    javascript = {
      require("formatter.filetypes.javascript").prettier,
    },
    javascriptreact = {
      require("formatter.filetypes.javascriptreact").prettier,
    },
    python = {
      require("formatter.filetypes.python").black,
    },
    json = {
      require("formatter.filetypes.json").prettier,
    },
    html = {
      require("formatter.filetypes.html").prettier,
    },
    go = {
      require("formatter.filetypes.go").gofmt,
    },
    sql = {
      require("formatter.filetypes.sql").pgformat,
    },
    markdown = {
      require("formatter.filetypes.markdown").prettier,
    },
    ["*"] = {
      require("formatter.filetypes.any").remove_trailing_whitespace,
    },
  },
})

-- linters
require("lint").linters_by_ft = {
  markdown = { "vale", "markdownlint" },
  javascript = { "eslint" },
  javascriptreact = { "eslint" },
  typescript = { "eslint" },
  typescriptreact = { "eslint" },
  python = { "pylint" },
  sql = { "sqlfluff" },
}
