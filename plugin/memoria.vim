" Vim memoria plugin file
" Maintainer: Polarsky

if exists('g:loaded_memoria')
  finish
endif
let g:loaded_memoria = 1

"===========================================================
" Global(s)
"===========================================================
" Global for time granularity
let g:memoriaGranularityMin = 15
let g:memoriaEnableBindings = 1

"===========================================================
" Commands
"===========================================================
" NOTE: User may use these to map commands to key bindings
command! Maday    call memoria#Day( 0 )
command! Matime   call memoria#Time( 0 )
command! Manew    call memoria#New( 0 )
command! Maupdate call memoria#Update( 0 )
command! Matodo   call memoria#Todo()
command! Madone   call memoria#Done()
command! Maplus   call memoria#IncrementTime( 1 )
command! Maminus  call memoria#IncrementTime( 0 )

"===========================================================
" Bindings
"===========================================================
" memoria filetype autocmd Bindings
augroup memoria
  autocmd!
  autocmd Filetype memoria setlocal shiftwidth=4 softtabstop=0 tabstop=4 expandtab
  autocmd Filetype memoria inoremap <buffer> <cr>  <cr><esc>0dwi
  autocmd Filetype memoria nnoremap <buffer> o     o<esc>0Di

  if ( 1 ==# g:memoriaEnableBindings )
    autocmd Filetype memoria nnoremap <buffer> <silent> <c-a> :call memoria#IncrementTime(1)<cr>
    autocmd Filetype memoria nnoremap <buffer> <silent> <c-x> :call memoria#IncrementTime(0)<cr>

    autocmd Filetype memoria iabbrev  <buffer> maday    <c-r>=memoria#Day( 1 )<cr><c-r>=memoria#EatChar( '\s' )<cr>
    autocmd Filetype memoria iabbrev  <buffer> matime   <c-r>=memoria#Time( 1 )<cr><c-r>=memoria#EatChar( '\s' )<cr>
    autocmd Filetype memoria iabbrev  <buffer> manew    <c-r>=memoria#New( 1 )<cr><c-r>=memoria#EatChar( '\s' )<cr>
    autocmd Filetype memoria iabbrev  <buffer> maupdate <c-r>=memoria#Update( 1 )<cr><c-r>=memoria#EatChar( '\s' )<cr>
    autocmd Filetype memoria iabbrev  <buffer> matodo   [_] TODO:
    autocmd Filetype memoria iabbrev  <buffer> madone   [X] DONE:
  endif
augroup END
