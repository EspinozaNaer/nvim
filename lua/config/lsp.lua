vim.diagnostic.config({
  severity_sort = true,
  underline = true,
  signs = true,
  update_in_insert = false,
  virtual_text = {
    spacing = 2,
    source = "if_many",
  },
  float = {
    border = "rounded",
    source = true,
  },
})

-- Keep the repository's gopls focus, but make it useful for serious Go work.
vim.lsp.config("gopls", {
  settings = {
    gopls = {
      completeUnimported = true,
      usePlaceholders = true,
      staticcheck = true,
      analyses = {
        nilness = true,
        unusedparams = true,
        unusedwrite = true,
        useany = true,
      },
    },
  },
})

-- Make editing this Neovim config itself pleasant.
vim.lsp.config("lua_ls", {
  settings = {
    Lua = {
      runtime = {
        version = "LuaJIT",
      },
      diagnostics = {
        globals = { "vim" },
      },
      workspace = {
        checkThirdParty = false,
        library = {
          vim.env.VIMRUNTIME,
        },
      },
      telemetry = {
        enable = false,
      },
    },
  },
})

vim.api.nvim_create_autocmd("LspAttach", {
  desc = "Buffer-local LSP keymaps",
  callback = function(args)
    local function map(lhs, rhs, desc)
      vim.keymap.set("n", lhs, rhs, {
        buffer = args.buf,
        silent = true,
        desc = desc,
      })
    end

    -- Neovim 0.12 already provides useful native LSP mappings such as K,
    -- grn, grr, gra, gri, and grt. These leader mappings preserve the
    -- discoverable style of the source config.
    map("<leader>lr", vim.lsp.buf.rename, "LSP rename")
    map("<leader>lR", vim.lsp.buf.references, "LSP references")
    map("<leader>ld", vim.lsp.buf.definition, "LSP definition")
    map("<leader>la", vim.lsp.buf.code_action, "LSP code action")
    map("<leader>le", vim.diagnostic.open_float, "Line diagnostics")
    map("<leader>lf", function()
      require("conform").format({
        bufnr = args.buf,
        lsp_format = "fallback",
      })
    end, "Format buffer")
  end,
})
