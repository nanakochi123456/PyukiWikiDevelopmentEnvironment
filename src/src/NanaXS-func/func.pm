######################################################################
# @@HEADER4_NANAMI@@
######################################################################

package NanaXS::func;

use 5.008100;
use strict;
use warnings;

require Exporter;

our @ISA = qw(Exporter);
our %EXPORT_TAGS = ( 'all' => [ qw(
) ] );
our @EXPORT_OK = ( @{ $EXPORT_TAGS{'all'} } );
our @EXPORT = qw(
);
our $VERSION = '0.1';

require XSLoader;
XSLoader::load('NanaXS::func', $VERSION);

sub gettz {
	if($::TZ eq '') {
		my $now=time();
		$::TZ=(timegm(localtime($now))-timegm(gmtime($now)))/3600;
	}
	return $::TZ;
}

sub date {
	my ($format, $tm, $gmtime) = @_;

	if(@_ > 1) {
		$tm=time if($tm + 0 eq 0);
	} else {
		$tm=time;
	}
	$gmtime="" if(@_ < 3);
	$gmtime=$gmtime eq "" ? 0 : 1;
	return NanaXS::func::xdate($format, $tm, $gmtime
		, $::TZ+0
		, $::resource{"date_ampm_en"}
		, $::resource{"date_ampm_".$::lang}
		, $::resource{"date_weekday_en"},
		, $::resource{"date_weekday_en_short"}
		, $::resource{"date_weekday_".$::lang}
		, $::resource{"date_weekday_".$::lang."_short"}
	);
}
1;
__END__
