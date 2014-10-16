######################################################################
# @@HEADER1@@
######################################################################
use strict;

######################################################################
# en:Default Language
# ja:�ǥե���Ȥθ���
######################################################################
# en:Select Defualt Language
# ja:�ǥե���ȸ�������
# @{ja:Japanese/en:English}
$::lang = "ja";

######################################################################
# ja:��������
######################################################################
# ja:���������ɡ����ܸ�Τߡ�#utf8
# @{utf8:utf8 only}#utf8
$::kanjicode = "utf8";#utf8

# ja:����饯����������#utf8
# @{utf-8}#utf8
$::charset = "utf-8";#utf8

# ja:���������ɡ����ܸ�Τߡ�#euc
# @ja{euc:EUC-JP/sjis:Shift-JIS/utf8:UTF-8}#euc
$::kanjicode = "euc";#euc

# ja:����饯����������#euc
# @{}#euc
$::charset = "";#euc

# ja:���쥳�����Ѵ�			# Jcode Only!!
# @ja{Jcode:Jcode.pm}
$::code_method{ja} = "Jcode";

######################################################################
# ja:�ǡ�����Ǽ�ǥ��쥯�ȥ�
######################################################################

# ja:CGI����Τߥ�����������ǡ����Υǥ��쥯�ȥ�
# @{.}
$::data_home = '.';

# ja:�֥饦�����鸫���ǡ����Υ��ɥ쥹
# @{.}
$::data_pub = '.';

# ja:�֥饦����������С����Хǥ��쥯�ȥ�
# @{.}
$::data_url = '.';

# ja:�����ƥ�γ�Ǽ�ǥ��쥯�ȥꡡ�̾���ѹ����ʤ��ǲ�����
# @{.}
$::bin_home = '.';

## cgi-bin���̤Υǥ��쥯�ȥ����
## for sourceforge.jp
## /home/groups/p/py/pyukiwiki/htdocs
## /home/groups/p/py/pyukiwiki/cgi-bin
#$::data_home = '.';
#$::data_pub = '../htdocs';
#$::data_url = '..';

## Windows NT Server (IIS+ActivePerl)�ξ�����
#$::data_home = 'C:/inetpub/cgi-bin/pyuki/';
#$::data_pub = 'C:/inetpub/cgi-bin/pyuki/';
#$::data_url = '.';

# ja:�ڡ����ǡ�����¸�ѥǥ��쥯�ȥ�
# @{$::data_home/wiki}
$::data_dir    = "$::data_home/wiki";

# ja:�Хå����å���¸�ѥǥ��쥯�ȥ� #nocompact
# @{$::data_home/backup}#nocompact
$::backup_dir  = "$::data_home/backup";

# ja:��ʬ��¸�ѥǥ��쥯�ȥ�
# @{$::data_home/diff}
$::diff_dir    = "$::data_home/diff";

# ja:����å�����¸�ѥǥ��쥯�ȥ�
# @{$::data_pub/cache}
$::cache_dir   = "$::data_pub/cache";

# ja:����å�������ѥ��ɥ쥹
# @{$::data_url/cache}
$::cache_url   = "$::data_url/cache";

# ja:ź�եե������Ǽ�ǥ��쥯�ȥ�
# @{$::data_pub/attach}
$::upload_dir  = "$::data_pub/attach";

# ja:ź�եե���������ѥ��ɥ쥹
# @{$::data_url/attach}
$::upload_url  = "$::data_url/attach";

# ja:�������������󥿡���Ǽ�ѥǥ��쥯�ȥ�
# @{$::data_url/counter}
$::counter_dir = "$::data_home/counter";

# ja:�ץ饰�����Ǽ�ǥ��쥯�ȥ�
# @{$::bin_home/plugin}
$::plugin_dir  = "$::bin_home/plugin";

# ja:Ex�ץ饰�����Ǽ�ǥ��쥯�ȥ�
# @{$::bin_home/lib}
$::explugin_dir= "$::bin_home/lib";

# ja:�������Ǽ�ѥǥ��쥤���ȥ�
# @{$::data_pub/skin}
$::skin_dir    = "$::data_pub/skin";

# ja:����������ѥǥ��쥯�ȥ�
# @{$::data_url/skin}
$::skin_url    = "$::data_url/skin";

# ja:������Ǽ�ѥǥ��쥯�ȥ�
# @{$::data_pub/image}
$::image_dir   = "$::data_pub/image";

# ja:����������URL
# @{$::data_url/image}
$::image_url   = "$::data_url/image";

# ja:ʸ������Ǽ�ǥ��쥯�ȥ�
# @{$::data_home/info}
$::info_dir    = "$::data_home/info";

# ja:�꥽������Ǽ�ǥ��쥯�ȥ�
# @{$::bin_home/resource}
$::res_dir     = "$::bin_home/resource";

# ja:�����ƥ��ѥǥ��쥯�ȥ�
# @{$::bin_home/lib}
$::sys_dir	   = "$::bin_home/lib";

# ja:XS�⥸�塼���ѥǥ��쥯�ȥ�
# @{$::bin_home/blib}
$::sysxs_dir   = "$::bin_home/blib";

######################################################################
# ja:����������
######################################################################
# ja:������̾��
# @{@list:$::skin_dir/*.skin.cgi}
$::skin_name   = "pyukiwiki";
$::use_blosxom = 0;	# blosxom.css����Ѥ���Ȥ����ˤ���


# ja:JavaScript�����ΰ���
# @{0:head��/1:body�θ��}
$::js_lasttag=1;

# for tdiary theme wrapper
#$::skin_name = "tdiary";
#$::skin_name{tdiary} = "tdiary_theme";
##$::skin_selector{tdiary} = "theme_id:alias name,theme_id:alias name";
##   setting.inc.cgi ��������Ǥ���褦�ˤʤ�
##   �����¿������ȥ���ץ뤬ɽ���Ǥ��ʤ���ǽ��������ޤ���

######################################################################
# ưŪ���åȥ��åץե�����
######################################################################
$::setup_file = "$::info_dir/setup.ini.cgi";
$::ngwords_file = "$::info_dir/setup_ngwords.ini.cgi";

######################################################################
# ja:HTTP�ץ������ꡡ�̾��������פǤ���
######################################################################
# ja:�ץ��������С��Υۥ���̾
# @{}
$::proxy_host = '';

# ja:�ץ��������С��Υݡ���
# @{3128}
$::proxy_port = 3128;

######################################################################
# ja:wiki�������Ծ���
# (���ѿ��θ���̾��Ϣ������ˤ���ȡ������̤ˤǤ��ޤ���
######################################################################
# ja:������̾
# @{PyukiWiki}
$::wiki_title = 'PyukiWiki';

# �ʱѸ���Υ����ȥ��
#$::wiki_title{en} = 'PyukiWiki';

# ja:������̾�ʥ����ȴ�����̾��
# @{anonymous}
$::modifier = 'anonymous';

# ja:������URL
# @{}
$::modifierlink = '';

# ja:�����ԥ᡼�륢�ɥ쥹
# @{}
$::modifier_mail = '';

# ja:�����������
# @{$::wiki_title}
$::meta_keyword = "$::wiki_title";

# ja:�����ȥ�οƳ��ؤ��ά����
# @ja{1:��ά����/0��ά���ʤ�}
$::short_title = 0;

######################################################################
# ja:��
######################################################################
# ja:����URL
# @{$::image_url/pyukiwiki.png}
$::logo_url = "$::image_url/pyukiwiki.png";

# ja:���β���
# @{80}
$::logo_width = 80;

# ja:���ι⤵
# @{80}
$::logo_height = 80;

# ja:��������ʸ��
# @{[PyukiWiki]}
$::logo_alt = "[PyukiWiki]";

######################################################################
# ������ץ�̾������
######################################################################
# servererror��urlhack�ץ饰�������Ѥ�����ϡ���ư�����ǤϤʤ�
# $::script��ɬ�����ꤷ�Ʋ�������
#$::script			 =  'index.cgi';
# ja:������ץ�̾����������Ϥʤ��Ǽ�ư������
# @ja{:��ư����/index.cgi:index.cgi/nph-index.cgi:nph-index.cgi/index.xcg:index.xcg}
$::script			 =  '';

