######################################################################
# @@HEADER3_NANAMI@@
######################################################################
# Whois & GeoIP warpper
# Net::Whois::IP Ben Schmitz -- ben@foink.com
#
# Get GeoIP or GeoLite City Database from
# http://dev.maxmind.com/geoip/geolite
#
######################################################################

package Nana::NetIP;
use strict;
use integer;
use Exporter;
use vars qw($VERSION);
$VERSION="0.9";
#use Nana::HTTP;
#use Nana::GZIP;
use Nana::Cache;

$NetIP::cache="/tmp";

%NetIP::MobileList=(
	nttdocomo=>"http://www.nttdocomo.co.jp/service/developer/make/content/ip/",
	au=>"http://www.au.kddi.com/ezfactory/tec/spec/ezsava_ip.html",
	softbank=>"http://creation.mb.softbank.jp/mc/tech/tech_web/web_ipaddress.html",
	willcom=>"http://www.willcom-inc.com/ja/service/contents_service/create/center_info/",
	emobile=>"http://developer.emnet.ne.jp/ipaddress.html",
);

$NetIP::geoipurls=<<EOM;
test|http://master.power.daiba.cx/archive/power120923.tar.gz
GeoLiteCity|http://geolite.maxmind.com/download/geoip/database/GeoLiteCity.dat.gz
GeoLiteCityv6|http://geolite.maxmind.com/download/geoip/database/GeoLiteCityv6-beta/GeoLiteCityv6.dat.gz
EOM

$NetIP::geoipfilesv4=<<EOM;
/usr/local/share/GeoIP/GeoIPCity.dat
/usr/local/share/GeoIP/GeoLiteCity.dat
$NetIP::cache/GeoIPCity.geoip
$NetIP::cache/GeoLiteCity.geoip
EOM

$NetIP::geoipfilesv6=<<EOM;
/usr/local/share/GeoIP/GeoIPCityv6.dat
/usr/local/share/GeoIP/GeoLiteCityv6.dat
$NetIP::cache/GeoIPCityv6.geoip
$NetIP::cache/GeoLiteCityv6.geoip
EOM

$NetIP::IPv4mask = "((25[0-5]|2[0-4][0-9]|[0-1]?[0-9]{1,2})[.](25[0-5]|2[0-4][0-9]|[0-1]?[0-9]{1,2})[.](25[0-5]|2[0-4][0-9]|[0-1]?[0-9]{1,2})[.](25[0-5]|2[0-4][0-9]|[0-1]?[0-9]{1,2})\/([0-3]?[0-9]))";

sub debug {
	print @_;
}

sub getdata {
	&getdata_mobileipjp;
	&getdata_geoip;
}

sub getdata_geoip {
	if(
		&load_module("Nana::HTTP")
	 && &load_module("Nana::GZIP")
	){
		my $cache=new Nana::Cache(
			dir=>$NetIP::cache,
			ext=>"geoip",
			use=>1,
			expire=>31*24*60*60,
		);
		my $gz=new Nana::GZIP;
		my $http=new Nana::HTTP(timeout=>10);
		foreach(split(/\n/,$NetIP::geoipurls)) {
			my($file, $url)=split(/\|/,$_);
			&debug("Fetch $url\n");
			my($stat, $body)=$http->get($url);
			if($stat+0 eq 0) {
				&debug("Fetch $url OK\n");
				my $extractdata=$gz->uncompress($body);
				$cache->write($file, $extractdata);
			} else {
				&debug("Fetch $url NG\n");
			}
		}
	}
}

sub getdata_mobileipjp {
	if(
		&load_module("Nana::HTTP")
	){
		my $http=new Nana::HTTP;
		my $cache=new Nana::Cache(
			dir=>$NetIP::cache,
			ext=>"mobileip",
			use=>1,
			expire=>31*24*60*60,
		);

		foreach my $service(keys %NetIP::MobileList) {
			my $url=$NetIP::MobileList{$service};
			my($stat, $body)=$http->get($url);
			my $buf;
			if($stat+0 eq 0) {
                $body=~s/[\s\t]//g;
                $body=~s/[\r\n]//g;
                $body=~s/<.*?>//g;
				my @ipv4=$body=~/$NetIP::IPv4mask/g;
				foreach(@ipv4) {
					next if(!/\./);
					$buf.="$_\t";
				}
				$cache->write($service,$buf);
			}
		}
	}
}

