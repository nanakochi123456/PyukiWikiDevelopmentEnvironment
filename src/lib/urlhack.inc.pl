######################################################################
# @@HEADER2_NANAMI@@
######################################################################
# This is extented plugin.
# To use this plugin, rename to 'urlhack.inc.cgi'
######################################################################
#
# SEO�к���URL�ϥå��ץ饰����
#
######################################################################

# PATH_INFO ��Ȥ���0�ξ��File not found����­����)
$urlhack::use_path_info=1
	if(!defined($urlhack::use_path_info));
#
# fake extension ��ĥ�ҵ���
$urlhack::fake_extention="/"		# only "/"
	if(!defined($urlhack::fake_extention));
#
# use puny url 0:16�ʥ��󥳡��� 1:puny���󥳡��� 2:UTF8���󥳡��� 3:û��URL
$urlhack::use_puny=1
	if(!defined($urlhack::use_puny));
#
# not convert Alphabet or Number ( or dot and slash) page
$urlhack::noconvert_marks=2	# 0:NO / 1:Alpha&Number / 2:AlphaNumber and mark
	if(!defined($urlhack::noconvert_marks));
#
# force url hack (non extention .cgi)
$urlhack::force_exec=0			# PATH_INFO��Ȥ�ʤ����ǡ���ĥ��CGI�Ǥʤ���硢1������
	if(!defined($urlhack::force_exec));

# û��URL��DB�ʸ����θ���ס�
$urlhack::shortdb="./wikidb"
	if(!defined($urlhack::shortdb));

###################
# sample of shorted wiki url
## PATH_INFO ��Ȥ���0�ξ��File not found����­����)
#$urlhack::use_path_info=0;
##
## fake extension ��ĥ�ҵ���
#$urlhack::fake_extention="";	# use path_info, only "/"
##
## use puny url 0:16�ʥ��󥳡��� 1:puny���󥳡��� 2:UTF8���󥳡��� 3:û��URL
#$urlhack::use_puny=3;
##
## not convert Alphabet or Number ( or dot and slash) page
#$urlhack::noconvert_marks=0; # 0:NO / 1:Alpha&Number / 2:AlphaNumber and mark
##
## force url hack (non extention .cgi)
#$urlhack::force_exec=1;	# PATH_INFO��Ȥ�ʤ����ǡ���ĥ��CGI�Ǥʤ����1������
#
## û��URL��DB�ʸ����θ���ס�
#$urlhack::shortdb="./wikidb";

# canonical (url)
$canonical::url=""
	if(!defined($canonical::url));


# robots.txt �񤭴���
$urlhack::robots_txt=<<EOM	if(!defined($urlhack::robots_txt));
User-agent: *
Allow: /
Crawl-delay: 10
EOM

#
######################################################################

use strict;
use Nana::MD5;
my %urldb;

# Initlize														# comment

sub plugin_urlhack_init {
	&exec_explugin_sub("lang");

	if($urlhack::use_puny eq 3) {
		my $err=&writechk($urlhack::shortdb);
		&print_error($err)  if($err ne '');
		&dbopen($urlhack::shortdb,\%urldb);
	}

	unless($::form{mypage} eq '' || $::form{mypage} eq $::FrontPage) {
		return('init'=>0
			,'func'=>'make_cookedurl',
			, 'make_cookedurl'=>\&make_cookedurl);
	}
	if($urlhack::use_path_info eq 0) {
		return('init'=>&plugin_urlhack_init_notfound
			,'func'=>'make_cookedurl',
			, 'make_cookedurl'=>\&make_cookedurl);
	} else {
		return('init'=>&plugin_urlhack_init_path_info
			,'func'=>'make_cookedurl',
			, 'make_cookedurl'=>\&make_cookedurl);
	}
}

