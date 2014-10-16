######################################################################
# @@HEADER3_YUKI@@
######################################################################

package Yuki::DiffText;
use strict;
use Algorithm::Diff qw(traverse_sequences);
use vars qw($VERSION @EXPORT_OK @ISA);
use vars qw($diff_text $diff_msgrefA $diff_msgrefB @diff_deleted @diff_added);
require Exporter;
@ISA = qw(Exporter);
@EXPORT_OK = qw(difftext);
$VERSION = '0.1';

sub difftext {
	($diff_msgrefA, $diff_msgrefB) = @_;
	undef $diff_text;
	undef @diff_deleted;
	undef @diff_added;
	traverse_sequences(
		$diff_msgrefA, $diff_msgrefB,
		{
			MATCH => \&df_match,
			DISCARD_A => \&df_delete,
			DISCARD_B => \&df_add,
		}
	);
	&diff_flush;
	return $diff_text;
}

sub diff_flush {
	$diff_text .= join('', map { "-$_\n" } splice(@diff_deleted));
	$diff_text .= join('', map { "+$_\n" } splice(@diff_added));
}

sub df_match {
	my ($a, $b) = @_;
	&diff_flush;
	$diff_text .= "=$diff_msgrefA->[$a]\n";
}

sub df_delete {
	my ($a, $b) = @_;
	push(@diff_deleted, $diff_msgrefA->[$a]);
}

sub df_add {
	my ($a, $b) = @_;
	push(@diff_added, $diff_msgrefB->[$b]);
}

1;
__END__

=head1 NAME

Yuki::DiffText - A wrapper of Algorithm::Diff for YukiWiki.

=head1 SYNOPSIS

    use strict;
    use Yuki::DiffText qw(difftext);
 
    my @array1 = ( "Alice", "Bobby", "Chris", );
    my @array2 = ( "Alice",          "Chris", "Diana", );
    my $difftext = difftext(\@array1, \@array2);
    print $difftext;
 
    # Result:
    # =Alice
    # -Bobby
    # =Chris
    # +Diana

=head1 SEE ALSO

=over 4

=item L<Algorithm::Diff>

=item PyukiWiki CVS

L<@@CVSURL@@/PyukiWiki-Devel/lib/Yuki/Diff.pm>

=back

=head1 AUTHOR

=over 4

@@AUTHOR_YUKI@@

@@AUTHOR_PYUKI@@

=back

=head1 LICENSE

@@LICENSE_YUKI@@

=cut
