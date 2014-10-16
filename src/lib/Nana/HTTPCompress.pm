######################################################################
# @@HEADER3_NANAMI@@
######################################################################
package	Nana::HTTPCompress;
use 5.005;
use strict;
use integer;
use Exporter;
use vars qw($VERSION);
$VERSION = '0.2';

use Nana::ServerInfo;

######################################################################
# multicore gzip tips: http://www.submit.ne.jp/1500			# comment

$gzip::path;
$gzip::header;

sub init {
	my($path)=@_;
	my $info=new Nana::ServerInfo;

	my $pigz_command='pigz';
	my $gzip_command='gzip';
	my $execpath="/usr/local/bin:/usr/bin:/bin:$ENV{PATH}";

	if($path eq 'nouse') {
		$path='';
	} elsif($path eq '') {
		my $forceflag="";
		my $fastflag="";
		foreach(split(/:/,$execpath)) {
			if(-x "$_/$gzip_command") {
				$path="$_/$gzip_command" ;
				if(open(PIPE,"$path --help 2>&1|")) {
					foreach(<PIPE>) {
						$forceflag="--force" if(/(\-\-force)/);
						$fastflag="--fast" if(/(\-\-fast)/);
					}
					close(PIPE);
				}
			}
		}
		foreach(split(/:/,$execpath)) {
			if(-x "$_/$pigz_command" && $info->core > 3) {
				$path="$_/$pigz_command" ;
				if(open(PIPE,"$path --help 2>&1|")) {
					foreach(<PIPE>) {
						$forceflag="--force" if(/(\-\-force)/);
						$fastflag="--fast" if(/(\-\-fast)/);
					}
					close(PIPE);
				}
			}
		}
		if($path ne '') {
			$gzip::path="$path $fastflag $forceflag";
			$::debug.="auto detect gzip path : \"$gzip::path\"\n";	# debug
		} elsif(&load_module("Compress::Zlib")) {
			$gzip::path="zlib";
			$::debug.="auto detect Compress::Zlib";	# debug
		}
	}

	if ($path ne '') {
		$gzip::path=$path;
		if(($ENV{'HTTP_ACCEPT_ENCODING'}=~/gzip/)) {
			if($ENV{'HTTP_ACCEPT_ENCODING'}=~/x-gzip/) {
				$gzip::header="Content-Encoding: x-gzip\n";
			} else {
				$gzip::header="Content-Encoding: gzip\n";
			}
			return $gzip::header;
		}
	}
}

sub output {
	my ($data)=shift;
	if ($gzip::header ne '') {
		if($gzip::path eq "zlib") {
			binmode(STDOUT);
			my $compress_data=Compress::Zlib::memGzip ($data);
			print $compress_data;
		} else {
			binmode(STDOUT);
			open(STDOUT,"| $gzip::path");
			print $data;
		}
	} else {
		print $data;
	}
	close(STDOUT);
}
1;
__END__

=head1 NAME

Nana::HTTPCompress - HTTP compress module

=head1 SEE ALSO

=over 4

=item PyukiWiki CVS

L<@@CVSURL@@/PyukiWiki-Devel/lib/Nana/HTTPCompress.pm>

=back

=head1 AUTHOR

=over 4

@@AUTHOR_NANAMI@@

@@AUTHOR_PYUKI@@

=back

=head1 LICENSE

@@LICENSE_NANAMI@@

=cut
