require'nvim-tree'.setup { 
 filters = {
    custom = { ".git", "node_modules" },
  },
  view = {
    width=40,
  },
  actions = {
    open_file = {
      resize_window = true,
    },
  },
  renderer = {
    highlight_git = true,
    highlight_opened_files = "3",
    add_trailing = true,
    group_empty = true,
    icons = {
      padding = ' ',
      glyphs = {
     default = '',
     symlink= '',
     git= {
       unstaged= "✗",
       staged= "✓",
       unmerged= "",
       renamed= "➜",
       untracked= "★",
       deleted= "",
       ignored= "◌"
       },
     folder= {
       arrow_open= "",
       arrow_closed= "",
       default= "",
       open= "",
       empty= "",
       empty_open= "",
       symlink= "",
       symlink_open= "",
       }
      }
    },
    special_files = {
      "README.md",
      "LICENSE",
      "Makefile",
      "package.json",
      "MAKEFILE",
    }
  },
  respect_buf_cwd = false,
}
