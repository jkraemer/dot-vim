
" * Text Formatting -- Specific File Formats

if !exists("autocommands_loaded")
  let autocommands_loaded = 1

  " treat anything at all with a .txt extension as being human-language text
  " [this clobbers the `help' filetype, but that doesn't seem to prevent help
  " from working properly]:
  augroup filetype
    autocmd BufNewFile,BufRead /tmp/mutt-* set filetype=mail
    autocmd BufNewFile,BufRead *.txt set filetype=human
    autocmd BufNewFile,BufRead *.html set filetype=html
  augroup END

  " in human-language files, automatically format everything at 72 chars:
  autocmd FileType mail,human set formatoptions+=t textwidth=72

  " for C-like programming, have automatic indentation:
  autocmd FileType c,cpp,slang set cindent

  " for actual C (not C++) programming where comments have explicit end
  " characters, if starting a new line in the middle of a comment automatically
  " insert the comment leader characters:
  autocmd FileType c set formatoptions+=ro

  " for Perl programming, have things in braces indenting themselves:
  autocmd FileType perl set smartindent

  " for CSS, also have things in braces indented:
  autocmd FileType css set smartindent

  " for HTML, generally format text, but if a long line has been created leave it
  " alone when editing:
  autocmd FileType html set formatoptions+=tl

  " for both CSS and HTML, use genuine tab characters for indentation, to make
  " files a few bytes smaller:
  " autocmd FileType html,css set noexpandtab tabstop=2

  " in makefiles, don't expand tabs to spaces, since actual tab characters are
  " needed, and have indentation at 8 chars to be sure that all indents are tabs
  " (despite the mappings later):
  autocmd FileType make set noexpandtab shiftwidth=8

endif
