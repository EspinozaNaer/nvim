local map = vim.keymap.set

local function opts(desc)
  return { silent = true, desc = desc }
end

-- Search movement from the original config: keep the match centered.
map("n", "n", "nzzzv", opts("Next search result"))
map("n", "N", "Nzzzv", opts("Previous search result"))

map("n", "<leader>n", "<cmd>nohlsearch<cr>", opts("Clear search highlight"))
map("n", "<leader>q", "<cmd>wqa<cr>", opts("Save all and quit"))
map("n", "<leader>Q", "<cmd>qa!<cr>", opts("Quit without saving"))

-- Telescope
map("n", "<leader>tf", "<cmd>Telescope find_files<cr>", opts("Find files"))
map("n", "<leader>tg", "<cmd>Telescope live_grep<cr>", opts("Live grep"))
map("n", "<leader>td", "<cmd>Telescope diagnostics<cr>", opts("Diagnostics"))
map("n", "<leader>tr", "<cmd>Telescope oldfiles<cr>", opts("Recent files"))
map("n", "<leader>tb", "<cmd>Telescope buffers<cr>", opts("Buffers"))
map("n", "<leader>tc", "<cmd>Telescope colorscheme<cr>", opts("Colorschemes"))

-- File navigation / Git
map("n", "<leader>o", "<cmd>Oil<cr>", opts("Open Oil"))
map("n", "<leader>g", "<cmd>Neogit<cr>", opts("Open Neogit"))

-- Code/navigation views
map("n", "<leader>ta", "<cmd>AerialToggle<cr>", opts("Toggle symbols outline"))

map("n", "<leader>e", "<cmd>NvimTreeToggle<cr>", opts("Toggle file tree"))
map("n", "<leader>tv", "<cmd>Vigilar<cr>", opts("Watch tests of this file's repo"))
map("n", "<leader>tE", function() require("config.estacion").diff_de_la_epica() end, opts("Diff of the epic so far"))
