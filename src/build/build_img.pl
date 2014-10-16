#!/usr/bin/perl
# release file perl script for pyukiwiki
# $Id$

use POSIX;

$cmd=$ARGV[0];
$arg=$ARGV[1];

if($cmd eq "login") {
	@list=(
		"apps-128.png,google.png",
		"f_logo.png,facebook.png",
		"hatena.png,hatena.png",
		"m_balloon_icon.png,mixi.png",
		"twitter-bird-blue-on-white.png,twitter.png",
		"Ymark.gif,yahooj.png",
		"openid_bi2.png,openid.png",
	);

	@size=(32,16);

	foreach $s(@size) {
		mkdir("./image/src/login$s");
		$w=$s;
		foreach $lst (@list) {
			($l,$r)=split(/,/,$lst);
			$r=~s/\.png/$s\.png/g;
			$ww=&shell("identify -format '%w' ./image/src/_login/$l");
			$p=$w/$ww*100;
			$r=&shell("convert -geometry $p% ./image/src/_login/$l ./image/src/login$s/$r");
		}
	}
}

if($cmd eq "make") {
	@img=("exedit","face","lang","navi", "login16","login32", "icon");
	$imgsrc="./image/src";
	$imgdst="./image";
	open(W, ">$arg")||die "$arg write\n";
	print W <<EOM;
ALLFILES=\\
EOM
	foreach(@img) {
		opendir(DIR, "$imgsrc/$_")||die;
		while($file=readdir(DIR)) {
			next if($file!~/\.(gif|jp?g|png)$/);
			print W <<EOM;
	$imgsrc/$_/$file \\
EOM
		}
	}

	print W "\n\n";
	foreach(@img) {
		print W <<EOM;
$imgdst/$_.png: ${ALLFILES}
	\${PERL} \${BUILDDIR}/build_img.pl all

EOM
	}

	$all="all:";
	foreach(@img) {
		$all.=" $imgdst/$_.png";
	}
	print W "$all\n";
	close(W);
}

if($cmd eq "all") {
	@img=("exedit","face","lang","navi", "org", "login16","login32", "icon");
	$imgsrc="./image/src";
	$imgdst="./image";
	$optipng="optipng -o7";

	foreach $img(@img) {
		open(W,">./skin/img-$img.css.org")||die;

		print W <<EOM;
/\* \@\@PYUKIWIKIVERSION\@\@ \*/
/\* \$Id\$ \*/
/\* Code=\@\@CODE\@\@ \*/

EOM
		opendir(DIR, "$imgsrc/$img")||die;
		unlink("$imgdst/$img.png");
		$w=0;
		$h=0;
		$hmax=0;
		@f=();
		while($file=readdir(DIR)) {
			next if($file eq "" || $file=~/^\./);
			next if(!$file=~/\.(jp?g|gif|png)/);
			push(@f, $file);
			$name=$file;
			$name=~s/\..*//g;
			$ret=&shell("identify -format '%w %h' $imgsrc/$img/$file");
			($ww,$hh)=split(/ /,$ret);
			if($file eq "star.gif") {
				$hh=15;
				$ww=15;
			}
			$hmax=$hh if($hmax < $hh);
	#print "$file=$hh ($hmax)\n";
		}
		foreach $file(@f) {
	#print STDERR "$file\n";
			$name=$file;
			$name=~s/\..*//g;
			$ret=&shell("identify -format '%w %h' $imgsrc/$img/$file");
			($ww,$hh)=split(/ /,$ret);
			if($file eq "star.gif") {
				$hh=15;
				$ww=15;
			}
			if($file=~/\.png/ && $img ne "org") {
				if(-r "$imgdst/$img.png") {
					&shell("cp $imgdst/$img.png $imgdst/_$img.png");
					&shell("convert -append $imgdst/_$img.png $imgsrc/$img/$file $imgdst/$img.png");
					unlink("$imgdst/_$img.png");

	#				$h=$h+$hh;
				} else {
					&shell("cp $imgsrc/$img/$file $imgdst/$img.png");
				}
				$name=lc $name;
				print W <<EOM;
#icn_$name {
	background: url(../image/$img.png) 0px @{[0 - $h]}px;
	height: @{[floor(($hmax - $hh)/2) ne 0 ? "@{[$hh - floor(($hmax - $hh)/2)]}" : $hh]}px;
	width: @{[$ww]}px;@{[floor(($hmax - $hh)/2) ne 0 ? "\n	padding-top: @{[floor(($hmax - $hh)/2)]}px;" : ""]}
}

EOM
				$h+=$hh;
			} else {
				&shell("cp $imgsrc/$img/$file $imgdst");
				$name=lc $name;
				print W <<EOM;
#icn_$name {
	background: url(../image/$img.png) 0px 0px;
	height: @{[$hh]}px;
	width: @{[$ww]}px;
}

EOM
			}
		}
		&shell("$optipng $imgdst/$img.png");
		closedir(DIR);
	close(W);
	}
}

sub shell {
	my($shell)=@_;
	my $buf;
	print STDERR "$shell\n";
	open(PIPE,"$shell 2>/dev/null|");
	foreach(<PIPE>) {
		chomp;
		$buf.=$_;
	}
	close(PIPE);
#	print STDERR "$buf\n";
	$buf;
}
