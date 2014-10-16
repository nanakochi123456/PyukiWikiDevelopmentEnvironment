######################################################################
# @@HEADER2_NANAMI@@
######################################################################
# This is extented plugin.
# To use this plugin, rename to 'ping.inc.cgi'
######################################################################

$ping::titleformat="__mypage__ - __wikititle__";

use Nana::HTTP;

if(!defined($ping::serverlist)) {
$ping::serverlist=<<EOM;
XMLRPC|http://blogsearch.google.com/ping/RPC2
NANA|http://api.my.yahoo.co.jp/RPC2
XMLRPC|http://rpc.reader.livedoor.com/ping
XMLRPC|http://blog.goo.ne.jp/XMLRPC
XMLRPC|http://ping.fc2.com
XMLRPC|http://ping.rss.drecom.jp/
XMLRPC|http://ping.dendou.jp/
XMLRPC|http://ping.freeblogranking.com/xmlrpc/
XMLRPC|http://rpc.pingomatic.com/
XMLRPC|http://rpc.weblogs.com/rpc2
XMLRPC|http://ping.myblog.jp
XMLRPC|http://www.blogpeople.net/servlet/weblogUpdates
EOM

$ping::serverlist.=<<EOM if($::rss_lines > 0);
NANA|http://api.my.yahoo.co.jp/rss/ping?u=__RSSURIENC__
EOM
}

$ping::wait=30*60
	if(!defined($ping::wait));

$ping::timeout=5
	if(!defined($ping::timeout));

$ping::pagesave;
%ping::sentserver;

use strict;

$ping::sendtimepage=":ping";

sub plugin_ping_init {
	&exec_explugin_sub("lang");
	&exec_explugin_sub("urlhack");
	&exec_explugin_sub("autometarobot");

	return ('init'=>1
		, 'func'=>'do_write', 'do_write'=>\&do_write
		, 'last_func'=>'&send_ping_main;');
}

sub send_ping_rpc {
	my($rpcurl,$name,$url,$rssurl)=@_;

	$rpcurl=~s/\/$//g;
	return if($ping::sentserver{$rpcurl} ne '');

	$ping::sentserver{$rpcurl}=$rpcurl;

	my $type="XMLRPC";
	if($rpcurl=~/\|/) {
		($type, $rpcurl)=split(/\|/,$rpcurl);
	}

	if(lc $type eq "xmlrpc") {
		&load_module("XMLRPC::Lite");
		return &send_ping_xmlrpc($rpcurl, $name, $url, $rssurl);
	} else {
		&load_module("Nana::HTTP");
		return &send_ping_nanahttp($rpcurl, $name, $url, $rssurl);
	}
}

sub send_ping_xmlrpc($rpcurl, $name, $url, $rssurl) {
# This code is use						# comment
# http://isnot.jp/?p=XML-RPC%A1%F8%B9%B9%BF%B7Ping%A4%CE%C1%F7%BF%AE #comment
	my($rpcurl,$name,$url,$rssurl)=@_;

	my $result;
	eval {
		local $SIG{ALRM}=sub { die "timeout" };
		alarm($ping::timeout);

		my $tmp = eval {
			XMLRPC::Lite
				->proxy($rpcurl)
				->call(
					'weblogUpdates.ping', $name, $url
					, $url, $rssurl
				)
				->result;
		};
		if ($@) {
			$result=$@;
		} else {
			$result=$tmp->{message};
		}
		$result=~s/<.*//g;
		$result=~s/\n.*//g;
		alarm 0;
	};
	alarm 0;
	if($@) {
		if($@=~/timeout/) {
			return(1,"Timeout");
		}
	}
	my $test=lc $result;
	return (0,$result) if($result eq "");
	if(	   $test=~/thank/ && $test=~/ping/
		|| $test=~/forwarded/ && $test=~/services/
		|| $test=~/\<boolean\>0\<\/boolean\>/
		|| $test=~/\<value\>0\<\/value\>/
		|| $test=~/OK/
		|| $test=~/successfully/ && $test=~/refresh/ && $test=~/requested/) {
		return (0,$result);
	}
	return (1,$result);
}

