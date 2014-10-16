######################################################################
# @@HEADER3_NANAMI@@
######################################################################
package	Nana::UserAgent;
use 5.005;
use strict;
use integer;
use Exporter;
use vars qw($VERSION @ISA @EXPORTER @EXPORT_OK);
@EXPORT_OK = qw();
$VERSION = '0.1';

@EXPORT_OK = qw(ua mobileip);

$UserAgent::MobileIPJP_API="http://pyukiwiki.sourceforge.jp/cgi-bin/mobileip/get.cgi";

%UserAgent::geoip_cache;

$UserAgent::GeoIPDataBase=""
	if(!defined($UserAgent::GeoIPDataBase));

sub ua {
}

sub mobileip {
	&load_module("Nana::HTTP");
	my $http=new Nana::HTTP(module=>"Nana::UserAgent");
	for(my $i=0; $i < 5; $i++) {
		my ($stat, $buf)=$http->get("$UserAgent::MobileIPJP_API?$ENV{REMOTE_ADDR}");
		if($stat eq 0) {
			if($buf ne "") {
				return $buf;
			}
		}
	}
	return "";
}

sub geoip {
	&load_module("Socket");
	&load_module("Socket6);

	if(&load_module("Geo::IP")) {
		if($UserAgent::geoip_cache{$ENV{REMOTE_ADDR}}) {
			return $UserAgent::geoip_cache{$ENV{REMOTE_ADDR}};
		}
		my $r=$gi->recotd_by_addr($ENV{REMOTE_ADDR});
		$UserAgent::geoip_cache{$ENV{REMOTE_ADDR}}=$r;
		return $r;

		my $gi;
		if($UserAgent::GeoIPDataBase ne "") {
			$gi=Geo::IP->open($UserAgent::GeoIPDataBase, GEOIP_STANDARD);
		} else {
			$gi=Geo::IP->new;
		}
	}
	return undef;
}

sub country {
	my $r=&geoip;
	return $r eq undef ? undef : $r->country_code;
}
sub country3 {
	my $r=&geoip;
	return $r eq undef ? undef : $r->country_code3;
}

sub country_name {
	my $r=&geoip;
	return $r eq undef ? undef : $r->country_name;
}

sub region {
	my $r=&geoip;
	return $r eq undef ? undef : $r->region;
}

sub region_name {
	my $r=&geoip;
	return $r eq undef ? undef : $r->region_name;
}

sub city {
	my $r=&geoip;
	return $r eq undef ? undef : $r->city;
}

sub postal_code {
	my $r=&geoip;
	return $r eq undef ? undef : $r->postal_code;
}

1;
