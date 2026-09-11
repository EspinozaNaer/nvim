local treesitter = require("nvim-treesitter")

local parsers = {
  "bash",
  "dockerfile",
  "go",
  "gomod",
  "gosum",
  "gowork",
  "hcl",
  "json",
  "lua",
  "markdown",
  "markdown_inline",
  "terraform",
  "yaml",
}

treesitter.setup({})
treesitter.install(parsers)

-- nvim-treesitter's current main branch delegates highlighting to Neovim.
vim.api.nvim_create_autocmd("FileType", {
  desc = "Enable Tree-sitter highlighting",
  pattern = {
    "sh",
    "bash",
    "dockerfile",
    "go",
    "gomod",
    "gosum",
    "gowork",
    "hcl",
    "json",
    "jsonc",
    "lua",
    "markdown",
    "terraform",
    "yaml",
  },
  callback = function(args)
    pcall(vim.treesitter.start, args.buf)
  end,
})
