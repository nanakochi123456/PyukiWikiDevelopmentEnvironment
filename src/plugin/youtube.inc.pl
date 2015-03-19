######################################################################
# @@HEADER2_NANAMI@@
######################################################################
# v0.2.1 First Release
######################################################################
# usage : #youtube(url, sd|hd, width=xxx)
######################################################################

@::youtube_baseurl=(
	"http://www.youtube.com/watch?v=",
	"https://www.youtube.com/watch?v=",
	"http://www.youtube.com/embed/",
	"https://www.youtube.com/embed/",
	"http://www.youtube.com/v/",
	"https://www.youtube.com/v/",
	"http://youtu.be/",
	"https://youtu.be/",
);

$::youtube_base_html=qq(<p><iframe width="\$width" height="\$height" src="https://www.youtube.com/embed/\$id" frameborder="0" allowfullscreen></iframe></p>);

%::youtube_default_width;
%::youtube_default_height;

$::youtube_default_width{sd}=420;
$::youtube_default_height{sd}=315;
$::youtube_default_width{hd}=560;
$::youtube_default_height{hd}=315;

sub plugin_youtube_convert{
	return "<p>\n" . &plugin_youtube_inline(@_) . "</p>\n";
}

sub plugin_youtube_inline {
	my($args)=shift;
	my @args = split(/,/, $args);
	return 'no argument(s).' if (@args < 1);

	my %parms;
	$parms{mode}="sd";

	foreach my $arg(@args) {
		my($l, $r)=split(/=/, $arg);
		if($arg=~/^[SsHh][Dd]$/) {
			if($arg=~/^[Hh][Dd]$/) {
				$parms{mode}="hd";
			}
		} elsif($l eq "width") {
			my $test=$r;
			$test=~s/[0123456789\%]//g;
			if($test eq "") {
				$parms{_width}=$r;
			}
		} elsif($l eq "height") {
			my $test=$r;
			$test=~s/[0123456789\%]//g;
			if($test eq "") {
				$parms{_height}=$r;
			}
		} else {
			foreach my $baseurl(@::youtube_baseurl) {
				my ($bburl, $bbquery)=split(/\?/,$baseurl);
				my $bburltest=$bburl;
				$bburltest=~s/\?.*//g;
				my $test=substr($arg, 0, length($bburltest));
				if($test eq $bburltest) {
					if($bbquery ne "") {
						my ($tl, $tr)=split(/\?/,$arg);
						foreach my $query(split(/&/,$tr)) {
							my($ql, $qr)=split(/=/, $query);
							if($ql eq "v") {
								$parms{id}=$qr;
							}
						}
					} else {
						$parms{id}=substr($arg, length($bburl));
					}
				}
			}
		}
	}

	$parms{width}=$::youtube_default_width{$parms{mode}};
	$parms{height}=$::youtube_default_height{$parms{mode}};

	if($parms{_height} ne "") {
		if($parms{_height}=~/%$/) {
			my $temp=$parms{_height};
			$temp=~s/%//g;
			$parms{width}=int($parms{width}*$temp/100);
			$parms{height}=int($parms{height}*$temp/100);
		} else {
			$parms{height}=int($parms{height});
			if($parms{mode} eq "sd") {
				$parms{width}=int($parms{width} / 3 * 4);
			} else {
				$parms{width}=int($parms{width} / 9 * 16);
			}
		}
	}

	if($parms{_width} ne "") {
		if($parms{_width}=~/%$/) {
			my $temp=$parms{_width};
			$temp=~s/%//g;
			$parms{width}=int($parms{width}*$temp*0.01);
			$parms{height}=int($parms{height}*$temp*0.01);
		} else {
			$parms{width}=int($parms{width});
			if($parms{mode} eq "sd") {
				$parms{height}=int($parms{height} / 4 * 3);
			} else {
				$parms{height}=int($parms{height} / 16 * 9);
			}
		}
	}
	$html=$::youtube_base_html;
	$html=~s/\$width/$parms{width}/g;
	$html=~s/\$height/$parms{height}/g;
	$html=~s/\$id/$parms{id}/g;
	return($html);
}
1;
