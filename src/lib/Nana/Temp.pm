######################################################################
# @@HEADER3_NANAMI@@
######################################################################
package	Nana::Temp;
use 5.005;
use strict;
use integer;
use Exporter;
use vars qw($VERSION @ISA @EXPORTER @EXPORT_OK);
$VERSION = '0.1';
@EXPORT_OK = qw(tempfile);

######################################################################

$Temp::Method=""
	if(!defined($Temp::Method));
$Temp::Loaded=0;
$Temp::DefaultTemplate="Pyuki-" . time . "-XXXXXXXXXXXXXXXXXXXXXXXX";

sub init {
	if(!$Temp::Loaded) {
		if($Temp::Method eq "") {
			foreach("File::Temp") {
				if(&load_module($_)) {
					$Temp::Method=$_;
				}
			}
		} else {
			foreach("File::Temp") {
				if($Temp::Method eq $_) {
					if(&load_module($_)) {
						$Temp::Method=$_;
					}
				}
			}
		}
	}
	$Temp::Loaded++;
}

sub tempfile {
	my (%hash)=@_;
	my $fh;
	my $fname;
	&init;
	if($Temp::Method eq "File::Temp") {
		if($hash{template} eq "") {
		($fh, $fname)=
			File::Temp::tempfile(
				$hash{template} eq ""
					? $Temp::DefaultTemplate
					: $hash{template},
				DIR => $hash{dir},
				SUFFIX => $hash{suffix});
		}
		return ($fh, $fname);
	} else {
		my $seed=$Temp::Loaded . $ENV{REMOTE_HOST} . $Temp::Loaded . $ENV{HTTP_USER_AGENT} . $Temp::Loaded . $ENV{HTTP_HOST} . $Temp::Loaded . $ENV{REQUEST_URL} . $Temp::Loaded . $ENV{QUERY_STRING} . $Temp::Loaded;
		my $sd;
		for(my $j = time; $j < time + 5; $j++) {
			for(my $l=time; $l < time + 30; $l++) {
				for(my $i=0; $i < length($seed); $i++) {
					$sd += chr(substr($seed, $i, 1)) + $j . length($sd) + $l;
				}
			}
			my $template=$hash{template};
			for(my $i=0; $template=~/X/; $i++) {
				$template=~s/X/@{[substr($sd, $i, 1)]}/;
			}
			my $tempfn="$hash{dir}/$sd$hash{suffix}";
			if(!-f $tempfn) {
				my $fh=&safe_open($tempfn, "w");
				return ($fh, $tempfn);
			}
		}
	}
}

sub load_module {
	my $funcp = $::functions{"load_module"};
	return &$funcp(@_);
}

1;
__END__

=head1 NAME

Nana::Temp - Temp filename generater

=head1 SEE ALSO

=over 4

=item PyukiWiki CVS

L<@@CVSURL@@/PyukiWiki-Devel/lib/Nana/Temp.pm>

=back

=head1 AUTHOR

=over 4

@@AUTHOR_NANAMI@@

@@AUTHOR_PYUKI@@

=back

=head1 LICENSE

@@LICENSE_NANAMI@@

=cut
