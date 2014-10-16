######################################################################
# @@HEADER2_NEKYO@@
######################################################################
# 現在参照中のおおよそのユーザー数を表示する。
# :書式|
#  #online
#  &online;
# @author Nekyo.
# @version v0.2 2004/12/06 問題があったので、排他lockなし版
######################################################################

$online::timeout = 300
	if(!defined($online::timeout));

######################################################################

use strict;

sub plugin_online_inline {
	return &plugin_online_convert;
}

sub plugin_online_convert {
	my $file = $::counter_dir . 'user.dat';

	if (!(-e $file)) {
		open(FILE, ">$file");
		close(FILE);
	}
	my $addr = $ENV{'REMOTE_ADDR'};

	open(FILE, "<$file");
	my @usr_arr = <FILE>;
	close(FILE);

	open(FILE, ">$file");
#	flock(FILE, 2);		# lock WriteBlock
	my $now = time();
	my ($ip_addr, $tim_stmp);
	foreach (@usr_arr) {
		chomp;
		($ip_addr, $tim_stmp) = split(/|/);

		if (($now - $tim_stmp) < $online::timeout and $ip_addr ne $addr) {
			print FILE "$ip_addr|$tim_stmp\n";
		}
	}
	print FILE "$addr|$now\n";
#	flock(FILE, 8);		# unlock						# comment
	close(FILE);

	open(FILE, "<$file");
	@usr_arr = <FILE>;
	close(FILE);
	return @usr_arr;
}
1;
__END__

=head1 NAME

online.inc.pl - PyukiWiki Plugin

=head1 SYNOPSIS

 &online;
 #online

=head1 DESCRIPTION

The near number of visiters referred to now is displayed.

=head1 SEE ALSO

=over 4

=item PyukiWiki/Plugin/Standard/online

L<@@BASEURL@@/PyukiWiki/Plugin/Standard/online/>

=item PyukiWiki CVS

L<@@CVSURL@@/PyukiWiki-Devel/plugin/online.inc.pl>

=back

=head1 AUTHOR

=over 4

@@AUTHOR_NEKYO@@

@@AUTHOR_PYUKI@@

=back

=head1 LICENSE

@@LICENSE_NEKYO@@

=cut
