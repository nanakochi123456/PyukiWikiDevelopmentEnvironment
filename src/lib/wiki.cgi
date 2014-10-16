######################################################################
# @@HEADER1@@
######################################################################
$|=1;	# debug
##############################									# comment
#use Nana::YukiWikiDB;
#use Nana::YukiWikiDB_GZIP;										#nocompact
$::modifier_dbtype = 'Nana::YukiWikiDB'
	if(!defined($::modifier_dbtype));
%::db_extention;

##############################
use CGI qw(:standard);
#use CGI::Carp qw(fatalsToBrowser);
use Nana::Carp;
# debug
use Time::Local;
##############################									# comment
# 2005.10.27 pochi: ��ư��󥯵�ǽ���ĥ ('?' | 'this' | '')	# comment
$::editchar = '?';
##############################									# comment
$::subject_delimiter = ' - ';
$::use_exists = 1;	# If you can use 'exists' method for your DB.	# comment

##############################									# comment
$::package = 'PyukiWiki';
 #$::version = '0.2.1-beta6';
$::version = '0.2.1-customoer-preview';
 $::version.="-utf8";#utf8

$::versionnumber=0 * 10000 + 21 * 100 + 5;

# 2005.12.19 pochi: mod_perl�Ǽ¹Բ�ǽ��					# comment
# �����Х�ؿ������										# comment
# moved 0.2.1 to wiki_sub.cgi (auto generate)				# comment

%::values=();

# �����󥿤γ�ĥ��										# comment

$::counter_ext = '.count';
my $lastmod;			# v0.0.9

%::database;			# database						# comment
%::infobase;			# infobase						# comment
%::diffbase;			# diffbase						# comment
%::backupbase;			# backupbase#nocompact			# comment
%::resource;			# resource						# comment
%::form;				# form							# comment
%::interwiki;			# interwiki						# comment
$::pageplugin=0;		# is page editing plugin flag	# comment

%::_plugined;			# 1:Pyuki/2:Yuki/0:None			# comment
%::_exec_plugined;		# 2:Inited/1:Loaded/0:None		# comment
%::_exec_plugined_func;	# override functions			# comment
%::_exec_plugined_value;# override values				# comment
%::_module_loaded;		# perl module					# comment
%::_resource_loaded;	# module						# comment

@::navi=();				# default navigator link array	# comment
@::addnavi=();			# adding navigator link array	# comment
%::navi=();				# navigator link				# comment
%::dtd;					# dtd define					# comment

%::_urlescape;			# for &encode					# comment
%::_dbmname_encode;		# for &dbmname					# comment
%::_dbmname_decode;		# for &undbmname				# comment

%::_date_ampm;			# for &date						# comment
%::_date_ampm_locale;
%::_date_weekday;
%::_date_weekdaylength;
%::_date_weekday_locale;
%::_date_weekdaylength_locale;

$::HTTP_HEADER;			# http header							# comment
$::IN_HEAD;				# adding <head>~</head> from plugin		# comment
$::IN_JSHEADVALUE;		# adding <head>~</head> JavaScript		# comment
$::IN_JSHEAD;			# adding <head>~</head> JavaScript		# comment
$::IN_CSSHEAD;			# adding <head>~</head> CSS				# comment
$::IN_CSSFILES;			# adding <head>~</head> CSS				# comment
$::IN_JSFILES;			# adding <head>~</head> JavaScript		# comment
$::IN_JSLOADER;			# adding <head>~</head> JavaScript		# comment

$::IN_BODY;				# adding <body> tag from plugin			# comment
$::IN_TITLE;			# adding <title> tag from plugin		# comment
$::IN_META_ROBOTS;		# robots control						# comment

$::is_xhtml;			# XHTML Flag							# comment
$gzip_header;			# gzip commpression header				# comment
$explugin_last;			# Ex Plugin Last Exec Module			# comment
@::loaded_explugin;		# Loaded Ex Plugin						# comment

# 2006.1.30 pochi: ���ԥ⡼�ɤ�����								# comment
$::lfmode;
$::escapeoff_exec;		# Disable ESC key for IE				# comment

$::highlight_exec=0;											#nocompact

$::linesave=0;			# save lines for plugin flag			# comment
$::linedata;			# save lines for plugin					# comment
$::eom_string;			# end of message for plugin				# comment
$::exec_inlinefunc;		# exec inline func						# comment
%::jscss_included;		# Load JavaScript and CSS				# comment

@::notes = ();
$::followtag_pub;		# follow control 	#nocompact

