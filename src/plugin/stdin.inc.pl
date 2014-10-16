######################################################################
# @@HEADER2_NANAMI@@
######################################################################

use strict;

require "$::plugin_dir/contents.inc.pl";

sub plugin_stdin_action {
	my $body;

	$::nowikiname = 1;

	# CGIでの実行を拒否する
	if($ENV{HTTP_USER_AGENT} ne '' || $ENV{HTTP_HOST} ne ''
	|| $ENV{REMOTE_ADDR} ne '') {
		return '';
	}

	&load_wiki_module(
		"init", "func", "db", "http", "html",
		"link", "sub", "plugin", "wiki");

	my $buf;
	my $contents_wiki;
	while(<STDIN>) {
		if(/^#contents/) {
			$contents_wiki=$_ 
		}
		$buf.=$_;
	}

	my $level;
	if($contents_wiki=~/^#contents\(.+?\,\d/) {
		$level=$1;
	} elsif($contents_wiki=~/^#contents\(\,1/) {
		$level=1;
	} else {
		$level=0;
	}
	my $contents=&plugin_contents_main("?",$level,split(/\n/, $buf));
	my $tmp=&text_to_html($buf);
	my $html;

$::wiki_name = '\b([A-Z][a-z]+[A-Z][a-z]+)\b';
$::bracket_name ='\[\[((?!\[)[^\]]+?)\]\]';
$::isurl=qq(s?(?:https?|ftp|news)://[-_.!~*'a-zA-Z0-9;/?:@&=+%#]+);
$::ismail=q{(?:[^(\040)<>@,;:".\\\\\[\]\000-\037\x80-\xff]+(?![^(\040)<>@,;:".\\\\\[\]\000-\037\x80-\xff])|"[^\\\\\x80-\xff\n\015"]*(?:\\\\[^\x80-\xff][^\\\\\x80-\xff\n\015"]*)*")(?:\.(?:[^(\040)<>@,;:".\\\\\[\]\000-\037\x80-\xff]+(?![^(\040)<>@,;:".\\\\\[\]\000-\037\x80-\xff])|"[^\\\\\x80-\xff\n\015"]*(?:\\\\[^\x80-\xff][^\\\\\x80-\xff\n\015"]*)*"))*@(?:[^(\040)<>@,;:".\\\\\[\]\000-\037\x80-\xff]+(?![^(\040)<>@,;:".\\\\\[\]\000-\037\x80-\xff])|\[(?:[^\\\\\x80-\xff\n\015\[\]]|\\\\[^\x80-\xff])*\])(?:\.(?:[^(\040)<>@,;:".\\\\\[\]\000-\037\x80-\xff]+(?![^(\040)<>@,;:".\\\\\[\]\000-\037\x80-\xff])|\[(?:[^\\\\\x80-\xff\n\015\[\]]|\\\\[^\x80-\xff])*\]))+};

	&_init_inline_regex;
	foreach(split(/\n/, $tmp)) {
		s!($::inline_regex)!&make_link($1)!geo;
#		s/^\x23.*//g if(!/\#contents.*/);
		$html.="$_\n";
	}

	$html=~s/\#contents.*\n/$contents/g;
	$html=~s/cmd=stdin//g;
	$html=~s/(\&|\&amp;)br;/\<br \/\>/g;
	$html=~s/(\&|\&amp;)hr;/\<hr \/\>/g;
	$html=~s/(\&|\&amp;)nbsp;/&nbsp;/g;

	print "$html\n";
	exit;
}
1;
__END__

=head1 NAME

stdin.inc.pl - PyukiWiki stdinistrator's Plugin

=head1 SYNOPSIS

REQUEST_METHOD="GET" QUERY_STRING="cmd=stdin" perl index.cgi

 setenv REQUEST_METHOD=GET
 setenv QUERY_STRING="cmd=stdin"
 perl index.cgi

=head1 DESCRIPTION

Convert wiki to html with standard input

=head1 SEE ALSO

=over 4

=item PyukiWiki/Plugin/Admin/stdin

L<@@BASEURL@@/PyukiWiki/Plugin/Admin/stdin/>

=item PyukiWiki CVS

L<@@CVSURL@@/PyukiWiki-Devel/plugin/stdin.inc.pl>

=back

=head1 AUTHOR

=over 4

@@AUTHOR_NANAMI@@

@@AUTHOR_PYUKI@@

=back

=head1 LICENSE

@@LICENSE_NANAMI@@

=cut
