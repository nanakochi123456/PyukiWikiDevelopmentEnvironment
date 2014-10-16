######################################################################
# @@HEADER1@@
######################################################################

	# SGML�δ�ʸ���Υ��������ץ����ɤμ��λ��Ȥ�����ɽ��		# comment
$::_sgmlescape=q{@@exec="./build/sgmlescape.regex"@@};

	# HTML���������פΥơ��֥�									# comment
%::_htmlspecial = (
	'&' => '&amp;',
	'<' => '&lt;',
	'>' => '&gt;',
	'"' => '&quot;',
);

	# HTML���󥨥������פΥơ��֥�								# comment
%::_unescape = (
	'amp'  => '&',
	'lt'   => '<',
	'gt'   => '>',
	'quot' => '"',
);

=head1 NAME

wiki_func.cgi - This is PyukiWiki, yet another Wiki clone.

=head1 SEE ALSO

=over 4

=item PyukiWiki/Dev/Specification/wiki_func.cgi

L<@@BASEURL@@/PyukiWiki/Dev/Specification/wiki_func.cgi/>

=item PyukiWiki CVS

L<@@CVSURL@@/PyukiWiki-Devel/lib/wiki_func.cgi>

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

=head2 getbasehref

=over 4

=item ������

�ʤ�

=item ����

$::basehref, $::basepath, $::script

=item �����С��饤��

��

=item ����

���Ȥʤ�URL��������롣

����ä� $::basehref�ڤ� $::basepath�����ꤵ��Ƥ�����ϲ��⤷�ʤ���

=back

=cut

sub _getbasehref {
	# Thanks moriyoshi koizumi.
	return if($::basehref ne '');
	$::basehost = "$ENV{'HTTP_HOST'}";
	my $schme;
	my $port;

	# changed on 0.2.1
	if($ENV{'https'} =~ /on/i) {
		$schme="https";
		if($ENV{SERVER_PORT} ne 443 && $::basehost!~/:\d/) {
			$port=$ENV{SERVER_PORT};
		}
	}
	if($ENV{SERVER_PORT} eq 443) { 
		$schme="https";
	}
	if($schme eq "") {
		$schme="http";
		if($ENV{SERVER_PORT} ne 80 && $::basehost!~/:\d/) {
			$port=$ENV{SERVER_PORT};
		}
	}

	$::basehost=$schme . '://' . $::basehost;
	$::basehost.=":$port" if($port ne "");

	# URL������									# comment
	my $uri;
	my $req=$ENV{REQUEST_URI};
	$req=~s/\?.*//g;
	if($req ne '') {
		if($req eq $ENV{SCRIPT_NAME}) {
			$uri= $ENV{'SCRIPT_NAME'};
		} else {
			for(my $i=0; $i<length($ENV{SCRIPT_NAME}); $i++) {
				if(substr($ENV{SCRIPT_NAME},$i,1) eq substr($req,$i,1)) {
					$uri.=substr($ENV{SCRIPT_NAME},$i,1);
				} else {
					last;
				}
			}
		}
	} else {
		$uri .= $ENV{'SCRIPT_NAME'};
	}
	$uri=~s/($::defaultindex)//g;
	$uri=~s/\/\//\//g;
	$::basehref=$::basehost . $uri;
	$::basepath=$uri;
	$::basepath=~s/\/[^\/]*$//g;
	$::basepath="/" if($::basepath eq '');
	$::script=$uri if($::script eq '');

	return($::basehref, $::basepath, $::script);
}

=lang ja

=head2 jscss_include

=over 4

=item ������

&jscss_include(plugin name, [load list], [Priority]);

=item ����

HTML����

=item �����С��饤��

��

=item ����

�ץ饰���������JavaScript��CSS���ɤ߹���ʸ������������롣

Nekyo���PyukiWiki�ȸߴ����Ϥ���ޤ���

=back

=cut

my $oldflg=0;

