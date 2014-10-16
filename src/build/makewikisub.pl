#!/usr/bin/perl
# make wiki_sub.cgi script for pyukiwiki
# $Id$


print <<EOM;
######################################################################
# \@\@HEADER1\@\@
######################################################################
# This is auto generation code
######################################################################

=head1 NAME

wiki_sub.cgi - This is PyukiWiki, yet another Wiki clone.

=head1 SEE ALSO

=over 4

=item PyukiWiki/Dev/Specification/wiki_sub.cgi

L<\@\@BASEURL\@\@/PyukiWiki/Dev/Specification/wiki_sub.cgi/>

=item PyukiWiki CVS

L<\@\@CVSURL\@\@/PyukiWiki-Devel/lib/wiki_sub.cgi>

=back

=head1 AUTHOR

=over 4

\@\@AUTHOR_NEKYO\@\@

\@\@AUTHOR_NANAMI\@\@

\@\@AUTHOR_PYUKI\@\@

=back

=head1 LICENSE

\@\@LICENSE_NEKYO\@\@

=cut

EOM

print <<EOM;
%::functions = (
EOM

foreach(@ARGV) {
	next if(/sub/);
	$fname=$_;
	$fname_sub=$fname;
	$fname_sub=~s/.*\/wiki\_//g;
	$fname_sub=~s/\..*//g;

	open(R,$fname)||die;
	foreach(<R>) {
		if(/^(sub\s\_)(\w*)/) {
			$func=$2;
			print <<EOM;
"$func"=>\\\&$func,
EOM
		}
	}
	close(R);
}

print <<EOM;
);
EOM

foreach(@ARGV) {
	next if(/sub/);
	$fname=$_;
	$fname_sub=$fname;
	$fname_sub=~s/.*\/wiki\_//g;
	$fname_sub=~s/\..*//g;

	open(R,$fname)||die;
	foreach(<R>) {
		if(/^(sub\s\_)(\w*)/) {
			$func=$2;
			print <<EOM;
# Function $func (wiki\_$fname_sub.cgi)				# comment
sub $func \{&load_wiki_module("$fname_sub");return \&\_$func(\@\_);}
EOM
		}
	}
	close(R);
}

print <<EOM;

1;
EOM