sub plugin_urlhack_init_path_info {
	my $req=$ENV{PATH_INFO};

	# cmd=read�ʳ��ϻ��Ѥ��ʤ�									# comment
	unless($::form{cmd} eq '' || $::form{cmd} eq 'read') {
		return 0;
	}

	# ��ĥ�ҵ������Ƥ����硢�������						# comment
	if($urlhack::fake_extention ne '') {
		my $regex=$urlhack::fake_extention;
		$regex=~s/([\.\/])/'\\x' . unpack('H2', $1)/eg;
		$req=~s/$regex$//g;
	}
	# ����ե��٥åȿ����Τߤǡ��Ѵ����פξ�� FrontPage ��		# comment
	if($urlhack::use_puny ne 3) {
		if(&is_exist_page($req)) {
			$::form{cmd}='read';
			$::form{mypage}=$req;
			return 0;
		}
	}

	# ��������פʥ���å������								# comment
	$req=~s!^/!!g;
	$req=~s!/$!!g;

	# ��ĥ�ҵ������Ƥ����硢�������						# comment
	if($urlhack::fake_extention ne '') {
		my $regex=$urlhack::fake_extention;
		$regex=~s/([\.\/])/'\\x' . unpack('H2', $1)/eg;
		$req=~s/$regex$//g;
	}
	# ����ե��٥åȿ����Τߤǡ��Ѵ����פξ�� FrontPage ��		# comment
	if($urlhack::use_puny ne 3) {
		if(&is_exist_page($req)) {
			$::form{cmd}='read';
			$::form{mypage}=$req;
			return 0;
		}
	}
	$req=&plugin_urlhack_decode($req);
	utf8::encode($req) if(utf8::is_utf8($req));

	# URI�����λ��ν���											# comment
	if($req eq '') {
		# �̾�Υ��󥳡��ɤξ��ν���							# comment
		$req=&decode($ENV{QUERY_STRING});
		if(&is_exist_page($req)) {
			$::form{cmd}='read';
			$::form{mypage}=$req;
			return 0;
		# cmd=read&mypage=xxx �ξ��							# comment
		} elsif(&is_exist_page($::form{mypage})) {
			$::form{cmd}='read';
			return 0;
		}
		# �Ǥʤ���С�FrontPage									# comment
		$::form{cmd}='read';
		$::form{mypage}=$::FrontPage;
		return 0;
	# REDIRECT_URI������������ڡ�����¸�ߤ������				# comment
	} elsif(&is_exist_page($req)) {
		$::form{cmd}='read';
		$::form{mypage}=$req;
		return 1;
	}
	return 0;
}

