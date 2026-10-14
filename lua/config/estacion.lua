local M = {}

local vigilante = { buf = nil, win = nil }
local recarga = nil

local function repos_en(raiz)
  local repos = {}
  for nombre, tipo in vim.fs.dir(raiz) do
    if tipo == "directory" and vim.uv.fs_stat(vim.fs.joinpath(raiz, nombre, ".git")) then
      table.insert(repos, vim.fs.joinpath(raiz, nombre))
    end
  end
  table.sort(repos)
  return repos
end

local function recargar_cambios_ajenos()
  vim.o.autoread = true
  if recarga then
    return
  end
  recarga = vim.uv.new_timer()
  recarga:start(1000, 1000, vim.schedule_wrap(function()
    if vim.fn.mode() ~= "c" and vim.fn.getcmdwintype() == "" then
      vim.cmd("silent! checktime")
    end
  end))
end

function M.vigilar(repo)
  if not (vigilante.win and vim.api.nvim_win_is_valid(vigilante.win)) then
    return vim.notify("La estación no está abierta: :Estacion", vim.log.levels.WARN)
  end
  local anterior = vigilante.buf
  vim.api.nvim_win_call(vigilante.win, function()
    vigilante.buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_win_set_buf(vigilante.win, vigilante.buf)
    vim.fn.jobstart({ "vigilar", repo }, { term = true })
  end)
  if anterior and vim.api.nvim_buf_is_valid(anterior) then
    vim.api.nvim_buf_delete(anterior, { force = true })
  end
end

function M.vigilar_repo_actual()
  local repo = vim.fs.root(0, ".git")
  if not repo then
    return vim.notify("Este archivo no está en un repo git", vim.log.levels.WARN)
  end
  M.vigilar(repo)
end

function M.abrir(raiz)
  raiz = vim.fs.normalize(raiz ~= "" and vim.fn.fnamemodify(raiz, ":p") or vim.fn.getcwd())
  vim.cmd.cd(raiz)
  recargar_cambios_ajenos()

  vim.cmd("silent only")
  local codigo = vim.api.nvim_get_current_win()
  vim.cmd("botright vsplit")
  vigilante.win = vim.api.nvim_get_current_win()
  vim.api.nvim_win_set_width(vigilante.win, math.floor(vim.o.columns * 0.32))
  vim.wo[vigilante.win].number = false
  vim.wo[vigilante.win].relativenumber = false
  vim.wo[vigilante.win].winfixwidth = true

  vim.api.nvim_set_current_win(codigo)
  vim.cmd("belowright split")
  require("nvim-tree.api").tree.open({ path = raiz })
  vim.api.nvim_set_current_win(codigo)

  local repos = vim.fs.root(raiz, ".git") and { vim.fs.root(raiz, ".git") } or repos_en(raiz)
  if #repos == 1 then
    M.vigilar(repos[1])
  elseif #repos > 1 then
    vim.ui.select(repos, {
      prompt = "¿Qué repo vigilar?",
      format_item = function(ruta) return vim.fs.basename(ruta) end,
    }, function(repo)
      if repo then M.vigilar(repo) end
    end)
  end
end

function M.diff_de_la_epica()
  local base = vim.fn.system({ "git", "rev-parse", "--verify", "--quiet", "origin/develop" }) ~= "" and "origin/develop" or "origin/main"
  vim.cmd("DiffviewOpen " .. base .. "...HEAD")
end

vim.api.nvim_create_user_command("Estacion", function(o) M.abrir(o.args) end, { nargs = "?", complete = "dir" })
vim.api.nvim_create_user_command("Vigilar", M.vigilar_repo_actual, {})

return M
