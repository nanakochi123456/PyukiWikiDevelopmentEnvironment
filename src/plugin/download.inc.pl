######################################################################
# @@HEADER2_NANAMI@@
######################################################################
# v0.2.1 First Release
######################################################################

use strict;
use Nana::MD5;
use Nana::Cache;
use Nana::Counter;

&getbasehref;

# format
# http://baseurl|download link name
$download::baseurl=$::basehref
	if(!defined($download::baseurl));
#$download::baseurl=<<EOM;
#http://cdn.daiba.cx|CDN ダイレクト
#http://jp-east.cdn.daiba.cx|GMO東京
#http://jp-west.cdn.daiba.cx|さくらインターネット大阪
#http://pcdn.info|CloudFlare
#EOM

$download::counter=1
	if($download::counter +0 eq 0);

$download::cache_expire=3600
	if($download::cache_expire +0 eq 0);

$download::file_icon =<<EOM if(!defined($download::file_icon));
<a href="\$LINK" class="icntool" id="icn_attach"><span>  </span></a>
EOM

$download::main_html=<<EOM if(!defined($download::main_html));
$download::file_icon <a class="download_url" href="\$LINK">\$FILENAME</a>
EOM

$download::info_html=<<EOM if(!defined($download::info_html));
<span class="download_info">\$DATETIME \$SIZE</span><br />
EOM

$download::mirror_html=<<EOM if(!defined($download::mirror_html));
[<a class"download_url" href="\$LINK">\$MIRRORNAME</a>]&nbsp;
EOM

$download::counter_html=<<EOM if(!defined($download::counter_html));
<br />
<span class="download_counter">
TOTAL:\$TOTAL TODAY:\$TODAY YESTERDAY:\$YESTERDAY
</span>
EOM

$download::downloadpage_html=<<EOM if(!defined($download::downloadpage_html));
<h2>\$download_title</h2><br /><br />
\$download_count<br /><br />
\$download_info<br /><br />
\$download_hash<br /><br />
\$download_msg<hr />
[\$download_back]
EOM

$download::strmaster=$::resource{download_plugin_master};
$download::strmirror=$::resource{download_plugin_mirror};

$download::hashlist="md5|32,sha1|40,sha256|64";
#$download::hashlist="md5|32,sha1|40,sha256|64,sha384|96,sha512|128";

sub plugin_dl_inline {
	return &plugin_download_convert(@_);
}

sub plugin_dl_convert {
	return &plugin_download_convert(@_);
}

sub plugin_download_inline {
	return &plugin_download_convert(@_);
}

sub plugin_download_action {
	my $url_id=$::form{fileid};
	$url_id=~s/[\.\/]//g;
	my $mirror=$::form{mirrorno};
	$mirror=~s/[\.\/]//g;
	$mirror += 0;

	my $mypage=$::form{mypage};

	my $cache=new Nana::Cache (
		ext=>"download",
		files=>1000,
		dir=>$::cache_dir,
		size=>100000,
		use=>1,
		expire=>$download::cache_expire,
		crlf=>1,
	);
	my $buf=$cache->read($url_id,1);

	if($buf ne "") {
		my @urls=split(/\n/, $buf);
		my $info=shift @urls;
		my %info;
		foreach(split(/\t/,$info)) {
			my($l, $r)=split(/=/, $_);
			$info{$l}=$r;
		}

		my $hash = &plugin_download_hash($info{name});
		if($urls[$mirror] ne "") {
			if($::form{redir} ne "") {
				$urls[$mirror]=~s/\t.*//g;
				&location($urls[$mirror]);
				my $cobj=new Nana::Counter(dir=>$::counter_dir, version=>$::CounterVersion);
				my %hash=$cobj->add("download-$hash");
				exit;
			} else {
				&jscss_include("location");
				my $url="$::script?cmd=download&amp;fileid=$hash&amp;mirrorno=$mirror&amp;mypage=@{[&encode($::form{mypage})]}&amp;redir=1";
				$::IN_JSHEAD.=<<EOM;
 jsdownload("sec", "$url", "3", "$info{name}");
EOM

				my $allhash;
				$allhash="<table>";
				foreach(split(/,/,$download::hashlist)) {
					my($l,$r)=split(/\|/,$_);
					if($info{$l} ne "") {
						$allhash.=&replace(
							$::resource{download_plugin_download_hash},
							name=>uc $l,
							value=>$info{$l},
						),
					}
				}
				$allhash.="</table>\n";

				my $tmp=&replace(
					$download::downloadpage_html,
						download_title=>&replace(
							$::resource{download_plugin_download_title},
							filename=>$info{name},
							url=>$url
						),

						download_msg=>&replace(
							$::resource{download_plugin_download_msg},
							filename=>$info{name},
							url=>$url
						),

						download_hash=>$allhash,

						download_count=>&replace(
							$::resource{download_plugin_download_count},
							filename=>$info{name},
							url=>$url,
							time=>3,
						),

						download_info=>&replace(
							$::resource{download_plugin_download_info},
							filename=>$info{name},
							url=>$url,
							timestamp=>&date($::download_format, $info{time}),
							size=>&plugin_download_bytes($info{size})
						),

						download_back=>&replace(
							$::resource{download_plugin_download_back},
							url=>"$::script?@{[&encode($::form{mypage})]}",
							pagename=>$::form{mypage}
						),

				);
				return (
					msg=>&replace(
						$::resource{download_plugin_download_titletag},
						filename=>$info{name},
						),
					body=>$tmp);
			}
		}
	}
}