# ini�ե������ɤ߹���											# comment
#$::ini_file = 'pyukiwiki.ini.cgi' if($::ini_file eq '');		# comment
#require $::ini_file;											# comment
#require $::setup_file if (-r $::setup_file);					# comment

## ������ե�����ν����										# comment
#&skin_init;													# comment

##############################									# comment
# WikiName														# comment
$::wiki_name = '@@exec="./build/wikiname.regex"@@';

# [[BracketName]]												# comment
$::bracket_name ='@@exec="./build/bracketname.regex"@@';

# InterWiki���													# comment
$::interwiki_definition = '@@exec="./build/interwikidef1.regex"@@';
$::interwiki_definition2 = '@@exec="./build/interwikidef2.regex"@@';

# InterWiki�Υ��												# comment
$::interwiki_name1 = '@@exec="./build/interwikiname1.regex"@@';
$::interwiki_name2 = '@@exec="./build/interwikiname2.regex"@@';

# URL������ɽ��													# comment
if($::useFileScheme eq 1) {
	$::isurl=qq(@@exec="./build/url_withfile.regex"@@);
} else {
	$::isurl=qq(@@exec="./build/url.regex"@@);
}

# �᡼�륢�ɥ쥹������ɽ��										# comment
$::ismail=q{@@exec="./build/mail.regex"@@};
$::ismail=q{@@exec="./build/mail_intra.regex"@@} if($::IntraMailAddr>0);

# ������ĥ�Ҥ�����ɽ��											# comment
$::image_extention=qq(@@exec="./build/image.regex"@@);
##############################									# comment
# IPV4���ɥ쥹������ɽ��										# comment
$::ipv4address_regex=qq(@@exec="./build/regipv4.regex"@@);

# IPV6���ɥ쥹������ɽ��										# comment
$::ipv6address_regex=qq(@@exec="./build/regipv6.regex"@@);		#nocompact

# �֥�å����ץ饰����											# comment
$::embed_plugin = '@@exec="./build/block_plugin.regex"@@';
$::embedded_name = '@@exec="./build/block_plugin_name.regex"@@';

# ����饤�󷿥ץ饰����										# comment
$::embedded_inline='@@exec="./build/inline_plugin.regex"@@';

##############################									# comment
# InfoBase�ι���̾												# comment
$::info_ConflictChecker = 'ConflictChecker';
$::info_LastModified = 'LastModified';
$::info_CreateTime='CreateTime';
$::info_LastModifiedTime='LastModifiedTime';
$::info_UpdateTime='UpdateTime';
$::info_IsFrozen = 'IsFrozen';
$::info_AdminPassword = 'AdminPassword';
##############################									# comment
# ����ڡ���̾													# comment
%::fixedpage = (
	$::AdminPage => 'admin',
	$::ErrorPage => '',
	$::RecentChanges => 'recent',
	$::IndexPage => 'list',
	$::SearchPage => 'search',
	$::CreatePage => 'newpage',
);

	# �Խ��Բĥץ饰����										# comment
%::fixedplugin = (
	'newpage' => 1,
	'search' => 1,
	'list' => 1,
);

	# �������ޥ��												# comment
my %command_do = (
	read => \&do_read,
	write => \&do_write,
);

&main;
exit(0);
##############################									# comment

=head1 NAME

wiki.cgi - This is PyukiWiki, yet another Wiki clone.

=head1 DESCRIPTION

PyukiWiki is yet another Wiki clone. Based on YukiWiki