sub plugin_urlhack_init_notfound {
	# nph������ץȤ���ĥ��.cgi�Ǥʤ���硢���Ѥ��ʤ�			# comment
	if($urlhack::force_exec eq 0) {
		unless($ENV{SCRIPT_NAME}=~/nph-/ || $ENV{REQUEST_URI}=~/\.cgi/) {
			$::debug.="Not used urlhack.inc.cgi\n";
			return 0;
		}
	}
	my $req;

	# ���顼404�ʳ��ϻ��Ѥ��ʤ�									# comment
	if($::form{cmd} eq 'servererror') {
		if($ENV{REDIRECT_STATUS} eq 404) {
			$req=$ENV{REDIRECT_URL};
		} else {
			return 0;
		}
	}

	# 404���֤��줿REDIRECT_URL���ʤ���cmd=read�ʳ��ϻ��Ѥ��ʤ�	# comment
	if($req ne '' || $::form{cmd} eq '' || $::form{cmd} eq 'read') {
		$req=$ENV{REQUEST_URI};
		$req="$req/" if($urlhack::force_exec eq 1 && ($ENV{REQUEST_URI}!~/\.cgi$/ || $ENV{REQUEST_URI}=~/\/$/));
	} else {
		return 0;
	}
	# ?�ʹߤ�̵�뤹��											# comment
	$req=~s/\?.*//g;

	# dot(.)��slash(/)��ͭ���ξ��								# comment
	if($urlhack::noconvert_marks eq 2 || 1) {
		my $uri;
		# ��URI����������������
		if($req ne '') {
			if($req eq $ENV{SCRIPT_NAME}) {
				$uri= $ENV{'SCRIPT_NAME'};
			} else {
				for(my $i=0; $i<length($ENV{SCRIPT_NAME}); $i++) {
					if(substr($ENV{SCRIPT_NAME},$i,1)
						eq substr($req,$i,1)) {
						$uri.=substr($ENV{SCRIPT_NAME},$i,1);
					} else {
						last;
					}
				}
			}
		} else {
			$uri .= $ENV{'SCRIPT_NAME'};
		}
					# slash�Τ�����ɽ���ˤ����뤿�ᥨ��������	# comment
		$uri=~s!/!\x08!g;
		$req=~s!/!\x08!g;
		$req=~s!^$uri!!g;
						# �᤹								# comment
		$req=~s!\x08!/!g;
	} else {
		$req=~s/.*\///g;
		$req=~s/^\///g;
	}
	# ��������פʥ���å������								# comment
	$req=~s!^/!!g;
	$req=~s!/$!!g;

	# ��ĥ�ҵ������Ƥ����硢�������						# comment
	if($urlhack::fake_extention ne '') {
		my $regex=$urlhack::fake_extention;
		$regex=~s/([\.\/])/'\\x' . unpack('H2', $1)/eg;
		$req=~s/$regex$//g;
	}
	# ����ե��٥åȿ����Τߤǡ��Ѵ����פξ�� FrontPage ��		# comment
	if($urlhack::use_puny ne 3) {
		$req=~s/%([A-Fa-f0-9][A-Fa-f0-9])/chr(hex($1))/eg;
		if(&is_exist_page($req)) {
			$::form{cmd}='read';
			$::form{mypage}=$req;
			return 0;
		}
	}
	$req=&plugin_urlhack_decode($req);

	# URI�����λ��ν���											# comment
	if($req eq '') {
		# �̾�Υ��󥳡��ɤξ��ν���							# comment
		$req=&decode($ENV{QUERY_STRING});
		if(&is_exist_page($req)) {
			$::form{cmd}='read';
			$::form{mypage}=$req;
			return 0;
		# cmd=read&mypage=xxx �ξ��							# comment
		} elsif(&is_exist_page($::form{mypage})) {
			$::form{cmd}='read';
			return 0;
		}
		# �Ǥʤ���С�FrontPage									# comment
		$::form{cmd}='read';
		$::form{mypage}=$::FrontPage;
		return 0;
	# REDIRECT_URI������������ڡ�����¸�ߤ������				# comment
	} elsif(&is_exist_page($req)) {
		$::form{cmd}='read';
		$::form{mypage}=$req;
		return 1;
	# �Ǥʤ���С�404 Not found���֤�							# comment
	} else {
#		$::form{cmd}='servererror';
#		$ENV{REDIRECT_STATUS}=404;
#		$ENV{REDIRECT_URL}=$ENV{REQUEST_URI};
#		$ENV{REDIRECT_REQUEST_METHOD}="GET";
#		return 0;
	}
}

# hack wiki.cgi of make_cookedurl								# comment

sub make_cookedurl {
	my($cookedchunk)=@_;
	if($urlhack::force_exec eq 0 && $urlhack::use_path_info eq 0) {
		unless($ENV{SCRIPT_NAME}=~/nph-/ || $ENV{REQUEST_URI}=~/\.cgi/) {
			return("$::script?$cookedchunk");
		}
	}
	$cookedchunk=&decode($cookedchunk);
	my $orgchunk=$cookedchunk;
	if($urlhack::noconvert_marks+0 eq 0) {
		$cookedchunk=&plugin_urlhack_encode($cookedchunk);
	} elsif($cookedchunk=~/(\W)/ && $urlhack::noconvert_marks+0 eq 1) {
		$cookedchunk=&plugin_urlhack_encode($cookedchunk);
	} elsif($cookedchunk=~/([^0-9A-Za-z\.\/])/) {
		$cookedchunk=&plugin_urlhack_encode($cookedchunk);
	}
	my $script=$::script;
	$script=~s/\/$//g;
	if($cookedchunk eq '' || $orgchunk eq $::FrontPage) {
		return "$script/";
	} else {
		return "$script/$cookedchunk$urlhack::fake_extention";
	}
}