# ja:���URL�����Ϥʤ��Ǽ�ư������
# @{}
$::basehref			 =  '';

# ja:��ʬ���ȤΥ�����ץ�̾
# @{index\.cgi|nph\-index\.cgi|index\.xcg}
$::defaultindex		 =  'index\.cgi|nph\-index\.cgi|index\.xcg';

# ja:cookie�Ѵ��ѥ������Ϥʤ��Ǽ�ư������
# @{}
$::basepath			 =  '';

######################################################################
# ja:�ǥե���ȥڡ���̾
######################################################################

# ja:FrontPage���ȥåץڡ���
# @{FrontPage}
$::FrontPage		 =  'FrontPage';

# ja:RecentChanges���ѹ�����
# @{RecentChanges}
$::RecentChanges	 =  'RecentChanges';

# ja:MenuBar�����Υ�˥塼
# @{MenuBar}
$::MenuBar			 =  'MenuBar';

# ja:SideBar�����Υ�˥塼
# @{:SideBar}
$::SideBar			 =  ':SideBar';

# ja:TitleHeader�������ΥХʡ���
# @{:TitleHeader}
$::TitleHeader		 =  ':TitleHeader';

# ja:Header �ڡ���������ɽ��
# @{:Header}
$::Header			 =  ':Header';

# ja:BodyHeader��Header��겼��ɽ��
# @{:BodyHeader}
$::BodyHeader		 =  ':BodyHeader';

# ja:Footer �ڡ���������ɽ��
# @{:Footer}
$::Footer			 =  ':Footer';

# ja:BodyFooter��Footer�����ɽ��
# @{:BodyFooter}
$::BodyFooter		 =  ':BodyFooter';

# ja:SkinFooter��PyukiWiki������������ʬ��ɽ��
# @{:SkinFooter}
$::SkinFooter		 =  ':SkinFooter';

# ja:SandBox��������������
# @{SandBox}
$::SandBox			 =  'SandBox';

# ja:InterWikiName��InterWiki���
# @{InterWikiName}
$::InterWikiName	 =  'InterWikiName';

# ja:InterWikiSandBox��InterWiki������
# @{InterWikiSandBox}
$::InterWikiSandBox	 =  'InterWikiSandBox';

# ja:Template�������������μ�ư�ƥ�ץ졼���ɤ߹��� by idea by koyakei
# @{Template}
$::Template		 =  ":Template";

# ja:ErrorPage�����顼ɽ���ڡ���
# @{ErrorPage}
$::ErrorPage		 =  "ErrorPage";

# ja:AdminPage���������ѥڡ�����?cmd=admin)
# @{AdminPage}
$::AdminPage		 =  "AdminPage";

# ja:IndexPage�������Υڡ�����?cmd=list)
# @{IndexPage}
$::IndexPage		 =  "IndexPage";

# ja:SearchPage�������ڡ�����?cmd=search)
# @{SearchPage}
$::SearchPage		 =  "SearchPage";

# ja:CreatePage�����������ڡ�����?cmd=newpage)
# @{CreatePage}
$::CreatePage		 =  "CreatePage";

######################################################################
# ja:�����ԥѥ���ɤ���¸��ˡ
######################################################################

# ja:�����ԥѥ���ɤΰŹ沽��ˡ
# @ja{AUTO:��ư���̾���ѹ����ʤ��ǲ�������/CRYPT:CRYPT/MD5:MD5/SHA1:SHA1/SHA256:SHA256/SHA384:SHA384/SHA512:SHA512/TEXT:���ƥ�����}
$::CryptMethod = "AUTO";

######################################################################
# �ѥ��������
######################################################################

# [pass] of cross MD5
#$::adminpass = '{MD5}21a37805a1e67cd6142d30ef780ce771';

# [pass] of text
$::adminpass = '{TEXT}pass';

# [pass] of plain crypt
#$::adminpass = crypt("pass", "AA");

# �ѥ���ɤ��̤ˤ�����
#�������̥ѥ���ɤǤ�ǧ�ڤ��ޤ��������̤���Ѥ��ʤ�����¬����ʥѥ������ϡ�
#$::adminpass = 'aetipaesgyaigygoqyiwgorygaeta';# �ǥե���Ȥ���ѻ��ѥǥ�������ǽ�ѥ�
#$::adminpass{admin} = '{TEXT}admin';		# �������ѥѥ���ɡ�������
#$::adminpass{frozen} = '{TEXT}frozen'	;	# ����ѥѥ����
#$::adminpass{attach} = '{TEXT}attach'	;	# ź���ѥѥ����

######################################################################
# ja:�ѥ���ɤΥ������ƥ�������
######################################################################
# ja:�ѥ���ɤ�ʰװŹ沽�����������롣
# @{1:�ʰװŹ沽�򤹤�(��JavaScript)/0:���ƥ����Ȥ���������}
$::Use_CryptPass = 0;						

######################################################################
# ����ꥹ��
######################################################################

#$::lang_list = "ja en";
#$::lang_list = "ja en cn";

######################################################################
# ja:RSS����
######################################################################

# ja:RSS�ν��϶Ž�
# @{1:1/2:2/3:3/4:4/5:5/6:6/7:7/8:8/9:9/10:10/15:15/20:20/25:25/30:30}
$::rss_lines = 15;

# ja:RSS��description�ιԿ�����ꤹ��
# @{1:1/2:2/3:3/4:4/5:5/6:6/7:7/8:8/9:9/10:10}
$::rss_description_line = 1;

# RSS���� (���ѿ��θ���̾��Ϣ������ˤ���ȡ������̤ˤǤ��ޤ���# ja:RSS��ɽ��
# @{$::wiki_title}
$::modifier_rss_title = $::wiki_title;

# ja:RSS�Υ����ʻ���ʤ��Ǽ�ư������
# @{}
$::modifier_rss_link = '';

# ja:RSS������
# @{Modified by $::modifier}
$::modifier_rss_description = "Modified by $::modifier";

#$::modifier_rss_title = "PyukiWiki $::version";
#$::modifier_rss_link = '@@PYUKI_URL@@';
#$::modifier_rss_description = 'This is PyukiWiki.';

%::rssenable;							# RSS/ATOM/OPML��ͭ��̵��

# ja:RSS1.0��ͭ���ˤ���
# @{1:ͭ��/0:̵��}
$::rssenable{rss10} = 1;

# ja:RSS2.0��ͭ���ˤ���
# @{1:ͭ��/0:̵��}
$::rssenable{rss20} = 1;

# ja:ATOM��ͭ���ˤ���
# @{1:ͭ��/0:̵��}
$::rssenable{atom} = 1;

# ja:OPML��ͭ���ˤ���
# @{1:ͭ��/0:̵��}
$::rssenable{opml} = 1;

######################################################################
# �ץ饰��������
######################################################################
$::plugin_disable{pluginname} = 1;	# pluginname��̵���ˤ���
#$::plugin_disable{bugtrack} = 1;	# bugtrack��̵���ˤ���

######################################################################
# ja:Ex�ץ饰��������
######################################################################
# ja:explugin�λ���
# @ja{1:���Ѥ���/0:���Ѥ��ʤ�}
$::useExPlugin = 1;

######################################################################
# ja:HTML���ϥ⡼��
######################################################################

# ja:PC�ν��ϥ⡼��
# @ja{html4:HTML 4.01 Transitional/xhtml10:XHTML 1.0 Strict/xhtml10t:XHTML 1.0 Transitional/xhtml11:XHTML 1.1/xhtmlbasic10:XHTML Basic 1.0/html5:HTML5��̤������}
$::htmlmode = "html4";

# ja:���ޡ��ȥե���ν��ϥ⡼�ɡ�̤������
# @{html4:HTML 4.01 Transitional/xhtml10:XHTML 1.0 Strict/xhtml10t:XHTML 1.0 Transitional/xhtml11:XHTML 1.1/xhtmlbasic10:XHTML Basic 1.0/html5:HTML5��̤������}
$::htmlmode{sp} = "html5";

