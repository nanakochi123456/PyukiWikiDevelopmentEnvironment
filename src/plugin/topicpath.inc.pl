######################################################################
# @@HEADER2_JUNICHI@@
######################################################################
# ���ꥸ�ʥ�Ȥ��ѹ���
# ��$topicpath::ARROW, $topicpath::FRONTPAGE �ؤ��������ѹ�
# ��PukiWiki�饤����ɽ��������ɲ�
# ��0.1.6�Ѥ�URL�������ѹ�
######################################################################
# select or edit style
######################################################################
# Re-Birth Original
#$topicpath::AutoLoad=1					if(!defined($topicpath::AutoLoad));
#$topicpath::SEPARATOR = $::separator	if(!defined($topicpath::SEPARATOR));
#$topicpath::FRONTMARK = ' �� '			if(!defined($topicpath::FRONTMARK));
#$topicpath::ARROW = ' &gt; '			if(!defined($topicpath::ARROW));
#$topicpath::FRONTPAGE = $::FrontPage	if(!defined($topicpath::FRONTPAGE));
#$topicpath::FRONTPAGENAME=$::FrontPage	if(!defined($topicpath::FRONTPAGENAME));
#$topicpath::PREFIX = '[ '				if(!defined($topicpath::PREFIX));
#$topicpath::SUFFIX = ' ]'				if(!defined($topicpath::SUFFIX));
######################################################################
# PukiWiki Like
$topicpath::AutoLoad=1					if(!defined($topicpath::AutoLoad));
$topicpath::SEPARATOR = $::separator	if(!defined($topicpath::SEPARATOR));
$topicpath::FRONTMARK = ' /  '			if(!defined($topicpath::FRONTMARK));
$topicpath::ARROW = ' / '				if(!defined($topicpath::ARROW));
$topicpath::FRONTPAGE = $::FrontPage	if(!defined($topicpath::FRONTPAGE));
$topicpath::FRONTPAGENAME='Top'			if(!defined($topicpath::FRONTPAGENAME));
$topicpath::PREFIX = ''					if(!defined($topicpath::PREFIX));
$topicpath::SUFFIX = ''					if(!defined($topicpath::SUFFIX));
######################################################################

sub plugin_topicpath_inline {
	# wiki.cgi������ɤ߹��ߤ�Ƚ�Ǥ���				# commnt
	my($wikicgiflag,$page)=split(/,/, shift);
	return '' if(shift eq 1 && $topicpath::AutoLoad eq 0);

	my $mypage = $page eq '' ? $::form{mypage} : $page;

	if(!(&is_exist_page($mypage))) {
		return "";
	}

	my @path_array = split($topicpath::SEPARATOR,$mypage);

	# FrontPage�Υ��å�										# commnt
	$topicpath::FRONTPAGEUrl = &createUrl($topicpath::FRONTPAGE, $topicpath::FRONTPAGE, $topicpath::FRONTPAGE, $topicpath::FRONTPAGENAME);

	if($mypage eq $topicpath::FRONTPAGE) {
		return $topicpath::PREFIX . $topicpath::FRONTPAGEUrl . $topicpath::SUFFIX;
	}

	$result = $topicpath::FRONTPAGEUrl . $topicpath::FRONTMARK;
	my $pathname = "";
	foreach $pagename (@path_array) {

		if($pathname ne "") {
			$pathname .= $topicpath::SEPARATOR . $pagename;
		}else{
			$pathname = $pagename;
		}

		$result .= &createUrl($pagename, $pathname, $topicpath::FRONTPAGE, $topicpath::FRONTPAGENAME);

		# �����Ĥ��� fix 0.2.0								# commnt
		$result .= $topicpath::ARROW;
	}
	# �Ǹ������������										# commnt
	$result =~s/$topicpath::ARROW$//g;

	return $topicpath::PREFIX . $result . $topicpath::SUFFIX;
}

# ex.														# commnt
# $pagename : Page											# commnt
# $pathname : Category/Page									# commnt
sub createUrl() {
	my ($pagename,$pathname, $FRONTPAGE, $FRONTPAGENAME) = @_;

	if(&is_exist_page($pathname)) {
		return qq|<a href="@{[&make_cookedurl(&encode($pathname))]}">@{[&escape($pagename eq $FRONTPAGE ? $FRONTPAGENAME : $pagename)]}</a>|;
	} else {
		return qq|@{[&escape($pagename)]}<a href="$::script?cmd=edit&amp;mypage=@{[&encode($pathname)]}">?</a>|;
	}
}

1;
__END__

=head1 NAME

topicpath.inc.pl - PyukiWiki Administrator's Plugin

=head1 SYNOPSIS

 automatic required (not compact version) or
 in :Header etc ... &topicpath;
 or put of skin file
  require 'plugin/topicpath.inc.pl';
  &plugin_topicpath_inline;

=head1 DESCRIPTION

It is the so-called "crumbs list."

Page name   It indicates by the class by /(slash) pause, and links to each page.

=head1 SEE ALSO

=over 4

=item PyukiWiki/Plugin/Admin/topicpath

L<@@BASEURL@@/PyukiWiki/Plugin/Admin/topicpath/>

=item PyukiWiki CVS

L<@@CVSURL@@/PyukiWiki-Devel/plugin/topicpath.inc.pl>

=item Site manufacture/PyukiWiki/Plugin/topicpath

It is the correspondence version to 0.1.5.

L<http://www.re-birth.com/pyuki/wiki.cgi?%a5%b5%a5%a4%a5%c8%c0%a9%ba%ee%2fPyukiWiki%2f%a5%d7%a5%e9%a5%b0%a5%a4%a5%f3%2f%a5%d1%a5%f3%a4%af%a4%ba%a5%ea%a5%b9%a5%c8>

=back

=head1 AUTHOR

=over 4

@@AUTHOR_JUNICHI@@

@@AUTHOR_PYUKI@@

=back

=head1 LICENSE

@@LICENSE_JUNICHI@@

=cut
