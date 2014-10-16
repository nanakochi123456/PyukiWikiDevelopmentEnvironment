######################################################################
# @@HEADER2_NANAMI@@
######################################################################
# This is extented plugin.
# To use this plugin, rename to 'captcha.inc.cgi'
######################################################################
#
# 文字認証プラグイン
#
######################################################################

@captcha::font=(
		"$::skin_dir/mika.ttf",
#		"$::skin_dir/aquafont.ttf",
);

%captcha::parm=(
	# 日本語数字							# comment
	ja_num=>{
		rnd_data=>[
			'いち,1','に,2','さん,3','よん,4', 'ご,5',
			'ろく,6','なな,7','はち,8','きゅう,9', 'ぜろ,0',
			'イチ,1','に,2','サン,3','ヨン,4', 'ご,5',
			'ロク,6','ナナ,7','ハチ,8','キュウ,9', 'ゼロ,0',
		],
		style=>"ime-mode: disable;",
		class=>"klimit-digit",
		length=>6,
		size=>[24,25],
		angle=>[-15,10,15],
		space=>1.4,
		width=>450,
		height=>50,
        font  =>@captcha::font,
	},
	# 日本語ひらがな						# comment
	ja=>{
		rnd_data=>[
			'た','ち','つ','て','と',
			'は','ひ','ふ','へ','ほ',
			'ま','み','む','め','も',
			'ら','り','る','れ','ろ',
			'か','き','く','け','こ',
			'わ','を','ん',
			'あ','い','う','え','お',
			'な','に','ぬ','ね','の',
			'や','ゆ','よ',
			'さ','し','す','せ','そ',
		],
		style=>"ime-mode: active;",
		length=>6,
		size=>[25,28],
		angle=>[-10,5,10,15],
		space=>1.25,
		width=>250,
		height=>50,
        font  =>@captcha::font,
	},
	# 英語数字							# comment
	def_num=>{
		rnd_data=>[
			'One,1','Two,2','Three,3','Fore,4', 'Five,5',
			'Six,6','Seven,7','Eight,8','Nine,9', 'Zero,0',
				],
		style=>"ime-mode: disable;",
		class=>"klimit-alnum",
		length=>6,
		size=>[25],
		angle=>[-10,-5,10,15,20],
		space=>0.9,
		width=>600,
		height=>50,
        font  =>@captcha::font,
	},
	# 英数字							# comment
	def=>{
		rnd_data=>[
				'L','M','N','O','P','Q',
				'X','Y','Z','1','2','3',
				'A','B','C','D','E','F',
				'4','5','6','7','8','9',
				'R','S','T','U','V','W',
				'G','H','I','J','K','L',
				],
		style=>"ime-mode: disable;",
		class=>"klimit-alnum",
		length=>6,
		size=>[28,30],
		angle=>[-10,5,10,15],
		space=>1.3,
		width=>220,
		height=>50,
        font  =>@captcha::font,
	},
	1=>{
		fontcolor=>["#dd2222","#119911","#4422ff"],
 		linecoloror=>"#7777cc",
		rndlines=>30,
		rndcircles=>40,
		lastrndlines=>5,
		lastrndcircles=>5,
		rndcolors=>["#ff8888","#88ff88","#8888ff","#ffff88","#ff88ff","#88ffff"],
		bgcolor=>"#eeeeff",
		backlinecolor=>"#000000",
	},
	2=>{
		fontcolor=>["#ff4422","#44aa22","#4422ff"],
 		linecoloror=>"#7777cc",
		rndlines=>30,
		rndcircles=>40,
		lastrndlines=>5,
		lastrndcircles=>5,
		rndcolors=>["#ff8888","#88ff88","#8888ff","#ffff88","#ff88ff","#88ffff"],
		bgcolor=>"#eeeeff",
		backlinecolor=>"#000000",
	},
	3=>{
		style=>"rect",
		fontcolor=>["#ff4444","#44ff44","#4488ff"],
		linecolor=>"#00aa00",
		rndlines=>30,
		rndcircles=>40,
		lastrndlines=>5,
		lastrndcircles=>5,
		rndcolors=>["#880000","#008800","#000088"],
		bgcolor=>"#000000",
		backlinecolor=>"#00ffff",
	},
);

$::captcha_cookie="CPA";

use strict;
use Nana::MD5 qw(md5_hex);
use Encode qw(from_to);

$captcha::init="";
$captcha::check="";
$captcha::id=0;
%captcha::cookie;
$captcha::lang="";

######################################################################
# Initlize												# comment