# ja:��Х���ν��ϥ⡼�ɡ�̤������
# @{html4:HTML 4.01 Transitional/xhtml10:XHTML 1.0 Strict/xhtml10t:XHTML 1.0 Transitional/xhtml11:XHTML 1.1/xhtmlbasic10:XHTML Basic 1.0/html5:HTML5��̤������}
$::htmlmode{mobile} = "xhtml10t";

###################################################################### #nocompact
# �Хå����åפλ���#nocompact
###################################################################### #nocompact
# ja:�Хå����åפ���Ѥ���#nocompact
# @{1:���Ѥ���/0:���Ѥ��ʤ�} #nocompact
$::useBackUp = 1;#nocompact

######################################################################
# ja:ɽ������
######################################################################
# ja:�ե������ޡ���
# @{1:�Ȥ�/0:�Ȥ�ʤ�}
$::usefacemark = 1;

# ja:�ݥåץ��å�
# @{0:���̤˥�󥯤���/1:�ݥåץ��åפ򤹤�/2:�����С�̾(HTTP_HOST)����Ӥ��ơ�Ʊ��ʤ����̤˥�󥯤���/3:���ɥ쥹($basehref)����Ӥ���Ʊ��ʤ����̤ˡ�ư��ʤ������С������}
$::use_popup = 1;

# ja:wikiʸ���ǥե���Ȥǲ��Ԥ�����
# @{0:���ʤ�/1:����}
$::line_break = 0;

# ja:�ǽ���������ɽ������
# @{0:ɽ�����ʤ�/1:������ɽ������/2:������ɽ������}
$::last_modified = 2;

# ja:�ǽ��������Υץ��ץ�
# @{Last-modified:}
$::lastmod_prompt = 'Last-modified:';

# ja:���Ƥβ��̤ǡ�Header��MenuBar��Footer��ɽ������
# @{1:����/0:���ʤ�}
$::allview = 1;	

# ja:����ɽ������
# @{0:$body�β���ɽ��/1:footer�ξ��ɽ��/2:footer�β���ɽ��}
$::notesview = 0;

# ja:�ڡ����եå����ξ���ɽ����perl�С�������
# @{1:����/0:���ʤ�}
$::enable_last = 1;

# ja:�ڡ����եå����˲�Ư��OS��ɽ������
# @{1:����/0:���ʤ�}
$::enable_last_os = 0;

# ja:�ڡ���ɽ�����֤�ɽ������
# @{1:����/0:���ʤ�}
$::enable_convtime = 1;

# ja:����ž���򤷤Ƥ��뤫ɽ������
# @{1:����/0:���ʤ�}
$::enable_compress = 1;

# ja:����΢�
# @{&dagger;}
$::_symbol_anchor = '&dagger;';

######################################################################
# ja:�᡼�륢�ɥ쥹�ݸ�
######################################################################

# ja:diff�ץ饰����ˤ����ƥ᡼�륢�ɥ쥹�򱣤���#compact
# ja:diff�ץ饰����ڤӥХå����åץץ饰����ˤ����ƥ᡼�륢�ɥ쥹�򱣤���#nocompact
# @{1:����/0:�����ʤ�}
$::diff_disable_email = 1;

# ja:�Хå����åץץ饰����Υ�����ɽ���ˤƥ᡼�륢�ɥ쥹�򱣤���#nocompact
# @{1:����/0:�����ʤ�}#nocompact
$::backup_disable_email = 1;

######################################################################
# ja:�����ե����ޥå�
######################################################################
# ja:���դΥե����ޥå�
# @{Y-m-d:yyyy-mm-dd/Y-n-j:yyyy-m-d/y-m-d:yy-mm-dd/y-n-j:yy-m-d/M d Y:Mon d yyyy/d M Y:d Mon yyyy/M d y:Mon d yy/d M y/d Mon yy}
$::date_format = "Y-m-d";

# ja:����Υե����ޥå�
# @{H\:i\:s:23\:05\:05/A h\:i\:s:PM 11\:05\:05/h\:i\:s/11\:05\:05}
$::time_format = "H:i:s";

# ja:&now;�������ե����ޥå�
# @{Y-m-d(lL) H\:i\:s:yyyy-mm-dd(ww) 23\:05\:05/Y-m-d(D) H\:i\:s:yyyy-mm-dd(w) 23\:05\:05/Y-m-d H\:i\:s:yyyy-mm-dd 23\:05\:05/Y-m-d(lL) A h\:i\:s:yyyy-mm-dd(ww) PM 11\:05\:05/Y-m-d(D) A h\:i\:s:yyyy-mm-dd(w) PM 11\:05\:05/Y-m-d A h\:i\:s:yyyy-mm-dd PM 11\:05\:05/Y-m-d(lL) h\:i\:s:yyyy-mm-dd(ww) 11\:05\:05/Y-m-d(D) h\:i\:s:yyyy-mm-dd(w) 11\:05\:05/Y-m-d h\:i\:s:yyyy-mm-dd 11\:05\:05/y-m-d(lL) H\:i\:s:yy-mm-dd(ww) 23\:05\:05/y-m-d(D) H\:i\:s:yy-mm-dd(w) 23\:05\:05/y-m-d H\:i\:s:yy-mm-dd 23\:05\:05/y-m-d(lL) A h\:i\:s:yy-mm-dd(ww) PM 11\:05\:05/y-m-d(D) A h\:i\:s:yy-mm-dd(w) PM 11\:05\:05/y-m-d A h\:i\:s:yy-mm-dd PM 11\:05\:05/y-m-d(lL) h\:i\:s:yy-mm-dd(ww) 11\:05\:05/y-m-d(D) h\:i\:s:yy-mm-dd(w) 11\:05\:05/y-m-d h\:i\:s:yy-mm-dd 11\:05\:05/D M d H\:i\:s Y:W d Mon 23\:05\:05 yyyy/M d H\:i\:s Y:d Mon 23\:05\:05 yyyy/D M d A h\:i\:s Y:W d Mon PM 11\:05\:05 yyyy/M d A h\:i\:s Y:d Mon PM 11\:05\:05 yyyy/D M d h\:i\:s Y:W d Mon 11\:05\:05 yyyy/M d h\:i\:s Y:d Mon 11\:05\:05 yyyy}
$::now_format = "Y-m-d(lL) H:i:s";

# ja:lastmod�������ե����ޥå�
# @{Y-m-d(lL) H\:i\:s:yyyy-mm-dd(ww) 23\:05\:05/Y-m-d(D) H\:i\:s:yyyy-mm-dd(w) 23\:05\:05/Y-m-d H\:i\:s:yyyy-mm-dd 23\:05\:05/Y-m-d(lL) A h\:i\:s:yyyy-mm-dd(ww) PM 11\:05\:05/Y-m-d(D) A h\:i\:s:yyyy-mm-dd(w) PM 11\:05\:05/Y-m-d A h\:i\:s:yyyy-mm-dd PM 11\:05\:05/Y-m-d(lL) h\:i\:s:yyyy-mm-dd(ww) 11\:05\:05/Y-m-d(D) h\:i\:s:yyyy-mm-dd(w) 11\:05\:05/Y-m-d h\:i\:s:yyyy-mm-dd 11\:05\:05/y-m-d(lL) H\:i\:s:yy-mm-dd(ww) 23\:05\:05/y-m-d(D) H\:i\:s:yy-mm-dd(w) 23\:05\:05/y-m-d H\:i\:s:yy-mm-dd 23\:05\:05/y-m-d(lL) A h\:i\:s:yy-mm-dd(ww) PM 11\:05\:05/y-m-d(D) A h\:i\:s:yy-mm-dd(w) PM 11\:05\:05/y-m-d A h\:i\:s:yy-mm-dd PM 11\:05\:05/y-m-d(lL) h\:i\:s:yy-mm-dd(ww) 11\:05\:05/y-m-d(D) h\:i\:s:yy-mm-dd(w) 11\:05\:05/y-m-d h\:i\:s:yy-mm-dd 11\:05\:05/D M d H\:i\:s Y:W d Mon 23\:05\:05 yyyy/M d H\:i\:s Y:d Mon 23\:05\:05 yyyy/D M d A h\:i\:s Y:W d Mon PM 11\:05\:05 yyyy/M d A h\:i\:s Y:d Mon PM 11\:05\:05 yyyy/D M d h\:i\:s Y:W d Mon 11\:05\:05 yyyy/M d h\:i\:s Y:d Mon 11\:05\:05 yyyy}
$::lastmod_format = "Y-m-d(lL) H:i:s";

