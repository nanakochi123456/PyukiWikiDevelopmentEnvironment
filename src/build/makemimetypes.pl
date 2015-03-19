#!/usr/bin/perl

$basemime="/usr/local/etc/apache22/mime.types";
$addmime="./build/mime_add.txt";
$resource="./build/mime_res.txt";
#$langlist="en ja";

&main;

sub main {
	if($ARGV[1] eq "") {
		print <<EOM;
Usage: $0 (lang) (output file)
EOM
		exit;
	}
	$lang=$ARGV[0];
	$output=$ARGV[1];
	open(R, $basemime) || die "$basemime\n";

	foreach(<R>) {
		next if(/^#/);
		s/\s\s\s*/\t/g;
		s/[\r\n]//g;
		($mimetype,$exts)=split(/\t/, $_);
		foreach $ext(split(/ /,$exts)) {
			$mime_types{$ext}=$mimetype;
		}
	}
	close(R);

	open(R, $addmime) || die "$addmime\n";

	foreach(<R>) {
		next if(/^#/);
		s/\s\s\s*/\t/g;
		s/[\r\n]//g;
		($mimetype,$exts)=split(/\t/, $_);
		foreach $ext(split(/ /,$exts)) {
			$mime_types{$ext}=$mimetype;
		}
	}
	close(R);

	open(R, $resource) || die "$resource\n";
	foreach(<R>) {
		s/[\r\n]//g;
		($_lang,$_ext,$_name)=split(/\t/,$_);
		$mime_res{$_lang}{$_ext}=$_name;
	}
	close(R);

	open(W, ">$output")||die "$output";
	$langname=$lang eq "en" ? "English"
					 : "ja" ? "Japanese \@\@CODE\@\@"
					 : "unknown";

	print W <<EOM;
# PyukiWiki Resource file ($langname)
# \@\@PYUKIWIKIVERSION\@\@
# \$Id\$

mimetypes= \\
EOM
	foreach(sort keys %mime_types) {
		$str=$mime_res{$lang}{$_};
		$str=$mime_res{en}{$_} if($str eq "");
		$str="\t$str" if($str ne "");
		if($_ ne "") {
			print W <<EOM;
$_\t$mime_types{$_}$str \\n\\
EOM
		}
	}
	print W "\n\n";
	close(W);
}