sub plugin_captcha_init {
	if($::form{cmd}=~/vote/) {
		$captcha::check="ok";
		return('init'=>1)
	}

	&load_wiki_module("auth");
	&exec_explugin_sub("authadmin_cookie");

	$::IN_JSHEADVALUE.=&maketoken if($::Token eq '');
	$::IN_HEAD.=&jscss_include("jquery");
	$::IN_HEAD.=&jscss_include("passwd");

	$captcha::lang=&getcaptcha_lang;
	if(&load_module("GD")) {
		&exec_explugin_sub("authadmin_cookie");
		if($::authadmin_cookie_user_name eq $::authadmin_cookie_admin_name{admin} && $::_exec_plugined{authadmin_cookie} eq 2) {
			$captcha::check="authed";
		} elsif($::authadmin_cookie_remotehostauthed) {
			$captcha::check="authedip";
		} elsif($::form{captcha_check} ne "" && $captcha::check eq "") {
			my $check=&code_convert(\$::form{captcha}, $::defaultcode);
			if($::defaultcode eq "utf8") {
				$check=Encode::decode('utf8',$check);
			}
			my($captcha_lang, $rand, $str, $inputstr)=&plugin_captcha_random($::form{captcha_check});
			$captcha::lang=$captcha_lang;

			if($inputstr eq $check) {
				$captcha::check="ok";
			} else {
				$captcha::check="ng";
			}
		}

		if($captcha::init eq "") {
			my $str;
			srand();
			$str=time . rand(time) . $ENV{HTTP_COOKIE} . $ENV{REMOTE_ADDR} . $ENV{HTTP_USER_AGENT};
			$captcha::init=md5_hex($str);
		}
		return ('init'=>1);
	}
	$captcha::check="error";
	return('init'=>0);
}