# ja:recent�������ե����ޥå�
# @{Y-m-d(lL) H\:i\:s:yyyy-mm-dd(ww) 23\:05\:05/Y-m-d(D) H\:i\:s:yyyy-mm-dd(w) 23\:05\:05/Y-m-d H\:i\:s:yyyy-mm-dd 23\:05\:05/Y-m-d(lL) A h\:i\:s:yyyy-mm-dd(ww) PM 11\:05\:05/Y-m-d(D) A h\:i\:s:yyyy-mm-dd(w) PM 11\:05\:05/Y-m-d A h\:i\:s:yyyy-mm-dd PM 11\:05\:05/Y-m-d(lL) h\:i\:s:yyyy-mm-dd(ww) 11\:05\:05/Y-m-d(D) h\:i\:s:yyyy-mm-dd(w) 11\:05\:05/Y-m-d h\:i\:s:yyyy-mm-dd 11\:05\:05/y-m-d(lL) H\:i\:s:yy-mm-dd(ww) 23\:05\:05/y-m-d(D) H\:i\:s:yy-mm-dd(w) 23\:05\:05/y-m-d H\:i\:s:yy-mm-dd 23\:05\:05/y-m-d(lL) A h\:i\:s:yy-mm-dd(ww) PM 11\:05\:05/y-m-d(D) A h\:i\:s:yy-mm-dd(w) PM 11\:05\:05/y-m-d A h\:i\:s:yy-mm-dd PM 11\:05\:05/y-m-d(lL) h\:i\:s:yy-mm-dd(ww) 11\:05\:05/y-m-d(D) h\:i\:s:yy-mm-dd(w) 11\:05\:05/y-m-d h\:i\:s:yy-mm-dd 11\:05\:05/D M d H\:i\:s Y:W d Mon 23\:05\:05 yyyy/M d H\:i\:s Y:d Mon 23\:05\:05 yyyy/D M d A h\:i\:s Y:W d Mon PM 11\:05\:05 yyyy/M d A h\:i\:s Y:d Mon PM 11\:05\:05 yyyy/D M d h\:i\:s Y:W d Mon 11\:05\:05 yyyy/M d h\:i\:s Y:d Mon 11\:05\:05 yyyy}
$::recent_format = "Y-m-d(lL) H:i:s";

# ja:�Хå����åפ������ե����ޥå�#nocompact
# @{Y-m-d(lL) H\:i\:s:yyyy-mm-dd(ww) 23\:05\:05/Y-m-d(D) H\:i\:s:yyyy-mm-dd(w) 23\:05\:05/Y-m-d H\:i\:s:yyyy-mm-dd 23\:05\:05/Y-m-d(lL) A h\:i\:s:yyyy-mm-dd(ww) PM 11\:05\:05/Y-m-d(D) A h\:i\:s:yyyy-mm-dd(w) PM 11\:05\:05/Y-m-d A h\:i\:s:yyyy-mm-dd PM 11\:05\:05/Y-m-d(lL) h\:i\:s:yyyy-mm-dd(ww) 11\:05\:05/Y-m-d(D) h\:i\:s:yyyy-mm-dd(w) 11\:05\:05/Y-m-d h\:i\:s:yyyy-mm-dd 11\:05\:05/y-m-d(lL) H\:i\:s:yy-mm-dd(ww) 23\:05\:05/y-m-d(D) H\:i\:s:yy-mm-dd(w) 23\:05\:05/y-m-d H\:i\:s:yy-mm-dd 23\:05\:05/y-m-d(lL) A h\:i\:s:yy-mm-dd(ww) PM 11\:05\:05/y-m-d(D) A h\:i\:s:yy-mm-dd(w) PM 11\:05\:05/y-m-d A h\:i\:s:yy-mm-dd PM 11\:05\:05/y-m-d(lL) h\:i\:s:yy-mm-dd(ww) 11\:05\:05/y-m-d(D) h\:i\:s:yy-mm-dd(w) 11\:05\:05/y-m-d h\:i\:s:yy-mm-dd 11\:05\:05/D M d H\:i\:s Y:W d Mon 23\:05\:05 yyyy/M d H\:i\:s Y:d Mon 23\:05\:05 yyyy/D M d A h\:i\:s Y:W d Mon PM 11\:05\:05 yyyy/M d A h\:i\:s Y:d Mon PM 11\:05\:05 yyyy/D M d h\:i\:s Y:W d Mon 11\:05\:05 yyyy/M d h\:i\:s Y:d Mon 11\:05\:05 yyyy}#nocompact
$::backup_format = "Y-m-d(lL) H:i:s";#nocompact

# ja:attach�ץ饰����Ǥ�ź�եե�����������ե����ޥå�
# @{Y-m-d(lL) H\:i\:s:yyyy-mm-dd(ww) 23\:05\:05/Y-m-d(D) H\:i\:s:yyyy-mm-dd(w) 23\:05\:05/Y-m-d H\:i\:s:yyyy-mm-dd 23\:05\:05/Y-m-d(lL) A h\:i\:s:yyyy-mm-dd(ww) PM 11\:05\:05/Y-m-d(D) A h\:i\:s:yyyy-mm-dd(w) PM 11\:05\:05/Y-m-d A h\:i\:s:yyyy-mm-dd PM 11\:05\:05/Y-m-d(lL) h\:i\:s:yyyy-mm-dd(ww) 11\:05\:05/Y-m-d(D) h\:i\:s:yyyy-mm-dd(w) 11\:05\:05/Y-m-d h\:i\:s:yyyy-mm-dd 11\:05\:05/y-m-d(lL) H\:i\:s:yy-mm-dd(ww) 23\:05\:05/y-m-d(D) H\:i\:s:yy-mm-dd(w) 23\:05\:05/y-m-d H\:i\:s:yy-mm-dd 23\:05\:05/y-m-d(lL) A h\:i\:s:yy-mm-dd(ww) PM 11\:05\:05/y-m-d(D) A h\:i\:s:yy-mm-dd(w) PM 11\:05\:05/y-m-d A h\:i\:s:yy-mm-dd PM 11\:05\:05/y-m-d(lL) h\:i\:s:yy-mm-dd(ww) 11\:05\:05/y-m-d(D) h\:i\:s:yy-mm-dd(w) 11\:05\:05/y-m-d h\:i\:s:yy-mm-dd 11\:05\:05/D M d H\:i\:s Y:W d Mon 23\:05\:05 yyyy/M d H\:i\:s Y:d Mon 23\:05\:05 yyyy/D M d A h\:i\:s Y:W d Mon PM 11\:05\:05 yyyy/M d A h\:i\:s Y:d Mon PM 11\:05\:05 yyyy/D M d h\:i\:s Y:W d Mon 11\:05\:05 yyyy/M d h\:i\:s Y:d Mon 11\:05\:05 yyyy}
$::attach_format = "Y-m-d(lL) H:i:s";