sub _jscss_include {
	my($v, $sub, $p)=@_;
	my($name, $func)=split(/:/,$v);

	if(!$::jscss_included{$name}) {
		if($oldflg eq 0) {
			$oldflg=&_is_no_xhtml(1) eq 0 ? 2 : 1;
		}

		$::jscss_included{$name}=1;
		return if($name!~/^\w{1,64}/);

		foreach("$name%s.css", "$name%s.js") {#, "$::skin_name.$name%s.js") {
#			my $result=&skin_check($_, ".unicode.$::lang", ".$kanjicode.$::lang", ".$::lang", "");
			my $result=&skin_check($_, "");
			if($result ne '') {
				if($result=~/\.js$/) {
					if($oldflg eq 2) {
						if(!$::jscss_included{"loader"}) {
							$::IN_JSLOADER.=<<EOM;
<script type="text/javascript" src="$::skin_url/loader.js" charset="$::charset"></script>
EOM
							$::jscss_included{"loader"}=2;
						}
						my $pro=$p + 0 > 0 ? $p : $name=~/common/ ? 6 : $name eq "jquery" ? 9 : $name=~/jquery/ ? 7 : 3;
	#					my $pro=$p+0>0 ? $p : $_pro;
						$::IN_JSFILES.=',"' . "$pro,$::skin_url/$result@{[$func ? qq(\|$func) : qq()]}" . '"';
					} else {
							$::IN_JSLOADER.=<<EOM;
<script type="text/javascript" src="$::skin_url/$result" charset="$::charset"></script>
EOM
					}
					$::jscss_included{$name}=2;
				} elsif($result=~/\.css$/) {
					$sub='media="screen"' if($sub eq "");
					$::IN_CSSFILES.=<<EOM;
<link rel="stylesheet" href="$::skin_url/$result" type="text/css" $sub charset="$::charset" />
EOM
					$::jscss_included{$name}=2;
				}
			}
		}
	}
	return '';
}

=lang ja

=head2 getcookie

=over 4

=item ������

&getcookie($cookie�μ���ID, %cookie����);

=item ����

%cookie����

=item �����С��饤��

��

=item ����

cookie��������롣

=back

=cut

sub _getcookie {
	&load_module("Nana::Cookie");
	return Nana::Cookie::getcookie(@_);
}

=lang ja

=head2 setcookie

=over 4

=item ������

&setcookie($cookie�μ���ID,ͭ������,%cookie����);

=item ����

�ʤ�

=item �����С��饤��

��

=item ����

cookie�����ꤹ�뤿���HTTP�إå����򥻥åȤ��롣

ͭ�����¤ˤϡ��ʲ��ο��ͤΤ�����Ǥ��롣

�� 1��$::cookie_expire��ͭ���ˤ��롣

�� 0�����å����Τ���¸���롣

��-1��cookie��õ�롣

=back

=cut

sub _setcookie {
	&load_module("Nana::Cookie");
	return Nana::Cookie::setcookie(@_);
}

=lang ja

=head2 read_resource

=over 4

=item ������

&read_resource(�ե�����̾, %�꥽��������);

=item ����

%�꥽��������

=item �����С��饤��

��

=item ����

�꥽�����ե�������ɤ߹���

=back

=cut

sub _read_resource {
	my ($file,%buf) = @_;
	return %buf if $::_resource_loaded{$file}++;
	my $fp=&_safe_open($file);
	my $addkey;
	my $addvalue;
	my $flg=0;
	while (<$fp>) {
		next if /^#/;
		s/[\r\n]//g;
		s/\\n/\n/g;
		if(/\\$/) {
			s/\\$//;
			if(/=/ && $flg eq 0) {
				($addkey, $addvalue) = split(/=/, $_, 2);
				$flg=1;
			} else {
				$addvalue.=$_;
			}
		} else {
			$flg=0;
			if($addkey ne "" && $addvalue ne "") {
				$buf{$addkey}=(defined($::resource_patch{$addkey}) ? $::resource_patch{$addkey} : $addvalue . $_);
				$addkey="";
				$addvalue="";
			} else {
				my ($key, $value) = split(/=/, $_, 2);
				$buf{$key}=(defined($::resource_patch{$key}) ? $::resource_patch{$key} : $value);
			}
		}
	}
	close($fp);
	return %buf;
}

=lang ja

=head2 armor_name

=over 4

=item ������

&armor_name(ʸ����);

=item ����

�Ѵ����줿ʸ����

=item �����С��饤��

��

=item ����

�ʲ���ʸ�����Ѵ���Ԥʤ���

��WikiName��WikiName

��WikiName�ǤϤʤ����Ρ�WikiName�ǤϤʤ��ϡ�

=back

=cut

sub _armor_name {
	my ($name) = @_;
	return ($name =~ /^$wiki_name$/o) ? $name : "[[$name]]";
}

=lang ja

=head2 unarmor_name

=over 4

=item ������

&armor_name(ʸ����);

=item ����

�Ѵ����줿ʸ����

=item �����С��饤��

��

=item ����

