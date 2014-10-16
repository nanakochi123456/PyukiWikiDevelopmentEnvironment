######################################################################
# @@HEADER1@@
######################################################################

	# SGMLの顔文字のエスケープコードの実体参照の正規表現		# comment
$::_sgmlescape=q{@@exec="./build/sgmlescape.regex"@@};

	# HTMLエスケープのテーブル									# comment
%::_htmlspecial = (
	'&' => '&amp;',
	'<' => '&lt;',
	'>' => '&gt;',
	'"' => '&quot;',
);

	# HTMLアンエスケープのテーブル								# comment
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

=item 入力値

なし

=item 出力

$::basehref, $::basepath, $::script

=item オーバーライド

可

=item 概要

基準となるURLを作成する。

前もって $::basehref及び $::basepathが設定されている場合は何もしない。

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

	# URLの生成									# comment
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

=item 入力値

&jscss_include(plugin name, [load list], [Priority]);

=item 出力

HTMLタグ

=item オーバーライド

可

=item 概要

プラグイン向けのJavaScript、CSSの読み込み文字列を生成する。

Nekyo氏のPyukiWikiと互換性はありません。

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

=item 入力値

&getcookie($cookieの識別ID, %cookie配列);

=item 出力

%cookie配列

=item オーバーライド

可

=item 概要

cookieを取得する。

=back

=cut

sub _getcookie {
	&load_module("Nana::Cookie");
	return Nana::Cookie::getcookie(@_);
}

=lang ja

=head2 setcookie

=over 4

=item 入力値

&setcookie($cookieの識別ID,有効期限,%cookie配列);

=item 出力

なし

=item オーバーライド

可

=item 概要

cookieを設定するためのHTTPヘッダーをセットする。

有効期限には、以下の数値のみ設定できる。

・ 1：$::cookie_expire秒有効にする。

・ 0：セッションのみ保存する。

・-1：cookieを消去する。

=back

=cut

sub _setcookie {
	&load_module("Nana::Cookie");
	return Nana::Cookie::setcookie(@_);
}

=lang ja

=head2 read_resource

=over 4

=item 入力値

&read_resource(ファイル名, %リソース配列);

=item 出力

%リソース配列

=item オーバーライド

可

=item 概要

リソースファイルを読み込む

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

=item 入力値

&armor_name(文字列);

=item 出力

変換された文字列

=item オーバーライド

可

=item 概要

以下の文字列変換を行なう。

・WikiName→WikiName

・WikiNameではない→［［WikiNameではない］］

=back

=cut

sub _armor_name {
	my ($name) = @_;
	return ($name =~ /^$wiki_name$/o) ? $name : "[[$name]]";
}

=lang ja

=head2 unarmor_name

=over 4

=item 入力値

&armor_name(文字列);

=item 出力

変換された文字列

=item オーバーライド

可

=item 概要

以下の文字列変換を行なう。

・WikiName→WikiName

・［［WikiNameではない］］→WikiNameではない

=back

=cut

sub _unarmor_name {
	my ($name) = @_;
	return ($name =~ /^$bracket_name$/o) ? $1 : $name;
}

=lang ja

=head2 is_bracket_name

=over 4

=item 入力値

&is_bracket_name(文字列);

=item 出力

ブラケットであるかのフラグ

=item オーバーライド

可

=item 概要

ブラケットであるかのフラグを返す。

=back

=cut

sub _is_bracket_name {
	my ($name) = @_;
	return ($name =~ /^$bracket_name$/o) ? 1 : 0;
}

=lang ja

=head2 dbmname

=over 4

=item 入力値

&dbmname(文字列);

=item 出力

変換された文字列

=item オーバーライド

可

=item 概要

文字列をDB用にHEX変換する。

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

=item 入力値

&undbmname(文字列);

=item 出力

変換された文字列

=item オーバーライド

可

=item 概要

DB用にHEX変換された文字列を戻す

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

=item 入力値

&decode(文字列);

=item 出力

変換された文字列

=item オーバーライド

可

=item 概要

URLエンコードされた文字列をデコードする。

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

=item 入力値

&encode(文字列);

=item 出力

変換された文字列

=item オーバーライド

可

=item 概要

URLエンコードをする。

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

=item 入力値

なし

=item 出力

文字列

=item オーバーライド

可

=item 概要

現在日時を取得する。

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

=item 入力値

&load_module(モジュール名);

=item 出力

モジュール名

=item オーバーライド

可

=item 概要

Perlモジュールを読み込む

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

=item 入力値

&code_convert(文字列, [euc|sjis|utf8|jis等] [,入力コード]);

=item 出力

文字列

=item オーバーライド

可

=item 概要

キャラクターコードを変換する。

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

=item 入力値

&is_exist_page(ページ名);

=item 出力

ページが存在する場合真

=item オーバーライド

可

=item 概要