sub new {
	my($class,%hash)=@_;
	my $self={
		gi=>&geoip($hash{addr}),
		whois=>&whois($hash{addr}),
		mobile=>&mobile($hash{addr})
	};
	return bless($self, $class);
}

sub mobile {
	my($addr)=@_;

	if(&load_module("Net::CIDR::Lite")) {
		my $cache=new Nana::Cache(
			dir=>$NetIP::cache,
			ext=>"mobileip",
			use=>1,
			expire=>31*24*60*60,
		);
		foreach my $service(keys %NetIP::MobileList) {
			my $cidr=Net::CIDR::Lite->new;
			my $buf=$cache->read($service, 1);
			foreach(split(/\t/,$buf)) {
				$cidr->add_any($_);
			}
#			my ($carrier,) =  map { keys %$_ } values %{$self->{spanner}->find($addr)};

			if($cidr->find($addr)) {
				return $service;
			}
		}
	}
}

sub geoip {
	my($addr)=@_;
	my $gfiles;
	if($addr=~/:/) {
		$gfiles=$NetIP::geoipfilesv6;
	} else {
		$gfiles=$NetIP::geoipfilesv4;
	}

	my $r;
	foreach my $gf(split(/\n/, $gfiles)) {
		if(-r $gf) {
			my $gi;
			if(!&load_module("Geo::IP::Record")) {
				return undef;
			}
#			$gi = Geo::IP->open($gf, GEOIP_STANDARD);
			$gi = Geo::IP->open($gf);
			if($addr=~/:/) {
				$r=$gi->recode_by_addr_v6($addr);
			} else {
				$r=$gi->record_by_addr($addr);

			}
			last;
		}
	}
	$r;
}

sub whois {
	my ($addr)=@_;

	my $cachefile=$addr;
	$cachefile=~s/[\:\.]//g;
	$cachefile=substr($cachefile, 0, 9);
	my $cache=new Nana::Cache(
		dir=>$NetIP::cache,
		ext=>"whois",
		use=>1,
		expire=>31*24*60*60,
		crlf=>1,
	);

	my $buf=$cache->read($cachefile);
	foreach(split(/\n/,$buf)) {
		my($ip, $source, $status, $country, $netname, 
		   $inetnum, $descr, $ranetsrc, $as, $network)=split(/\t/,$_);
		if($ip eq $addr) {
			return &whoishash($_);
		}
	}
	foreach(split(/\n/,$buf)) {
		my($ip, $source, $status, $country, $netname, 
		   $inetnum, $descr, $ranetsrc, $as, $network)=split(/\t/,$_);
		my $cidr=Net::CIDR::Lite->new;
		$cidr->add_any($network);

		if($cidr->find($addr)) {
			$buf.=<<EOM;
$addr\t$source\t$status\t$country\t$netname\t$inetnum\t$descr\t$ranetsrc\t$as\t$network
EOM
			$cache->write($cachefile, $buf);
			return &whoishash($_);
		}
	}

	my $r=&getwhois($addr);
	my($r_ranet, $ar2)=Nana::Whois::IP::whoisip_query(
		$addr,"" ,"", "RANET");

	my $whois_hash;
	eval {
		$whois_hash=<<EOM;
$addr\t@{[$r->{source}]}\t@{[$r->{status}]}\t@{[$r->{country}]}\t@{[$r->{netname}]}\t@{[$r->{inetnum}]}\t@{[$r->{descr}]}\t@{[$r_ranet->{source}]}\t@{[$r_ranet->{origin}]}\t@{[$r_ranet->{route}]}
EOM
	};
	if($whois_hash ne "") {
		$cache->write($cachefile, $buf . $whois_hash);
		return &whoishash($whois_hash);
	}
}

