######################################################################
# @@HEADER2_NEKYO@@
######################################################################

sub plugin_aname_inline {
	return &plugin_aname_convert(@_);
}

sub plugin_aname_convert {
	return '' if (@_ < 1);	# no param
	my @args = split(/,/, shift);
	my $id = shift(@args);
	return false if (!($id =~ /^[A-Za-z][\w\-]*$/));

	my $body = '';
	if (@args) {
		$body = pop(@args);
		$body =~ s/<\/?a[^>]*>//;
	}
	my $class = 'anchor';
	my $url = '';
	my $attr_id = " id=\"$id\"";

	foreach (@args) {
		if (/super/) {
			$class = 'anchor_super';
		}
		if (/full/) {
#			$url = "$::script?".rawurlencode($vars['page']);
			$url = &make_cookedurl(&encode($page));0
		}
		if (/noid/) {
			$attr_id = '';
		}
	}
	return "<a class=\"$class\"$attr_id href=\"$url#$id\" title=\"$id\">$body</a>";
}

1;
__DATA__

sub plugin_aname_usage {
	return {
		name => 'aname',
		version => '1.0',
		type => 'inline,convert',
		author => '@@NEKYO@@',
		syntax => '&aname(anchor name [,{[super], [full], [noid]}] ){ anchor string };\n#aname(anchor name [,{[super], [full], [noid]}, anchor string] )',
		description => 'An anchor link, set as the position.',
		description_ja => '指定した位置にアンカー(リンクの飛び先)を設定します。
',
		example => '#aname(aliasname,full,anchor)',
	};
}

1;
__END__

=head1 NAME

aname.inc.pl - PyukiWiki Plugin

=head1 SYNOPSIS

 &aname(anchor name [,{[super], [full], [noid]}] ){ anchor string };
 #aname(anchor name [,{[super], [full], [noid]}, anchor string] )',

=head1 DESCRIPTION

An anchor link, set as the position.

=back

=head1 SEE ALSO

=over 4

=item PyukiWiki/Plugin/Standard/aname

L<@@BASEURL@@/PyukiWiki/Plugin/Standard/aname/>

=item PyukiWiki CVS

L<@@CVSURL@@/PyukiWiki-Devel/plugin/aname.inc.pl>

=back

=head1 AUTHOR

=over 4

@@AUTHOR_NEKYO@@

@@AUTHOR_PYUKI@@

=back

=head1 LICENSE

@@LICENSE_NEKYO@@

=cut