sub plugin_urlhack_decode {
	my($str)=@_;
	if($str eq "robots.txt") {
		print &http_header("Content-type: text/plain");
		print $urlhack::robots_txt;
		exit;
	}
	my ($base, $canonicalflg)=&getbase;
	if($str=~/xn\-/) {
		&plugin_urlhack_usepuny;
		$str=~s/\_/\//g;
		$str=IDNA::Punycode::decode_punycode($str);
		$str=&code_convert(\$str, $::defaultcode, 'utf8');
		if($urlhack::use_puny ne 1 || $canonicalflg) {
			$::IN_HEAD.=<<EOM;
<link rel="canonical" href="$base@{[&plugin_urlhack_encode($str,$urlhack::use_puny)]}" />
EOM
			$canonicalflg=0;
		}
	} elsif(&urldb_decode($str) ne '') {
		$str=&urldb_decode($str);
		if($urlhack::use_puny ne 3 || $canonicalflg) {
			$::IN_HEAD.=<<EOM;
<link rel="canonical" href="$base@{[&plugin_urlhack_encode($str,$urlhack::use_puny)]}" />
EOM
			$canonicalflg=0;
		}
	} elsif($str=~/^[0-9A-Fa-f]+/) {
		$str=~s/([A-Fa-f0-9][A-Fa-f0-9])/pack("C", hex($1))/eg;
		if($urlhack::use_puny ne 0 || $canonicalflg) {
			$::IN_HEAD.=<<EOM;
<link rel="canonical" href="$base@{[&plugin_urlhack_encode($str,$urlhack::use_puny)]}" />
EOM
			$canonicalflg=0;
		}
	} else {
		my $tmp=&decode($str);
		$str=&code_convert(\$tmp, $::defaultcode, 'utf8');
		if($urlhack::use_puny ne 2 || $canonicalflg) {
			$::IN_HEAD.=<<EOM;
<link rel="canonical" href="$base@{[&plugin_urlhack_encode($str,$urlhack::use_puny)]}" />
EOM
			$canonicalflg=0;
		}
	}
	if($canonicalflg) {
		$::IN_HEAD.=<<EOM;
<link rel="canonical" href="$base$str" />
EOM
	}
	$str=~s/\+/\ /g;
	$str=~s/\!2b/\+/g;
	return $str;
}

sub plugin_urlhack_encode {
	my($str, $enc)=@_;
	$enc=$enc eq '' ? $urlhack::use_puny : $enc;
	if($enc eq 0) {
		$str=~ s/(.)/unpack('H2', $1)/eg;
	} elsif($enc eq 2) {
		$str=&encode(&code_convert(\$str, 'utf8', $::defaultcode));
#		$str=~s!%20!+!g;	# comment
		$str=~s!\+!%20!g;	# fixed 0.2.0-p3	# comment
		$str=~s!%2d!-!g;
		$str=~s!%2[Ff]!/!g;
	} elsif($enc eq 3) {
		$str=&urldb_encode($str);
	} else {
		&plugin_urlhack_usepuny;
		$str=~s/\+/!2b/g;
		$str=~s/\ /+/g;
		my $org=$str;
		$str=&code_convert(\$str, 'utf8', $::defaultcode);
		utf8::decode($str);
		$str=IDNA::Punycode::encode_punycode($str);
		$str=~s/\-{3,9}/--/g;
		$str=~s/\//\_/g if($str ne $org);
		utf8::encode($str);
		$str=~s!%2d!-!g;
	}
	return $str;
}