sub getwhois {
	my($addr)=@_;
	my @list=("ARIN", "RIPE", "APNIC", "KRNIC", "LACNIC", "AFRINIC");
	my $ret;
	foreach my $list(@list) {
		my($r, $ar)=Nana::Whois::IP::whoisip_query(
			$addr,"" ,"", $list);
		my $flg=0;
		foreach(keys $r) {
			$flg=1 if($$r{$_}=~/BLOCK/);
			$flg=1 if($$r{$_}=~/0\.0\.0\.0/);
		}
		if(!$flg) {
			foreach(keys $r) {
				$$ret{lc $_}=$$r{$_};
				$$ret{lc $_}=~s/[\t\,\=]//g;
				$$ret{lc $_}=~s/[\#].*//g;
			}
		}
	}
	$ret;
}

sub whoishash {
	my ($l)=@_;
	my($ip, $source, $status, $country, $netname, 
	   $inetnum, $descr, $ranetsrc, $as, $network)=split(/\t/,$l);
	my $whois_hash={
		addr=>$ip,
		source=>$source,
		status=>$status,
		country=>$country,
		netname=>$netname,
		inetnum=>$inetnum,
		descr=>$descr,
		ranetsrc=>$ranetsrc,
		as=>$as,
		network=>$network,
	};
	return $whois_hash;
}

sub get {
	my ($self, $option)=@_;
	my $r;
	eval {
		if($option eq "country_code") {
			$r=$self->{gi}->country_code;
		} elsif($option eq "country_code3") {
			$r=$self->{gi}->country_code3;
		} elsif($option eq "country_name") {
			$r=$self->{gi}->country_name;
		} elsif($option eq "region") {
			$r=$self->{gi}->region;
		} elsif($option eq "region_name") {
			$r=$self->{gi}->region_name;
		} elsif($option eq "city") {
			$r=$self->{gi}->city;
		} elsif($option eq "postal_code") {
			$r=$self->{gi}->postal_code;
		} elsif($option eq "latitude") {
			$r=$self->{gi}->latitude;
		} elsif($option eq "longitude") {
			$r=$self->{gi}->longitude;
		} elsif($option eq "time_zone") {
			$r=$self->{gi}->time_zone;
		} elsif($option eq "area_code") {
			$r=$self->{gi}->area_code;
		} elsif($option eq "continent_code") {
			$r=$self->{gi}->continent_code;
		} elsif($option eq "metro_code") {
			$r=$self->{gi}->metro_code;
		} elsif($option eq "source") {
			$r=$self->{whois}->{source};
		} elsif($option eq "status") {
			$r=$self->{whois}->{status};
		} elsif($option eq "country") {
			$r=$self->{whois}->{country};
		} elsif($option eq "netname") {
			$r=$self->{whois}->{netname};
		} elsif($option eq "inetnum") {
			$r=$self->{whois}->{inetnum};
		} elsif($option eq "descr") {
			$r=$self->{whois}->{descr};
		} elsif($option eq "as") {
			$r=$self->{whois}->{as};
		} elsif($option eq "network") {
			$r=$self->{whois}->{network};
		} elsif($option eq "mobile") {
			$r=$self->{mobile};
		}
	};
	return $r;
}

sub load_module {
	my $funcp = $::functions{"load_module"};
	return &$funcp(@_);
}

########################################
# from Net::Whois::IP
########################################
package Nana::Whois::IP;

use vars qw($VERSION @ISA @EXPORT @EXPORT_OK);
use IO::Socket;
require Exporter;
#use Carp;

#@ISA = qw(Exporter AutoLoader);

########################################
# $ Id: IP.pm,v 1.21 2007-03-07 16:49:36 ben Exp $
########################################

#$ VERSION = '1.10';

my %whois_servers = (
	"RIPE"=>"whois.ripe.net",
	"APNIC"=>"whois.apnic.net",
	"KRNIC"=>"whois.krnic.net",
	"LACNIC"=>"whois.lacnic.net",
	"ARIN"=>"whois.arin.net",
	"AFRINIC"=>"whois.afrinic.net",
	"RANET"=>"whois.ra.net",
	);

sub whoisip_query {
	my($ip,$multiple_flag,$search_options, $server) = @_;
	if($ip !~ /\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}/) {
		die "$ip is not a valid ip address";
	}
	my($response) = _do_lookup($ip,$server,$multiple_flag,$search_options);
	return($response);
}