sub plugin_captcha_random {
	my($md5str)=@_;
	my $test=~s/[0-9A-Fa-f]//g;
	my @md5;
	if($test eq "") {
		my $captcha_lang=&getcaptcha_lang;

		for(my $i=0; $i<length($md5str); $i++) {
			$md5[$i]=hex(substr($md5str, $i*2, 2));
		}
		my $chk=1;
		for(my $i=1; $i<100; $i++) {
			$chk=$i if(defined($captcha::parm{$i}->{fontcolor}));
		}
		my $rand=int($md5[0] % $chk)+1;

		# 文字を生成する
		my $displaystr;
		my $inputstr;
		my @used=();
		my @rnddata=@{$captcha::parm{$captcha_lang}->{rnd_data}};
		my $j=0;
		for(my $i=0; $i<$captcha::parm{$captcha_lang}->{length}; $i++) {
			my $flg=0;
			my $count=0;
			my $displaychar;
			my $inputchar;
			while(1) {
				$j=($j+1) % $#md5;
				my $char=$rnddata[$md5[$j] % $#rnddata];
				if($char=~/\,/) {
					($displaychar,$inputchar)=split(/,/,$char);
				} else {
					$displaychar=$char;
					$inputchar=$char;
				}
				$displaychar=&code_convert(\$displaychar, $::defaultcode);
				$inputchar=&code_convert(\$inputchar, $::defaultcode);
				if($::defaultcode eq "utf8") {
					$displaychar=Encode::decode('utf8',$displaychar);
					$inputchar=Encode::decode('utf8',$inputchar);
				}
				$flg=0;
				foreach(@used) {
					$flg=1 if($inputchar eq $_);
				}
				$count++;
				if($flg eq 0) {
					push(@used,$inputchar);
					$inputstr.=$inputchar;
					$displaystr.=$displaychar;
					last;
				}
			} # while($flg eq 0 && length($inputstr) < $captcha::parm{$captcha_lang}->{length});
		}
#		$inputstr=substr($inputstr, 0, $captcha::parm{$captcha_lang}->{length});
#		$inputstr=&strcutbytes($inputstr, 12) . "[$inputstr]";
		return($captcha_lang, $rand, $displaystr, $inputstr);

	} else {
		return ("def", 1, "");
	}
}

sub plugin_captcha_form {
	my $html;
	$captcha::id++;

	my($dmy,$dmy,$string, $inputstring)=plugin_captcha_random($captcha::init);
	$inputstring=&code_convert(\$inputstring, $::defaultcode);
	if($::defaultcode eq "utf8") {
		$inputstring=Encode::encode('utf8', $inputstring);
	}
	my $captcha_msg;
	if($captcha::check eq "ok") {
		$captcha_msg=$::resource{captcha_plugin_ok};
	} elsif($captcha::check eq "ng") {
		$captcha_msg=$::resource{captcha_plugin_ng};
		$inputstring="";
	} elsif($captcha::check eq "authed") {
		$captcha_msg=$::resource{captcha_plugin_authed};
	} elsif($captcha::check eq "authedip") {
		$captcha_msg=$::resource{captcha_plugin_authedip};
	} elsif($captcha::check eq "error") {
		$captcha_msg=$::resource{captcha_plugin_error};
		$inputstring="";
	} else {
		$captcha_msg=$::resource{captcha_plugin_before};
		$inputstring="";
	}
	if($captcha::check=~/ok|error|authed/) {
		$html=<<EOM;
<input type="hidden" name="captcha_check" value="$captcha::init" />
<input type="hidden" name="captcha" value="$inputstring" />
$captcha_msg<br />
EOM
	} else {
		$html=<<EOM;
<span class="captcha">
<span class="captcha_image" id="captcha@{[$captcha::id]}">
<img src="$::script?cmd=captcha&amp;mode=image&amp;teststring=$captcha::init" /></span>
<br />
<input type="hidden" name="captcha_check" value="$captcha::init" />
$captcha_msg
[
<a href="#" onclick="return reload_captcha('$::captcha_cookie','captcha@{[$captcha::id]}');">
$::resource{captcha_plugin_reload}</a>]
<br />
<input type="text" name="captcha" value="" @{[$captcha::parm{$captcha::lang}->{style} ne "" ? qq(style="$captcha::parm{$captcha::lang}->{style}") : ""]} @{[$captcha::parm{$captcha::lang}->{class} ne "" ? qq(class="$captcha::parm{$captcha::lang}->{class}") : ""]} onkeyup="this.value=this.value.toUpperCase();" maxlength="$captcha::parm{$captcha::lang}->{length}" />
$inputstring
</span>
<br />
EOM
	$::IN_JSHEAD.=<<EOM;
setCaptchaCookie("$::captcha_cookie", "$captcha::init");
EOM
	}
	return $html;

}

sub getcaptcha_lang {
	my $captcha_lang=$::lang;
	$captcha_lang="def" if(!defined($captcha::parm{$captcha_lang}->{rnd_data}));
	return $captcha_lang;
}

sub spam_filter {
	my ($chk_str, $level, $uricount, $mailcount, $retflg) = @_;

	if($captcha::check!~/ok|authed/) {
		&snapshot('Char auth error');
		&skinex($::form{mypage}, &message($::resource{captcha_plugin_fobidden}), 0);
		exit;
	}
	return if ($::filter_flg != 1);	# フィルターオフなら何もしない。 # comment
	return if ($chk_str eq '');		# 文字列が無ければ何もしない。	 # comment

	# v 0.2.0 fix													 # comment

	my $chk_jp_regex=$::chk_jp_hiragana ? '[あ-んア-ン]' : '[\x80-\xFE]';

	my $chk_jp_regex=$::chk_jp_hiragana ? '[あ-んア-ン]' : '[\x80-\xFE]';
	if($uricount+0 eq 0 || $uricount+0 > $::chk_uri_count+0) {
		$uricount=$::chk_uri_count;
	}

	# レベル 2　を除きOver Httpチェックを行う。						# comment
	# changed by nanami and v 0.2.0-p2 fix
	if (($level ne  1) && ($uricount > 0) && (($chk_str =~ s/https?:\/\///g) >= $uricount)) {
		&snapshot('Over http');
		return "Over http" if($retflg+0 eq 1);
	# Over Mailチェックを行う。
	} elsif (($level ne  1) && ($mailcount+0 > 0) && (($chk_str =~ s/$::ismail//g) >= $uricount)) {
		&snapshot('Over Mail', $retflg+0);
		return "Over Mail" if($retflg+0 eq 1);
	# レベルが 1 の時のみ 日本語チェックを行う。					# comment
	# changed by nanami and v 0.2.0 fix
	} elsif (($level >= 1) && ($::chk_jp_only == 1) && ($chk_str !~ /$chk_jp_regex/)) {
		&snapshot('No Japanese', $retflg+0);
		return "No Japanese" if($retflg+0 eq 1);
	} else {
		return;
	}
	&skinex($::form{mypage}, &message($::resource{auth_writefobidden}), 0);
	&close_db;
	return "spam" if($retflg+0 eq 1);
	exit;
}

1;
__DATA__
sub plugin_captcha_setup {
	return(
		ja=>'文字認証プラグイン',
		en=>'Image character auth plugin)',
		url=>'@@BASEURL@@/PyukiWiki/Plugin/ExPlugin/captcha/'
		require=>'GD',
	);
}
__END__

=head1 NAME

captcha.inc.pl - PyukiWiki Plugin

=head1 SYNOPSIS

Image character auth plugin

=head1 DESCRIPTION

Image character auth plugin

=head1 USAGE

rename to captcha.inc.cgi

place true type font to skin directory,

=head1 OVERRIDE

spam_filter

=head1 SEE ALSO

=over 4

=item PyukiWiki/Plugin/ExPlugin/captcha

L<@@BASEURL@@/PyukiWiki/Plugin/ExPlugin/captcha/>

=item PyukiWiki/Plugin/Standard/captcha

L<@@BASEURL@@/PyukiWiki/Plugin/Standard/captcha/>

=item PyukiWiki CVS

L<@@CVSURL@@/PyukiWiki-Devel/lib/captcha.inc.pl>

L<@@CVSURL@@/PyukiWiki-Devel/plugin/captcha.inc.pl>

=back

=head1 AUTHOR

=over 4

@@AUTHOR_NANAMI@@


@@AUTHOR_PYUKI@@

=back

=head1 LICENSE

@@LICENSE_NANAMI@@

=cut