# ja:ref�ץ饰����Ǥ�ź�եե�����������ե����ޥå�
# @{Y-m-d(lL) H\:i\:s:yyyy-mm-dd(ww) 23\:05\:05/Y-m-d(D) H\:i\:s:yyyy-mm-dd(w) 23\:05\:05/Y-m-d H\:i\:s:yyyy-mm-dd 23\:05\:05/Y-m-d(lL) A h\:i\:s:yyyy-mm-dd(ww) PM 11\:05\:05/Y-m-d(D) A h\:i\:s:yyyy-mm-dd(w) PM 11\:05\:05/Y-m-d A h\:i\:s:yyyy-mm-dd PM 11\:05\:05/Y-m-d(lL) h\:i\:s:yyyy-mm-dd(ww) 11\:05\:05/Y-m-d(D) h\:i\:s:yyyy-mm-dd(w) 11\:05\:05/Y-m-d h\:i\:s:yyyy-mm-dd 11\:05\:05/y-m-d(lL) H\:i\:s:yy-mm-dd(ww) 23\:05\:05/y-m-d(D) H\:i\:s:yy-mm-dd(w) 23\:05\:05/y-m-d H\:i\:s:yy-mm-dd 23\:05\:05/y-m-d(lL) A h\:i\:s:yy-mm-dd(ww) PM 11\:05\:05/y-m-d(D) A h\:i\:s:yy-mm-dd(w) PM 11\:05\:05/y-m-d A h\:i\:s:yy-mm-dd PM 11\:05\:05/y-m-d(lL) h\:i\:s:yy-mm-dd(ww) 11\:05\:05/y-m-d(D) h\:i\:s:yy-mm-dd(w) 11\:05\:05/y-m-d h\:i\:s:yy-mm-dd 11\:05\:05/D M d H\:i\:s Y:W d Mon 23\:05\:05 yyyy/M d H\:i\:s Y:d Mon 23\:05\:05 yyyy/D M d A h\:i\:s Y:W d Mon PM 11\:05\:05 yyyy/M d A h\:i\:s Y:d Mon PM 11\:05\:05 yyyy/D M d h\:i\:s Y:W d Mon 11\:05\:05 yyyy/M d h\:i\:s Y:d Mon 11\:05\:05 yyyy}
$::ref_format = "Y-m-d(lL) H:i:s";

# ja:download�ץ饰����Ǥ�URL�������ե����ޥå�
# @{Y-m-d(lL) H\:i\:s:yyyy-mm-dd(ww) 23\:05\:05/Y-m-d(D) H\:i\:s:yyyy-mm-dd(w) 23\:05\:05/Y-m-d H\:i\:s:yyyy-mm-dd 23\:05\:05/Y-m-d(lL) A h\:i\:s:yyyy-mm-dd(ww) PM 11\:05\:05/Y-m-d(D) A h\:i\:s:yyyy-mm-dd(w) PM 11\:05\:05/Y-m-d A h\:i\:s:yyyy-mm-dd PM 11\:05\:05/Y-m-d(lL) h\:i\:s:yyyy-mm-dd(ww) 11\:05\:05/Y-m-d(D) h\:i\:s:yyyy-mm-dd(w) 11\:05\:05/Y-m-d h\:i\:s:yyyy-mm-dd 11\:05\:05/y-m-d(lL) H\:i\:s:yy-mm-dd(ww) 23\:05\:05/y-m-d(D) H\:i\:s:yy-mm-dd(w) 23\:05\:05/y-m-d H\:i\:s:yy-mm-dd 23\:05\:05/y-m-d(lL) A h\:i\:s:yy-mm-dd(ww) PM 11\:05\:05/y-m-d(D) A h\:i\:s:yy-mm-dd(w) PM 11\:05\:05/y-m-d A h\:i\:s:yy-mm-dd PM 11\:05\:05/y-m-d(lL) h\:i\:s:yy-mm-dd(ww) 11\:05\:05/y-m-d(D) h\:i\:s:yy-mm-dd(w) 11\:05\:05/y-m-d h\:i\:s:yy-mm-dd 11\:05\:05/D M d H\:i\:s Y:W d Mon 23\:05\:05 yyyy/M d H\:i\:s Y:d Mon 23\:05\:05 yyyy/D M d A h\:i\:s Y:W d Mon PM 11\:05\:05 yyyy/M d A h\:i\:s Y:d Mon PM 11\:05\:05 yyyy/D M d h\:i\:s Y:W d Mon 11\:05\:05 yyyy/M d h\:i\:s Y:d Mon 11\:05\:05 yyyy}
$::download_format = "Y-m-d(lL) H:i:s";

#$::lastmod_format = "yǯn��j��(lL) ALg��kʬS��";	# ���ܸ�ɽ������

	# ǯ  :Y:����(4��)/y:����(2��)
	# ��  :n:1-12/m:01-12/M:Jan-Dec/F:January-December
	# ��  :j:1-31/J:01-31
	# ����:l:Sunday-Saturday/D:Sun-Sat/DL:������-������/lL:��-��
	# ampm:a:am or pm/A:AM or PM/AL:���� or ���
	# ��  : g:1-12/G:0-23/h:01-12/H/00-23
	# ʬ  : k:0-59/i:00-59
	# ��  : S:0-59/s:00-59
	# O   : ����˥å��Ȥλ��ֺ�
	# r RFC 822 �ե����ޥåȤ��줿���� ��: Thu, 21 Dec 2000 16:01:07 +0200 
	# Z �����ॾ����Υ��ե��å��ÿ��� -43200 ���� 43200 
	# L ��ǯ�Ǥ��뤫�ɤ�����ɽ�������͡� 1�ʤ鱼ǯ��0�ʤ鱼ǯ�ǤϤʤ��� 
	# lL:���ߤΥ�����θ���Ǥ�������û��
	# DL:���ߤΥ�����θ���Ǥ�������Ĺ��
	# aL:���ߤΥ�����θ���Ǥθ���������ʸ����
	# AL:���ߤΥ�����θ���Ǥθ������ʾ�ʸ����
	# t ���ꤷ����������� 28 ���� 31 
	# B Swatch ���󥿡��ͥåȻ��� 000 ���� 999 
	# U Unix ��(1970ǯ1��1��0��0ʬ0��)������ÿ� See also time() 

######################################################################
# ja:ʸ���Ѵ�
######################################################################
# ja:ɽ��ʸ����ư�ִ�
# @{80}
# format : before/after(space)before/after
$::replace{ja}='\\\\/&yen;';

######################################################################
# ja:�ڡ����Խ�
######################################################################
# ja:�ƥ����ȥ��ꥢ�Υ�����
# @{80}
$::cols = 80;

# �ƥ����ȥ��ꥢ�ιԿ�
# @{25}
$::rows = 25;

# ��ĥ��ǽ(JavaScript)
# @{1:���Ѥ���/0:���Ѥ��ʤ�}
$::extend_edit = 1;

# ja:PukiWiki�饤�����Խ�����
# @{0:PyukiWiki���ꥸ�ʥ�/1:PukiWiki�ߴ�/2:PukiWiki�ܿ����ɤ߹��ߵ�ǽ/3:PukiWiki�ܿ��������Τ߿����ɤ߹��ߵ�ǽ}
$::pukilike_edit = 3;

# ja:�ץ�ӥ塼��ɽ������
# @{0:�Խ����̤ξ�/1:�Խ����̤β�}
$::edit_afterpreview = 1;

# ja:���������ξ�硢��Ϣ�ڡ����Υ�󥯤����ͤȤ���ɽ������
# @{[[$1]]}
$::new_refer = '[[$1]]';

# ja:�����ڡ����������̤ǡ��ɤΥڡ����β��ؤ���뤫����Ǥ���褦�ˤ���
# @{1:���Ѥ���/0:���Ѥ��ʤ�}
$::new_dirnavi = 1;

# ja:�ڡ����Խ��塢location�ǰ�ư���롣��äƥ���ɥܥ���򲡤������ˡ��ٹ��ɽ�����ʤ����̤�����ޤ�����̵�������С��Ǥ�ư��ʤ��ʤ��ǽ��������ޤ���
# @{1:location�ǰ�ư����/0:location����Ѥ��ʤ�}
$::write_location = 1;

# ja:��ʬ�Խ�
# @{0:���Ѥ��ʤ�/1:���Ѥ���/2:���ڡ�������Ѥ���}
$::partedit = 1;


# ja:��ʬ�Խ��ǡ��ǽ�θ��Ф����������ʬ��1���ܤθ��Ф��Ȥߤʤ�
# @{0:���ʤ��ʤ�/1:���ʤ�}
$::partfirstblock = 0;

