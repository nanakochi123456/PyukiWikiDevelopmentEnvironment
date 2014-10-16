######################################################################
# @@HEADER2_NANAMI@@
######################################################################

use strict;
use Nana::Cache;
use Nana::OPML;

$opml::pages_title="News"
	if(!defined($opml::pages_title));
$opml::related_title="Related site"
	if(!defined($opml::related_title));

sub plugin_opml_action {
	if($::_exec_plugined{lang} > 1) {
		$::modifier_rss_title=$::modifier_rss_title{$::lang} if($::modifier_rss_title{$::lang} ne '');
		$::modifier_rss_link=$::modifier_rss_link{$::lang} ne '' ? $::modifier_rss_link{$::lang}: $::modifier_rss_link ne '' ? $::modifier_rss_link : $::basehref;
		$::modifier_rss_description=$::modifier_rss_description{$::lang} if($::modifier_rss_description{$::lang} ne '');
	} else {
		$::modifier_rss_link=$::modifier_rss_link ne '' ? $::modifier_rss_link : $::basehref;
	}


	my $cache=new Nana::Cache (
		ext=>"showrss",
		files=>1000,
		dir=>$::cache_dir,
		size=>200000,
		use=>1,
		expire=>365*86400,
	);

	my $opml = new Nana::OPML(
		version => '1.0',
		encoding => $::charset,
	);
	$opml->channel(
		title => $::modifier_rss_title
				. ($::_exec_plugined{lang} > 1 ? "(" . (split(/,/,$::langlist{$::lang}))[0] . ")" : ""),
 		link  => $::modifier_rss_link,
		description => $::modifier_rss_description,
	);

	$opml->add_item(
		title => $::modifier_rss_title
				. ($::_exec_plugined{lang} > 1 ? "($::langlist{$::lang})" : ""),
		link  => $::modifier_rss_link,
		xmlurl => "$::basehref?cmd=rss&amp;ver=2.0"
				. ($::_exec_plugined{lang} > 1 ? "&amp;lang=$::lang" : ""),
		type => "rss",
	);

	opendir(DIR,$::cache_dir) || die "$::cache_dir not found";
	my $flg=0;
	while(my $dir=readdir(DIR)) {
		if($dir=~/\.showrss$/  && $dir!~/^687474703A2F2F/) {
			$dir=~s/\.showrss//g;
			my $file=$dir;
			my $rssurl=$dir;
			$rssurl=~s/([A-Fa-f0-9][A-Fa-f0-9])/pack("C", hex($1))/eg;
			$rssurl=$::modifier_rss_link . "?cmd=rsspage&amp;lang=$::lang&amp;mypage=" . &encode($rssurl);
			my $buf=$cache->read($file,1);
			my %xml = &xmlParser($buf);
			my $title=$xml{'rdf:RDF/channel/title'};
			$title=$xml{'rss/channel/title'} if($title eq '');
			my $link=$xml{'rdf:RDF/channel/link'};
			$link=$xml{'rss/channel/link'} if($link eq '');
			$link=$xml{'rss/channel/link'} if($link eq '');
			$link=$::modifier_rss_link . "?" . &encode($rssurl) if($link eq '');
			if($flg eq 0) {
				$opml->add_item(
					title => $opml::pages_title,
				);
				$flg=1;
			}
			next if($title eq '');
			$opml->add_item(
				title => $title,
				link  => $link,
				xmlurl => $rssurl,
				type => "rss",
				language => $::lang
			);
		}
	}
	close(DIR);
	opendir(DIR,$::cache_dir) || die "$::cache_dir not found";
	my $flg=0;
	while(my $dir=readdir(DIR)) {
		if($dir=~/\.showrss$/ && $dir=~/^687474703A2F2F/) {
			$dir=~s/\.showrss//g;
			my $file=$dir;
			my $rssurl=$dir;
			$rssurl=~s/([A-Fa-f0-9][A-Fa-f0-9])/pack("C", hex($1))/eg;
			my $buf=$cache->read($file,1);
			my %xml = &xmlParser($buf);
			my $title=$xml{'rdf:RDF/channel/title'};
			$title=$xml{'rss/channel/title'} if($title eq '');
			my $link=$xml{'rdf:RDF/channel/link'};
			$link=$xml{'rss/channel/link'} if($link eq '');
			$link=$::modifier_rss_link . "?" . &encode($rssurl) if($link eq '');
			if($flg eq 0) {
				$opml->add_item(
					title => $opml::related_title,
				);
				$flg=1;
			}
			next if($title eq '');
			$opml->add_item(
				title => $title,
				link  => $link,
				xmlurl => $rssurl,
				type => "rss",
				language => $::lang
			);
		}
	}
	close(DIR);

	my $body=$opml->as_string;
	if($::lang eq 'ja' && $::defaultcode ne $::kanjicode) {
		$body=&code_convert(\$body,   $::kanjicode);
	}
	print &http_header(
		"Content-type: text/xml; charset=$::charset", $::HTTP_HEADER);
	&compress_output($body . &exec_explugin_last);
	&close_db;
	exit;
}

sub xmlParser {
	my ($stream) = @_;
	my ($i, $ch, $name, @node, $val, $key, %xml);
	my $flg = 0;
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
__END__
=head1 NAME

opml.inc.pl - PyukiWiki Plugin

=head1 SYNOPSIS

 ?cmd=opml[&lang=lang]

=head1 DESCRIPTION

Output OPML

=head1 SEE ALSO

=over 4

=item PyukiWiki/Plugin/Standard/opml

L<@@BASEURL@@/PyukiWiki/Plugin/Standard/opml/>

=item PyukiWiki CVS

L<@@CVSURL@@/PyukiWiki-Devel/plugin/opml.inc.pl>

=back

=head1 AUTHOR

=over 4

@@AUTHOR_NANAMI@@

@@AUTHOR_PYUKI@@

=back

=head1 LICENSE

@@LICENSE_NANAMI@@

=cut
