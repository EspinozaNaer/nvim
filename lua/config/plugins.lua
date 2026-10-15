local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.uv.fs_stat(lazypath) then
  local output = vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "--branch=stable",
    "https://github.com/folke/lazy.nvim.git",
    lazypath,
  })

  if vim.v.shell_error ~= 0 then
    error("Failed to install lazy.nvim:\n" .. output)
  end
end

vim.opt.rtp:prepend(lazypath)

local lsp_servers = {
  "gopls",
  "lua_ls",
  "bashls",
  "jsonls",
  "yamlls",
  "dockerls",
  "terraformls",
  "marksman",
}

require("lazy").setup({
  -- Keep one theme instead of carrying the source config's theme collection.
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      style = "night",
      styles = { comments = { italic = false } },
      on_highlights = function(hl, c)
        hl["@comment.documentation"] = { fg = c.blue1 }
        hl["@type.definition"] = { fg = c.magenta }
        hl["@constant"] = { fg = c.blue1 }
        hl.LineNr = { fg = c.comment }
      end,
    },
    config = function(_, opts)
      require("tokyonight").setup(opts)
      vim.cmd.colorscheme("tokyonight-night")
    end,
  },

  { "nvim-lua/plenary.nvim", lazy = true },
  { "nvim-tree/nvim-web-devicons", lazy = true },

  {
    "nvim-telescope/telescope.nvim",
    tag = "v0.2.1",
    cmd = "Telescope",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    opts = {
      defaults = {
        mappings = {
          i = {
            ["<C-u>"] = false,
            ["<C-d>"] = false,
          },
        },
      },
    },
  },

  {
    "stevearc/oil.nvim",
    cmd = "Oil",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    opts = {
      view_options = {
        show_hidden = true,
      },
    },
  },

  {
    "nvim-tree/nvim-tree.lua",
    cmd = { "NvimTreeToggle", "NvimTreeOpen", "NvimTreeFindFile" },
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    opts = {
      hijack_netrw = false,
      hijack_directories = { enable = false },
      update_focused_file = { enable = true },
      view = { width = 34 },
      git = { enable = true, ignore = true },
      filters = { dotfiles = false },
      renderer = {
        group_empty = true,
        highlight_git = "name",
        hidden_display = "simple",
      },
    },
  },

  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {},
  },

  {
    "NeogitOrg/neogit",
    cmd = "Neogit",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "sindrets/diffview.nvim",
      "nvim-telescope/telescope.nvim",
    },
    opts = {
      integrations = {
        telescope = true,
        diffview = true,
      },
    },
  },

  {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    build = ":TSUpdate",
    config = function()
      require("config.treesitter")
    end,
  },

  -- The source config already uses blink.cmp. Stay on stable v1 while v2 is
  -- still under active development.
  {
    "saghen/blink.cmp",
    version = "1.*",
    dependencies = {
      "rafamadriz/friendly-snippets",
    },
    opts = {
      keymap = {
        preset = "default",
      },
      completion = {
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 300,
        },
      },
      signature = {
        enabled = true,
      },
      sources = {
        default = { "lsp", "path", "snippets", "buffer" },
      },
      fuzzy = {
        implementation = "prefer_rust_with_warning",
      },
    },
    opts_extend = { "sources.default" },
  },

  {
    "mason-org/mason-lspconfig.nvim",
    dependencies = {
      {
        "mason-org/mason.nvim",
        opts = {},
      },
      "neovim/nvim-lspconfig",
    },
    opts = {
      ensure_installed = lsp_servers,
      automatic_enable = lsp_servers,
    },
    config = function(_, opts)
      -- Apply our server overrides before Mason enables the servers.
      require("config.lsp")
      require("mason-lspconfig").setup(opts)
    end,
  },

  {
    "j-hui/fidget.nvim",
    opts = {},
  },

  {
    "stevearc/conform.nvim",
    event = "BufWritePre",
    cmd = "ConformInfo",
    opts = {
      formatters_by_ft = {
        go = { "gofmt" },
        lua = { "stylua" },
        sh = { "shfmt" },
        bash = { "shfmt" },
        json = { "prettier" },
        jsonc = { "prettier" },
        yaml = { "prettier" },
        markdown = { "prettier" },
        terraform = { "terraform_fmt" },
        hcl = { "terraform_fmt" },
      },
      format_on_save = {
        timeout_ms = 1000,
        lsp_format = "fallback",
      },
    },
  },

  {
    "folke/trouble.nvim",
    cmd = "Trouble",
    keys = {
      {
        "<leader>xx",
        function()
          require("trouble").toggle("diagnostics")
        end,
        desc = "Toggle diagnostics list",
      },
    },
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    opts = {},
  },

  {
    "folke/todo-comments.nvim",
    event = { "BufReadPost", "BufNewFile" },
    cmd = { "TodoTelescope", "TodoQuickFix", "TodoLocList" },
    keys = {
      {
        "<leader>tt",
        "<cmd>TodoTelescope<cr>",
        desc = "Find TODO comments",
      },
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    opts = {},
  },

  {
    "stevearc/aerial.nvim",
    cmd = { "AerialToggle", "AerialOpen" },
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    opts = {},
  },

  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    opts = {
      options = {
        theme = "auto",
        globalstatus = true,
      },
    },
  },

  -- Replaces cetanu/key-menu.nvim with a mainstream discoverability layer.
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {},
  },
}, {
  checker = {
    enabled = true,
    notify = false,
  },
  change_detection = {
    notify = false,
  },
})
