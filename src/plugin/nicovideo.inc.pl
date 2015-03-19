######################################################################
# @@HEADER2_NANAMI@@
######################################################################
# v0.2.1 First Release
######################################################################
# usage : #nicovideo(url, sd|hd, width=xxx)
######################################################################

@::nicovideo_baseurl=(
	"http://www.nicovideo.jp/watch/",
	"https://www.nicovideo.jp/watch/",
	"http://nico.ms/",
	"https://nico.ms/",
	"http://ext.nicovideo.jp/thumb_watch/",
	"https://ext.nicovideo.jp/thumb_watch/",
	);

@::nicoillustration_baseurl=(
	"http://seiga.nicovideo.jp/watch/im",
	"https://seiga.nicovideo.jp/watch/im",
	"http://ext.seiga.nicovideo.jp/thumb/im",
	"https://ext.seiga.nicovideo.jp/thumb/im",
	"http://nico.ms/im",
	"https://nico.ms/im",
);

@::nicomanga_baseurl=(
	"http://seiga.nicovideo.jp/watch/mg",
	"https://seiga.nicovideo.jp/watch/mg",
	"http://ext.seiga.nicovideo.jp/thumb/mg",
	"https://ext.seiga.nicovideo.jp/thumb/mg",
	"http://nico.ms/mg",
	"https://nico.ms/mg",
);

$::nicovideo_base_html=qq(<p><script type="text/javascript" src="http://ext.nicovideo.jp/thumb_watch/\$id?w=\$width&h=\$height"></script><noscript><a href="http://www.nicovideo.jp/watch/\$id">http://www.nicovideo.jp/watch/\$id</a></noscript></p>);

$::nicoillustration_base_html=qq(<iframe width="\$width" height="\$height" src="http://ext.seiga.nicovideo.jp/thumb/im\$id" scrolling="no" style="border:solid 1px #888;" frameborder="0"><a href="http://nico.ms/im\$id">http://seiga.nicovideo.jp/watch/im\$id</a></iframe>);

$::nicomanga_base_html=qq(<iframe width="\$width" height="\$height" src="http://ext.seiga.nicovideo.jp/thumb/mg\$id" scrolling="no" style="border:solid 1px #888;" frameborder="0"><a href="http://nico.ms/mg\$id">http://seiga.nicovideo.jp/watch/mg\$id</a></iframe>);

%::nicovideo_default_width;
%::nicovideo_default_height;

$::nicovideo_default_width{sd}=490;
$::nicovideo_default_height{sd}=307;
$::nicovideo_default_width{hd}=490;
$::nicovideo_default_height{hd}=307;

$::nicoseiga_default_width=312;
$::nicoseiga_default_height=176;

sub plugin_nicovideo_convert{
	return "<p>\n" . &plugin_nicovideo_inline(@_) . "</p>\n";
}

sub plugin_nicovideo_inline {
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
			foreach my $baseurl(@::nicovideo_baseurl) {
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

	$parms{width}=$::nicovideo_default_width{$parms{mode}};
	$parms{height}=$::nicovideo_default_height{$parms{mode}};

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
	$html=$::nicovideo_base_html;
	$html=~s/\$width/$parms{width}/g;
	$html=~s/\$height/$parms{height}/g;
	$html=~s/\$id/$parms{id}/g;
	return($html);
}
1;