�ʲ���ʸ�����Ѵ���Ԥʤ���

��WikiName��WikiName

���Ρ�WikiName�ǤϤʤ��ϡϢ�WikiName�ǤϤʤ�

=back

=cut

sub _unarmor_name {
	my ($name) = @_;
	return ($name =~ /^$bracket_name$/o) ? $1 : $name;
}

=lang ja

=head2 is_bracket_name

=over 4

=item ������

&is_bracket_name(ʸ����);

=item ����

�֥饱�åȤǤ��뤫�Υե饰

=item �����С��饤��

��

=item ����

�֥饱�åȤǤ��뤫�Υե饰���֤���

=back

=cut

sub _is_bracket_name {
	my ($name) = @_;
	return ($name =~ /^$bracket_name$/o) ? 1 : 0;
}

=lang ja

=head2 dbmname

=over 4

=item ������

&dbmname(ʸ����);

=item ����

�Ѵ����줿ʸ����

=item �����С��饤��

��

=item ����

ʸ�����DB�Ѥ�HEX�Ѵ����롣

=back

=cut

sub _dbmname {
	my ($name) = @_;
	if($::_module_loaded{NanaXS::func}) {
		return NanaXS::func::dbmname($name);
	} else {
#		$name =~ s/(.)/uc unpack('H2', $1)/eg;				# comment
		$name =~ s/(.)/$::_dbmname_encode{$1}/g;
		return $name;
	}
}

=lang ja

=head2 undbmname

=over 4

=item ������

&undbmname(ʸ����);

=item ����

�Ѵ����줿ʸ����

=item �����С��饤��

��

=item ����

DB�Ѥ�HEX�Ѵ����줿ʸ������᤹

=back

=cut

sub _undbmname {
	my ($name) = @_;
	if($::_module_loaded{NanaXS::func}) {
		return NanaXS::func::undbmname($name);
	} else {
#		$name =~ s/(.)/uc unpack('H2', $1)/eg;					# comment
		$name =~ s/([0-9A-F][0-9A-F])/$::_dbmname_decode{$1}/g;
		return $name;
	}
}

=lang ja

=head2 decode

=over 4

=item ������

&decode(ʸ����);

=item ����

�Ѵ����줿ʸ����

=item �����С��饤��

��

=item ����

URL���󥳡��ɤ��줿ʸ�����ǥ����ɤ��롣

=back

=cut

sub _decode {
	my ($s) = @_;
	if($::_module_loaded{NanaXS::func}) {
		return NanaXS::func::decode($name);
	} else {
		$s =~ tr/+/ /;
#		$s =~ s/%([A-Fa-f0-9][A-Fa-f0-9])/pack("C", hex($1))/eg;	# better ? # debug	# comment
		$s =~ s/%([A-Fa-f0-9][A-Fa-f0-9])/chr(hex($1))/eg;
		# add 0.2.0-p1	# comment
		$s =~ s/%(25)/chr(hex($1))/eg;
		return $s;
	}
}

=lang ja

=head2 encode

=over 4

=item ������

&encode(ʸ����);

=item ����

�Ѵ����줿ʸ����

=item �����С��饤��

��

=item ����

URL���󥳡��ɤ򤹤롣

=back

=cut

sub _encode {
	my ($encoded) = @_;
	if($::_module_loaded{NanaXS::func}) {
		return NanaXS::func::encode($name);
#		$encoded =~ s/(\W)/'%' . unpack('H2', $1)/eg;		# comment
	} else {
		$encoded =~ s/(\W)/$::_urlescape{$1}/g;
		$encoded =~ s/\%20/+/g;
		return $encoded;
	}
}

=lang ja

=head2 get_now

=over 4

=item ������

�ʤ�

=item ����

ʸ����

=item �����С��饤��

��

=item ����

����������������롣

=back

=cut

sub _get_now {
	my (@week) = qw(Sun Mon Tue Wed Thu Fri Sat);
	my ($sec, $min, $hour, $day, $mon, $year, $weekday) = localtime(time);
	$weekday = $week[$weekday];
	return sprintf("%d-%02d-%02d ($weekday) %02d:%02d:%02d",
		$year + 1900, $mon + 1, $day, $hour, $min, $sec);
}


=lang ja

=head2 load_module

=over 4

=item ������

&load_module(�⥸�塼��̾);

=item ����

�⥸�塼��̾

=item �����С��饤��

��

=item ����

Perl�⥸�塼����ɤ߹���

=back

=cut

