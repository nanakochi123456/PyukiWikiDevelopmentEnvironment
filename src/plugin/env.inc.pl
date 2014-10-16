######################################################################
# @@HEADER2_NANAMI@@
######################################################################

use strict;

######################################################################

sub plugin_env_convert {
	&plugin_env_inline(@_);
}

sub plugin_env_inline {
	my($env, $regex, $page)=split(/,/,shift);
	return ' ' if(!&is_frozen($::form{mypage}));

	if(lc $regex eq "view") {
		return $ENV{$env};
	}

	if($::ENV{$env}=~/$regex/i) {
		return &text_to_html($::database{$page});
	}
	return " ";
}

1;
__END__

=head1 NAME

env.inc.pl - PyukiWiki ExPlugin

=head1 SYNOPSIS

 &env(Environment, Regex, Display Wiki Format);

=head1 SEE ALSO

=over 4

=item PyukiWiki/Plugin/Standard/env

L<@@BASEURL@@/PyukiWiki/Plugin/Standard/env/>

=item PyukiWiki CVS

L<@@CVSURL@@/PyukiWiki-Devel/plugin/env.inc.pl>

=back

=head1 AUTHOR

=over 4

@@AUTHOR_NANAMI@@

@@AUTHOR_PYUKI@@

=back

=head1 LICENSE

@@LICENSE_NANAMI@@

=cut
