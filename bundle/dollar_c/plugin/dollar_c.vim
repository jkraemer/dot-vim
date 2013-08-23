" easy file opening:
" $c in commandline ergibt Pfad der aktuellen Datei
" C-x loescht in commandline rueckwaerts bis zum naechsten slash
func! Cwd()
  let cwd = getcwd()
  return "e " . cwd
endfunc

func! DeleteTillSlash()
  let cmd = getcmdline()
  let cmd_edited = substitute(cmd, "\\(.*/\\).*", "\\1", "")
  if cmd == cmd_edited
    let cmd_edited = substitute(cmd, "\\(.*/\\).*/", "\\1", "")
   endif
   return cmd_edited
endfunc

func! CurrentFileDir()
  return "e " . expand("%:p:h") . "/"
endfunc

cno $c e <C-\>eCurrentFileDir()<cr>
cmap <C-x> <C-\>eDeleteTillSlash()<CR>