sub urldb_decode {
	my($str)=shift;
	&dbopen($urlhack::shortdb,\%urldb);
	my $str=$urldb{"p$::lang" . $str};
	return $str;
}

sub urldb_encode {
	my($str)=shift;
	my $try=62;
	my $chk=$urldb{"c$::lang" . $str};
	if($chk ne '') {
		return $chk;
	}
	my $count=$urldb{"sys-count"}+0;
	my $keylen;
	my $tmp=1;
	for(my $i=1; $i<=30; $i++) {
		$keylen=$i;
		$tmp=$tmp * $try;
			last if($count < $tmp);
	}
	my $c=0;
	my $hashedurl;
	my $cmpedurl;
	do {
		$hashedurl=Nana::MD5::md5($c . time . $c . $str);
		$c++;
		$cmpedurl=substr(&trip($hashedurl),0, $keylen);
		if($urldb{"p$::lang" . $cmpedurl} eq '') {
			$urldb{"c$::lang" . $str}=$cmpedurl;
			$urldb{"p$::lang" . $cmpedurl}=$str;
			$urldb{"sys-count"}=($count+1);
			$str=$cmpedurl;
			return $str;
		}
	} while($c<1000);
	return $str;
}

sub trip {
	my ($tripkey)=shift;
	$tripkey = substr($tripkey,1);
	my $salt = substr($tripkey.'H.',1,2);
	$salt =~ s/[^\.-z]/\./go;
	$salt =~ tr/:;<=>?@[\\]^_`/ABCDEFGabcdef/;
	my $trip = crypt($tripkey,$salt);
	$trip =~ tr/\/:;<=>?@[\\]^_`./ABCDEFGHabcdefgh/;
	return $trip;
}

sub plugin_urlhack_usepuny {
	if($::puny_loaded+0 ne 1) {
		if($] < 5.008001) {
			die "Perl v5.8.1 required this is $]";
		}
		$::puny_loaded=1;
		require "$::explugin_dir/IDNA/Punycode.pm";
	}
	IDNA::Punycode::idn_prefix('xn--');
}

sub getbase {
	&getbasehref;
	if($canonical::url=~/$::isurl/) {
		if(substr($canonical::url, 0, length($canonical::url)) ne substr($::basehref, 0, length($canonical::url))) {
			if($::IN_HEAD!~/rel="canonical"/) {
				return ($canonical::url, 1);
			}
		}
	}
	return ($::basehref, 0);
}

1;
__DATA__
	return(
		ja=>'SEO�к���URL�ϥå�',
		en=>'The measure against SEO',
		override=>'make_cookedurl',
		setting_ja=>
			'$::urlhack_use_path_info=�᥽�å�:1=PATH_INFO,0=Not Found ���顼/' .
			'$::urlhack_fake_extention=���γ�ĥ�Ҥ�����:=�ʤ�,.html,/=�ǥ��쥯�ȥ�˸�����/' .
			'$::urlhack_noconvert_marks=���󥳡��ɤ��ʤ�ʸ��:0=���٤ƥ��󥳡���,1=����ե��٥åȤȿ����ΤߤΥڡ����Τ�,2=����ե��٥åȤȿ������ɥåȡ�����å���',
		setting_en=>
			'$::urlhack_use_path_info=Method:1=PATH_INFO,0=Not Found Error/' .
			'$::urlhack_fake_extention=Fake extention:=none,.html,/' .
			'$::urlhack_noconvert_marks=Not convert charactors:0=All encode,1=Alphabet and number of page name,2=Alphabet and number and dot and slash',
		url=>'@@BASEURL@@/PyukiWiki/Plugin/ExPlugin/urlhack/'
	);
__END__

=head1 NAME

urlhack.inc.pl - PyukiWiki Plugin

=head1 SYNOPSIS

The measure against SEO (Serach Engine Optimize), remove URL of '?' to hit to a search engine

=head1 DESCRIPTION

