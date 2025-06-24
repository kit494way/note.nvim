local os = require("os")

local plugin_name = "note.nvim"

local cwd = nil
local note_dirs = {}
local plugin_default_note_dir = vim.fs.joinpath(vim.fn.stdpath("data"), plugin_name)

local function note_dir()
  if cwd then
    return cwd
  elseif note_dirs.default ~= nil then
    return note_dirs.default
  else
    return plugin_default_note_dir
  end
end

local telescope_builtin = nil
local function ensure_telescope()
  if not telescope_builtin then
    local ok, builtin = pcall(require, "telescope.builtin")
    if not ok then
      vim.api.nvim_echo({ { "Missing telescope" } }, true, { err = true })
      return
    end
    telescope_builtin = builtin
  end
  return telescope_builtin
end

local M = {}

function M.setup(opts)
  opts = opts or {}

  if opts.dirs and type(opts.dirs) == "table" then
    note_dirs = opts.dirs

    if note_dirs.default == nil then
      note_dirs.default = plugin_default_note_dir
    end

    cwd = opts.dirs.default
  end
end

function M.register_dirs(opts)
  note_dirs = vim.tbl_extend("force", note_dirs, opts)
end

function M.note_dir()
  return note_dir()
end

function M.dirs()
  return note_dirs
end

function M.pwd()
  vim.api.nvim_echo({ { note_dir() } }, false, {})
end

function M.cd(key)
  if key ~= nil and note_dirs[key] ~= nil then
    cwd = note_dirs[key]
  else
    cwd = note_dirs.default
  end
  vim.api.nvim_echo({ { "Changed note_dir to " .. note_dir() } }, true, {})
end

function M.new_note(name)
  local prefix = os.date("%Y%m%d%H%M%S-")
  vim.cmd.edit(vim.fs.joinpath(note_dir(), prefix .. name))
end

function M.edit(fname)
  local note_path = vim.fs.joinpath(note_dir(), fname)
  if vim.fn.filereadable(note_path) == 0 then
    vim.api.nvim_echo({ { "Note " .. fname .. "does not exists." } }, true, { err = true })
    return
  end
  vim.cmd.edit(note_path)
end

function M.find(key)
  local dir = note_dir()
  if key ~= nil and note_dirs[key] ~= nil then
    dir = note_dirs[key]
  end

  ensure_telescope().find_files { cwd = dir }
end

return M
