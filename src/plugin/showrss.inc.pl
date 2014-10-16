######################################################################
# @@HEADER2_NEKYO@@
######################################################################

use strict;
use Nana::Cache;
use Nana::HTTP;

sub plugin_showrss_inline
{
	return &plugin_showrss_convert(shift);
}

sub plugin_showrss_convert {
	my ($rssuri,$tmplname,$usecache,$dateflag,$discflag,$domain) = split(/,/, shift);
	return if($rssuri eq '');

	my $expire = $usecache * 3600;
	my $cachefile = &dbmname($rssuri);
	my $stream="";
	my $result;
	my $body = "";

	my $cache=new Nana::Cache (
		ext=>"showrss",
		files=>100,
		dir=>$::cache_dir,
		size=>100000,
		use=>($usecache eq '0' ? 0 : 1),
		expire=>($expire+0 <= 0 ? 3600 : $expire),
	);

	my $buf=$cache->read($cachefile,1);
	# rss10page�Ő������ꂽ�y�[�W�̏ꍇ					# comment
	if($rssuri!~/$::isurl/) {
		return &makebody($buf,$tmplname,$dateflag,$discflag,$domain);
	}
	if($cache->read($cachefile) ne '') {
		return &makebody($buf,$tmplname,$dateflag,$discflag,$domain);
	}
	my $pid;
	if($buf ne '') {
		$cache->write($cachefile,$buf);	# �ꎞ�I�ɃL���b�V�����ĕێ�	# comment
		$pid=fork;
	}
	$result=0;

	unless(defined $pid) {
		# �V���O���^�X�N�����܂��̓L���b�V�������݂��Ȃ��Ƃ�	# comment
		($result,$stream)=&plugin_showrss_sub($rssuri);
		$cache->write($cachefile,$stream) if($result eq 0);
		if($result ne 0) {
			return qq(#showrss: $stream : $rssuri);
		}
		return &makebody($stream,$tmplname,$dateflag,$discflag,$domain);
	} else {
		if($pid) {
			# �}���`�^�X�N�̐e									# comment
			local $SIG{ALRM} = sub { die "time out" };
			eval {
				alerm(1);
				wait;
				alerm(0);
			};
			if ($@ =~ /time out/) {
				return &makebody($buf,$tmplname,$dateflag,$discflag,$domain);
			} else {
				return &makebody($cache->read($cachefile,1),$tmplname,$dateflag,$discflag,$domain);
			}
		} else {
			# �}���`�^�X�N�̎q									# comment
			close(STDOUT);
			($result,$stream)=&plugin_showrss_sub($rssuri);
			$cache->write($cachefile,$stream) if($result eq 0);
			exit;
		}
	}
}

sub makebody {
	my($stream,$tmplname,$dateflag,$discflag,$domain)=@_;
	my $body;
	my %xml = &xmlParser($stream);
	my @title = split(/\n/,
		($xml{'rdf:RDF/item/title'} ne ""
		? $xml{'rdf:RDF/item/title'} : $xml{'rss/channel/item/title'}
		)
	);
	my @date = split(/\n/,
		($xml{'rdf:RDF/item/dc:date'} ne ""
		? $xml{'rdf:RDF/item/dc:date'} : $xml{'rss/channel/dc:date'}
		)
	);
	my @link = split(/\n/,
		($xml{'rdf:RDF/item/link'} ne ""
		? $xml{'rdf:RDF/item/link'} : $xml{'rss/channel/item/link'}
		)
	);

	my @desc;
	if($discflag eq 1) {
		@desc = split(/\n/,
			($xml{'rdf:RDF/item/description'} ne ""
			? $xml{'rdf:RDF/item/description'}
			: $xml{'rss/channel/item/description'}
			)
		);
	}


	my ($footer, $ll, $lr);

	if (lc $tmplname eq "menubar") {
		$body .=<<"EOD";
<div class="small">
<ul class="recent_list">
EOD
		$ll = "<li>";
		$lr = "</li>\n";
		$footer = "</ul>\n</div>\n";
	} elsif (lc $tmplname eq "recent") {
		$body .=<<"EOD";
<div class="small">
<string>$date[0]</strong>
<ul class="recent_list">
EOD
		$ll = "<li>";
		$lr = "</li>\n";
		$footer = "</ul>\n</div>\n";
	} elsif (lc $tmplname eq "body") {
		$body .=<<"EOD";
<div>
<ul class="recent_list">
EOD
		$ll = "<li>";
		$lr = "</li>\n";
		$footer = "</ul>\n</div>\n";
	} else {
		$ll = $footer = "";
		$lr = "<br />\n";
	}

	my $count = 0;
	my $dt;
	foreach (@title) {
		if($dateflag >= 2) {
			my $tm=$date[$count];
			if($tm ne '') {
				$tm=~/^(\d{4})\-(\d{1,2})\-(\d{1,2})T(\d{1,2})\:(\d{1,2})\:(\d{1,2})(?:\+)(\d{1,2})\:(\d{1,2})/;
				$tm=eval {Time::Local::timegm($6,$5,$4,$3,$2-1,$1-1900)-$7*3600-$8*60; };
				$dt=&date($::date_format . ($dateflag eq 3 ? " $::time_format" : ""),$tm) . " ";
				$dt=&date($::date_format . ($dateflag eq 3 ? " $::time_format" : ""),$tm) . " ";
			} else {
				$dt='';
			}
		}
		# �����h���C���Ή��A�X�ɑΉ� v0.1.9							# comment
		if($discflag) {
			$domain=$ENV{HTTP_HOST} if($domain eq '');
			if($link[$count]=~/https?\:\/\/$domain\//) {
				$body .=<<"EOD";
$ll@{[&make_link_url("ext",$link[$count],$dt . $title[$count],"","_self")]}<br />$desc[$count]$lr
EOD
			} else {
				$body .=<<"EOD";
$ll@{[&make_link_url("ext",$link[$count],$dt . $title[$count],"","_blank")]}<br />$desc[$count]$lr
EOD
			}
		} else {
			if($link[$count]=~/https?\:\/\/$domain\//) {
				$body .=<<"EOD";
$ll@{[&make_link_url("ext",$link[$count],$dt . $title[$count],"","_self")]}$lr
EOD
			} else {
				$body .=<<"EOD";
$ll@{[&make_link_url("ext",$link[$count],$dt . $title[$count],"","_blank")]}$lr
EOD
			}
		}
		$count++;
	}
	$body .= $footer;
	return $body;
}

sub plugin_showrss_sub {
	my($rssuri)=@_;
	my $code = 'utf8';
	my ($result, $stream);
	my $http=new Nana::HTTP('plugin'=>"showrss");
	($result, $stream) = $http->get($rssuri);
	$stream=~s/[\xd\xa]//g;

	return($result, $stream) if ($result != 0); # $stream is errorcode.

	if($stream=~/encoding="[Ee][Uu][Cc]/) {
		$code="euc";
	} elsif($stream=~/encoding="[Ss][Hh][Ii][Ff][Tt]/) {
		$code="sjis";
	} else {
		$code="utf8";
	}
	$stream = &replace(&code_convert(\$stream,$::defaultcode, $code));
	return ($result,$stream);
}

sub replace {
	my ($xmlStream) = @_;
	$xmlStream =~ s/<\?(.*)\?>//g;
	$xmlStream =~ s/<rdf:RDF(.*?)>/<rdf:RDF>/g;
	$xmlStream =~ s/<rss(.*?)>/<rss>/g;
	$xmlStream =~ s/<channel(.*?)>/<channel>/g;
	$xmlStream =~ s/<item(.*?)>/<item>/g;
	$xmlStream =~ s/<content:encoded>(.*?)<\/content:encoded>//g;
	$xmlStream =~ s/\ *\/>/\/>/g;
	$xmlStream =~ s/<([^<>\ ]*)\ ([^<>]*)\/>/<$1>$2<\/$1>/g;
	$xmlStream =~ s/<([^<>\/]*)\/>/<$1><\/$1>/g;
	$xmlStream =~ s/<!\[CDATA\[(.+)\]\]>/$1/g;
	return $xmlStream;
}

sub xmlParser {
	my ($stream) = @_;
	$stream=~s/\<\!\[CDATA\[//g;
	$stream=~s/\]\]\>//g;
	$stream=~s/<[Bb][Rr]><\/[Bb][Rr]>/\r/g;

	my ($i, $ch, $name, @node, $val, $key, %xml);
	my $flg = 0;	# 1:key / 0:value
	$stream=~s/<br><\/br>/\r/g;
	foreach $i (0..length $stream) {
		$ch = substr($stream, $i, 1);
		if ($ch eq '<') {
			$flg = 1;
			undef $name;
			foreach (@node) {
				$name .= "$_/";
			}
			chop $name;
			$val =~ s/<//g;
			$val =~ s/>//g;
			$val =~ s/\r/<br \/>/g;
			$xml{$name} .= "$val\n";
			undef $val;
		}
		if ($flg) {
			$key .= $ch;
		} else {
			$val .= $ch;
		}
		if ($ch eq '>') {
			$flg = 0;
			if ($key =~ /\//) {
				pop @node;
			} else {
				$key =~ s/<//g;
				$key =~ s/>//g;
				push @node, $key;
			}
			undef $key;
		}
	}
	return %xml;
}

1;
=head1 NAME

showrss.inc.pl - PyukiWiki Plugin

=head1 SYNOPSIS

 #showrss(URL of rdf, [recent|body|menubar], time, dateflag, discflag)

=head1 DESCRIPTION

Reading rdf and display.

Time specifies the effective time of cash per 1 hour. Specification of 0 does not use cash.

It is necessary to create a directory 'cache'. Use of Jcode.pm or Unicode::Japanese becomes indispensable.

=head1 USING

=over 4

=item [recent|body|menubar]

View format selection of 'recent', 'body' or 'menubar'

=item time

Update cycle of hour

=item dateflag

Setting 2 of display date, and Setting 3 of display date time

=item discflag

Setting 1 of display description, 0 and none is no display

=back

=head1 SEE ALSO

=over 4

=item PyukiWiki/Plugin/Standard/showrss

L<@@BASEURL@@/PyukiWiki/Plugin/Standard/showrss/>

=item PyukiWiki CVS

L<@@CVSURL@@/PyukiWiki-Devel/plugin/showrss.inc.pl>

=back

=head1 AUTHOR

=over 4

@@AUTHOR_NEKYO@@

@@AUTHOR_PYUKI@@

=back

=head1 LICENSE

@@LICENSE_NEKYO@@

=cut
