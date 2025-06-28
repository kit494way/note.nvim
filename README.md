# note.nvim

Neovim plugin to write, read, and manage notes in local directory.

## Installation

lazy.nvim:

```lua
{
  "kit494way/note.nvim",
  opts = {
    dirs = { -- Register directories to save notes.
      default = "/path/to/default/directory/to/save/notes",
      another = "/path/to/another/directory/to/save/notes",
    },
  },
  dependencies = {
    "nvim-telescope/telescope.nvim", -- Some features requires telescope
  },
}
```

## Usage

```
:Note [key] {filename}
```

Open a new file `%Y%m%d%H%M%S-{filename}` in a note directory specified by `key`.
`%Y%m%d%H%M%S` is replaced by current time.
If `key` is omitted, current note directory is used.

```
:NoteEdit {filename}
```

Open a note.

```
:NoteCd [key]
```

Change the note directory. `key` is a key of the directory registered in `opts.dirs`.
If `key` is omitted, the default directory is used.

```
:NotePwd
```

Show current note directory.

```
:NoteFind [key]
```

Find a note from a note directory specified by `key` and open it.
If `key` is omitted, the current not directory is used.
This requires [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim/tree/master).
