######################################################################
# @@HEADER2_NANAMI@@
######################################################################
# This is sub plugin of captcha.inc.cgi
######################################################################

use strict;
use warnings;
use GD;
use File::Spec;

sub getvalue {
	my ($v)=@_;
	if(ref($v) eq "ARRAY") {
		my @v=@{$v};
		return $v[int(rand($#v+1))];
	} else {
		return $v;
	}
}
sub getcolor {
	my($obj, $color)=@_;
	my $tmpcolor=&getvalue($color);

	if($tmpcolor=~/^#([0-9A-Fa-f][0-9A-Fa-f])([0-9A-Fa-f][0-9A-Fa-f])([0-9A-Fa-f][0-9A-Fa-f])$/) {
		return $obj->colorAllocate(hex($1),hex($2),hex($3));
	}
	return undef;
}

sub plugin_captcha_action {
	return if($::form{mode} ne "image");

	srand();

	my $chk=1;
	for(my $i=1; $i<100; $i++) {
		$chk=$i if(defined($captcha::parm{$i}->{fontcolor}));
	}

	return if($::form{teststring} eq "");
	my($captcha_lang, $rand, $tmpstr)=&plugin_captcha_random($::form{teststring});
	my $str=$tmpstr;

	my $width=$captcha::parm{$captcha_lang}->{width};
	my $height=$captcha::parm{$captcha_lang}->{height};
	my $im = new GD::Image($width, $height);
	$im->trueColor(1);


	# 背景色として塗りつぶし四角を描く				# comment
	$im->filledRectangle(0, 0, $width-1, $height-1, &getcolor($im, $captcha::parm{$rand}->{bgcolor}));

	# 外枠を描画									# comment
	$im->rectangle(0, 0, $width-1, $height-1, &getcolor($im, $captcha::parm{$rand}->{backlinecolor}));

	# 文字の前に線と丸を書く						# comment
	for(my $i=0; $i<$captcha::parm{$rand}->{rndlines}; $i++) {
		$im->line(
			rand($width-1), rand($height-1)
		  , rand($width-1), rand($height-1)
		  , &getcolor($im, $captcha::parm{$rand}->{rndcolors})
		);
	}

	for(my $i=0; $i<$captcha::parm{$rand}->{rndcircles}; $i++) {
		$im->arc(
			rand($width-1), rand($height-1)
		  , rand($width-1), rand($height-1)
		  , 0, 360
		  , &getcolor($im, $captcha::parm{$rand}->{rndcolors})
		);
	}

	my $PI=3.141592;
	my $str_x=10;
	my $str_y=40;
	my $ut8encoded;
	if($::defaultcode eq "utf8") {
		$ut8encoded=$str;
	} else {
		$ut8encoded=&code_convert(\$str, "utf8", "euc");
	}
	utf8::decode($ut8encoded);
	my $bkfontcolor;
	for(my $i=0; $i<length($ut8encoded); $i++) {
		my $char=substr($ut8encoded, $i, 1);
		utf8::encode($char);
		my $fontcolor=&getcolor($im, $captcha::parm{$rand}->{fontcolor});
     	# 文字を描画								# comment
		my $size=&getvalue($captcha::parm{$captcha_lang}->{size});
     	$im->stringFT($fontcolor,
				File::Spec->rel2abs(&getvalue($captcha::parm{$captcha_lang}->{font})),
				$size,
				&getvalue($captcha::parm{$captcha_lang}->{angle}) * ($PI/180),
				$str_x + $size*$i * &getvalue($captcha::parm{$captcha_lang}->{space}), $str_y,
				$char);
	}

	# 文字の後に線と丸を書く					# comment
	for(my $i=0; $i<$captcha::parm{$rand}->{lastrndlines}; $i++) {
		$im->line(
			rand($width-1), rand($height-1)
		  , rand($width-1), rand($height-1)
		  , &getcolor($im, $captcha::parm{$rand}->{rndcolors})
		);
	}

	for(my $i=0; $i<$captcha::parm{$rand}->{lastrndcircles}; $i++) {
		$im->arc(
			rand($width-1), rand($height-1)
		  , rand($width-1), rand($height-1)
		  , 0, 360
		  , &getcolor($im, $captcha::parm{$rand}->{rndcolors})
		);
	}

	print &http_header("Content-type: image/png");
	binmode STDOUT;
	print $im->png;
	exit;
}
1;
__END__
=head1 NAME

captcha.inc.pl - PyukiWiki Plugin

=head1 SYNOPSIS

 ?cmd=captcha

=head1 DESCRIPTION

Sub plugin for captcha.inc.cgi

=head1 SEE ALSO

=over 4

=item PyukiWiki/Plugin/Standard/captcha

L<@@BASEURL@@/PyukiWiki/Plugin/Standard/captcha/>

=item PyukiWiki/Plugin/ExPlugin/captcha

L<@@BASEURL@@/PyukiWiki/Plugin/ExPlugin/captcha/>

=item PyukiWiki CVS

L<@@CVSURL@@/PyukiWiki-Devel/plugin/captcha.inc.pl>

L<@@CVSURL@@/PyukiWiki-Devel/lib/captcha.inc.pl>

=head1 AUTHOR

=over 4

@@AUTHOR_NANAMI@@

@@AUTHOR_PYUKI@@

=back

=head1 LICENSE

@@LICENSE_NANAMI@@

=cut