sub _load_module{
	my $mod = shift;
	return $mod if $::_module_loaded{$mod}++;
	# bug fix 0.2.0-p3								# comment
	if($mod=~/^[\w\:]{1,64}$/) {
		eval qq( require $mod; );
		unless($@) {						# debug
			$::debug.="Load perl module $mod\n";		# debug
		} else {							# debug
			$::debug.="Load perl module $mod failed\n";# debug
		}									# debug
		$mod=undef if($@);
		return $mod;
	}
	return undef;
}

=lang ja

=head2 code_convert

=over 4

=item ������

&code_convert(ʸ����, [euc|sjis|utf8|jis��] [,���ϥ�����]);

=item ����

ʸ����

=item �����С��饤��

��

=item ����

����饯���������ɤ��Ѵ����롣

=back

=cut

sub _code_convert {
	my ($contentref, $kanjicode, $icode) = @_;
	&load_module("Nana::Code");
	return Nana::Code::conv($contentref, $kanjicode, $icode);
}

=lang ja

=head2 is_exist_page

=over 4

=item ������

&is_exist_page(�ڡ���̾);

=item ����

�ڡ�����¸�ߤ����翿

=item �����С��饤��

��

=item ����

�ڡ�����¸�ߤ��뤫�����å�����

=back

=cut

sub _is_exist_page {
	my ($name) = @_;
	return 0 if($name eq '');
	foreach(keys %::fixedpage) {
		if($::fixedpage{$_} ne '' && $_ eq $name) {
			return 1;
		}
	}
	return ($use_exists) ?
		 exists($::database{$name}) ? 1 : 0
		: $::database{$name} ne '' ? 1 : 0;
}

=lang ja

=head2 replace

=over 4

=item ������

&replace(ʸ����, [old=>new, old1=>new1 ...]);

=item ����

ʸ������ִ�����

=item �����С��饤��

��

=item ����

ʸ������ִ�����

=back

=cut

sub _replace {
	my($s, %h)=@_;

	foreach(keys %h) {
		$s=~s/\$$_/$h{$_}/g;
	}
	$s;
}

=lang ja

=head2 trim

=over 4

=item ������

&trim(ʸ����);

=item ����

�Ѵ����줿ʸ����

=item �����С��饤��

��

=item ����

ʸ����������(Ⱦ��)����������

=back

=cut

sub _trim {
	my ($s) = @_;
	$s =~ s/^\s*(\S+)\s*$/$1/o; # trim		# comment
	return $s;
}

=lang ja

=head2 escape

=over 4

=item ����

&escape(ʸ����);

=item ����

�������줿ʸ����

=item �����С��饤��

��

=item ����

HTML�����򥨥������פ��롣

=back

=cut

sub _escape {
	return &htmlspecialchars(shift);
}

=lang ja

=head2 unescape

=over 4

=item ������

&unescape(ʸ����);

=item ����

�������줿ʸ����

=item �����С��饤��

��

=item ����

���������פ��줿HTML�������᤹��

=back

=cut

sub _unescape {
	my $s=shift;
	$s=~s/\&(amp|lt|gt|quot);/$::_unescape{$1}/g;
	return $s;
}

=lang ja

=head2 htmlspecialchars

=over 4

=item ������

&htmlspecialchars(ʸ����,[SGML���֤��ᤵ�ʤ����1]);

=item ����

�Ѵ����줿ʸ����

=item �����С��饤��

��

=item ����

HTMLʸ����򥨥������פ��롣

=back

=cut