ページが存在するかチェックする

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

=item 入力値

&replace(文字列, [old=>new, old1=>new1 ...]);

=item 出力

文字列を置換する

=item オーバーライド

可

=item 概要

文字列を置換する

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

=item 入力値

&trim(文字列);

=item 出力

変換された文字列

=item オーバーライド

可

=item 概要

文字列の前後の(半角)空白を取り除く

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

=item 入力

&escape(文字列);

=item 出力

整形された文字列

=item オーバーライド

可

=item 概要

HTMLタグをエスケープする。

=back

=cut

sub _escape {
	return &htmlspecialchars(shift);
}

=lang ja

=head2 unescape

=over 4

=item 入力値

&unescape(文字列);

=item 出力

整形された文字列

=item オーバーライド

可

=item 概要

エスケープされたHTMLタグを戻す。

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

=item 入力値

&htmlspecialchars(文字列,[SGML実態を戻さない場合1]);

=item 出力

変換された文字列

=item オーバーライド

可

=item 概要

HTML文字列をエスケープする。

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
		# 顔文字、SGML実体参照を戻す						# comment
		$s=~s/&amp;($::_sgmlescape);/&$1;/ig;
		# 10進、16進実態参照を戻す							# comment
		$s=~s/&amp;#([0-9A-Fa-fXx]+)?;/&#$1;/g;
		return $s;
	}
}

=lang ja

=head2 javascriptspecialchars

=over 4

=item 入力値

&javaspecialchars(文字列);

=item 出力

変換された文字列

=item オーバーライド

可

=item 概要

JavaScript文字列を安全に実行できるようにエスケープする。

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

=item 入力

&strcutbytes(strings, length);

=item 出力

文字列

=item オーバーライド

可

=item 概要

マルチバイト文字を切り出す

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

=item 入力

&strcutbytes_utf8(strings, length);

=item 出力

文字列

=item オーバーライド

可

=item 概要

マルチバイト文字を切り出す

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

=item 入力

&fopen(filename or URL, mode);

=item 出力

ファイルハンドル

=item オーバーライド

可

=item 概要

ファイルまたはURLをオープンするPHP互換関数

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

=item 入力

&escapeoff(0 or 1 or 2)

=item 出力

$::IN_HEAD

=item オーバーライド

可

=item 概要

IEにおいて、入力欄を誤って半角・全角キーと間違えて、ESCキーで押してしまうのを阻止する。

メインのJavaScriptは、skin/common?.js に記述されています。

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

=item 入力値

なし

=item 出力

GMTとの差の時間

=item オーバーライド

可

=item 概要

GMTとの差を時間(hour)で返す。

=back

=cut

sub _gettz {
	&load_module("Nana::Date");
	return Nana::Date::gettz;
}

=lang ja

=head2 getwday

=over 4

=item 入力値

&getwday($year,$mon,$mday);

=item 出力

曜日番号

=item オーバーライド

可

=item 概要

今日の曜日を求める

=back

=cut

sub _getwday {
	&load_module("Nana::Date");
	return Nana::Date::getwday(@_);
}

=lang ja

=head2 lastday

=over 4

=item 入力値

&lastday($year,$mon);

=item 出力

その年月の最終日

=item オーバーライド

可

=item 概要

その年月の最終日を求める。

=back

=cut

sub _lastday {
	&load_module("Nana::Date");
	return Nana::Date::lastday(@_);
}

=lang ja

=head2 dateinit

=over 4

=item 入力値

なし

=item 出力

なし

=item オーバーライド

可

=item 概要

何もしません　互換性用ダミー関数

=back

=cut

sub _dateinit {
}

=lang ja

=head2 date

=over 4

=item 入力値

&date(format [,unixtime] [,"gmtime"]);

=item 出力

変換された日付文字列

=item オーバーライド

可

=item 概要

日付を取得し、指定したPHP書式に変換する。

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

=item 入力値

&http_date(unixtime);

=item 出力

変換された日付文字列

=item オーバーライド

可

=item 概要

HTTPヘッダ用の日付に変換する。

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

=item 入力

&getremotehost;

=item 出力

$ENV{REMOTE_HOST}

=item オーバーライド

可

=item 概要

リモートホストを出力する。

=back

=cut

sub _getremotehost {
	&load_module("Nana::RemoteHost");
	Nana::RemoteHost::get();
}

=lang ja

=head2 safe_open

=over 4

=item 入力

&safe_open("filename" or ">filename" etc..., ["r","w","w+","a"])

&safe_open("<" or ">" or ">>"..., "filename" or ">filename")

=item 出力

ファイルハンドル

=item オーバーライド

可

=item 概要

ファイルを開く

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

=item 入力

&location(url);

&location(url, code, header);

=item 出力

ファイルハンドル

=item オーバーライド

可

=item 概要

リダイレクトをする

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
