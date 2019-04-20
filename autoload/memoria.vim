" Vim memoria plugin file
" Maintainer: Polarsky

if exists('g:autoloaded_memoria')
  finish
endif
let g:autoloaded_memoria = 1

"===========================================================
" Functions: Drawing
"===========================================================
" memoria#Day:
"   Weekday MM/DD
"   in:  boolean return str true:1 false:0
"   out: return str
function! memoria#Day( ret )
  let str = strftime( "%A %-m/%-d" )
  if ( 0 ==# a:ret )
    call s:AppendToCurrentLine( str )
    return ''
  else
    return str
  endif
endfunction

" memoria#Time:
"   Time range stamp
"   in:  boolean return str true:1 false:0
"   out: return str
function! memoria#Time( ret )
  let str = s:GetTimeRange()
  if ( 0 ==# a:ret )
    call s:AppendToCurrentLine( str )
    return ''
  else
    return str
  endif
endfunction

" memoria#New:
"   New (category entry)
"   in:  boolean return str true:1 false:0
"   out: return str
function! memoria#New( ret )
  let str = 'XXX (XXX (XXX)): XXX hours'
  if ( 0 ==# a:ret )
    call s:AppendToCurrentLine( str )
    return ''
  else
    return str
  endif
endfunction

" memoria#Update:
"   Update Hours (Update to time stamp line)
"   in:  boolean return str true:1 false:0
"   out: return str
function! memoria#Update( ret )
  let str = s:UpdateTimeStampLine()
  if ( 0 ==# a:ret )
    call s:SetCurrLine( str )
    return ''
  else
    execute "normal! \<esc>0Di"
    return str
  endif
endfunction

" memoria#Todo:
"   Replaces todo with done in current line
"   out: empty str
function! memoria#Todo()
  let l:save = winsaveview()
  s/\[X\] DONE:/\[_\] TODO:/e
  call winrestview(l:save)
  return ''
endfunction

" memoria#Done:
"   Replaces done with todo in current line
"   out: empty str
function! memoria#Done()
  let l:save = winsaveview()
  s/\[_\] TODO:/\[X\] DONE:/e
  call winrestview(l:save)
  return ''
endfunction

"===========================================================
" Functions: Formating
"===========================================================
" s:SetCurrLine:
"   in: string to replace line with
function! s:SetCurrLine( str )
  call setline( line( '.' ), a:str )
endfunction

" s:AppendToCurrentLine:
"   in: string to replace line with
function! s:AppendToCurrentLine( str )
  call append( line('.'), a:str )
  normal! J
endfunction

" Remove a character matching pattern
"   in:  takes in a patter
function! memoria#EatChar( pat )
  let c = nr2char( getchar( 0 ) )
  return ( c =~ a:pat ) ? '' : c
endfunction

" s:PostPad:
"   in:  string
"   in:  pad length
"   in:  char to pad with
"   Note: PostPad str with pad numer of char's
function! s:PostPad( str, pad, ... )
  if a:0 > 0
    let char = a:1
  else
    let char = ' '
  endif

  return a:str . repeat( char, a:pad - len( a:str ) )
endfunction

" s:PrePad:
"   in:  string
"   in:  pad length
"   in:  char to pad with
"   Note: PrePad str with pad numer of char's
function! s:PrePad( str, pad, ... )
  if a:0 > 0
    let char = a:1
  else
    let char = ' '
  endif
  return repeat( char, a:pad - len( a:str ) ) . a:str
endfunction

"===========================================================
" Functions: Regex Matching
"===========================================================
" s:IsComment:
"   in:  string line
"   out: boolean
"   Note: Checks if string line given is a comment string
function! s:IsComment( str )
  let match = matchstr( a:str , "#.*$" )
  return !empty( match )
endfunction

" s:IsTimeStamp:
"   in:  string word
"   out: boolean
"   Note: Checks if string word given is a time stamp
function! s:IsTimeStamp( str )
  let match = matchstr( a:str , "[0-9][0-9]:[0-9][0-9]" )
  return !empty( match )
endfunction

"===========================================================
" Functions: Time String Parsing
"===========================================================
" s:GetTimeRange:
"   Note: Returns a string of g:s:Granularity invervals
function! s:GetTimeRange()
  let min   = strftime( "%M" )
  let n_min = min
  let hr    = strftime( "%H" )
  let n_hr  = hr
  let granu = s:GetGranularity()

  if ( granu/2 > float2nr( fmod( min*1.0 , granu ) ) )
    let min = float2nr( floor( min / (granu*1.0) ) ) * granu
  else
    let min = float2nr( ceil( min / (granu*1.0) ) ) * granu
  endif
  let n_min = min

  if ( 60 ==# min )
    let min    = 0
    let n_min  = granu
    let hr    += 1
    let n_hr   = hr
  else
    let n_min += granu
    if ( 60 ==# n_min )
      let n_min = 0
      let n_hr += 1
    endif
  endif

  let str_t1 = s:PrePad( hr, 2, '0' )   . ':' . s:PrePad( min, 2, '0' )
  let str_t2 = s:PrePad( n_hr, 2, '0' ) . ':' . s:PrePad( n_min, 2, '0' )

  return str_t1 . '-' . str_t2
endfunction

" s:GetTimeStampRanges:
"   in:  a line string
"   out: a string of time stamp ranges found in that line string
"   Note: returns string of all time stamp ranges in line
"   XXX: Does not remove repeated time stamp ranges
function! s:GetTimeStampRanges( str )
  let stamp_ranges = ''

  if ( !s:IsComment( a:str ) )
    let line_arr = split( a:str )
    for word in line_arr
      if ( s:IsTimeStamp( word ) )
        let stamp_ranges = stamp_ranges . word . ' '
      endif
    endfor
  endif

  return stamp_ranges
endfunction

" s:GetTimeStamps:
"   in:  a line string
"   out: a string of time stamps found in that line string
"   Note: empty string returned for comment lines
"   XXX: Does not remove repeated time stamp ranges
function! s:GetTimeStamps( str )
  let stamps = ''

  if ( !s:IsComment( a:str ) )
    let line_arr = split( a:str )
    for word in line_arr
      let word_arr = split( word, '-' )
      for sword in word_arr
        if ( s:IsTimeStamp( sword ) )
          let stamps = stamps . sword . ' '
        endif
      endfor
    endfor
  endif

  return stamps
endfunction

" s:SumOfTimeStamps:
"   in:  string of time stamps like so:
"        00:00-00:00 00:00-00:00
"   out: string of the float of total hours found in time stamps
"   Note: Adds time stamp ranges
"   XXX: Function does not check for invalid timestamps
function! s:SumOfTimeStamps( time_stamps )
  let time_stamps_arr = split( a:time_stamps )
  let hrs_sum         = 0

  for time in time_stamps_arr
    let time    = split( time, ':' )
    let hr      = time[0]*1.0 + time[1]/60.0
    let hrs_sum = abs( hr - hrs_sum )
  endfor

  return s:Float2Str( hrs_sum )
endfunction

" s:UpdateTimeStampLine:
"   in:  gets current line at cursor
"   out: appends to end of current line at cursor total hours
"   Note: current line at cursor must not be a comment line
"         or line not containing solely timestamps
function! s:UpdateTimeStampLine()
  let curr_line = getline( '.' )
  if ( s:IsComment( curr_line ) )
    echom 'memoria:Error: Line is a comment cannot update time'
    return curr_line
  endif

  let stamps = s:GetTimeStamps( curr_line )
  if ( empty( stamps ) )
    echom 'memoria:Error: Line contains no time stamps'
    return curr_line
  endif

  let hrs = s:SumOfTimeStamps( stamps )
  if ( empty( hrs ) )
    let hrs = '0'
  endif

  let stamp_ranges = s:GetTimeStampRanges( curr_line )
  normal! 0D
  return stamp_ranges . '(' . hrs . ' hours)'
endfunction

" s:IncrementTime:
"   Increment time stamp/val under cursor
"   in:   1=add 0=sub, by g:memoriaGranularityMin
function! memoria#IncrementTime( op )
  let l:save = winsaveview()
  let str_cursor  = strpart( getline('.'), col('.')-5, 9 )
  let stamp = matchstr( str_cursor , '\v[0-9][0-9]:[0-9][0-9]' )
  let val   = matchstr( str_cursor , '\v([0-9]+([.][0-9]*)?|[.][0-9]+)' )
  let symb  = matchstr( str_cursor , '-' )
  let granu = s:GetGranularity()

  if ( !empty( stamp ) )
    let str = split( stamp, ':' )
    let hr    = str[0]
    let min   = str[1]

    " Add granu option
    if ( 1 ==# a:op )
      let min += granu
      let str  = ''

      if ( min >= 60 )
        let min = min - 60
        if ( 23 ==# hr )
          let hr = 0
        else
          let hr += 1
        endif
      endif
    " sub granu option
    else
      let min -= granu
      if ( min < 0 )
        let min = 60 + min
        if ( 0 ==# hr )
          let hr = 23
        else
          let hr -= 1
        endif
      endif
    endif

    let str = s:PrePad( hr, 2, '0' ) . ':' . s:PrePad( min, 2, '0' )
    execute 's/' . stamp . '/' . str . '/e'

  elseif ( !empty( val ) && empty( symb ) )
    let str = ''
    let res = str2float( val )
    let inc = (granu*1.0)/60.0

    " Add granu option
    if ( 1 ==# a:op )
      let res += inc
    " sub granu option
    else
      let res -= inc
      if ( res < 0 )
        let res = 0
      endif
    endif

    let str = s:Float2Str( res )
    execute 's/' . val . '/' . str . '/e'
  endif
  call winrestview(l:save)
endfunction

" s:GetGranularity:
"   returns a floored integer value between 1-30
function! s:GetGranularity()
  let granu = float2nr( floor( g:memoriaGranularityMin*1.0 ) )
  if ( granu <= 0 || granu > 30 )
    let granu = 15
  endif
  return granu
endfunction

" s:Float2Str:
"   in:  float
"   out: str of that float
function! s:Float2Str( flt )
  let inte = float2nr( a:flt )
  let frac = float2nr( (a:flt - inte*1.0) * 100 )

  if ( 0 ==# frac )
    return inte
  else
    return inte . '.' . frac
  endif
endfunction
