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
:Note {filename}
```

Open a new file `%Y%m%d%H%M%S-{filename}` in the note directory.
`%Y%m%d%H%M%S` is replaced by current time.

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
:NoteFind
```

Find a note and open it. This requires [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim/tree/master).
