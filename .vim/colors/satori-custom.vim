" Vim color file
" Maintainer: Ruda Moura <ruda@rudix.org>
" Last Change: Sun Feb 24 18:50:47 BRT 2008

highlight clear Normal
if &background=="light"
    set background="dark"
else
    set background&
endif

highlight clear

if exists("syntax_on")
  syntax reset
endif

let colors_name = "satori-custom"

" Vim colors
highlight Normal     ctermfg=NONE       cterm=NONE
highlight Comment    ctermfg=Cyan       cterm=NONE
highlight Constant   ctermfg=Red        cterm=NONE
highlight Number     ctermfg=Red        cterm=NONE
highlight Identifier ctermfg=Blue       cterm=NONE
highlight Statement  ctermfg=LightGreen cterm=NONE
highlight Operator   ctermfg=Green      cterm=NONE
highlight Function   ctermfg=Green      cterm=Bold
highlight PreProc    ctermfg=Blue       cterm=Bold
highlight Type       ctermfg=Magenta    cterm=NONE
highlight Typedef    ctermfg=Magenta    cterm=Bold
highlight Special    ctermfg=Magenta    cterm=NONE
highlight Search     ctermbg=darkGreen  cterm=NONE


" Vim monochrome
highlight Normal     term=NONE
highlight Comment    term=NONE
highlight Constant   term=Underline
highlight Number     term=Underline
highlight Identifier term=NONE
highlight Statement  term=Bold
highlight PreProc    term=NONE
highlight Type       term=Bold
highlight Special    term=NONE

" GVim colors
" highlight Normal     guifg=White        gui=NONE    guibg=black
" highlight Comment    guifg=DarkCyan     gui=NONE
" highlight Constant   guifg=Red          gui=NONE
" highlight Number     guifg=Red          gui=Bold
" highlight Identifier guifg=DarkGreen    gui=NONE
" highlight Statement  guifg=DarkGreen    gui=Bold
" highlight PreProc    guifg=Blue         gui=NONE
" highlight Type       guifg=Magenta      gui=NONE
" highlight Special    guifg=Red          gui=Bold


" Vim colors
highlight Normal     guifg=White      gui=NONE      guibg=Black
highlight Comment    guifg=Cyan       gui=NONE
highlight Constant   guifg=Red        gui=NONE
highlight Number     guifg=Red        gui=NONE
highlight Identifier guifg=LightBlue       gui=NONE
highlight Statement  guifg=LightGreen gui=NONE
highlight Operator   guifg=Green      gui=NONE
highlight Function   guifg=Green      gui=Bold
highlight PreProc    guifg=Blue       gui=Bold
highlight Type       guifg=Magenta    gui=NONE
highlight Typedef    guifg=Magenta    gui=Bold
highlight Special    guifg=Magenta    gui=NONE
highlight Search     guibg=darkGreen  gui=NONE