# ja:PukiWiki��
# @{0:���Ѥ��ʤ�/1:���Ѥ���}
$::usePukiWikiStyle = 1;

# ja:�Ǽ���������뤵��Ƥ���ڡ����Ǥ�ץ饰���󤫤�񤭹����褦�ˤ���
# @{1:���Ѥ���/0:���Ѥ��ʤ�}
$::writefrozenplugin = 1;

# ja:�����ڡ���������ǧ��
# @{0:ï�Ǥ�����Ǥ���/1:���ѥ���ɤ�ɬ��}
$::newpage_auth = 0;

# ja:���������ץ�����ư��
# @{0:�ʤˤ⤷�ʤ�/1:���Ϥ������Ƥ�ü�����Τ��ɻߤ���/2:���������ץ����������줿�顢�ե������õ�뤫��ǧ����}
$::use_escapeoff = 2;

# ja:�ե�����μ�ư�Хå����å�#nocompact
# @{0:�Хå����åפ���/1:�Хå����åפ��ʤ�}#nocompact
$::use_formbackup = 1;#nocompact

# ja:�Ǽ�������̾������¸��setting.inc.cgiͭ�����Τߡ�
# @{0:��¸���ʤ�/1:�ǥե���Ȥ�ͭ���ˤ���}
$::setting_savename = 0;

######################################################################
# ja:��ư���
######################################################################

# ja:WikiName�μ�ư���
# @{0:��ư��󥯤���/1:��ư��󥯤��ʤ�}
$::nowikiname = 0;

# ja:URL�μ�ư���
# @{1:��ư��󥯤���/0:��ư��󥯤��ʤ�}
$::autourllink = 1;

# ja:�᡼�륢�ɥ쥹�μ�ư���
# @{1:��ư��󥯤���/0:��ư��󥯤��ʤ�}
$::automaillink = 1;

# ja:�����Υ�ܥåȤΥե���#nocompact
# @{0:�ե������ʤ�/1:�������ȤΤߥե���/2:���ƥե�������}#nocompact
$::follow = 2;#nocompact
#nocompact
# ja:article���˽񤫤줿URL�Υե���#nocompact
# @{0:�ե������ʤ�/1:�ǥե����/2:���ƥե�������}#nocompact
$::postfollow = 0;#nocompact

# ja:file://�Υ������ޤ�ͭ���ˤ���ʥ���ȥ�ͥåȸ�����
# @{0:�̾�/1:ͭ���ˤ���}
$::useFileScheme = 0;

# ja:����ȥ�ͥåȸ����˥ɥåȤʤ��Υ᡼�륢�ɥ쥹��ͭ���ˤ���
# @{0:�̾�/1:ͭ���ˤ���}
$::IntraMailAddr = 0;

# ja:URL�˲����Τ�Τ���ꤵ�줿�顢̵����img�����ǥ�󥯤򤹤롣
# @{0:��󥯤Τߤ���/1:������ɽ������}
$::use_autoimg = 1;

# ja:���ܤǤ��ʤ�URL������ɽ����
# @{(\/\/|\.exe|\.scr|\.bat|\.pif|\.com|\.jpe?g|\.gif|\.png)$';}
$::ignoreurl = '(\/\/|\.exe|\.scr|\.bat|\.pif|\.com|\.jpe?g|\.gif|\.png)$';

######################################################################
# ja:���å���
######################################################################
# ja:��¸cookie��ͭ�����¡�3�����
# @{7776000}
$::cookie_expire = 3*30*86400;

# ja:��¸cooki�Υ�ե�å���ֳ֡�1����
# @{86400}
$::cookie_refresh = 86400;

######################################################################
# ja:�������������󥿡�
######################################################################

# ja:�������������󥿡��μ���
# @ja{1:���饷�å������󥿡��ʺ����Ⱥ����Τ���¸��/2:��ĥ�����󥿡�/3:��®�����󥿡��ʣ������������뤴�Ȥˣ��Х��Ⱦ��񤷤ޤ���}
$::CounterVersion = 1;

# ja:��¸���������ʺ���1000����
# @{365}
$::CounterDates = 365;

# ja:�����󥿡��Υ�⡼�ȥۥ��Ȥ�����å�����
# @{1:��⡼�ȥۥ��Ȥ�����å�����/0:����ɤǤ�̵���ǥ�����Ȥ���}
$::CounterHostCheck = 1;

######################################################################
# ja:�������������󥿡�
######################################################################

# ja:ź�դλ���
# @ja{0:���Ѥ��ʤ�/1:���Ѥ���/2:ǧ���դǻ��Ѥ���/3:����Τ�ǧ���դǻ��Ѥ���}
$::file_uploads = 2;

# ja:���åץ��ɥե�����κ�������
# @{5000000}
$::max_filesize = 5000000;

# ja:ź�եե�����δʰ����ƴƺ���Ԥʤ�
# @{1:�Ԥʤ�/0:�Ԥ�ʤ�}
$::AttachFileCheck = 0;

# ja:ź�եե�����Υ�������ɥ�����Ȥ�Ԥʤ�
# @{0:������Ȥ�Ԥʤ�ʤ�/1:������Ȥ�Ԥʤ�/2:���������ɽ�����̤�ɽ���⤹��}
$::AttachCounter = 0;

######################################################################
# ja:�إ��
######################################################################

# ja:�إ�פ�ץ饰����Ǽ¹Ԥ���
# @{1:�ץ饰���󤫤�¹Ԥ���/0:�ڡ����Ȥ���ɽ������}
$::use_HelpPlugin = 1;	# �إ�פ�ץ饰����Ǽ¹Ԥ���ʥʥӥ��������Ѳ����ޤ���

# �إ�ץڡ������Խ��������
# ?cmd = adminedit&mypage = %a5%d8%a5%eb%a5%d7 ��
# UTF-8�ǤǤ����
# ?cmd = adminedit&mypage = ?%e3%83%98%e3%83%ab%e3%83%97 ��

# ja:�إ�פΥ�󥯤�ɽ�����ʤ�
# @{0:ɽ������/1:ɽ�����ʤ�}
$::no_HelpLink = 0;

######################################################################
# ja:����
######################################################################
# ja:�����ޤ�����������
# @ja{0:�̾︡��/1:���ܸ�ʰפ����ޤ���������Ѥ���}
$::use_FuzzySearch = 1;

# ja:����������Ĵɽ���򤹤�#nocompact
# @ja{0:���⤷�ʤ�/1:��Ĵɽ���򤹤�}#nocompact
$::use_Highlight = 1;

######################################################################
# ja:�����ȥޥå�
######################################################################

# ja:�����ȥޥåפλ���
# @ja{0:�ꥹ�ȤΤ�/1:�ꥹ�ȡ������ȥޥåפ�ξ�������Ѥ���}
$::use_Sitemap = 0;

######################################################################
# ja:XML�����ȥޥå�
######################################################################
# ja:�������󥸥���������륵���ȥޥåפλ���
# @ja{0:���Ѥ��ʤ�/1:���Ѥ���}
$::use_Sitemaps = 1;
# ?cmd = sitemaps��XML

######################################################################
# ja:�ʥӥ�����������
######################################################################
# ja:�ʥӥ����Ȥ�ɽ��
# @ja{0:ɽ������/1:ɽ�����ʤ�}
$::disable_navigator = 0;

# ja:�ʥӥ�������ɽ������
# @ja{0:����ɡ�/1:�ȥåס�}
$::naviindex = 1;

######################################################################
# ja:��ư�ꥫ�Х꡼
######################################################################

# @ja{0:OFF/1:ON}
$::auto_recovery = 1;

######################################################################
# ja:�ڡ���̾��ɽ��
######################################################################

# ja:�ڡ���̾�β���topicpath�ʥѥ󤯤��ꥹ�ȡˤλ���
# @ja{0:���Ѥ��ʤ�/1:���Ѥ���}
$::useTopicPath = 1;

# ja:���ػ����ѥ��ѥ졼��
# @{/}
$::separator = '/';