sub _htmlspecialchars {
	my($s,$flg)=@_;
	if($::_module_loaded{NanaXS::func}) {
		return NanaXS::func::date(@_);
	} else {
		return $s if($s!~/([<>"&])/);

		$s=~s/([<>"&])/$::_htmlspecial{$1}/g;
		return $s if($flg eq 1);
		# ��ʸ����SGML���λ��Ȥ��᤹						# comment
		$s=~s/&amp;($::_sgmlescape);/&$1;/ig;
		# 10�ʡ�16�ʼ��ֻ��Ȥ��᤹							# comment
		$s=~s/&amp;#([0-9A-Fa-fXx]+)?;/&#$1;/g;
		return $s;
	}
}

=lang ja

=head2 javascriptspecialchars

=over 4

=item ������

&javaspecialchars(ʸ����);

=item ����

�Ѵ����줿ʸ����

=item �����С��饤��

��

=item ����

JavaScriptʸ���������˼¹ԤǤ���褦�˥��������פ��롣

=back

=cut

sub _javascriptspecialchars {
	my($s)=@_;
	if($::_module_loaded{NanaXS::func}) {
		return NanaXS::func::javascriptspecialchars(@_);
	} else {
		$s=&htmlspecialchars($s);
		$s=~s|'|&apos;|g;
		return $s;
	}
}

=lang ja

=head2 strcutbytes

=over 4

=item ����

&strcutbytes(strings, length);

=item ����

ʸ����

=item �����С��饤��

��

=item ����

�ޥ���Х���ʸ�����ڤ�Ф�

=back

=cut

sub _strcutbytes {
	my ($src, $maxlen) = @_;
	if ($::lang eq 'ja') {
		if($::defaultcode ne "utf8") {
			$src=&code_convert(\$src, "utf8", $::defaultcode);
		}
	}

	my $buf=&strcutbytes_utf8(substr($src, 0, $maxlen), $maxlen);

	if ($::lang eq 'ja') {
		if($::defaultcode ne "utf8") {
			$buf=&code_convert(\$buf, $::defaultcode, "utf8");
		}
	}
	return $buf;
}

=lang ja

=head2 strcutbytes_utf8

=over 4

=item ����

&strcutbytes_utf8(strings, length);

=item ����

ʸ����

=item �����С��饤��

��

=item ����

�ޥ���Х���ʸ�����ڤ�Ф�

=back

=cut

sub _strcutbytes_utf8 {
	my ($src, $maxlen) = @_;
	my $srclen = length($src);
	my $srcpos = 0;
	while($srcpos < $srclen) {
		my $character = substr($src, $srcpos, 1);
		my $value = ord($character);
		if($value < 0x80) { # ASCII characters
			$srcpos ++;
			next;
		}
		my $width = 6;
		$width = 5 if($value < 0xFC);
		$width = 4 if($value < 0xF8);
		$width = 3 if($value < 0xF0);
		$width = 2 if($value < 0xE0);
		my $nextpos = $srcpos + $width;
		last if($nextpos > $maxlen);
		last if($nextpos > $srclen); # sequence is incomplete
		$srcpos = $nextpos;
	}
	return substr($src, 0, $srcpos);
}

=lang ja

=head2 fopen

=over 4

=item ����

&fopen(filename or URL, mode);

=item ����

�ե�����ϥ�ɥ�

=item �����С��饤��

��

=item ����

�ե�����ޤ���URL�򥪡��ץ󤹤�PHP�ߴ��ؿ�

=back

=cut

sub _fopen {
	my ($fname, $fmode) = @_;
	my $_fname;
	my $fp;

	if ($fname =~ /^http:\/\//) {
		&load_module("Nana::HTTP");
		my $http=new Nana::HTTP(module=>"fopen");
		my($stat, $fp)=$http->open($fname);
		return "" if($stat ne 0);
		autoflush $fp(1);
		return $fp;
	} else {
		reutrn &_safe_open($fname, $fmode);
	}
}

=lang ja

=head2 	escapeoff

=over 4

=item ����

&escapeoff(0 or 1 or 2)

=item ����

$::IN_HEAD

=item �����С��饤��

��

=item ����

IE�ˤ����ơ���������ä�Ⱦ�ѡ����ѥ����ȴְ㤨�ơ�ESC�����ǲ����Ƥ��ޤ��Τ��˻ߤ��롣

�ᥤ���JavaScript�ϡ�skin/common?.js �˵��Ҥ���Ƥ��ޤ���

=back

=cut

sub _escapeoff {
	my ($flg)=@_;
	return if($::escapeoff_exec eq 1);
	$::escapeoff_exec = 1;

	return if($::form{cmd}!~/edit/);

	$::IN_JSHEAD.=<<EOM;
ev.add("onload", "ebak");
ev.add("onkeydown", @{[$flg eq 2 ? '"eprsc"' : $flg eq 1 ? '"eprs"' : '"eprn"']});
EOM
}

=lang ja

=head2 gettz

=over 4

=item ������

�ʤ�

=item ����

GMT�Ȥκ��λ���

=item �����С��饤��

��

=item ����

GMT�Ȥκ������(hour)���֤���

=back

=cut

sub _gettz {
	&load_module("Nana::Date");
	return Nana::Date::gettz;
}

=lang ja

=head2 getwday

=over 4

=item ������

&getwday($year,$mon,$mday);

=item ����

�����ֹ�

=item �����С��饤��

��

=item ����

���������������

=back

=cut

sub _getwday {
	&load_module("Nana::Date");
	return Nana::Date::getwday(@_);
}

=lang ja

=head2 lastday

=over 4

=item ������

&lastday($year,$mon);

=item ����

����ǯ��κǽ���

=item �����С��饤��

��

=item ����

����ǯ��κǽ�������롣

=back

=cut

sub _lastday {
	&load_module("Nana::Date");
	return Nana::Date::lastday(@_);
}

=lang ja

=head2 dateinit

=over 4

=item ������

�ʤ�

=item ����

�ʤ�

=item �����С��饤��

��

=item ����

���⤷�ޤ��󡡸ߴ����ѥ��ߡ��ؿ�

=back

=cut

sub _dateinit {
}

=lang ja

=head2 date

=over 4

=item ������

&date(format [,unixtime] [,"gmtime"]);

=item ����

�Ѵ����줿����ʸ����

=item �����С��饤��

��

=item ����

���դ�����������ꤷ��PHP�񼰤��Ѵ����롣

=back

=cut

sub _date {
	if($::_module_loaded{NanaXS::func}) {
		return NanaXS::func::date(@_);
	} else {
		&load_module("Nana::Date");
		return Nana::Date::date(@_);
	}
}

=lang ja

=head2 http_date

=over 4

=item ������

&http_date(unixtime);

=item ����

�Ѵ����줿����ʸ����

=item �����С��饤��

��

=item ����

HTTP�إå��Ѥ����դ��Ѵ����롣

=back

=cut

sub _http_date {
	my ($tm)=@_;
	if($tm+0 eq 0) {
		$tm=time;
	}
	if(&load_module("HTTP::Date")) {
		my $tmp;
		eval {
			$tmp=&HTTP::Date::time2str($tm);
		};
		if($tmp ne '') {
			return $tmp;
		}
	}
	return &_date("D, j M Y G:i:S",0,"gmtime");
}

=lang ja

=head2 getremotehost

=over 4

=item ����

&getremotehost;

=item ����

$ENV{REMOTE_HOST}

=item �����С��饤��

��

=item ����

��⡼�ȥۥ��Ȥ���Ϥ��롣

=back

=cut

sub _getremotehost {
	&load_module("Nana::RemoteHost");
	Nana::RemoteHost::get();
}

=lang ja

=head2 safe_open

=over 4

=item ����

&safe_open("filename" or ">filename" etc..., ["r","w","w+","a"])

&safe_open("<" or ">" or ">>"..., "filename" or ">filename")

=item ����

�ե�����ϥ�ɥ�

=item �����С��饤��

��

=item ����

�ե�����򳫤�

=back

=cut

sub _safe_open {
	my $mode = shift;
	my $file;
	if($mode=~/[\<\>]/) {
		$file=shift;
	} else {
		$file=$mode;
		$mode=lc shift;
	}

	if($file=~/[\<\>]/) {
		die "safe_open:not support $file";
	}

	if($mode eq "" || $mode eq "<" || $mode eq "r") {
		$mode="<";
	} elsif($mode eq "w" || $mode eq ">") {
		$mode=">";
	} elsif($mode eq "w+" || $mode eq "+>") {
		$mode="+>";
	} elsif($mode eq "a" || $mode eq ">>") {
		$mode=">>";
	} else {
		die "safe_open:not support $mode mode";
	}

	my $result;
	my $fh;

	$result = open $fh, $mode, $file;

	unless ($result) {
		warn "$!: $file";
		my $basename=$file;
		$basename=~s/.*\///g;
		$basename=~s/.*\\//g;
		die "safe_open:[$basename] can't access";
	}
	return $fh;
}

=lang ja

=head2 location

=over 4

=item ����

&location(url);

&location(url, code, header);

=item ����

�ե�����ϥ�ɥ�

=item �����С��饤��

��

=item ����

������쥯�Ȥ򤹤�

=back

=cut

sub _location {
	my ($url, $code, $header)=@_;
	$code=302 if($code+0 eq 0);
	if($::debuglocation+0 eq 1) {				# debug
		print "Content-type: text/html\n\n";	# debug
		print "<html><body>Code $code<hr>";		# debug
		print qq(<a href="$url">$url</a>);		# debug
		print "</body></html>";					# debug
		return;									# debug
	}											# debug
	print &http_header(
		"Status: $code " . ($code eq 301 ? "Moved Permanently" : "Found"),
		"Location: $url",
		$header,
		"\n\n"
	);
}
1;
