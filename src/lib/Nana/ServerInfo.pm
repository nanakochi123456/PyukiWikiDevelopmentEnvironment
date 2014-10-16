######################################################################
# @@HEADER3_NANAMI@@
######################################################################

package	Nana::ServerInfo;
use 5.005;
use strict;
use integer;
use Exporter;
use vars qw($VERSION);
$VERSION = '0.1';

######################################################################

sub new {
	my($class,%hash)=@_;
# http://d.hatena.ne.jp/perlcodesample/20080430/1209569716	# comment
	my $os=$^O;
	my $info;
	my $cores=0;
	if(lc $os eq "linux") {
		open(PIPE, "/bin/cat /proc/cpuinfo |") || die "Can't open /proc/cpuinfo";
		foreach(<PIPE>) {
			$info.=$_;
		}
		close(PIPE);
	}
	if(lc $os eq "freebsd") {
		open(PIPE, "/bin/cat /var/run/dmesg.boot |") || die "Can't open /var/run/dmesg.boot";
		foreach(<PIPE>) {
			$info.=$_;
		}
		close(PIPE);
	}
	if(lc $os eq "linux") {
		my $lines=0;
		foreach(split/\n/,$info) {
			$lines++ if(/model name/);
		}
		$cores=$lines if($lines > 1);
	}
	if(lc $os eq "freebsd") {
		foreach my $buf(split/\n/,$info) {
			if($buf=~/ CPUs/) {
				$buf=~s/.*\: //g;
				$buf=~s/ CPUs//g;
				$cores=$buf if($buf+0 > 1);
			}
		}
	}
	my $self={
		os=>$os,
		core=>$cores + 0
	};
	return bless $self, $class;
}

sub os {
	my($self,$name)=@_;
	return $self->{os}
}

sub core {
	my($self,$name)=@_;
	return $self->{core};
}

1;
__END__

=head1 NAME

Nana::ServerInfo - Server spec analyzer module

=head1 SEE ALSO

=over 4

=item PyukiWiki CVS

L<@@CVSURL@@/PyukiWiki-Devel/lib/Nana/ServerInfo.pm>

=back

=head1 AUTHOR

=over 4

@@AUTHOR_NANAMI@@

@@AUTHOR_PYUKI@@

=back

=head1 LICENSE

@@LICENSE_NANAMI@@

=cut
