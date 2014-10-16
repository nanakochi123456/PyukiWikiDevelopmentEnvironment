######################################################################
# @@HEADER2_NANAMI@@
######################################################################
# 0.2.1 bugfix
######################################################################

sub plugin_pagenavi_inline {
	return plugin_pagenavi_convert(@_);
}

sub plugin_pagenavi_convert {
	my ($args) = @_;
	my @args = split(/,/, $args);
	my $tmp;
	my $body;

	foreach(@args) {
		if(/$::separator/) {
			$tmp="";
			my @pages=split(/$::separator/,$_);
			foreach(@pages) {
				my($name,$alias)=split(/>/,$_);
				$alias=$name if($alias eq '');
				$tmp.=$alias;
				$body.=qq([[$name>$tmp]]/);
				$tmp.=$::separator;
			}
			$body=~s/\/$//g;
		} else {
			$body.=$_;
		}
	}

	$body=&text_to_html($body);
	return $body;
}

1;
__END__

=head1 NAME

pagenavi.inc.pl - PyukiWiki Plugin

=head1 SYNOPSIS

 #pagenavi(string, string, string...)

=head1 DESCRIPTION

The near number of visiters referred to now is displayed.

=head1 USAGE

=over 4

=item Makes link from upper layer to this page

 PyukiWiki/Glossary>Yougo/About PyukiWiki>PyukiWiki

It's write, convert to ...

 [[PyukiWiki]]/[[Glossary>PyukiWiki/Yougo]]/[[About PyukiWiki>PyukiWiki/Yougo/PyukiWiki]]

=item Others

Others are described by the usual Wiki grammar. After combining all parameters, it is changed into HTML with a text_to_html function.

=item Example

 #pagenavi(*,PyukiWiki/PyukiWiki Download>Download,!)
 #pagenavi(-Reference:,TOP>FrontPage/Glossary>Yougo>PyukiWiki)

=item Convenient usage

As a template of newpage.inc.pl, edit.inc.pl,
it is setting $::new_refer of pyukiwiki.ini.cgi.
It is convenient if you set it as a variable.

=back

=head1 SEE ALSO

=over 4

=item PyukiWiki/Plugin/Standard/pagenavi

L<@@BASEURL@@/PyukiWiki/Plugin/Standard/pagenavi/>

=item PyukiWiki CVS

L<@@CVSURL@@/PyukiWiki-Devel/plugin/pagenavi.inc.pl>

=back

=head1 AUTHOR

=over 4

@@AUTHOR_NANAMI@@

@@AUTHOR_PYUKI@@

=back

=head1 LICENSE

@@LICENSE_NANAMI@@

=cut
