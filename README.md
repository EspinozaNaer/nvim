# Cetanu Neovim config

Shameless fork of `cetanu/dotfiles/nvim`, without personal configuration and with small updates to dependencies.
Dedicated to my personal use in learning Neovim, will probably add more configuration files later™.

## Target

- Neovim 0.12.4+.
- `git`, `curl`, `tar`, and a C compiler.
- `ripgrep` (`rg`) for Telescope live grep.
- `tree-sitter-cli` 0.26.1+ for the current `nvim-treesitter` main branch.

Neovim's standard `stdpath()` locations.

## External formatters

Conform will use these when they are available:

- Go: `gofmt` (comes with Go)
- Lua: `stylua`
- shell: `shfmt`
- JSON/YAML/Markdown: `prettier`
- Terraform/HCL: `terraform fmt` (comes with Terraform)

If one is unavailable, `lsp_format = "fallback"` lets Conform use LSP
formatting when that language server supports it.

You can install generic formatter packages from `:Mason` where available.

## Main mappings

Leader is `<Space>`.

| Mapping | Action |
|---|---|
| `<leader>tf` | Find files |
| `<leader>tg` | Live grep |
| `<leader>td` | Telescope diagnostics |
| `<leader>tr` | Recent files |
| `<leader>tb` | Buffers |
| `<leader>o` | Oil file browser |
| `<leader>g` | Neogit |
| `<leader>ta` | Aerial symbols |
| `<leader>tt` | TODO search |
| `<leader>xx` | Trouble diagnostics |
| `<leader>lr` | LSP rename |
| `<leader>lR` | LSP references |
| `<leader>ld` | LSP definition |
| `<leader>la` | LSP code action |
| `<leader>le` | Diagnostic float |
| `<leader>lf` | Format buffer |

Neovim 0.12 also provides native LSP mappings such as `K`, `grn`, `grr`,
`gra`, `gri`, and `grt`. and `gc`/`gcc` commenting, so this config deliberately
does not install `Comment.nvim`.