sub send_ping_nanahttp {
	my($rpcurl,$name,$url,$rssurl)=@_;

	$rpcurl =~ m!(http:)?(//)?([^:/]*)?(:([0-9]+)?)?(/.*)?!;
	my $host = ($3 ne "") ? $3 : "localhost";
	my $port = ($5 ne "") ? $5 : 80;
	my $path = ($6 ne "") ? $6 : "/";

	my $pingmsg=<<EOM;
<?xml version="1.0" encoding='UTF-8'?>
<methodCall>
<methodName>weblogUpdates.ping</methodName>
<params>
<param>
<value>$name</value>
</param>
<param>
<value>$url</value>
</param>
</params>
</methodCall>
EOM

	my $pingbody=&code_convert(\$pingmsg, 'utf8', $::defaultcode);

	my $length = length($pingbody);
	my $header=<<EOM;

Content-Type: text/xml; charset=utf-8
Content-Length: $length
Referer: $url
EOM
	my $http=new Nana::HTTP('module'=>"ping");#, 'header'=>$header);
	my ($result, $stream) = $http->post($rpcurl, , $pingbody);
	my $test=lc $stream;
	if(	   $test=~/thank/ && $test=~/ping/
		|| $test=~/forwarded/ && $test=~/services/
		|| $test=~/\<boolean\>0\<\/boolean\>/
		|| $test=~/\<value\>0\<\/value\>/
		|| $test=~/OK/
		|| $test=~/successfully/ && $test=~/refresh/ && $test=~/requested/) {
		return (0,$stream);
	}
	return (1,$stream);
}

sub send_ping_main {
	my($page)=$ping::pagesave;
	return if($page eq '');
	close(STDOUT);
	close(STDERR);

	my $results;

	# マルチタスクをする
	my $pid=fork;
	if($pid) {
	} else {
		foreach my $server(split(/\n/,$ping::serverlist)) {
			my %val;
			next if($server!~/$::isurl/);
			$val{RSSURI}="$::basehref?cmd=rss@{[$::_exec_plugined{lang} > 1 ? '&amp;lang=$::lang' : '']}";
			$val{RSSURIENC}=&encode($val{RSSURI});
			$server=&ping_replace($server,%val);
			$val{mypage}=$page;
			$val{wikititle}=$::wiki_title;
			my $title=&ping_replace($ping::titleformat,%val);
			$val{TITLE}=&code_convert(\$title,'utf8',$::defaultcode);
			$val{TITLE}=$title;
			$val{URL}=$::basehref;

			my($stat,$result)=&send_ping_rpc($server, $val{TITLE}, $val{URL}, $val{RSSURI});

			if($stat eq 0) {
				$results.="Sent $server\n";
			} else {
				$results.="Error $server\n($result)\n";
			}
		}
		&load_module("Nana::Mail");
		my $mailtitle;
		$mailtitle=&code_convert(\$ping::pagesave,'jis',$::defaultcode);
		if(-f $::ini_file) {
			require $::ini_file;
		} elsif(-f "pyukiwiki.ini.cgi") {
			require "pyukiwiki.ini.cgi";
		}
		Nana::Mail::toadmin($::mail_head{ping}, $mailtitle, "Ping sent results\n$results");
	}
}

sub send_ping {
	my($page)=@_;
	return if(!&is_exist_page($page));
	my $lastmod=$::database{$ping::sendtimepage};
	if($lastmod=~/(\d+)/) {
		$lastmod=$1+0;
	} else {
		$lastmod=0;
	}

	if(time < $lastmod + $ping::wait) {
		my $msg=<<EOM;
Ping waiting @{[&date($::lastmod_format, $lastmod + $ping::wait)]}
EOM
		Nana::Mail::toadmin($::mail_head{ping}, $page, $msg);
		return;
	}

	my $time=time;
	my $newlastmod=<<EOM;
#freeze
// Do not edit. using ping sending check
$time
EOM
	$::database{$ping::sendtimepage}=$newlastmod;

	if(&load_module("XMLRPC::Lite")) {
		$ping::pagesave=$page;
	} else {
		&load_module("Nana::Mail");
		Nana::Mail::toadmin($::mail_head{ping}, $page, "Can't send ping. please install XMLRPC::Lite (in SOAP::Lite)");
	}	
}

sub ping_replace {
	my ($str,%ref)=@_;
	foreach my $key(keys %ref) {
		$str=~s/\_\_$key\_\_/$ref{$key}/g;
	}
	return $str;
}

sub do_write_after {
	my($page, $mode)=@_;
	if($page ne '' && $mode ne "Delete") {
		if($::form{mypage}=~/$::resource{help}|$::resource{rulepage}|$::RecentChanges|$::MenuBar|$::SideBar|$::TitleHeader|$::Header|$::Footer$::BodyHeader$::BodyFooter|$::SkinFooter|$::SandBox|$::InterWikiName|$::InterWikiSandBox|$::non_list/
			|| $::meta_keyword eq "" || lc $::meta_keyword eq "disable"
			|| &is_readable($::form{mypage}) eq 0) {
			return;
		}
		&send_ping($page);
	}
}
1;
__DATA__
sub plugin_ping_setup {
	return(
		en=>'Send ping.',
		jp=>'pingを送信する,
		override=>'do_write',
		url=>'@@BASEURL@@/PyukiWiki/Plugin/ExPlugin/ping/',
		require=>"XMLRPC::Lite",
	);
__END__

=head1 NAME

ping.inc.pl - PyukiWiki Plugin

=head1 SYNOPSIS

Sent weblog ping.

=head1 DESCRIPTION

Sent weblog ping.

=head1 USAGE

rename to ping.inc.cgi

Setting ping server list on $ping::serverlist

If you need the URL of the RSS is, please include in the parameter or "__RSSURIENC__".

=head1 OVERRIDE

do_write_after was overrided.

=head1 SEE ALSO

=over 4

=item PyukiWiki/Plugin/ExPlugin/ping

L<@@BASEURL@@/PyukiWiki/Plugin/ExPlugin/ping/>

=item PyukiWiki CVS

L<@@CVSURL@@/PyukiWiki-Devel/lib/ping.inc.pl>

=head1 AUTHOR

=over 4

@@AUTHOR_NANAMI@@

@@AUTHOR_PYUKI@@

=back

=head1 LICENSE

@@LICENSE_NANAMI@@

=cut