# ja:�ɥå�
# @{.}
$::dot = '.';

# ja:���β����ġ���С�
# @ja{0:ɽ�����ʤ�/1:RSS���Τ�ɽ��/2:���٤�ɽ������}
$::toolbar = 2;

######################################################################
# ja:setting.inc.pl/cgi
######################################################################
# ja:�����ԴĶ����굡ǽ��Ȥ�
# @{0:���Ѥ��ʤ�/1:���Ѥ���}
$::use_Setting = 1;

# ja:�����󥻥쥯����Ȥ�
# @{0:���Ѥ��ʤ�/1:���Ѥ���}
$::use_SkinSel = 1;

######################################################################
# ja:����
######################################################################

# ja:��������κ�����¸��
# @{50}
$::maxrecent = 50;

# ja:���������������˴ޤ�ʤ��ڡ���̾(����ɽ����)
# @{(^\:|$::separator\:)}
$::non_list = qq((^\:|$::separator\:));
#$::non_list = qq((^\:));
#$::non_list = qq((^\:|$::MenuBar\$)); # example of MenuBar

# ja:ź�եե���������ڡ���������non_list�ǻ��ꤷ���ڡ��������
# @ja{0:�������ʤ�/1:��������}
$::attach_nonlist = 1;

######################################################################
# ja:gzip��������
######################################################################

# ja:gzip�ѥ��λ���
# @ja{:��ưǧ��/nouse:gzip����Ѥ��ʤ�/\/bin\/gzip -1:\/bin\/gzip -1 (��®)/\/usr\/bin\/gzip -1 -f:\/usr\/bin\/gzip -1 -f (��®)/\/usr\/local\/bin\/pigz -1 -f:\/usr\/local\/bin\/pigz -1 -f (���˹�®�Ǥ�������ɸ��ġ���Ǥ�)/\/bin\/gzip -9:\/bin\/gzip -9 (�ǹⰵ��)/\/usr\/bin\/gzip -9 -f:\/usr\/bin\/gzip -9 -f (�ǹⰵ��)/zlib:zlib(perlɸ��饤�֥��Ǥ�������®�Ǥ�)}
$::gzip_path = '';

#$::gzip_path = '/bin/gzip -1';			# fast
#$::gzip_path = '/usr/bin/gzip -1 -f';	# fast
#$::gzip_path = '/usr/local/bin/pigz -1 -f';	# very fast
#$::gzip_path = '/bin/gzip -9';			# max compress
#$::gzip_path = '/usr/bin/gzip -9 -f';	# max compress

# gzip����Ѥ��ʤ����
#$::gzip_path = 'nouse';				# ���Ѥ��ʤ����
										# ư���ʤ���祳���ȥ�����

######################################################################
# ja:�᡼�����Τ�����
######################################################################

# ja:Wiki�������Τ�����ͤ��Τ餻��
# @{0:���⤷�ʤ�/1:�Τ餻��}
$::sendmail_to_admin = 0;

# ja:Wiki�������Τ��Τ餻���ɲå᡼�륢�ɥ쥹
# @{$::modifier_mail\n}
$::addmodifier_mail = '';

# ja:�������ΤΥ᡼��Υإå�
# @{[Wiki]}
$::mail_head = "[Wiki]";

# do not change
$::mail_head_plus = "";

# ja:�ե�����᡼��Υإå�
# @{Form}
$::mail_head{form} = "Form";

# ja:���������Υإå�
# @{New}
$::mail_head{new} = "New";

# ja:�����Υإå�
# @{Modify}
$::mail_head{modify} = "Modify";

# ja:����Υإå�
# @{Delete}
$::mail_head{delete} = "Delete";

# ja:ping�Υإå�
# @{Ping}
$::mail_head{ping} = "Ping";

# ja:���ѥ�Υإå�
# @{Spam}
$::mail_head{spam} = "Spam";

# ja:���ݤΥإå�
# @{Deny}
$::mail_head{deny} = "Deny";

# ja:ź�եե����륢�åץ��ɤΥإå�
# @{AttachUpload}
$::mail_head{attachupload} = "AttachUpload";

# ja:ź�եե��������Υإå�
# @{AttachDelete}
$::mail_head{attachdelete} = "AttachDelete";

# ja:������Υ᡼��Υإå�
# @{Post}
$::mail_head{post} = "Post";

# ja:��ɼ���Υ᡼��Υإå�
# @{Vote}
$::mail_head{vote} = "Vote";

# ja:����ե������ѹ����ΤΥإå�
# @{SetupEdit}
$::mail_head{setupedit} = "SetupEdit";

# ja:����ե����������ΤΥإå�
# @{SetupDelete}
$::mail_head{setupdel} = "SetupDelete";

# ja:�ȥ�å��Хå����ΤΥإå�
# @{TrackBack}
$::mail_head{trackback} = "TrackBack";

# UTF-8�᡼�������  MIME::Base64��ɬ��
# @ja{0:ISO-2022-JP����������/1:UTF8���������� MIME::Base64��ɬ��}
$::send_utf8_mail = 0;

# ja:sendmail�ѥ��λ���
# @{/usr/sbin/sendmail -t\n/usr/bin/sendmail -t\n/usr/lib/sendmail -t\n/var/qmail/bin/sendmail -t}
$::modifier_sendmail = <<EOM;
/usr/sbin/sendmail -t
/usr/bin/sendmail -t
/usr/lib/sendmail -t
/var/qmail/bin/sendmail -t
EOM

# ja:���Ը�����PGP�Ź沽�ΰ٤Υץ����Υѥ��ȥ��ץ����
# @{}
$::modifier_pgp = "";
#$::modifier_pgp = "/usr/local/bin/gpg --always-trust";

# ja:���Ը�����PGP�Ź沽�Υ᡼��������ʻ�̾�ޤ��ϥ᡼�륢�ɥ쥹��
# @{}
$::modifier_pgp_name = "";

# ja:����å������Τ�����ͤ��Τ餻��
# @{0:���Τ��ʤ�/1:���Τ���}
$::sendmail_crash_to_admin = 0;	# compact
$::sendmail_crash_to_admin = 0;	# release
$::sendmail_crash_to_admin = 1;	# devel

# ja:��Ԥ˥���å������Τ���������
# @{0:���Τ��ʤ�/1:���Τ���}
$::sendmail_crash_to_author = 1;	# compact
$::sendmail_crash_to_author = 1;	# release
$::sendmail_crash_to_author = 1;	# devel

# ja:��Ԥ���������ѹ����ʤ��ǲ�������������ͽ��ʤ��ѹ������
# @{pyukiwiki-crash@daiba.cx}
$::sendmail_crash_to_author_mail = 'pyukiwiki-crash@daiba.cx';

######################################################################
# P3P�Υ���ѥ��ȥݥꥷ�� http://fs.pics.enc.or.jp/p3pwiz/p3p_ja.html
# ɬ�פǤ���� /w3c�ʲ��ǥ��쥯�ȥ�ˤ�Ŭ�ڤ˥ե���������֤���ͭ���ˤ��ޤ�
######################################################################
#$::P3P = "NON DSP COR CURa ADMa DEVa IVAa IVDa OUR SAMa PUBa IND ONL UNI COM NAV INT CNT STA";

######################################################################
# �ʥӥ������˥�󥯤��ɲä��륵��ץ�
######################################################################
#push(@::addnavi,"link:help");		# help�������ɲ�
##push(@::addnavi,"link::help");	# help�θ����ɲ�
#$::navi{"link_title"} = "��󥯽�";
#$::navi{"link_url"} = "$::script?%a5%ea%a5%f3%a5%af";	# page of '���'
#$::navi{"link_name"} = "��󥯽�";
#$::navi{"link_type"} = "page";
#$::navi{"link_height"} = 14;
#$::navi{"link_width"} = 16;

######################################################################
# �ǡ����١������󥸥�
######################################################################
$::modifier_dbtype = 'Nana::YukiWikiDB';
#$::modifier_dbtype = 'Nana::GDBM';
#$::modifier_dbtype = 'Nana::SQLite';
# this is obsoleted
#$::modifier_dbtype = 'Yuki::YukiWikiDB';

