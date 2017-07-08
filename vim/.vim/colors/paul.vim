" Vim color file
" Maintainer:   Bohdan Vlasyuk <bohdan@vstu.edu.ua>
" Last Change:  2002 Mar 09

" darkblue -- for those who prefer dark background
" [note: looks bit uglier with come terminal palettes,
" but is fine on default linux console palette.]

set bg=dark
hi clear
if exists("syntax_on")
    syntax reset
endif

let colors_name = "paul"

hi Normal       guifg=lightgray     guibg=gray2     ctermfg=gray
hi ErrorMsg     guifg=#ffffff       guibg=#287eff   ctermfg=white           ctermbg=lightblue
hi Visual       guifg=darkgreen     guibg=fg        gui=reverse             ctermfg=lightblue   ctermbg=fg      cterm=reverse
hi VisualNOS    guifg=#8080ff       guibg=fg        gui=reverse,underline   ctermfg=lightblue   ctermbg=fg      cterm=reverse,underline
hi Todo         guifg=red           guibg=darkblue  gui=bold,underline      ctermfg=red         ctermbg=darkblue

hi SpecialKey   guifg=cyan          ctermfg=darkcyan
hi Directory    guifg=cyan          ctermfg=cyan
hi Title        guifg=magenta gui=none      ctermfg=magenta cterm=bold
hi WarningMsg   guifg=red           ctermfg=red
hi WildMenu     guifg=yellow guibg=black    ctermfg=yellow ctermbg=black cterm=none term=none
hi ModeMsg      guifg=#22cce2           ctermfg=lightblue
hi MoreMsg      ctermfg=darkgreen       ctermfg=darkgreen
hi Question     guifg=green gui=none        ctermfg=green cterm=none
hi NonText      guifg=#0030ff guibg=black   ctermfg=darkblue

hi StatusLine   guifg=blue  guibg=gray gui=none ctermfg=blue ctermbg=gray term=none cterm=none
hi StatusLineNC guifg=black guibg=gray gui=none ctermfg=black ctermbg=gray term=none cterm=none
hi VertSplit    guifg=black guibg=gray gui=none ctermfg=black ctermbg=gray term=none cterm=none

hi Folded       guifg=darkred  guibg=lightgray gui=none ctermfg=black ctermbg=gray term=none cterm=none
hi FoldColumn   guifg=darkred  guibg=lightgray gui=none ctermfg=black ctermbg=gray term=none cterm=none
hi LineNr       guifg=#90f020           ctermfg=green cterm=none

hi DiffAdd      guibg=darkblue      ctermbg=darkblue    term=none       cterm=none
hi DiffChange   guibg=darkmagenta   ctermbg=magenta     cterm=none
hi DiffDelete   guifg=Blue          guibg=DarkCyan      ctermfg=blue    ctermbg=cyan gui=bold
hi DiffText     cterm=bold          ctermbg=red         gui=bold        guibg=Red

hi Cursor       guifg=#000020 guibg=#ffaf38 ctermfg=none ctermbg=brown
hi lCursor      guifg=#ffffff guibg=#000000 ctermfg=none ctermbg=darkgreen

hi Comment      guifg=#80a0dd       ctermfg=darkred
hi Constant     ctermfg=magenta     guifg=#ffa0a0 cterm=none
hi Special      ctermfg=brown       guifg=orange cterm=none gui=none
hi Identifier   ctermfg=red        guifg=orange cterm=none
hi Statement    ctermfg=darkyellow  guifg=darkyellow cterm=none gui=none
hi PreProc      ctermfg=magenta     guifg=#ff80ff gui=none cterm=none
hi type         ctermfg=darkyellow  guifg=#4B9696 gui=bold cterm=none
hi Underlined   cterm=underline     term=underline
hi coffeeObjAssign ctermfg=cyan guifg=cyan

if version >= 700 " Vim 7.x specific colors
  hi CursorLine     guifg=NONE        guibg=#333333     gui=NONE      ctermfg=NONE        ctermbg=NONE        cterm=underline
  hi CursorColumn   guifg=NONE        guibg=#121212     gui=NONE      ctermfg=NONE        ctermbg=NONE        cterm=BOLD
  hi MatchParen     guifg=#f6f3e8     guibg=#857b6f     gui=BOLD      ctermfg=white       ctermbg=darkgray    cterm=NONE
  hi Pmenu          guifg=#f6f3e8     guibg=#444444     gui=NONE      ctermfg=black       ctermbg=gray        cterm=NONE
  hi PmenuSel       guifg=#000000     guibg=#cae682     gui=NONE      ctermfg=white       ctermbg=red         cterm=NONE
  hi PmenuThumb     guifg=yellow      guibg=gray        gui=NONE      ctermfg=yellow        ctermbg=darkgray    cterm=NONE
  hi Search         guifg=NONE        guibg=NONE        gui=underline ctermfg=NONE        ctermbg=NONE        cterm=underline
  hi IncSearch      guifg=NONE        guibg=NONE        gui=underline ctermfg=NONE        ctermbg=NONE        cterm=underline
endif
