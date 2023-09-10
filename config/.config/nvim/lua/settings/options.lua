
local options = {
termguicolors= true,

history= 10000,

hidden= true,
-- notimeout= true,
wrap= true,
autoindent= true,
number= true,
numberwidth= 4,
lcs= "trail:·,tab:»·",
-- nolist= true,
autoread= true,
lazyredraw= true,
encoding= "utf-8",
fileencoding= "utf-8",
backspace= "eol,start,indent",
showmatch= true,
scrolloff= 5,
ignorecase= true,
smartcase= true,

-- wildignore+= "*/.git/*,*/.hg/*,*/.svn/*,*/.DS_Store"
-- wildignore+= "*/node_modules/*"
-- wildmenu= true,

tabstop= 2,
expandtab= true,
softtabstop= 2,
shiftwidth= 2,

mouse = "a",

updatetime = 100,
-- " completion

completeopt= "menuone,noinsert,noselect",

background= "dark",
}
-- vim.g.completion_match_strategy_list = ['exact', 'substring', 'fuzzy']
vim.g.signify_sign_delete_first_line = '-'


for k, v in pairs(options) do
  vim.opt[k] = v
end

vim.cmd "set whichwrap+=<,>,[,],h,l"
vim.cmd [[set iskeyword+=-]]
vim.cmd [[set formatoptions-=cro]] -- TODO: this doesn't seem to work

vim.filetype.add {
  extension = {
    conf = "dosini",
  },
}

-- Setting testing strategy
vim.g['test#strategy'] = 'floaterm'
vim.g['test#go#gotest#options'] = '-v'

