######################################################################
# @@HEADER3_NANAMI@@
######################################################################

package	Nana::RemoteHost;
use 5.005;
use strict;
use integer;
use Exporter;
use vars qw($VERSION);
$VERSION = '0.1';

######################################################################

$Nana::RemoteHost::Execed=0;
sub get {
	return if($Nana::RemoteHost::Execed eq 1);

	$Nana::RemoteHost::Execed=1;

	# from http://www.alib.jp/perl/resolv.html#nocompact	# comment
	# and  http://www2u.biglobe.ne.jp/MAS/perl/waza/dns.html#nocompact	# comment

	if($ENV{REMOTE_HOST} eq '' || $ENV{REMOTE_ADDR} eq $ENV{REMOTE_HOST}) {#nocompact
		my $addr=$ENV{REMOTE_ADDR};#nocompact
		my $ipv4addr;#nocompact
		my $ipv6addr;#nocompact
		if($addr=~/^(?:::(?:f{4}:)?)?((?:0*(?:2[0-4]\d|25[0-5]|[01]?\d\d|\d)\.){3}0*(?:2[0-4]\d|25[0-5]|[01]?\d\d|\d)|(?:\d+))$/) {#nocompact
			$ipv4addr=$1;#nocompact
			$ENV{REMOTE_ADDR}="$ipv4addr";#nocompact
		} elsif($addr=~/:/) {#nocompact
			$ipv6addr=$addr;#nocompact
			$ENV{REMOTE_ADDR}="$ipv6addr";#nocompact
		} else {#nocompact
			$ipv4addr=$addr;#nocompact
			$ENV{REMOTE_ADDR}="$ipv4addr";#nocompact
		}#nocompact
		if($ipv4addr ne '') {#nocompact
			my $host#nocompact
			 = gethostbyaddr(pack("C4", split(/\./, $ENV{REMOTE_ADDR})), 2);#nocompact
			if($host eq '') {#nocompact
				$host=$ENV{REMOTE_ADDR};#nocompact
			}#nocompact
			$ENV{REMOTE_HOST}=$host;#nocompact
		} elsif($ipv6addr ne '') {#nocompact
			my $funcp = $::functions{"load_module"};
			if(&$funcp("Net::DNS")) {#nocompact
				# IPV6アドレスを展開する。#nocompact	# comment
				my @address;#nocompact
				if ($ipv6addr =~ /::/) {#nocompact
			        my ($adr_a, $adr_b) = split /::/, $ipv6addr;#nocompact
			        my @adr_a = split /:/, $adr_a;#nocompact
			        my @adr_b = split /:/, $adr_b;#nocompact
   					for (scalar @adr_a .. 7 - scalar @adr_b) {#nocompact
						push @adr_a, 0#nocompact
					}#nocompact
					@address = (@adr_a, @adr_b);#nocompact
				} else {#nocompact
					@address = split /:/, $ipv6addr;#nocompact
				}#nocompact
				$ipv6addr =  (join ":", @address);#nocompact
#nocompact
				# IPV6アドレスを解決する#nocompact	# comment
				my $resolver = new Net::DNS::Resolver;#nocompact
			    my $ans = $resolver->query($ipv6addr, 'PTR', 'IN');#nocompact
				if($ans) {#nocompact
			        foreach my $rr ($ans->answer) {#nocompact
			                next if $rr->type ne "PTR";#nocompact
			                $ENV{REMOTE_HOST}=$rr->ptrdname;#nocompact
			        }#nocompact
				} else {#nocompact
					$ENV{REMOTE_HOST}="$ipv6addr";#nocompact
				}#nocompact
			} else {#nocompact
				$ENV{REMOTE_HOST}="$ipv6addr";#nocompact
			}#nocompact
		}#nocompact
	}#nocompact
	if($ENV{REMOTE_HOST} eq '') {#compact
		my $host#compact
		 = gethostbyaddr(pack("C4", split(/\./, $ENV{REMOTE_ADDR})), 2);#compact
		if($host eq '') {#compact
			$host=$ENV{REMOTE_ADDR};#compact
		}#compact
		$ENV{REMOTE_HOST}=$host;#compact
	}#compact
	# プロクシのIPアドレスを抜く #nocompact #comment
	my $proxy;#nocompact
	if($ENV{REMOTE_HOST_ORG} eq '') {#nocompact
		$ENV{REMOTE_HOST_ORG}=$ENV{REMOTE_HOST};#nocompact
	} else {#nocompact
		$ENV{REMOTE_HOST}=$ENV{REMOTE_HOST_ORG};#nocompact
	}#nocompact
	if($ENV{HTTP_CLIENT_IP}=~/($::ipv4address_regex)/) {#nocompact
		$proxy=$1;#nocompact
	} elsif($ENV{HTTP_CLIENT_IP}=~/($::ipv6address_regex)/) {#nocompact
		$proxy=$1;#nocompact
	} elsif($ENV{HTTP_FORWARDED}=~/($::ipv4address_regex)/) {#nocompact
		$proxy=$1;#nocompact
	} elsif($ENV{HTTP_FORWARDED}=~/($::ipv6address_regex)/) {#nocompact
		$proxy=$1;#nocompact
	} elsif($ENV{HTTP_X_FORWARDED_FOR}=~/($::ipv4address_regex)/) {#nocompact
		$proxy=$1;#nocompact
	} elsif($ENV{HTTP_X_FORWARDED_FOR}=~/($::ipv6address_regex)/) {#nocompact
		$proxy=$1;#nocompact
	} elsif($ENV{HTTP_VIA}=~/($::ipv4address_regex)/) {#nocompact
		$proxy=$1;#nocompact
	} elsif($ENV{HTTP_VIA}=~/($::ipv6address_regex)/) {#nocompact
		$proxy=$1;#nocompact
	}#nocompact
	if($proxy ne '') {#nocompact
		$ENV{REMOTE_HOST}.= " ($proxy)";#nocompact
	}#nocompact
}
1;
__END__

=head1 NAME

Nana::RemoteHost - Get remoteHost module

=head1 SEE ALSO

=over 4

=item PyukiWiki CVS

L<@@CVSURL@@/PyukiWiki-Devel/lib/Nana/RemoteHost.pm>

=back

=head1 AUTHOR

=over 4

@@AUTHOR_NANAMI@@

@@AUTHOR_PYUKI@@

=back

=head1 LICENSE

@@LICENSE_NANAMI@@

=cut
