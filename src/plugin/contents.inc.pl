######################################################################
# @@HEADER2_NEKYO@@
######################################################################
# v0.2.1 2012/10/10 アンカー名の取り扱い方法を変更
# v0.1.7 2006/05/26 #contents(他ページ) で他ページのコンテンツが表示
#                   できるよう変更 無指定の時はいままで通りです。
# v0.1.6 2006/01/07 *****まで対応、その他修正
# v0.0.2 2005/01/20 base による弊害の対応
# v0.0.1 プロトタイプ
######################################################################

use strict;

sub plugin_contents_convert {
	my ($parmpage, $level)=@_;
	my $page;
	if ($parmpage ne '') {
		$page = $parmpage;
		$::pushedpage = $page;
	} else {
		$page = $::form{mypage};
	}

	my ($txt) = $::database{$page};
	my (@txt) = split(/\r?\n/, $txt);
	return &plugin_contents_main("", $level, @txt);
}

sub plugin_contents_main {
	my $baseurl = shift;
	my $level = shift;
	my @txt = @_;
	my $tocnum = 0;
	my (@tocsaved, @tocresult);
	my $title;
#	my $nametag = &pageanchorname($::form{mypage});

	$level=5 if($level+0 eq 0);
	foreach (@txt) {
		chomp;
		if (/^(\*{1,$level})(.+)/) {
			my $plus=$level+1;
			if(/^(\*{$plus,10})/) {
				$tocnum++;
				next;
			}
			&back_push('ul', length($1), \@tocsaved, \@tocresult);
			$title = &inlinetext($2);

			if($baseurl eq '') {
				push(@tocresult, qq(<li><a href=")
					 . &make_cookedurl(&encode($::pushedpage eq '' ? $::form{mypage} : $::pushedpage))
					. "#" . &makeanchor($::form{mypage}, $tocnum, $title) . qq(">$title</a></li>\n));
			} else {
				push(@tocresult, qq(<li><a href=")
					 . $baseurl
					. "#" . &makeanchor($::form{mypage}, $tocnum, $title) . qq(">$title</a></li>\n));
			}
			$tocnum++;
		}
	}
	push(@tocresult, splice(@tocsaved));
	my $body = <<EOD;
<div class="contents">
<a id="@{[&makeanchor($::form{mypage}, $tocnum, "contents")]}"></a>
EOD
	$body .= join("\n", @tocresult) . "</div>\n";
	return $body;
}
1;
__END__

=head1 NAME

contents.inc.pl - PyukiWiki Plugin

=head1 SYNOPSIS

 #contents
 #contents(page name)

=head1 DESCRIPTION

The list of the titles in the installed page is displayed.

=head1 SEE ALSO

=over 4

=item PyukiWiki/Plugin/Standard/contents

L<@@BASEURL@@/PyukiWiki/Plugin/Standard/contents/>

=item PyukiWiki CVS

L<@@CVSURL@@/PyukiWiki-Devel/plugin/contents.inc.pl>

=back

=head1 AUTHOR

=over 4

@@AUTHOR_NEKYO@@

@@AUTHOR_PYUKI@@

=back

=head1 LICENSE

@@LICENSE_NEKYO@@

=cut
