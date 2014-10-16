Status: 503 Service unavailable Content-type: text/html

PyukiWiki Runtime Error

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Undefined subroutine &main::_is_no_xhtml called at ./lib/wiki_sub.cgi line 288.
┌─────────────────────────────────────────┐
│                                    Trace Info                                    │
├─────┬───────────────┬───┬───────────────┤
│ Package  │             File             │ Line │           FUnction           │
├─────┼───────────────┼───┼───────────────┤
│main      │./lib/wiki_sub.cgi            │   288│Nana::Carp::err 0             │
├─────┴───────────────┴───┴───────────────┤
│285 : # Function init_dtd (wiki_html.cgi) # comment                               │
│286 : sub init_dtd {&load_wiki_module("html");return &_init_dtd(@_);}             │
│287 : # Function is_no_xhtml (wiki_html.cgi) # comment                            │
│288 : sub is_no_xhtml {&load_wiki_module("html");return &_is_no_xhtml(@_);}       │
│289 : # Function meta_robots (wiki_html.cgi) # comment                            │
│290 : sub meta_robots {&load_wiki_module("html");return &_meta_robots(@_);}       │
│291 : # Function text_to_html (wiki_html.cgi) # comment                           │
├─────┬───────────────┬───┬───────────────┤
│main      │./lib/wiki_html.cgi           │   136│main::is_no_xhtml 1           │
├─────┴───────────────┴───┴───────────────┤
│133 : );                                                                          │
│134 :                                                                             │
│135 : $::dtd=$::dtd{$::htmlmode};                                                 │
│136 : $::dtd=$::dtd{html4} if($::dtd eq '') || &is_no_xhtml(0);                   │
│137 : $::dtd.=qq(\n\n);                                                           │
│138 :                                                                             │
│139 : # XHTMLであるかのフラグを設定 # comment                                     │
├─────┬───────────────┬───┬───────────────┤
│main      │./lib/wiki_sub.cgi            │   286│main::_init_dtd 1             │
├─────┴───────────────┴───┴───────────────┤
│283 : # Function location (wiki_func.cgi) # comment                               │
│284 : sub location {&load_wiki_module("func");return &_location(@_);}             │
│285 : # Function init_dtd (wiki_html.cgi) # comment                               │
│286 : sub init_dtd {&load_wiki_module("html");return &_init_dtd(@_);}             │
│287 : # Function is_no_xhtml (wiki_html.cgi) # comment                            │
│288 : sub is_no_xhtml {&load_wiki_module("html");return &_is_no_xhtml(@_);}       │
│289 : # Function meta_robots (wiki_html.cgi) # comment                            │
├─────┬───────────────┬───┬───────────────┤
│main      │./lib/wiki.cgi                │   280│main::init_dtd 1              │
├─────┴───────────────┴───┴───────────────┤
│277 : &getbasehref;                                                               │
│278 :                                                                             │
│279 : &init_lang;                                                                 │
│280 : &init_dtd;                                                                  │
│281 : &init_global;                                                               │
│282 : &init_follow; #nocompact                                                    │
│283 : &skin_init;                                                                 │
├─────┬───────────────┬───┬───────────────┤
│main      │./lib/wiki.cgi                │   192│main::main 1                  │
├─────┴───────────────┴───┴───────────────┤
│189 : write => \&do_write,                                                        │
│190 : );                                                                          │
│191 :                                                                             │
│192 : &main;                                                                      │
│193 : exit(0);                                                                    │
│194 : ############################## # comment                                    │
│195 :                                                                             │
├─────┬───────────────┬───┬───────────────┤
│main      │index.cgi                     │    48│(eval) 1                      │
├─────┴───────────────┴───┴───────────────┤
│45 : # $::_conv_start = (times)[0];                                               │
│46 : #}                                                                           │
│47 :                                                                              │
│48 : require "$::sys_dir/wiki.cgi";                                               │
│49 :                                                                              │
│50 : __END__                                                                      │
│51 :                                                                              │
└─────────────────────────────────────────┘
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
                 PyukiWiki version 0.2.1-customoer-preview-utf8 pkgtype develop
                                  Build on 2014-02-11 22:22:59 BuildNumber 2348
                                                                   Server Admin
