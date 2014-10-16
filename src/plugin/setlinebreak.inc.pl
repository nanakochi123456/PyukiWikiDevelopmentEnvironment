######################################################################
# @@HEADER2_NANAMI@@
######################################################################

use strict;

sub plugin_setlinebreak_convert {
	my($mode)=split(/,/, shift);
	if($mode eq '') {
		$::lfmode=$::lfmode eq 0 ? 1 : 0;
	} elsif(lc $mode eq 'default') {
		$::lfmode=$::line_break;
	} elsif($mode=~/^(1|[Oo][Nn])/) {
		$::lfmode=1;
	} else {
		$::lfmode=0;
	}
	return ' ';
}

1;
__END__

=head1 NAME

setlinebreak.inc.pl - PyukiWiki Plugin

=head1 SYNOPSIS

 #setlinebreak([0|1] or [off|on|default])
 &*lfmode([0|1);

=head1 DESCRIPTION

It sets up whether it is considered that the new-line in an input text is a new-line.

How PyukiWiki treats the new-line in an input text changes according to the contents of a setting of $::line_break in pukiwiki.ini.cgi

It can specify now how about the line after an applicable page, setlinebreak plug-in is not based on a setup of $::line_break, but treats a new-line.

=back

=head1 USAGE

=over 4

=item Argument

The treatment of subsequent new-lines is specified as a parameter. When a parameter is omitted, a setup about whether it is regarded as a new-line is reversed.

 on or 1 - It is considered by the subsequent texts that the new-line in a paragraph is a new-line ($::line_break= it is the same as that of 1).
 off or 0 - A new-line is disregarded by the subsequent texts ($::line_break= it is the same as that of 0). In order to start a new line, it is necessary to describe a tilde at the end of the sentence, or to use br plug-in in a line.
 default - The treatment of a new-line is returned to a $::line_break setup of the site.

=back

=head1 SEE ALSO

=over 4

=item PyukiWiki/Plugin/Standard/setlinebreak

L<@@BASEURL@@/PyukiWiki/Plugin/Standard/setlinebreak/>

=item PyukiWiki CVS

L<@@CVSURL@@/PyukiWiki-Devel/plugin/setlinebreak.inc.pl>

=back

=head1 AUTHOR

=over 4

@@AUTHOR_NANAMI@@

@@AUTHOR_PYUKI@@

=back

=head1 LICENSE

@@LICENSE_NANAMI@@

=cut
