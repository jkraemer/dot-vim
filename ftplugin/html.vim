" * Keystrokes -- For HTML Files

" Some automatic HTML tag insertion operations are defined next.  They are
" allset to normal mode keystrokes beginning \h.  Insert mode function keys are
" also defined, for terminals where they work.  The functions referred to are
" defined at the end of this .vimrc.

" \hc ("HTML close") inserts the tag needed to close the current HTML construct
" [function at end of file]:
nnoremap \hc :call InsertCloseTag()<CR>
imap <F8> <Space><BS><Esc>\hca

" \hp ("HTML previous") copies the previous (non-closing) HTML tag in full,
" including attributes; repeating this straight away removes that tag and
" copies the one before it [function at end of file]:
nnoremap \hp :call RepeatTag(0)<CR>
imap <F9> <Space><BS><Esc>\hpa
" \hn ("HTML next") does the same thing, but copies the next tag; so \hp and
" \hn can be used to cycle backwards and forwards through the tags in the file
" (like <Ctrl>+P and <Ctrl>+N do for insert mode completion):
nnoremap \hn :call RepeatTag(1)<CR>
imap <F10> <Space><BS><Esc>\hna

" there are other key mappings that it's useful to have for typing HTML
" character codes, but that are definitely not wanted in other files (unlike
" the above, which won't do any harm), so only map these when entering an HTML
" file and unmap them on leaving it:
autocmd BufEnter * if &filetype == "html" | call MapHTMLKeys() | endif
function! MapHTMLKeys(...)
" sets up various insert mode key mappings suitable for typing HTML, and
" automatically removes them when switching to a non-HTML buffer

  " if no parameter, or a non-zero parameter, set up the mappings:
  if a:0 == 0 || a:1 != 0

    " require two backslashes to get one:
    inoremap \\ \

    " then use backslash followed by various symbols insert HTML characters:
    inoremap \& &amp;
    inoremap \< &lt;
    inoremap \> &gt;
    inoremap \. &middot;

    " em dash -- have \- always insert an em dash, and also have _ do it if
    " ever typed as a word on its own, but not in the middle of other words:
    inoremap \- &#8212;
    " iabbrev _ &#8212;

    " hard space with <Ctrl>+Space, and \<Space> for when that doesn't work:
    inoremap \<Space> &nbsp;
    imap <C-Space> \<Space>

    " have the normal open and close single quote keys producing the character
    " codes that will produce nice curved quotes (and apostophes) on both Unix
    " and Windows:
    " inoremap ` &#8216;
    " inoremap ' &#8217;
    " then provide the original functionality with preceding backslashes:
    " inoremap \` `
    " inoremap \' '

    " curved double open and closed quotes (2 and " are the same key for me):
    inoremap \2 &#8220;
    inoremap \" &#8221;

    " when switching to a non-HTML buffer, automatically undo these mappings:
    autocmd! BufLeave * call MapHTMLKeys(0)

  " parameter of zero, so want to unmap everything:
  else
    iunmap \\
    iunmap \&
    iunmap \<
    iunmap \>
    iunmap \-
    " iunabbrev _
    iunmap \<Space>
    iunmap <C-Space>
    "iunmap `
    "iunmap '
    "iunmap \`
    "iunmap \'
    iunmap \2
    iunmap \"

    " once done, get rid of the autocmd that called this:
    autocmd! BufLeave *

  endif " test for mapping/unmapping

endfunction " MapHTMLKeys()


function! InsertCloseTag()
" inserts the appropriate closing HTML tag; used for the \hc operation defined
" above;
" requires ignorecase to be set, or to type HTML tags in exactly the same case
" that I do;
" doesn't treat <P> as something that needs closing;
" clobbers register z and mark z
" 
" by Smylers  http://www.stripey.com/vim/
" 2000 May 4

  if &filetype == 'html' || &filetype == 'eruby' || &filetype == 'aspnet'

    " list of tags which shouldn't be closed:
    let UnaryTags = ' area base br dd dt hr img input link meta '

    " remember current position:
    normal mz

    " loop backwards looking for tags:
    let Found = 0
    while Found == 0
      " find the previous < (but not one which is followed by %), 
      " then go forwards one character and grab the first
      " character plus the entire word:
      execute "normal ?\<LT>[^%]\<CR>l"
      normal "zyl
      let Tag = expand('<cword>')

      " if this is a closing tag skip back to its matching opening tag:
      if @z == '/'
        execute "normal ?\<LT>" . Tag . "\<CR>"

      " if this is a unary tag, then position the cursor for the next
      " iteration:
      elseif match(UnaryTags, ' ' . Tag . ' ') > 0
        normal h

      " otherwise this is the tag that needs closing:
      else
        let Found = 1

      endif
    endwhile " not yet found match

    " create the closing tag and insert it:
    let @z = '</' . Tag . '>'
    normal `z
    if col('.') == 1
      normal "zP
    else
      normal "zp
    endif

  else " filetype is not HTML
    echohl ErrorMsg
    echo 'The InsertCloseTag() function is only intended to be used in HTML ' .
      \ 'files.'
    sleep
    echohl None

  endif " check on filetype

endfunction " InsertCloseTag()

function! RepeatTag(Forward)
" repeats a (non-closing) HTML tag from elsewhere in the document; call
" repeatedly until the correct tag is inserted (like with insert mode <Ctrl>+P
" and <Ctrl>+N completion), with Forward determining whether to copy forwards
" or backwards through the file; used for the \hp and \hn operations defined
" above;
" requires preservation of marks i and j;
" clobbers register z
"
" by Smylers  http://www.stripey.com/vim/
"
" 2000 May 4: for `Vim' 5.6

  if &filetype == 'html'

    " if the cursor is where this function left it, then continue from there:
    if line('.') == line("'i") && col('.') == col("'i")
      " delete the tag inserted last time:
      if col('.') == strlen(getline('.'))
        normal dF<x
      else
        normal dF<x
        if col('.') != 1
          normal h
        endif
      endif
      " note the cursor position, then jump to where the deleted tag was found:
      normal mi`j

    " otherwise, just store the cursor position (in mark i):
    else
      normal mi
    endif

    if a:Forward
      let SearchCmd = '/'
    else
      let SearchCmd = '?'
    endif

    " find the next non-closing tag (in the appropriate direction), note where
    " it is (in mark j) in case this function gets called again, then yank it
    " and paste a copy at the original cursor position, and store the final
    " cursor position (in mark i) for use next time round:
    execute "normal " . SearchCmd . "<[^/>].\\{-}>\<CR>mj\"zyf>`i"
    if col('.') == 1
      normal "zP
    else
      normal "zp
    endif
    normal mi

  else " filetype is not HTML
    echohl ErrorMsg
    echo 'The RepeatTag() function is only intended to be used in HTML files.'
    sleep
    echohl None

  endif

endfunction " RepeatTag()

