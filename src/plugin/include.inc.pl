######################################################################
# @@HEADER2_NEKYO@@
######################################################################
# v0.2.1 add noinclude option
######################################################################

use strict;

$::includedpage;

sub plugin_include_inline {
	return &plugin_include_convert(@_);
}

sub plugin_include_convert {
	my ($arg)=@_;
	my(@opt)=split(/,/,$arg);
	my $notitle=0;
	my $noinclude=0;
	my $body;
	foreach(@opt) {
		$notitle=1 if(/notitle/);
		$noinclude=1 if(/noinclude/);
	}

	my $page = shift @opt;
	if($noinclude) {
		if($::includedpage eq "") {
			my $wiki;
			foreach(@opt) {
				next if(/noinclude/);
				$wiki.=$_;
			}
			$body = &text_to_html($wiki, toc=>1);
			return "$body";
		}
		return ' ';
	}

	if ($page eq '') { return ''; }
	my $body = '';
	if (&is_exist_page($page)) {
		if(&is_readable($page)) {
			$::includedpage=$::form{mypage};
			$::form{mypage}=$page;
			my $rawcontent = $::database{$page};
			$body = &text_to_html($rawcontent, toc=>1);
			$::form{mypage}=$::includedpage;
			$::includedpage="";
			my $cookedpage = &encode($page);
			my $link = "<a href=\"$::script?$cookedpage\">$page</a>";
			if ($::form{mypage} eq $::MenuBar) {
				$body = <<"EOD";
<span align="center"><h5 class="side_label">$link</h5></span>
<small>$body</small>
EOD
			} else {
				if($notitle eq 0) {
					$body = "<h1>$link</h1>\n$body\n";
				}
			}
		} else {
			return ' ';
		}
	}
	return $body;
}
1;
__END__

=head1 NAME

include.inc.pl - PyukiWiki Plugin

=head1 SYNOPSIS

 #include(wikipage[,notitle])

=head1 DESCRIPTION

Include WikiPage

=head1 USAGE

=over 4

=item notitle

Disable display page title of included page

=back

=head1 SEE ALSO

=over 4

=item PyukiWiki/Plugin/Standard/include

L<@@BASEURL@@/PyukiWiki/Plugin/Standard/include/>

=item PyukiWiki CVS

L<@@CVSURL@@/PyukiWiki-Devel/plugin/include.inc.pl>

=back

=head1 AUTHOR

=over 4

@@AUTHOR_NEKYO@@

@@AUTHOR_PYUKI@@

=back

=head1 LICENSE

@@LICENSE_NEKYO@@

=cut
