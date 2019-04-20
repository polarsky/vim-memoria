" Vim memoria syntax file
" Maintainer: Polarsky

if exists("b:current_syntax")
  finish
endif

" memoria Keywords for special emphasis
syn keyword memoriaTodo    TODO FIXME XXX EPS 000 contained
syn keyword memoriaFill    TODO FIXME XXX EPS 000
syn keyword memoriaDays    Sunday Monday Tuesday Wednesday Thursday Friday Saturday
syn keyword memoriaDays    Sun    Mon    Tues    Wed       Thurs    Fri    Sat
syn keyword memoriaTime    YEAR    Year    YY  Yr  year    yr
syn keyword memoriaTime    YEARS   Years       Yrs years   yrs
syn keyword memoriaTime    MONTH   Month   MM      month
syn keyword memoriaTime    MONTHS  Months          months
syn keyword memoriaTime    DAY     Day     DD      day
syn keyword memoriaTime    DAYS    Days            days
syn keyword memoriaTime    HOUR    Hour    HR  Hr  hour    hr
syn keyword memoriaTime    HOURS   Hours   HRS Hrs hours   hrs
syn keyword memoriaTime    MINUTES Minutes MIN Min minutes min
syn keyword memoriaTime    SECONDS Seconds SEC Sec seconds sec

" Comments
syn match   memoriaComment "#.*$"  display contains=memoriaTodo,@Spell

" Numericals
syn match   memoriaNumber  "\<\d\>"                                 display
syn match   memoriaNumber  "\<[0-9]\d\+\>"                          display
syn match   memoriaNumber  "\<\d\+[jJ]\>"                           display
syn match   memoriaFloat   "\.\d\+\%([eE][+-]\=\d\+\)\=[jJ]\=\>"    display
syn match   memoriaFloat   "\<\d\+[eE][+-]\=\d\+[jJ]\=\>"           display
syn match   memoriaFloat   "\<\d\+\.\d*\%([eE][+-]\=\d\+\)\=[jJ]\=" display

" Identifiers
syn match   memoriaParen   "[(|)|):]"                   display
syn match   memoriaDate    "\s*[0-9]*[0-9]/[0-9]*[0-9]" display
syn match   memoriaStamp   "[0-9][0-9]:[0-9][0-9]"      display

if version >= 508 || !exists("did_memoria_syn_inits")
  if version <= 508
    let did_memoria_syn_inits = 1
    command -nargs=+ HiLink hi link <args>
  else
    command -nargs=+ HiLink hi def link <args>
  endif

  " link matches to native vim highlight groups
  HiLink memoriaTodo    Todo
  HiLink memoriaFill    Todo
  HiLink memoriaDays    VisualNOS
  HiLink memoriaTime    Statement
  HiLink memoriaComment Comment
  HiLink memoriaFloat   Float
  HiLink memoriaNumber  Number
  HiLink memoriaParen   Define
  HiLink memoriaDate    VisualNOS
  HiLink memoriaStamp   Type
endif

let b:current_syntax = "memoria"
