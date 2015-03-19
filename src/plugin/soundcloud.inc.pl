######################################################################
# @@HEADER2_NANAMI@@
######################################################################
# v0.2.1 First Release
######################################################################
# usage : #soundcloud([word press code])
######################################################################

$::soundcloud_base_html=qq(<iframe width="\$width" height="\$height" scrolling="no" frameborder="no" src="https://w.soundcloud.com/player/?url=\$url&amp;\$params"></iframe>);

sub plugin_soundcloud_convert {
	my($args)=shift;
	my @args = split(/,/, $args);
	return '<p>no argument(s).</p>' if (@args < 1);

	my %params;
	my %eparams;
	my $wp=shift @args;

	if($wp=~/^\[soundcolud/) {
		return "<p>not wordpress code for soundcloud argument(s). '$wp'</p>";
	}

	foreach my $args(split(/ /, $wp)) {
		my @arg=split(/=/, $args);
		my $l=shift @arg;
		my $r=join("=",@arg);
		$r=~s/\"//g;
		if($l=~/url|params|width|height/) {
			$params{$l}=$r;
		}
	}
	foreach(keys %params) {
		$eparams{$_}=&htmlspecialchars($params{$_});
		$eparams{$_}=~s/:/%3A/g;
	}

	my $html=&replace($::soundcloud_base_html
		, url=>$eparams{url}
		, params=>$eparams{params}
		, height=>$params{height}
		, width=>$params{width}
	);
	return $html;
}
1;
