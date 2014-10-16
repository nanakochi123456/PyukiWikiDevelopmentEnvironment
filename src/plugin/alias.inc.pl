######################################################################
# @@HEADER2_NANAMI@@
######################################################################
# Based on PukiWiki Plugin "alias.inc.php" ver.1.5 2005/05/28
# modified by kochi
######################################################################

use strict;

$alias::loopmax=2;

%alias::loopcount;
@alias::pushmypage;

sub plugin_alias_convert {
	# no param											# comment
	my($page,$usethispagetitle)=split(/,/, shift);
	return ' ' if($::form{mypage}=~/($::MenuBar|$::SideBar|$::Header|$::Footer)$/);
	return ' ' if($::form{cmd} ne 'read');
	return ' ' if($::form{noalias} eq 'true');
	return ' ' if($alias::loopcount{$::form{mypage}} > 0);
	$alias::loopcount{$::form{mypage}}++;
	$alias::loopcount{""}++;
	return ' ' if($alias::loopcount{""} >= $alias::loopmax);

	push(@alias::pushmypage,$::form{mypage});
	my $title=$::form{mypage};
	$::form{mypage}=$page;
	if($usethispagetitle eq 1) {
		&do_read($title);
	} else {
		&do_read;
	}
	&close_db;
	exit;
}

1;
__DATA__

sub plugin_alias_usage {
	return {
		name => 'alias',
		type => 'convert',
		version => '1.0',
		author => '@@NANAMI@@',
		syntax => '#alias(page, flag)',
		description => 'It jumps to specified another Wiki page, without displaying a page.',
		description_ja => 'ページを表示せずに、指定した別のWikiページへジャンプする。',

		example => '#alias(pagename, pageflag)',
	};
}

1;
__END__

=head1 NAME

alias.inc.pl - PyukiWiki Plugin

=head1 SYNOPSIS

 #alias(pagename [,pagenameflag])

=head1 DESCRIPTION

It jumps to specified another Wiki page, without displaying a page.

=back

=head1 USAGE

=over 4

=item pagename

Specify wiki page. When the loop is carried out, an alias is ended at the time and the page in this time is displayed.

=item pagenameflag

If it specified 0, the page name of the alias point will be displayed.

If it specified 1, the page name of alias origin will be displayed. However, as for the link of edit etc., the page name of the alias point is specified.

=item other

In order to change the page of alias origin, please change by the ?cmd=adminedit&mypage=pagename.

=back

=head1 SETTING

=head2 alias.inc.pl

=over 4

=item $alias::loopmax

The number of times of the maximum of an alias is specified. A default is 2.

=back

=head1 SEE ALSO

=over 4

=item PyukiWiki/Plugin/Standard/alias

L<@@BASEURL@@/PyukiWiki/Plugin/Standard/alias/>

=item PyukiWiki CVS

L<@@CVSURL@@/PyukiWiki-Devel/plugin/alias.inc.pl>

=back

=head1 AUTHOR

=over 4

@@AUTHOR_NANAMI@@

@@AUTHOR_PYUKI@@

=back

=head1 LICENSE

@@LICENSE_NANAMI@@

=cut