sub plugin_download_convert {
	my @urls=split(/,/,shift);
	my $body;
	my $mirrors=0;
	my %info;
	my $basename=$urls[0];
	$basename=~s/.*\///g;

	foreach(@urls) {
		my($download_url, $download_name)=split(/\|/, $_);

		$download_name=$download_name eq "" ?
			sprintf($mirrors>0 ? $download::strmirror : $download::strmaster, $mirrors) : $download_name;

		if($download_url=~/^(.+?):\/\/(.+?):?(\d+)?(\/.*)?$/) {
			my $proto=$1;
			my $host=$2;
			my $port=$3;
			my $path=$4;
			my $parm=$path if($path=~/\?/);
			my $ext=$4;
			$ext=~s/.*\.//g;
			$path=~s/\?.*//g;
			$parm=~s/.*\?//g;
			my @paths=split(/\//, $path);

			my $url="$proto://$host@{[$port ne '' ? qq(:$port) : qq()]}/$path?$parm&amp;ext=.$ext";
				if(&dlchk($basename, $url)) {
				$body.=&dllink($basename, $url, $download_name, $mirrors, %info);
				$mirrors++;
			}
			foreach my $baseurltemp (split(/\n/, $download::baseurl)) {
				my ($baseurl, $baseurlname)=split(/\|/, $baseurltemp);
				for (my $i=0; $i <= $#paths; $i++) {
					my $tempurl;
					for (my  $j=$i; $j <= $#paths; $j++) {
						$tempurl .= "/" . $paths[$j];
					}

					if(&dlchk($basename, "$baseurl/$tempurl?$parm&amp;ext=.$ext", $baseurlname)) {
#$body.="<hr>path=$path<hr>Check ok $baseurl/$tempurl?$parm&amp;ext=.$ext<hr>";
						$body.=&dllink($basename, $url,  $baseurlname eq "" ? $download_name : $baseurlname, $mirrors, %info);
						$mirrors++;
						last;
					}
				}
			}
		}
	}
	$body.=&dlcounter($basename, , , $mirrors, %info);
	# flush
	&dlchk($basename, "EOM");
	$body;
}

$download::dlchkwrite=0;

sub dlchk {
	my ($basename, $url, $baseurlname)=@_;

	my $cachefile = &plugin_download_hash($basename);
	my $cache=new Nana::Cache (
		ext=>"download",
		files=>1000,
		dir=>$::cache_dir,
		size=>100000,
		use=>1,
		expire=>$download::cache_expire,
		crlf=>1,
	);
	my $buf=$cache->read($cachefile,1);
	if($buf=~/EOM/) {
		my @urls=split(/\n/, $buf);
		my $info=shift @urls;
		foreach(@urls) {
			return "true" if($url eq $_);
		}
		return "false";
	}
	if($url eq "EOM") {
		$buf.="EOM\n";
		$cache->write($cachefile,$buf);
		return "true";
	}
	if($buf ne "" || $download::dlchkwrite{$basename}) {
		$download::dlchkwrite{$basename}++;
		my @urls=split(/\n/, $buf);
		my $info=shift @urls;
		my($name, $time, $length, $type)=split(/\t/, $info);
		my $chk=0;
		foreach(@urls) {
			$chk++ if($_ eq $url);
		}
		if($chk eq $#urls+1) {
			return "true";
		}
		&load_module("Nana::HTTP");
		my $http=new Nana::HTTP('plugin'=>"download");
		my ($result, $stream) = $http->head($url);
		if($result eq 0) {
			my %info=&plugin_download_parseheader($stream);
			if($name eq $basename && $info{"Content-Length"} eq $length) {
				$url=~s/\:\/\//\f/g;
				while($url=~/\/\//) {
					$url=~s/\/\//\//g;
				}
				$url=~s/\f/\:\/\//g;
				$buf.=<<EOM;
$url\t$baseurlname
EOM
				$cache->write($cachefile,$buf);
				return "true";
			}
		}
	} else {
		&load_module("Nana::HTTP");
		&load_module("HTTP::Date");
		my $http=new Nana::HTTP('plugin'=>"download");
		my ($result, $stream) = $http->head($url);
		if($result eq 0) {
			my %info=&plugin_download_parseheader($stream);
			$buf=qq(name=$basename\ttime=$info{"Last-Modified"}\tsize=$info{"Content-Length"}\ttype=$info{"Content-Type"});

			$cache->write($cachefile,$buf);
			foreach my $hh(split(/,/,$download::hashlist)) {
				my($hashname, $hashlength)=split(/\|/, $hh);
				my $http2=new Nana::HTTP('plugin'=>"download");
				my $newurl=$url;
				$newurl=~s/\?\&amp\;ext.*/\.$hashname/g;

				my ($result, $stream) = $http2->get($newurl);
				if($result eq 0) {
					foreach($stream=~/([0-9A-Fa-f]{16,128})/) {
						if(length($1) eq $hashlength) {
							$buf.=qq(\t$hashname=$1);
						}
					}
				}
			}
			$buf.=<<EOM;

$url
EOM

			$cache->write($cachefile,$buf);
			return "true";
		}
	}
	return "false";
}

sub dllink {
	my ($basename, $url, $downloadname, $mirror, %info)=@_;
	my $hash = &plugin_download_hash($basename);

	if($downloadname ne "") {
		my $body=&replace($download::mirror_html
			, LINK=>"$::script?cmd=download&amp;fileid=$hash&amp;mirrorno=$mirror&amp;mypage=@{[&encode($::form{mypage})]}",
			, MIRRORNAME=>$downloadname
		);
		return $body;
	}
	my $body=&replace($download::main_html
		, LINK=>"$::script?cmd=download&amp;fileid=$hash&amp;mirrorno=$mirror&amp;mypage=@{[&encode($::form{mypage})]}",
		, FILENAME=>$basename
	);

	my $cachefile = &plugin_download_hash($basename);
	my $cache=new Nana::Cache (
		ext=>"download",
		files=>1000,
		dir=>$::cache_dir,
		size=>100000,
		use=>1,
		expire=>$download::cache_expire,
	);
	my $buf=$cache->read($cachefile,1);
	if($buf ne "") {
		my @urls=split(/\n/, $buf);
		my $info=shift @urls;
		my %info;
		foreach(split(/\t/, $info)) {
			my($l, $r)=split(/=/, $_);
			$info{$l}=$r;
		}
		$body.=&replace($download::info_html
			, DATETIME=>&date($::download_format, $info{time})
			, SIZE=>&plugin_download_bytes($info{size})
		);
	}
	$body;
}

sub dlcounter {
	my ($basename, $url, $downloadname, $mirror, %info)=@_;
	my $body;
	my $hash = &plugin_download_hash($basename);
	my $cobj=new Nana::Counter(dir=>$::counter_dir, version=>$::CounterVersion);	my %hash=$cobj->read("download-$hash");
	$body.=&replace($download::counter_html
		, TOTAL=>$hash{total}
		, TODAY=>$hash{today}
		, YESTERDAY=>$hash{yesterday}
	);
	$body;
}

sub plugin_download_hash {
	my $str=shift;
	if($download::temphash{$str} eq "") {
		$download::temphash{$str}=Nana::MD5::md5_hex($str);
	}
	$download::temphash{$str};
}

sub plugin_download_parseheader {
	my($stream)=shift;
	my %info;

	foreach(split(/\n/, $stream)) {
		s/\r//g;
		my ($name, $value)=split(/:\s?/, $_);
		if($name eq "Last-Modified") {
			$info{"Last-Modified"}=HTTP::Date::str2time($value);
		}
		if($name eq "Content-Length") {
			$info{"Content-Length"}=$value;
		}
		if($name eq "Content-Type") {
			$info{"Content-Type"}=$value;
		}
	}
	%info;
}

sub plugin_download_bytes {
	my ($size)=@_;
	my $kb = $size . " bytes";
	if($size>1024) {
		$kb = sprintf("%.1f KB", $size / 1024);
	}
	if($size>1024 * 1024) {
		$kb = sprintf("%.1f MB", $size / 1024 / 1024);
	}
	if($size>1024 * 1024 * 1024) {
		$kb = sprintf("%.1f GB", $size / 1024 / 1024 / 1024);
	}
	if($size>1024 * 1024 * 1024 * 1024) {
		$kb = sprintf("%.1f TB", $size / 1024 / 1024 / 1024 / 1024);
	}
	return $kb;
}

1;