In robot type search engines, (eg. Google, Yahoo), it coming to be hard to carry out the crawl of the page which is a script clearly. Therefore, the result of the search engine of a site may carry out a rank down.

Therefore, it is remove URL of '?' and the method of making a robot recognizing PyukiWiki not as a dynamic page but as a static page is offered.

=head1 USAGE

=head2 Enable plugin

Rename to urlhack.inc.cgi

=head2 Using PATH_INFO

By the default, since PATH_INFO is used, use use can be carried out as it is.

Also in a not corresponding server, this operates lightly.

http://example.com/ etc. does not support URL which makes a CGI name omit as a TOP page.


When the actual condition is http://example.com/index.cgi, please rename B<index.cgi> to B<wiki> and following description recommend you add to .htaccess following description.

 <FilesMatch "^wiki$">
    ForceType application/x-httpd-cgi
 </FilesMatch>

Let http://example.com/wiki be a TOP page by carrying out like this.

=head2 Using 404 Not found error from redirect server error

Although this can respond to many servers and omitted URL, there is a problem that a error log remains in a server whenever it is accessed.

However, the server which the nph script does not support cannot use it.

=over 4

=item index.cgi etc...

In order to make it operate as a nph script, it renames to nph-index.cgi etc.

=item urlhack.inc.cgi

change from B<$urlhack::use_path_info=1;> to B<$urlhack::use_path_info=0;>

=item .htaccess

 DirectoryIndex B<nph-index.cgi> index.cgi wiki.cgi pyukiwiki.cgi index.html

 RewriteEngine on
 RewriteBase /
 
 RewriteCond %{REQUEST_URI} !^/(attach|cache|image|skin)
 RewriteRule ^\?(.*)$ ./index.cgi?$1 [L]
 RewriteCond %{REQUEST_URI} !^/(attach|cache|image|skin)
 RewriteRule ^(.+)/$ ./index.cgi/$1 [L]
 RewriteCond %{REQUEST_URI} !^/(attach|cache|image|skin)
 RewriteRule ^$ ./index.cgi [L]

 ErrorDocument 400 /nph-index.cgi?cmd=servererror
 ErrorDocument 401 /nph-index.cgi?cmd=servererror
 ErrorDocument 402 /nph-index.cgi?cmd=servererror
 ErrorDocument 403 /nph-index.cgi?cmd=servererror
 ErrorDocument 404 /nph-index.cgi?cmd=servererror
 ErrorDocument 500 /nph-index.cgi?cmd=servererror

=head1 SETTING

=over 4

=item $urlhack::use_path_info

When using a PATH_INFO environment variable, it is set 1, using 404 Not found of error it is set 0.

=item $urlhack::fake_extention

Sorry. this option is '/' only ;;

 $urlhack::fake_extention='/';
 http://example.com/FrontPage/
 http://example.com/PyukiWiki/Download/
 http://example.com/a5d8a5eba5d7/

=item $urlhack::use_puny

 0:Hex encode
 1:Puny encode
 2:UTF8 encode
 3:shorted encode (use Dictionary Database)

=item $urlhack::noconvert_marks

In the case of the page name which consists of only specified characters, it does not encode.

 0: Unconditional encoding is carried out.
 1: Only the page which consists of only a number and the alphabet does not encode.
 2: Only the page which consists of a number, the alphabet, dot (.), and slash (/) does not encode.

=back

=head1 OVERRIDE

make_cookedurl was overrided.

=head1 SEE ALSO

=over 4

=item PyukiWiki/Plugin/ExPlugin/urlhack

L<@@BASEURL@@/PyukiWiki/Plugin/ExPlugin/urlhack/>

=item PyukiWiki CVS

L<@@CVSURL@@/PyukiWiki-Devel/lib/urlhack.inc.pl>

=back

=head1 AUTHOR

=over 4

@@AUTHOR_NANAMI@@

@@AUTHOR_PYUKI@@

=back

=head1 LICENSE

@@LICENSE_NANAMI@@

=cut
