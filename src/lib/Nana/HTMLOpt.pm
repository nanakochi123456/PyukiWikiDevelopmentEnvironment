######################################################################
# @@HEADER3_NANAMI@@
######################################################################
package	Nana::HTMLOpt;
use 5.005;
use strict;
use integer;
use vars qw($VERSION);
$VERSION = '0.1';

######################################################################

sub xhtml {
	my($body)=shift;

	$body=~s/\/\/\-\-\>\n?\<\/script\>\n?<script\s?type\=\"text\/javascript\"\>\<\!\-\-\n?//g;
	$body=~s/(<\!\-\-)/\n\/\/<\!\[CDATA\[/g;
	$body=~s/(\/\/\-\->)/\/\/\]\]>/g;
	$body=~s/<pre>\n/<pre>/g;
	$body=~s/<div>([\s\t\r\n]+)?<\/div>//g;
	$body=~s/<p>\n<\/p>(<p>\n<\/p>)?/<p>\n<\/p>/g;
	$body=~s/>\n(\n+)?</>\n</g;

	return $body;
}

sub html {
	my($body)=shift;

	$body=~s/\/\/\-\-\>\n?\<\/script\>\n?<script\s?type\=\"text\/javascript\"\>\<\!\-\-\n?//g;
	$body=~s/\ \/>/>/g;
	$body=~s/<div>([\s\t\r\n]+)?<\/div>//g;
	$body=~s/<p>\n<\/p>(<p>\n<\/p>)?/<p>\n<\/p>/g;
	$body=~s/>\n(\n+)?</>\n</g;

	return $body;
}
1;
__END__

=head1 NAME

Nana::HTMLOpt - HTML Optimizer module

=head1 SEE ALSO

=over 4

=item PyukiWiki CVS

L<@@CVSURL@@/PyukiWiki-Devel/lib/Nana/HTMLOpt.pm>

=back

=head1 AUTHOR

=over 4

@@AUTHOR_NANAMI@@

@@AUTHOR_PYUKI@@

=back

=head1 LICENSE

@@LICENSE_NANAMI@@

=cut
