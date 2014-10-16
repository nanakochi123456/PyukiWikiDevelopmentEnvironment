######################################################################
# @@HEADER2_NANAMI@@
######################################################################

use Nana::Pod2Wiki;
use strict;

require "$::plugin_dir/contents.inc.pl";

sub plugin_perlpod_action {
	my $file;

	if($ENV{HTTP_USER_AGENT} ne '' || $ENV{HTTP_HOST} ne ''
	|| $ENV{REMOTE_ADDR} ne '') {

		$file=$::form{file};
		return if($file=~/\.\./ || $file=~/^\// || $file=~/[|><%'"]/);
		return('msg'=>"\t$::$file"
			,'body'=>&perlpod($file
							, $::form{notitle} ne '' ? "notitle" : ""
							, $::form{source} ne '' ? 1 : 0));
	}

	$::nowikiname = 1;
	&load_wiki_module(
		"init", "func", "db", "http", "html",
		"link", "sub", "plugin", "wiki");

	my $file=$ARGV[0];
	my ($name,$body)=Nana::Pod2Wiki::pod2wiki($file,0);

	print "*$name\n\#contents\n----\n$body";
	exit;
}

sub plugin_perlpod_convert {
	my $file;
	my($file,$notitle,$source)=split(/,/,shift);
	$source+=0;
	return if($file=~/\.\./ || $file=~/^\// || $file=~/[|><%'"]/);
	return(&perlpod($file,$notitle ne '' ? "notitle" : "",$source));
}

sub getperlpath{
	my $perlpath;
	if(open(R,"$0")) {
		$perlpath=<R>;
		close(R);
		$perlpath=~s/#!//g;
		$perlpath=~s/-//g;
		$perlpath=~s/ //g;
		$perlpath=~s/[\r\n]//g;
		return $perlpath;
	}
	return '';
}

sub perlpod {
	my($file,$notitle,$source)=@_;
	$file=~s/.*\///g;
	my $dir;
	$::interwiki_definition="";
	$::interwiki_definition2="";

	foreach my $dirs($::data_home, $::data_pub, $::explugin_dir, $::plugin_dir
			, $::res_dir, $::skin_dir, $::image_dir) {
		if(-r "$dir/$file") {
			my $html;
			return &perlpod_sub("$dir/$file",$notitle,$source);
		}
	}
	foreach my $dirs($::explugin_dir, $::plugin_dir, $::res_dir, $::skin_dir, $::data_home, $::data_pub) {
		my $ret=&perlpod_sub2($dirs,$file);
		if($ret ne '') {
			return &perlpod_sub($ret,$notitle,$source);
		}
	}
	return("File nod found:$file");
}

my $level=0;

sub perlpod_sub {
	my($file,$notitle,$source)=@_;
	my ($name,$body)=Nana::Pod2Wiki::pod2wiki($file,$notitle);
	my $html;
	my $query=&htmlspecialchars($ENV{QUERY_STRING});
	if($source+0 eq 0) {
		if($notitle eq '') {
			$html=&text_to_html("*$name\n\pod2wikidummycontents\n----\n$body");
			my $contents=&plugin_contents_main("?$query",,split(/\n/,"*$name\n\pod2wikidummycontents\n----\n$body"));
			$html=~s!pod2wikidummycontents!$contents!g;
		} else {
			$html.=&plugin_contents_main("?$query",,split(/\n/,"$body"));
			$html.=&text_to_html("----\n$body");
		}
	} else {
		if($notitle eq '') {
			$html="*$name\n\#contents\n----\n$body";
		} else {
			$html="#contents\n";
			$html.="----\n$body";
		}
		$html=<<EOM;
<form>
<textarea cols="$::cols" rows="$::rows" name="mymsg">$html</textarea>
</form>
EOM
	}
	$html=~s/\x5/\#/g;
	$html=~s/\x6/\&/g;
	$html=~s/\x4/\:/g;
	return $html;
}

sub perlpod_sub2 {
	my($dir,$file)=@_;

	opendir(DIR,$dir);
	my @files=readdir(DIR);
	closedir(DIR);

	foreach(@files) {
		next if($_ eq '.' || $_ eq '..');
		my $path="$dir/$_";
		return $path if($_ eq $file);
		if(-d $path) {
			$level++;
			return '' if($level > 10);
			my $ret=&perlpod_sub2($path,$file);
			return $ret if($ret ne '');
			$level--;
		}
	}
	return "";
}


1;
__END__

=head1 NAME

perlpod.inc.pl - PyukiWiki Plugin

=head1 SYNOPSIS

 ?cmd=perlpod&file=perl script file or pod file. [&notitle=true] [&source=true]
 #perlpod(perl script file or pod file.)

=head1 DESCRIPTION

View perl document of pod

A directory cannot be specified because of the measure against security.

Automatically Recursive search of the bottom of the directory setup by pyukiwiki.ini.cgi.

=head1 SEE ALSO

=over 4

=item PyukiWiki/Plugin/Standard/perlpod

L<@@BASEURL@@/PyukiWiki/Plugin/Standard/perlpod/>

=item PyukiWiki CVS

L<@@CVSURL@@/PyukiWiki-Devel/plugin/perlpod.inc.pl>

L<@@CVSURL@@/PyukiWiki-Devel/lib/Nana/Pod2Wiki.pm>

=back

=head1 AUTHOR

=over 4

@@AUTHOR_NANAMI@@

@@AUTHOR_PYUKI@@

=back

=head1 LICENSE

@@LICENSE_NANAMI@@

=cut
