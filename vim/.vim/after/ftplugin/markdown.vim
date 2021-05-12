" r Automatically insert the current comment leader after hitting
"   <Enter> in Insert mode.
" o Automatically insert the current comment leader after hitting 'o' or
"   'O' in Normal mode.
set formatoptions+=ro

" The 'comments' option is a comma-separated list of parts.
" Each part defines a type of comment string.
" A part consists of: {flags}:{string}

" {string} is the literal text that must appear.

" {flags}:
"   n Nested comment.  Nesting with mixed parts is allowed.
"   b Blank (<Space>, <Tab> or <EOL>) required after {string}.
set comments=b:*,b:-,b:+,b:1.,n:>
set comments=b:*,b:-,b:+,b:1.,n:>
