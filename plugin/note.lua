if vim.g.loaded_note == 1 then
  return
end
vim.g.loaded_note = 1

local function complete_note_dir(arg_lead, cmd_line, cursor_pos)
  local dirs = require("note").dirs()
  return vim
    .iter(dirs)
    :filter(function(k, _)
      return string.find(k, arg_lead)
    end)
    :map(function(k, _)
      return k
    end)
    :totable()
end

vim.api.nvim_create_user_command("Note", function(opts)
  require("note").new_note(unpack(opts.fargs))
end, {
  nargs = "+",
  complete = function(arg_lead, cmd_line, cursor_pos)
    local arg_positions = vim.iter(cmd_line:gmatch("()%s+")):totable()
    if
      (#arg_positions == 1 and cursor_pos >= arg_positions[1])
      or (#arg_positions >= 2 and cursor_pos >= arg_positions[1] and cursor_pos < arg_positions[2])
    then
      return complete_note_dir(vim.split(arg_lead, " ")[1], cmd_line, cursor_pos)
    end
  end,
})

vim.api.nvim_create_user_command("NoteEdit", function(opts)
  require("note").edit(opts.fargs[1])
end, {
  nargs = 1,
  complete = function(arg_lead, cmd_line, cursor_pos)
    local note_dir = require("note").note_dir()
    local notes = vim.fs.find(function(name, path)
      return string.find(name, arg_lead)
    end, {
      type = "file",
      path = note_dir,
      limit = math.huge,
    })
    return vim.iter(notes):map(vim.fs.basename):totable()
  end,
})

vim.api.nvim_create_user_command("NoteFind", function(opts)
  require("note").find(opts.fargs[1])
end, { nargs = "?", complete = complete_note_dir })

vim.api.nvim_create_user_command("NoteCd", function(opts)
  require("note").cd(opts.fargs[1])
end, { nargs = "?", complete = complete_note_dir })

vim.api.nvim_create_user_command("NotePwd", function()
  require("note").pwd()
end, { nargs = 0 })
