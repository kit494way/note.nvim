if vim.g.loaded_note == 1 then
  return
end
vim.g.loaded_note = 1

vim.api.nvim_create_user_command("Note", function(opts)
  require("note").new_note(opts.fargs[1])
end, { nargs = 1 })

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

vim.api.nvim_create_user_command("NoteFind", function()
  require("note").find()
end, { nargs = 0 })

vim.api.nvim_create_user_command("NoteCd", function(opts)
  require("note").cd(opts.fargs[1])
end, {
  nargs = "?",
  complete = function(arg_lead, cmd_line, cursor_pos)
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
  end,
})

vim.api.nvim_create_user_command("NotePwd", function()
  require("note").pwd()
end, { nargs = 0 })
