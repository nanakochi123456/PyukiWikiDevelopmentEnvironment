######################################################################
# @@HEADER3_NANAMI@@
######################################################################

package	Nana::Cookie;
use 5.005;
use strict;
use integer;
use Exporter;
use vars qw($VERSION @ISA @EXPORTER @EXPORT_OK);
$VERSION = '0.2';
@EXPORT_OK = qw(getcookie setcookie);

######################################################################

sub getcookie {
	my($cookieID,%buf)=@_;
	my @pairs;
	my ($pair, $cname, $value);
	my %DUMMY;

	my $decode = $::functions{"decode"};

	@pairs = split(/;/,&$decode($ENV{'HTTP_COOKIE'}));
	foreach $pair (@pairs) {
		($cname,$value) = split(/=/,$pair,2);
		$cname =~ s/ //g;
		$DUMMY{$cname} = $value;
	}
	@pairs = split(/,/,$DUMMY{$cookieID});
	foreach $pair (@pairs) {
		($cname,$value) = split(/:/,$pair,2);
		$buf{$cname} = $value;
	}
	return %buf;
}

sub setcookie {
	my ($cookieID,$expire,%buf)=@_;
	my ($date, $data, $name, $value);

	my $datefunc = $::functions{"http_date"};
	my $tzfunc = $::functions{"gettz"};

	if($expire+0 > 0) {
		$date=&$datefunc(time+&$tzfunc*3600+$::cookie_expire);
	} elsif($expire+0 < 0) {
		$date=&$datefunc(1);
	}
	$buf{cookietime}=time;
	while(($name,$value)=each(%buf)) {
		$data.="$name:$value," if($name ne '');
	}
	$data=~s/,$//g;

	my $encodefunc = $::functions{"encode"};
	$data=&$encodefunc($data);

	$::HTTP_HEADER.=qq(Set-Cookie: $cookieID=$data;);
	$::HTTP_HEADER.=qq( path=$::basepath;);
	$::HTTP_HEADER.=" expires=$date" if($expire ne 0);
	$::HTTP_HEADER.="\n";
}
1;
__END__

=head1 NAME

Nana::Cookie - Simple Cookie module fork from Yuichat.

=head1 SEE ALSO

=over 4

=item YuiChat

L<http://www.cup.com/yui/>

=item PyukiWiki CVS

L<@@CVSURL@@/PyukiWiki-Devel/lib/Nana/Cookie.pm>

=back

=head1 AUTHOR

=over 4

@@AUTHOR_NANAMI@@

@@AUTHOR_PYUKI@@

=back

=head1 LICENSE

@@LICENSE_NANAMI@@

=cut
