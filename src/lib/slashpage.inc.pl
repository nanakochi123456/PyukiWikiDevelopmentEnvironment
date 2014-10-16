######################################################################
# @@HEADER2_NANAMI@@
######################################################################
# This is extented plugin.
# To use this plugin, rename to 'slashpage.inc.cgi'
######################################################################

use strict;

sub plugin_slashpage_init {
	&exec_explugin_sub("lang");
	@::PLUGIN_SLASHPAGE_STACK=();

	# / を含むページのみ配列に格納する				# debug # comment
	foreach my $pages (keys %::database) {
		push(@::PLUGIN_SLASHPAGE_STACK,$pages) if($pages=~/\//);
	}
	@::PLUGIN_SLASHPAGE_STACK=sort @::PLUGIN_SLASHPAGE_STACK;

	# InterWikiからのを検索してみる					# debug # comment
	my $req=$ENV{QUERY_STRING};
	if($req ne '' && $::form{mypage} eq $::FrontPage && ($::form{cmd} eq '' || $::form{cmd} eq 'read')) {
		if (&is_exist_page($req)) {
			$::form{mypage}=$req;
		} else {
			foreach my $pagetemp (@::PLUGIN_SLASHPAGE_STACK) {
				my $pagetemp2=$pagetemp;
				$pagetemp2=~s/.*\///g;
				if($pagetemp2 eq $req) {
					$::form{mypage}=$pagetemp;
					last;
				}
			}
		}
	}
	return('init'=>1,'func'=>'make_link_wikipage', 'make_link_wikipage'=>\&make_link_wikipage);
}

sub make_link_wikipage {
	my($chunk1,$escapedchunk)=@_;
	my($chunk,$anchor)=$chunk1=~/^([^#]+)#?(.*)/;
	my $cookedchunk  = &encode($chunk);
	my $cookedurl=&make_cookedurl($cookedchunk);

	if (&is_exist_page($chunk)) {
		if($anchor eq '') {
			return qq(<a title="$chunk" href="$cookedurl">$escapedchunk</a>);
		} else {
			return qq(<a title="$chunk" href="$cookedurl#$anchor">$escapedchunk</a>);
		}
	}
	foreach my $pagetemp (@::PLUGIN_SLASHPAGE_STACK) {
		my $pagetemp2=$pagetemp;
		$pagetemp2=~s/.*\///g;
		if($pagetemp2 eq $chunk) {
			$cookedchunk  = &encode($pagetemp);
			$cookedurl=&make_cookedurl($cookedchunk);
			if($anchor eq '') {
				return qq(<a title="$pagetemp" href="$cookedurl">$escapedchunk</a>);
			} else {
				return qq(<a title="$1" href="$cookedurl#$anchor">$escapedchunk</a>);
			}
		}
	}
	if (&is_editable($chunk)) {
		# 2005.10.27 pochi: 自動リンク機能を拡張		# comment
		if ($::editchar eq 'this') {
			return qq(<a title="$::resource{editthispage}" class="editlink" href="$::script?cmd=edit&amp;mypage=$cookedchunk">$escapedchunk</a>);
		} elsif ($::editchar) {
			# original
			return qq($escapedchunk<a title="$::resource{editthispage}" class="editlink" href="$::script?cmd=edit&amp;mypage=$cookedchunk">$::editchar</a>);
		}
	}
	return $escapedchunk;
}

1;
__DATA__
sub plugin_slashpage_setup {
	return(
		ja=>'階層下のページ名を容易にリンクする',
		en=>'Link of the page name under a class easily',
		override=>'make_link_wikipage',
		url=>'@@BASEURL@@/PyukiWiki/Plugin/ExPlugin/slashpage/'
	);
__END__

=head1 NAME

slashpage.inc.pl - PyukiWiki Plugin

=head1 SYNOPSIS

Link of the page name under a class easily

=head1 DESCRIPTION

Even if linked by WikiName or [[BracketName]], it enables it to link to a page which is under the following classes.

 PyukiWiki/Glossary/WikiName
 PyukiWiki/Sample/BracketName

First, rather than the bottom of a class, since it refers to an actual page name, when a name overlaps, please link by all page names using an alias etc.

=head1 USAGE

rename to slashpage.inc.cgi

=head1 OVERRIDE

make_link_wikiname was overrided.

=head1 SEE ALSO

=over 4

=item PyukiWiki/Plugin/ExPlugin/slashpage

L<@@BASEURL@@/PyukiWiki/Plugin/ExPlugin/slashpage/>

=item PyukiWiki CVS

L<@@CVSURL@@/PyukiWiki-Devel/lib/slashpage.inc.pl>

=back

=head1 AUTHOR

=over 4

@@AUTHOR_NANAMI@@

@@AUTHOR_PYUKI@@

=back

=head1 LICENSE

@@LICENSE_NANAMI@@

=cut
