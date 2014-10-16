######################################################################
# @@HEADERPLUGIN_NANAMI@@
######################################################################
# &qrcode(string,ecc=[L|M|Q|H],version=version,size=ModuleSize)
#  ecc:エラー訂正レベル Lが最も悪くHが最も良い
#  version:1〜15
#  サイズ:1〜5
######################################################################

$PLUGIN="qrcode";
$VERSION="1.3";

use strict;
use GD::Barcode;

$qrcode::defaultECC='M'
	if(!defined($qrcode::defaultECC));
$qrcode::defaultVersion=0	# auto detect
	if(!defined($qrcode::defaultVersion));
$qrcode::defaultSize=3
	if(!defined($qrcode::defaultSize));

my %ecc_character_hash= (
	'L'=>1,
	'M'=>0,
	'Q'=>3,
	'H'=>2
);

sub plugin_qrcode_inline {
	my @args=split(/,/,shift);
	my $string="";
	my $ecc=$qrcode::defaultECC;
	my $version=$qrcode::defaultVersion;
	my $size=$qrcode::defaultSize;

	foreach(@args) {
		lc;
		if(/^ecc\=([lmqh])/) {
			$ecc=$1;
		} elsif(/^version=(\d{1,2})/) {
			$version=$1 if($version>0 && $version <= 15);
		} elsif(/^size=(\d)/) {
			$size=$1 if($size>0 && $size<= 5);
		} elsif($string eq '') {
			$string=&encode(&unescape($_));
		}
	}
	return <<EOM;
<img alt="$string" src="$::script?cmd=qrcode&amp;str=$string&amp;ecc=$ecc&amp;version=$version&amp;size=$size" />
EOM
}

sub plugin_qrcode_action {
	my %hParm;
	my $oGdBar;

	if(!defined($::form{ecc}) || !defined($::form{version})
		|| !defined($::form{size}) || !defined($::form{str})) {
		exit;
	}

	$hParm{Ecc}=$::form{ecc};
	$hParm{ModuleSize}=$::form{size};
	if($::form{version} ne 0) {
		$hParm{Version}=$::form{version};
	} else {
		$hParm{Version}=1+int(
			length($::form{str}) / (
				($::form{ecc} eq 'H' ? 8 : $::form{ecc} eq 'Q' ? 12
		 		: $::form{ecc} eq 'M' ? 15 : 18)
				-2));
	}
	my $str=&code_convert(\$::form{str},'sjis');
	$str=~s/\\n/\x0D\x0A/g;
	$oGdBar = GD::Barcode->new(
		'QRcode',
		$str,
		\%hParm);
	die($GD::Barcode::errStr) unless($oGdBar);

	binmode(STDOUT);
	print &http_header("Content-type: image/png");
	print $oGdBar->plot->png;
	exit;
}
1;
__END__

=head1 NAME

qrcode.inc.pl - PyukiWiki Plugin

=head1 SYNOPSIS

 &qrcode(string [,ecc=L|M|Q|H]] [,version=1-15] [,size=1-5]);

=head1 DESCRIPTION

The specified ASCII character sequence is changed into the QR code (R) Image.

=head1 USAGE

=over 4

=item string

The ASCII character string changed into the QR code is specified.

Only the alphanumeric character, the sign, and Japanese can be specified.

If \n is inserted in the character string, it becomes changing line.

=item ecc=L|M|Q|H

Error correction capability (data recovery capability) is specified.

Recovery level of the level 'L' about 7%, level M about 15%, level Q about 25%, level H about 30%

Default is level M

=item version=1-15

A version (module size) is specified. By a version, which can be inputted has restriction.

Default is auto detect.

=item size=1-5

The size of a picture is specified.

Default is 3.

=back

=head1 SEE ALSO

=over 4

=item PyukiWiki/Plugin/Nanami/qrcode

L<@@BASEURL@@/PyukiWiki/Plugin/Nanami/qrcode/>

=item PyukiWiki CVS

L<@@CVSURL@@/PyukiWiki-Devel/plugin/qrcode.inc.pl>

=item CPAN Mr. Takanori Kawai

GD::Barcode is included in this plugin.

L<http://search.cpan.org/~kwitknr/>

=item DENSO WAVE INCORPORATED

The QR code (R) is the registered trademark of DENSO WAVE INCORPORATED.

L<http://www.denso-wave.com/>

=back

=head1 AUTHOR

=over 4

@@AUTHOR_NANAMI@@

@@AUTHOR_PYUKI@@

=back

=head1 LICENSE

@@LICENSE_NANAMI@@

=cut