sub _do_lookup {
	my($ip,$registrar,$multiple_flag,$search_options) = @_;
	my $extraflag = "1";
	my $whois_response;
	my $whois_response_hash;
	my @whois_response_array;
	LOOP: while($extraflag ne "") {
		my $lookup_host = $whois_servers{$registrar};
		($whois_response,$whois_response_hash) = _do_query($lookup_host,$ip,$multiple_flag);
		push(@whois_response_array,$whois_response_hash);
		my($new_ip,$new_registrar) = _do_processing($whois_response,$registrar,$ip,$whois_response_hash,$search_options);
		if(($new_ip ne $ip) || ($new_registrar ne $registrar) ) {
			$ip = $new_ip;
			$registrar = $new_registrar;
			$extraflag++;
			next LOOP;
		}else{
			$extraflag="";
			last LOOP;
		}
	}

	if(%{$whois_response_hash}) {
		foreach (sort keys(%{$whois_response_hash}) ) {
		}
		return($whois_response_hash,\@whois_response_array);
	}else{
		return($whois_response,\@whois_response_array);
	}
}

sub _do_query{
	my($registrar,$ip,$multiple_flag) = @_;
	my @response;
	my $i =0;
LOOP:while(1) {
		$i++;
		my $sock = _get_connect($registrar);
		print $sock "$ip\n";
		@response = <$sock>;
		close($sock);
		if($#response < 0) {
			if($i <=3) {
				next LOOP;
			}else{
				die "No valid response for 4th time... dying....";
			}
		}else{
			last LOOP;
		}
	}
	sleep(1);
	my %hash_response;
	foreach my $line (@response) {
		if($line =~ /^(.+):\s+(.+)$/) {
			if( ($multiple_flag) && ($multiple_flag ne "") ) {
				push @{ $hash_response{$1} }, $2;
			}else{
				$hash_response{$1} = $2;
			}
		}
    }
	return(\@response,\%hash_response);
}

sub _do_processing {
	my($response,$registrar,$ip,$hash_response,$search_options) = @_;

	my $pattern1 = "TechPhone";
	my $pattern2 = "OrgTechPhone";
	if(($search_options) && ($search_options->[0] ne "") ) {
		$pattern1 = $search_options->[0];
		$pattern2 = $search_options->[1];
    }

	LOOP:foreach (@{$response}) {
		if (/Contact information can be found in the (\S+)\s+database/) {
			$registrar = $1;
			last LOOP;
		}elsif((/OrgID:\s+(\S+)/i) || (/source:\s+(\S+)/i) && (!defined($hash_response->{$pattern1})) ) {
			my $val = $1;
			if($val =~ /^(?:RIPE|APNIC|KRNIC|LACNIC|AFRINIC)$/) {
				$registrar = $val;
				last LOOP;
			}
		}elsif(/Parent:\s+(\S+)/) {
			if(($1 ne "") && (!defined($hash_response->{'TechPhone'})) && (!defined($hash_response->{$pattern2})) ) {
				$ip = $1;
				last LOOP;
			}
		}elsif($registrar eq 'ARIN' && (/.+\((.+)\).+$/) && ($_ !~ /.+\:.+/)) {
			my $origIp = $ip;$ip = '! '.$1;
			if ($ip !~ /\d{1,3}\-\d{1,3}\-\d{1,3}\-\d{1,3}/){
				$ip = $origIp;
			}
		}else{
			$ip = $ip;
			$registrar = $registrar;
		}
    }
    return($ip,$registrar);
}

sub _get_connect {
	my($whois_registrar) = @_;
	my $sock = IO::Socket::INET->new(
				PeerAddr=>$whois_registrar,
				PeerPort=>'43',
				Timeout=>'60',
#				Blocking=>'0',
	);
	unless($sock) {
		die "Failed to Connect to $whois_registrar at port print -$@";
		sleep(5);
		$sock = IO::Socket::INET->new(
					PeerAddr=>$whois_registrar,
					PeerPort=>'43',
					Timeout=>'60',
#					Blocking=>'0',
		);
		unless($sock) {
			die "Failed to Connect to $whois_registrar at port 43 for the second time - $@";
		}
    }
    return($sock);
}

1;
__END__