PyukiWiki can treat Japanese WikiNames (enclosed with [[ and ]]).
PyukiWiki provides 'InterWiki' feature, RDF Site Summary (RSS),
and some embedded commands (such as [[# comment]] to add comments).

=head1 SEE ALSO

=over 4

=item PyukiWiki/Dev/Specification/wiki.cgi

L<@@BASEURL@@/PyukiWiki/Dev/Specification/wiki.cgi/>

=item PyukiWiki CVS

L<@@CVSURL@@/PyukiWiki-Devel/lib/wiki.cgi>

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

=lang ja

=head1 FUNCTIONS

=head2 main

=over 4

=item ������

�ʤ�

=item ����

�ʤ�

=item �����С��饤��

�Բ�

=item ����

PyukiWiki�ν�����򤹤롣

=back

=cut

sub main {
	&load_wiki_module("sub", "func", "version");

	# XS�����뤫�����å�����			# comment # devel
	if(&load_module("NanaXS::func") ne undef) {		# devel
		$::version.="-xs";							# devel
	}												# devel

	&writablecheck;
	&getbasehref;

	&init_lang;
	&init_dtd;
	&init_global;
	&init_follow;			#nocompact
	&skin_init;

	# fix titles
	$::meta_keyword=$::wiki_title if($::meta_keyword eq "PyukiWiki");
	$::modifier_rss_title=$::wiki_title if($::modifier_rss_title eq "PyukiWiki");
	$::modifier_rss_description=$::wiki_title if($::modifier_rss_description eq "Modified by anonymous");

	# CGI.pm�ν����										# comment
	$qCGI=new CGI;

	# ����꥽�������ɤ߹���								# comment
	%::resource = &read_resource("$::res_dir/resource.$::lang.txt");

	# ����ʸ����ν����									# comment
	&dateinit;

	# �ѿ������											# comment
	$::HTTP_HEADER = '';
	$::IN_HEAD = '';
	if($::P3P ne '') {
		$::HTTP_HEADER.=qq(P3P: CP="$::P3P"\n);
	}

	# &check_modifiers;										# comment
	&init_db;				# DB���󥸥�ν����			# comment
	&open_db;				# DB�򳫤�						# comment
	&init_form;				# �ե�����ν����				# comment
	&init_InterWikiName;	# interwiki�ν����				# comment
	&init_inline_regex;		# ����饤������ɽ���ν����	# comment

	# Ex�ץ饰����(*.inc.cgi)�ε�ư							# comment
	&exec_explugin if($::useExPlugin > 0);

	# gzip���̽����										# comment
	&gzip_init;

	# ��ư�ꥫ�Х꡼										# comment
	&init_recovery;

	# �������ޥ��(cmd=read, cmd=write)�ε�ư				# comment
	my $ret=1;
	if ($command_do{$::form{cmd}}) {
		$ret=&{$command_do{$::form{cmd}}};
	}
	# ���������ץ饰����(?cmd=)�ε�ư						# comment
	if($ret eq 1) {
		if (&exec_plugin == 1) {
			$::form{mypage} = $::FrontPage if (!$::form{mypage});
			$::pageplugin=1;
			&do_read;
		}
	}
	# DB���Ĥ���											# comment
	&close_db;
}

	# not delete for d e b u g
sub _db {
	my($arg)=@_;
	return($arg);
}


=lang ja

=head2 print_error

=over 4

=item ������

&print_error(���顼��å�����);

=item ����

�ʤ�

=item �����С��饤��

��

=item ����

���顼��å���������Ϥ��롣

=back

=cut

sub print_error {
	my ($msg) = @_;
	&skinex("\t\t$ErrorPage", qq(<p><strong class="error">$msg</strong></p>), 0);
	close(STDOUT);
	exit(0);
}

=lang ja

=head2 message

=over 4

=item ������

&message(ɽ��ʸ����);

=item ����

HTML

=item �����С��饤��

��

=item ����

��å���������Ϥ��롣

=back

=cut

sub message {
	my ($msg) = @_;
	return qq(<p><strong>$msg</strong></p>);
}

=lang ja

=head2 reregist_subs

=over 4

=item ������

&reregist_subs("�ؿ�̾", "�ؿ�̾", ....);

=item ����

�ʤ�

=item �����С��饤��

��

=item ����

�����ؿ����������롣

=back

=cut

sub reregist_subs {
	my (@args)=@_;
	foreach my $arg(@args) {
		my $stat=eval {"exists &$arg;"};
		if($stat) {
	# http://d.hatena.ne.jp/perlcodesample/20081210/1228922629	# comment
			eval qq( sub $arg { return \&\_$arg(\@_); });
			unless($@) {						# debug
				$::debug.="$arg registed\n"		# debug
			} else {							# debug
				$::debug.="$arg regist failed\n"# debug
			}									# debug
		}
	}
}

=lang ja

=head2 load_wiki_module

=over 4

=item ������

&load_wiki_module("PyukiWiki�����⥸�塼��̾", ....);

=item ����

�ʤ�

=item �����С��饤��

��

=item ����

ʬ�䤵�줿�����⥸�塼����ɤ߹���

=back

=cut

sub load_wiki_module {
	my (@args)=@_;
	foreach my $arg(@args) {
		my $f="$::sys_dir/wiki\_$arg.cgi";
		if(-r $f) {
			if(!$::loaded_wiki_module{$arg}++) {
				eval qq(require "$f";);
				unless($@) {						# debug
					$::debug.="Load module $arg\n";		# debug
				} else {							# debug
					$::debug.="Load module $arg failed\n";# debug
				}									# debug
			}
		}
	}
}

1;
__END__
