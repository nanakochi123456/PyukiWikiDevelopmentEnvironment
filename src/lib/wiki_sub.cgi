######################################################################
# @@HEADER1@@
######################################################################
# This is auto generation code
######################################################################

=head1 NAME

wiki_sub.cgi - This is PyukiWiki, yet another Wiki clone.

=head1 SEE ALSO

=over 4

=item PyukiWiki/Dev/Specification/wiki_sub.cgi

L<@@BASEURL@@/PyukiWiki/Dev/Specification/wiki_sub.cgi/>

=item PyukiWiki CVS

L<@@CVSURL@@/PyukiWiki-Devel/lib/wiki_sub.cgi>

=back

=head1 AUTHOR

=over 4

@@AUTHOR_NEKYO@@

@@AUTHOR_NANAMI@@

@@AUTHOR_PYUKI@@

=back

=head1 LICENSE

@@LICENSE_NEKYO@@

=cut

%::functions = (
"valid_password"=>\&valid_password,
"passwordform"=>\&passwordform,
"authadminpassword"=>\&authadminpassword,
"password_decode"=>\&password_decode,
"password_encode"=>\&password_encode,
"iscryptpass"=>\&iscryptpass,
"maketoken"=>\&maketoken,
"open_db"=>\&open_db,
"open_info_db"=>\&open_info_db,
"dbopen"=>\&dbopen,
"dbopen_gz"=>\&dbopen_gz,
"close_db"=>\&close_db,
"close_info_db"=>\&close_info_db,
"dbclose"=>\&dbclose,
"open_diff"=>\&open_diff,
"close_diff"=>\&close_diff,
"open_backup"=>\&open_backup,
"close_backup"=>\&close_backup,
"init_db"=>\&init_db,
"getbasehref"=>\&getbasehref,
"jscss_include"=>\&jscss_include,
"getcookie"=>\&getcookie,
"setcookie"=>\&setcookie,
"read_resource"=>\&read_resource,
"armor_name"=>\&armor_name,
"unarmor_name"=>\&unarmor_name,
"is_bracket_name"=>\&is_bracket_name,
"dbmname"=>\&dbmname,
"undbmname"=>\&undbmname,
"decode"=>\&decode,
"encode"=>\&encode,
"get_now"=>\&get_now,
"load_module"=>\&load_module,
"code_convert"=>\&code_convert,
"is_exist_page"=>\&is_exist_page,
"replace"=>\&replace,
"trim"=>\&trim,
"escape"=>\&escape,
"unescape"=>\&unescape,
"htmlspecialchars"=>\&htmlspecialchars,
"javascriptspecialchars"=>\&javascriptspecialchars,
"strcutbytes"=>\&strcutbytes,
"strcutbytes_utf8"=>\&strcutbytes_utf8,
"fopen"=>\&fopen,
"escapeoff"=>\&escapeoff,
"gettz"=>\&gettz,
"getwday"=>\&getwday,
"lastday"=>\&lastday,
"dateinit"=>\&dateinit,
"date"=>\&date,
"http_date"=>\&http_date,
"getremotehost"=>\&getremotehost,
"safe_open"=>\&safe_open,
"location"=>\&location,
"init_dtd"=>\&init_dtd,
"is_no_xhtml"=>\&is_no_xhtml,
"meta_robots"=>\&meta_robots,
"text_to_html"=>\&text_to_html,
"highlight"=>\&highlight,
"pageanchorname"=>\&pageanchorname,
"makeanchor"=>\&makeanchor,
"inlinetext"=>\&inlinetext,
"back_push"=>\&back_push,
"inline"=>\&inline,
"note"=>\&note,
"content_output"=>\&content_output,
"compress_output"=>\&compress_output,
"http_header"=>\&http_header,
"writablecheck"=>\&writablecheck,
"writechk"=>\&writechk,
"init_global"=>\&init_global,
"init_lang"=>\&init_lang,
"init_form"=>\&init_form,
"gzip_init"=>\&gzip_init,
"skin_init"=>\&skin_init,
"skin_check"=>\&skin_check,
"init_InterWikiName"=>\&init_InterWikiName,
"init_inline_regex"=>\&init_inline_regex,
"init_follow"=>\&init_follow,
"make_link"=>\&make_link,
"make_link_wikipage"=>\&make_link_wikipage,
"make_link_interwiki"=>\&make_link_interwiki,
"make_cookedurl"=>\&make_cookedurl,
"make_link_mail"=>\&make_link_mail,
"make_link_url"=>\&make_link_url,
"make_link_target"=>\&make_link_target,
"make_link_urlhref"=>\&make_link_urlhref,
"make_link_image"=>\&make_link_image,
"exec_plugin"=>\&exec_plugin,
"exec_explugin"=>\&exec_explugin,
"exec_explugin_sub"=>\&exec_explugin_sub,
"exist_plugin"=>\&exist_plugin,
"exist_explugin"=>\&exist_explugin,
"exec_explugin_last"=>\&exec_explugin_last,
"embedded_to_html"=>\&embedded_to_html,
"embedded_inline"=>\&embedded_inline,
"skinex"=>\&skinex,
"maketitle"=>\&maketitle,
"convtime"=>\&convtime,
"skinhead"=>\&skinhead,
"makenavigator"=>\&makenavigator,
"makenavigator_sub1"=>\&makenavigator_sub1,
"makenavigator_sub2"=>\&makenavigator_sub2,
"makenavigator_sub3"=>\&makenavigator_sub3,
"navi_toolbar"=>\&navi_toolbar,
"skin_footer"=>\&skin_footer,
"snapshot"=>\&snapshot,
"spam_filter"=>\&spam_filter,
"do_read"=>\&do_read,
"print_content"=>\&print_content,
"topicpath"=>\&topicpath,
"get_fullname"=>\&get_fullname,
"get_subjectline"=>\&get_subjectline,
"get_info"=>\&get_info,
"is_frozen"=>\&is_frozen,
"is_readable"=>\&is_readable,
"is_editable"=>\&is_editable,
"interwiki_convert"=>\&interwiki_convert,
"set_info"=>\&set_info,
"disablewords"=>\&disablewords,
"do_write"=>\&do_write,
"do_backup"=>\&do_backup,
"do_write_page"=>\&do_write_page,
"do_write_info"=>\&do_write_info,
"do_delete_page"=>\&do_delete_page,
"do_delete_info"=>\&do_delete_info,
"do_write_after"=>\&do_write_after,
"conflict"=>\&conflict,
"update_recent_changes"=>\&update_recent_changes,
"send_mail_to_admin"=>\&send_mail_to_admin,
"read_by_part"=>\&read_by_part,
"frozen_reject"=>\&frozen_reject,
);
# Function valid_password (wiki_auth.cgi)				# comment
sub valid_password {&load_wiki_module("auth");return &_valid_password(@_);}
# Function passwordform (wiki_auth.cgi)				# comment
sub passwordform {&load_wiki_module("auth");return &_passwordform(@_);}
# Function authadminpassword (wiki_auth.cgi)				# comment
sub authadminpassword {&load_wiki_module("auth");return &_authadminpassword(@_);}
# Function password_decode (wiki_auth.cgi)				# comment
sub password_decode {&load_wiki_module("auth");return &_password_decode(@_);}
# Function password_encode (wiki_auth.cgi)				# comment
sub password_encode {&load_wiki_module("auth");return &_password_encode(@_);}
# Function iscryptpass (wiki_auth.cgi)				# comment
sub iscryptpass {&load_wiki_module("auth");return &_iscryptpass(@_);}
# Function maketoken (wiki_auth.cgi)				# comment
sub maketoken {&load_wiki_module("auth");return &_maketoken(@_);}
# Function open_db (wiki_db.cgi)				# comment
sub open_db {&load_wiki_module("db");return &_open_db(@_);}
# Function open_info_db (wiki_db.cgi)				# comment
sub open_info_db {&load_wiki_module("db");return &_open_info_db(@_);}
# Function dbopen (wiki_db.cgi)				# comment
sub dbopen {&load_wiki_module("db");return &_dbopen(@_);}
# Function dbopen_gz (wiki_db.cgi)				# comment
sub dbopen_gz {&load_wiki_module("db");return &_dbopen_gz(@_);}
# Function close_db (wiki_db.cgi)				# comment
sub close_db {&load_wiki_module("db");return &_close_db(@_);}
# Function close_info_db (wiki_db.cgi)				# comment
sub close_info_db {&load_wiki_module("db");return &_close_info_db(@_);}
# Function dbclose (wiki_db.cgi)				# comment
sub dbclose {&load_wiki_module("db");return &_dbclose(@_);}
# Function open_diff (wiki_db.cgi)				# comment
sub open_diff {&load_wiki_module("db");return &_open_diff(@_);}
# Function close_diff (wiki_db.cgi)				# comment
sub close_diff {&load_wiki_module("db");return &_close_diff(@_);}
# Function open_backup (wiki_db.cgi)				# comment
sub open_backup {&load_wiki_module("db");return &_open_backup(@_);}
# Function close_backup (wiki_db.cgi)				# comment
sub close_backup {&load_wiki_module("db");return &_close_backup(@_);}
# Function init_db (wiki_db.cgi)				# comment
sub init_db {&load_wiki_module("db");return &_init_db(@_);}
# Function getbasehref (wiki_func.cgi)				# comment
sub getbasehref {&load_wiki_module("func");return &_getbasehref(@_);}
# Function jscss_include (wiki_func.cgi)				# comment
sub jscss_include {&load_wiki_module("func");return &_jscss_include(@_);}
# Function getcookie (wiki_func.cgi)				# comment
sub getcookie {&load_wiki_module("func");return &_getcookie(@_);}
# Function setcookie (wiki_func.cgi)				# comment
sub setcookie {&load_wiki_module("func");return &_setcookie(@_);}
# Function read_resource (wiki_func.cgi)				# comment
sub read_resource {&load_wiki_module("func");return &_read_resource(@_);}
# Function armor_name (wiki_func.cgi)				# comment
sub armor_name {&load_wiki_module("func");return &_armor_name(@_);}
# Function unarmor_name (wiki_func.cgi)				# comment
sub unarmor_name {&load_wiki_module("func");return &_unarmor_name(@_);}
# Function is_bracket_name (wiki_func.cgi)				# comment
sub is_bracket_name {&load_wiki_module("func");return &_is_bracket_name(@_);}
# Function dbmname (wiki_func.cgi)				# comment
sub dbmname {&load_wiki_module("func");return &_dbmname(@_);}
# Function undbmname (wiki_func.cgi)				# comment
sub undbmname {&load_wiki_module("func");return &_undbmname(@_);}
# Function decode (wiki_func.cgi)				# comment
sub decode {&load_wiki_module("func");return &_decode(@_);}
# Function encode (wiki_func.cgi)				# comment
sub encode {&load_wiki_module("func");return &_encode(@_);}
# Function get_now (wiki_func.cgi)				# comment
sub get_now {&load_wiki_module("func");return &_get_now(@_);}
# Function load_module (wiki_func.cgi)				# comment
sub load_module {&load_wiki_module("func");return &_load_module(@_);}
# Function code_convert (wiki_func.cgi)				# comment
sub code_convert {&load_wiki_module("func");return &_code_convert(@_);}
# Function is_exist_page (wiki_func.cgi)				# comment
sub is_exist_page {&load_wiki_module("func");return &_is_exist_page(@_);}
# Function replace (wiki_func.cgi)				# comment
sub replace {&load_wiki_module("func");return &_replace(@_);}
# Function trim (wiki_func.cgi)				# comment
sub trim {&load_wiki_module("func");return &_trim(@_);}
# Function escape (wiki_func.cgi)				# comment
sub escape {&load_wiki_module("func");return &_escape(@_);}
# Function unescape (wiki_func.cgi)				# comment
sub unescape {&load_wiki_module("func");return &_unescape(@_);}
# Function htmlspecialchars (wiki_func.cgi)				# comment
sub htmlspecialchars {&load_wiki_module("func");return &_htmlspecialchars(@_);}
# Function javascriptspecialchars (wiki_func.cgi)				# comment
sub javascriptspecialchars {&load_wiki_module("func");return &_javascriptspecialchars(@_);}
# Function strcutbytes (wiki_func.cgi)				# comment
sub strcutbytes {&load_wiki_module("func");return &_strcutbytes(@_);}
# Function strcutbytes_utf8 (wiki_func.cgi)				# comment
sub strcutbytes_utf8 {&load_wiki_module("func");return &_strcutbytes_utf8(@_);}
# Function fopen (wiki_func.cgi)				# comment
sub fopen {&load_wiki_module("func");return &_fopen(@_);}
# Function escapeoff (wiki_func.cgi)				# comment
sub escapeoff {&load_wiki_module("func");return &_escapeoff(@_);}
# Function gettz (wiki_func.cgi)				# comment
sub gettz {&load_wiki_module("func");return &_gettz(@_);}
# Function getwday (wiki_func.cgi)				# comment
sub getwday {&load_wiki_module("func");return &_getwday(@_);}
# Function lastday (wiki_func.cgi)				# comment
sub lastday {&load_wiki_module("func");return &_lastday(@_);}
# Function dateinit (wiki_func.cgi)				# comment
sub dateinit {&load_wiki_module("func");return &_dateinit(@_);}
# Function date (wiki_func.cgi)				# comment
sub date {&load_wiki_module("func");return &_date(@_);}
# Function http_date (wiki_func.cgi)				# comment
sub http_date {&load_wiki_module("func");return &_http_date(@_);}
# Function getremotehost (wiki_func.cgi)				# comment
sub getremotehost {&load_wiki_module("func");return &_getremotehost(@_);}
# Function safe_open (wiki_func.cgi)				# comment
sub safe_open {&load_wiki_module("func");return &_safe_open(@_);}
# Function location (wiki_func.cgi)				# comment
sub location {&load_wiki_module("func");return &_location(@_);}
# Function init_dtd (wiki_html.cgi)				# comment
sub init_dtd {&load_wiki_module("html");return &_init_dtd(@_);}
# Function is_no_xhtml (wiki_html.cgi)				# comment
sub is_no_xhtml {&load_wiki_module("html");return &_is_no_xhtml(@_);}
# Function meta_robots (wiki_html.cgi)				# comment
sub meta_robots {&load_wiki_module("html");return &_meta_robots(@_);}
# Function text_to_html (wiki_html.cgi)				# comment
sub text_to_html {&load_wiki_module("html");return &_text_to_html(@_);}
# Function highlight (wiki_html.cgi)				# comment
sub highlight {&load_wiki_module("html");return &_highlight(@_);}
# Function pageanchorname (wiki_html.cgi)				# comment
sub pageanchorname {&load_wiki_module("html");return &_pageanchorname(@_);}
# Function makeanchor (wiki_html.cgi)				# comment
sub makeanchor {&load_wiki_module("html");return &_makeanchor(@_);}
# Function inlinetext (wiki_html.cgi)				# comment
sub inlinetext {&load_wiki_module("html");return &_inlinetext(@_);}
# Function back_push (wiki_html.cgi)				# comment
sub back_push {&load_wiki_module("html");return &_back_push(@_);}
# Function inline (wiki_html.cgi)				# comment
sub inline {&load_wiki_module("html");return &_inline(@_);}
# Function note (wiki_html.cgi)				# comment
sub note {&load_wiki_module("html");return &_note(@_);}
# Function content_output (wiki_http.cgi)				# comment
sub content_output {&load_wiki_module("http");return &_content_output(@_);}
# Function compress_output (wiki_http.cgi)				# comment
sub compress_output {&load_wiki_module("http");return &_compress_output(@_);}
# Function http_header (wiki_http.cgi)				# comment
sub http_header {&load_wiki_module("http");return &_http_header(@_);}
# Function writablecheck (wiki_init.cgi)				# comment
sub writablecheck {&load_wiki_module("init");return &_writablecheck(@_);}
# Function writechk (wiki_init.cgi)				# comment
sub writechk {&load_wiki_module("init");return &_writechk(@_);}
# Function init_global (wiki_init.cgi)				# comment
sub init_global {&load_wiki_module("init");return &_init_global(@_);}
# Function init_lang (wiki_init.cgi)				# comment
sub init_lang {&load_wiki_module("init");return &_init_lang(@_);}
# Function init_form (wiki_init.cgi)				# comment
sub init_form {&load_wiki_module("init");return &_init_form(@_);}
# Function gzip_init (wiki_init.cgi)				# comment
sub gzip_init {&load_wiki_module("init");return &_gzip_init(@_);}
# Function skin_init (wiki_init.cgi)				# comment
sub skin_init {&load_wiki_module("init");return &_skin_init(@_);}
# Function skin_check (wiki_init.cgi)				# comment
sub skin_check {&load_wiki_module("init");return &_skin_check(@_);}
# Function init_InterWikiName (wiki_init.cgi)				# comment
sub init_InterWikiName {&load_wiki_module("init");return &_init_InterWikiName(@_);}
# Function init_inline_regex (wiki_init.cgi)				# comment
sub init_inline_regex {&load_wiki_module("init");return &_init_inline_regex(@_);}
# Function init_follow (wiki_init.cgi)				# comment
sub init_follow {&load_wiki_module("init");return &_init_follow(@_);}
# Function make_link (wiki_link.cgi)				# comment
sub make_link {&load_wiki_module("link");return &_make_link(@_);}
# Function make_link_wikipage (wiki_link.cgi)				# comment
sub make_link_wikipage {&load_wiki_module("link");return &_make_link_wikipage(@_);}
# Function make_link_interwiki (wiki_link.cgi)				# comment
sub make_link_interwiki {&load_wiki_module("link");return &_make_link_interwiki(@_);}
# Function make_cookedurl (wiki_link.cgi)				# comment
sub make_cookedurl {&load_wiki_module("link");return &_make_cookedurl(@_);}
# Function make_link_mail (wiki_link.cgi)				# comment
sub make_link_mail {&load_wiki_module("link");return &_make_link_mail(@_);}
# Function make_link_url (wiki_link.cgi)				# comment
sub make_link_url {&load_wiki_module("link");return &_make_link_url(@_);}
# Function make_link_target (wiki_link.cgi)				# comment
sub make_link_target {&load_wiki_module("link");return &_make_link_target(@_);}
# Function make_link_urlhref (wiki_link.cgi)				# comment
sub make_link_urlhref {&load_wiki_module("link");return &_make_link_urlhref(@_);}
# Function make_link_image (wiki_link.cgi)				# comment
sub make_link_image {&load_wiki_module("link");return &_make_link_image(@_);}
# Function exec_plugin (wiki_plugin.cgi)				# comment
sub exec_plugin {&load_wiki_module("plugin");return &_exec_plugin(@_);}
# Function exec_explugin (wiki_plugin.cgi)				# comment
sub exec_explugin {&load_wiki_module("plugin");return &_exec_explugin(@_);}
# Function exec_explugin_sub (wiki_plugin.cgi)				# comment
sub exec_explugin_sub {&load_wiki_module("plugin");return &_exec_explugin_sub(@_);}
# Function exist_plugin (wiki_plugin.cgi)				# comment
sub exist_plugin {&load_wiki_module("plugin");return &_exist_plugin(@_);}
# Function exist_explugin (wiki_plugin.cgi)				# comment
sub exist_explugin {&load_wiki_module("plugin");return &_exist_explugin(@_);}
# Function exec_explugin_last (wiki_plugin.cgi)				# comment
sub exec_explugin_last {&load_wiki_module("plugin");return &_exec_explugin_last(@_);}
# Function embedded_to_html (wiki_plugin.cgi)				# comment
sub embedded_to_html {&load_wiki_module("plugin");return &_embedded_to_html(@_);}
# Function embedded_inline (wiki_plugin.cgi)				# comment
sub embedded_inline {&load_wiki_module("plugin");return &_embedded_inline(@_);}
# Function skinex (wiki_skin.cgi)				# comment
sub skinex {&load_wiki_module("skin");return &_skinex(@_);}
# Function maketitle (wiki_skin.cgi)				# comment
sub maketitle {&load_wiki_module("skin");return &_maketitle(@_);}
# Function convtime (wiki_skin.cgi)				# comment
sub convtime {&load_wiki_module("skin");return &_convtime(@_);}
# Function skinhead (wiki_skin.cgi)				# comment
sub skinhead {&load_wiki_module("skin");return &_skinhead(@_);}
# Function makenavigator (wiki_skin.cgi)				# comment
sub makenavigator {&load_wiki_module("skin");return &_makenavigator(@_);}
# Function makenavigator_sub1 (wiki_skin.cgi)				# comment
sub makenavigator_sub1 {&load_wiki_module("skin");return &_makenavigator_sub1(@_);}
# Function makenavigator_sub2 (wiki_skin.cgi)				# comment
sub makenavigator_sub2 {&load_wiki_module("skin");return &_makenavigator_sub2(@_);}
# Function makenavigator_sub3 (wiki_skin.cgi)				# comment
sub makenavigator_sub3 {&load_wiki_module("skin");return &_makenavigator_sub3(@_);}
# Function navi_toolbar (wiki_skin.cgi)				# comment
sub navi_toolbar {&load_wiki_module("skin");return &_navi_toolbar(@_);}
# Function skin_footer (wiki_skin.cgi)				# comment
sub skin_footer {&load_wiki_module("skin");return &_skin_footer(@_);}
# Function snapshot (wiki_spam.cgi)				# comment
sub snapshot {&load_wiki_module("spam");return &_snapshot(@_);}
# Function spam_filter (wiki_spam.cgi)				# comment
sub spam_filter {&load_wiki_module("spam");return &_spam_filter(@_);}
# Function do_read (wiki_wiki.cgi)				# comment
sub do_read {&load_wiki_module("wiki");return &_do_read(@_);}
# Function print_content (wiki_wiki.cgi)				# comment
sub print_content {&load_wiki_module("wiki");return &_print_content(@_);}
# Function topicpath (wiki_wiki.cgi)				# comment
sub topicpath {&load_wiki_module("wiki");return &_topicpath(@_);}
# Function get_fullname (wiki_wiki.cgi)				# comment
sub get_fullname {&load_wiki_module("wiki");return &_get_fullname(@_);}
# Function get_subjectline (wiki_wiki.cgi)				# comment
sub get_subjectline {&load_wiki_module("wiki");return &_get_subjectline(@_);}
# Function get_info (wiki_wiki.cgi)				# comment
sub get_info {&load_wiki_module("wiki");return &_get_info(@_);}
# Function is_frozen (wiki_wiki.cgi)				# comment
sub is_frozen {&load_wiki_module("wiki");return &_is_frozen(@_);}
# Function is_readable (wiki_wiki.cgi)				# comment
sub is_readable {&load_wiki_module("wiki");return &_is_readable(@_);}
# Function is_editable (wiki_wiki.cgi)				# comment
sub is_editable {&load_wiki_module("wiki");return &_is_editable(@_);}
# Function interwiki_convert (wiki_wiki.cgi)				# comment
sub interwiki_convert {&load_wiki_module("wiki");return &_interwiki_convert(@_);}
# Function set_info (wiki_write.cgi)				# comment
sub set_info {&load_wiki_module("write");return &_set_info(@_);}
# Function disablewords (wiki_write.cgi)				# comment
sub disablewords {&load_wiki_module("write");return &_disablewords(@_);}
# Function do_write (wiki_write.cgi)				# comment
sub do_write {&load_wiki_module("write");return &_do_write(@_);}
# Function do_backup (wiki_write.cgi)				# comment
sub do_backup {&load_wiki_module("write");return &_do_backup(@_);}
# Function do_write_page (wiki_write.cgi)				# comment
sub do_write_page {&load_wiki_module("write");return &_do_write_page(@_);}
# Function do_write_info (wiki_write.cgi)				# comment
sub do_write_info {&load_wiki_module("write");return &_do_write_info(@_);}
# Function do_delete_page (wiki_write.cgi)				# comment
sub do_delete_page {&load_wiki_module("write");return &_do_delete_page(@_);}
# Function do_delete_info (wiki_write.cgi)				# comment
sub do_delete_info {&load_wiki_module("write");return &_do_delete_info(@_);}
# Function do_write_after (wiki_write.cgi)				# comment
sub do_write_after {&load_wiki_module("write");return &_do_write_after(@_);}
# Function conflict (wiki_write.cgi)				# comment
sub conflict {&load_wiki_module("write");return &_conflict(@_);}
# Function update_recent_changes (wiki_write.cgi)				# comment
sub update_recent_changes {&load_wiki_module("write");return &_update_recent_changes(@_);}
# Function send_mail_to_admin (wiki_write.cgi)				# comment
sub send_mail_to_admin {&load_wiki_module("write");return &_send_mail_to_admin(@_);}
# Function read_by_part (wiki_write.cgi)				# comment
sub read_by_part {&load_wiki_module("write");return &_read_by_part(@_);}
# Function frozen_reject (wiki_write.cgi)				# comment
sub frozen_reject {&load_wiki_module("write");return &_frozen_reject(@_);}

1;