######################################################################
# ja:���ѥ�ե��륿��
######################################################################

# ja:���ѥ�ե��륿����ͭ���ˤ���
# @{0:̵��/1:ͭ��}
$::filter_flg = 1;
$::chk_uri_count = 10;				# �쥪�ץ����

# ja:Wiki�Խ����̤Ǥ�URL���¸Ŀ�
# @{10}
$::chk_wiki_uri_count = 10;	

# ja:�Ǽ������Ǥ�URL���¸Ŀ�
# @{1}
$::chk_article_uri_count = 1;

# ja:�Ǽ������ǤΥ᡼�륢�ɥ쥹�����¸Ŀ�
# @{1}
$::chk_article_mail_count = 1;

# ja:�Խ����̤����ܸ줬¸�ߤ��ʤ���硢���ѥ�Ȥߤʤ�
# @{0}
$::chk_write_jp_only = 0;

# ja:�Ǽ��ġ��������������ܸ줬��������äƤ��ʤ��ȡ����ѥ�Ȥߤʤ�
# @{1}
$::chk_jp_only = $::lang eq "ja" ? 1 : 0;

# ja:���ե�����
# @{$::cache_dir/deny-log.deny}
$::deny_log = "$::cache_dir/deny-log.deny";

# ja:�ե��륿���ե饰���դ��Ƥ���Ȥ��Υ�������
# @{$::cache_dir/black-lst.deny}
$::black_log = "$::cache_dir/black-lst.deny";

# ja:���ݥꥹ��
# @{$::cache_dir/denylist.deny}
$::deny_list = "$::cache_dir/denylist.deny";

# ja:��ưŪ�˵��ݥꥹ�Ȥ���Ͽ�������
# @{3}
$::auto_add_deny = 3;

# ja:���ݤ�ͭ�����¡�1�����
# @{2678400}
$::deny_expire = 24*60*60*31;

# �񤭹��߶ػߥ������
$::ngwords="ngwords.ini.cgi" if($::ngwords eq "");
require $::ngwords if(-f $::ngwords);
require $::ngwords_file if(-f $::ngwords_file);

# ja:�񤭹��߶ػߥ�ɤ�ͭ���ˤ���
# @{0}
$::use_disablewords = 0;

######################################################################
# ja:�����ॾ��������
######################################################################

# ja:�����ॾ����(GMT�Ȥλ��ֺ���
# @{:��ư����/-12:GMT-12\:00 ���˥����ȥ��������������/-11:GMT-11\:00 �ߥåɥ������硢���⥢/-10:GMT-10\:00 �ϥ磻/-9:GMT-09\:00 ���饹��/-8:GMT-08\:00 ��ʿ��ɸ������ƹ񡢥��ʥ��ˡ��ƥ��ե���/-7:GMT-07\:00 ���꥾��/-7:GMT-07\:00 ����ɸ������ƹ񡢥��ʥ���/-6:GMT-06\:00 ������������/-6:GMT-06\:00 �ᥭ�������ƥ�/-6:GMT-06\:00 �������ꥫ/-6:GMT-06\:00 ����ɸ������ƹ񡢥��ʥ���/-5:GMT-05\:00 ����ǥ���������/-5:GMT-05\:00 �ܥ�������ޡ�����/-5:GMT-05\:00 ����ɸ������ƹ񡢥��ʥ���/-4:GMT-04\:00 ���饫������ѥ�/-4:GMT-04\:00 ����ƥ�����/-4:GMT-04\:00 ������ɸ��� (���ʥ�)/-3.5:GMT-03\:30 �˥塼�ե���ɥ���/-3:GMT-03\:00 ���꡼�����/-3:GMT-03\:30 �֥��Υ������쥹�����硼��������/-3:GMT-03\:00 �֥饸�ꥢ/-2:GMT-02\:00 ���������/-1:GMT-01\:00 �����쥹����/-1:GMT-01\:00 �����ܥ٥�ǽ���/0:GMT+00\:00 �����֥�󥫡�����ӥ�/0:GMT+00\:00 ����˥å�ɸ���/0:GMT+00\:00 ���֥�󡢥�����Х顢�ꥹ�ܥ󡢥��ɥ�/1:GMT+01\:00 ���ॹ�ƥ���ࡢ�٥��󡢥٥�󡢥��ޡ����ȥå��ۥ��/1:GMT+01\:00 ���饨�ܡ������ԥ������ե������ӥ�˥她����륷���������/1:GMT+01\:00 �֥��å��롢�ޥɥ꡼�ɡ����ڥ�ϡ����󡢥ѥ�/1:GMT+01\:00 �٥����顼�ɡ��ץ������С��֥��ڥ��ȡ����֥��ʡ��ץ��/1:GMT+01\:00 ��������եꥫ/2:GMT+02\:00 ���ƥ͡���������֡��롢�ߥ󥹥�/2:GMT+02\:00 ���륵���/2:GMT+02\:00 ������/2:GMT+02\:00 �ϥ顼�졢�ץ�ȥꥢ/2:GMT+02\:00 �֥��쥹��/2:GMT+02\:00 �إ륷�󥭡��ꥬ�������/3:GMT+03\:00 ���������ȡ�����/3:GMT+03\:00 �ʥ����/3:GMT+03\:00 �Х����å�/3:GMT+03\:00 �⥹����ܥ르���顼�ɡ����󥯥ȥڥƥ�֥륰/3.5:GMT+03\:30 �ƥإ��/4:GMT+04\:00 ���֥��ӡ��ޥ����å�/4:GMT+04\:00 �Х����ȥӥꥷ������Х�/4.5:GMT+04\:30 ���֡���/5:GMT+05\:00 ������ޥС��ɡ�����������������/5:GMT+05\:00 �����ƥ��С���/5.5:GMT+05\:30 ���륫�å���������ʥ������Х����˥塼�ǥ꡼/5.75:GMT+05\:45 ���ȥޥ�/6:GMT+06\:00 �������ʡ����å�/6:GMT+06\:00 ����ޥƥ����Υܥ��ӥ륹�� /6:GMT+06\:00 ���ꡢ���������ʥץ�/6.5:GMT+06\:30 ��󥰡���/7:GMT+07\:00 ���饹�Υ�륹��/7:GMT+07\:00 �Х󥳥����ϥΥ������㥫�륿/8:GMT+08\:00 ���륯���ĥ��������С��ȥ�/8:GMT+08\:00 ��������ס��롢���󥬥ݡ���/8:GMT+08\:00 �ѡ���/8:GMT+08\:00 ����/8:GMT+08\:00 �̵����ŷġ������������/9:GMT+09\:00 ������/9:GMT+09\:00 �䥯���ĥ�/9:GMT+09\:00��塢���ڡ����/9.5:GMT+09\:30 ���ǥ졼��/9.5:GMT+09\:30 ����������/10:GMT+10\:00 ���饸�����ȥ�/10:GMT+10\:00 �����٥顢���ܥ�󡢥��ɥˡ�/10:GMT+10\:00 �����ࡢ�ݡ��ȥ�쥹�ӡ�/10:GMT+10\:00 �֥ꥹ�٥�/10:GMT+10\:00 �ۥС���/11:GMT+11\:00 �ޥ����󡢥�������硢�˥塼����ɥ˥�/12:GMT+12\:00 ���������ɡ��������ȥ�/12:GMT+12\:00 �ե��������������å����ޡ���������/13:GMT+13\:00 �̥�����ե�}
$::TZ = '';
#$::TZ = '9';		# ������Τ������Ϥ䤤���⡩�������ѡ�


######################################################################
# �����������
######################################################################
$::disable_wiki_title = 0;
$::disable_wiki_page_title = 0;


######################################################################
1;

__END__
=head1 NAME

pyukiwiki.ini.cgi - This is pyukiwiki setting file

=head1 DESCRIPTION

This file is a configuration file of PyukiWiki.
Please carry out a suitable setup before setting up CGI.

=cut
