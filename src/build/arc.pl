#!/usr/bin/perl
#--------------------------------------------------------------
# PyukiWiki Installer CGI Maker
# $Id$
#--------------------------------------------------------------
# easy tape archive tool
#--------------------------------------------------------------

$opt=$ARGV[0];

$add=0;
$dir=0;
$sepa1="\x0\xff\x0\xff\x0\xff\x0\xff\x0";
$sepa2="\x0\xff\x5\xff\x0\xff\x5\xff\x0";

if($opt=~/a/) {
	$add=1;
}
if($opt=~/d/) {
	$dir=1;
}
if($opt=~/v/) {
	$v=1;
}

$out=$ARGV[1];
open(W, ">$out")||die;
print "Output: $out\n" if($v);

binmode(W);
$f=0;
if(1) {
	for($i=2; $ARGV[$i] ne ""; $i++) {
		open(PIPE, "find $ARGV[$i] |")||die;
		foreach(<PIPE>) {
			push(@dirs, "$_");
		}
		close(PIPE);
		@dirs=sort @dirs;
		foreach(@dirs) {
			chomp;
			if(!-d $_) {
				($dev,$ino,$mode,$nlink,$uid,$gid,$rdev,$size,
				    $atime,$mtime,$ctime,$blksize,$blocks) = stat($_);
				$fn=$_;
				$dfn=$_;
				if($dir eq 0) {
					$fn=~s/.*\///g;
				}
				next if($chk{$dfn} eq 1);
				$chk{$dfn}=1;
				print "a $dfn\n";
#				syswrite(W, $sepa1, length($sepa1));
				$fw.=$sepa1;
#				$a=sprintf("%s$sepa2%d$sepa2%d$sepa2"
#							, $fn, $mode, $size);
				$a=sprintf("%s$sepa2%d$sepa2"
							, $fn, $size);
#				syswrite(W, $a, length($a));
				$fw.=$a;
				open(R, $dfn)||die;
				$len=sysread(R, $buf, $size);
#				syswrite(W, $buf, $len);
				$fw.=$buf;
				close(R);
				$f++;
			} elsif($dir) {
				$fn=$_;
				($dev,$ino,$mode,$nlink,$uid,$gid,$rdev,$size,
				    $atime,$mtime,$ctime,$blksize,$blocks) = stat($_);
				next if($chk{$fn} eq 1);
				$chk{$fn}=1;
				print "d $fn\n";
#				syswrite(W, $sepa1, length($sepa1));
				$fd.=$sepa1;
#				$a=sprintf("%s$sepa2%d$sepa2%s"
#							, $fn, $mode);
				$a=sprintf("%s$sepa2%s"
							, $fn, "d");
#				syswrite(W, $a, length($a));
				$fd.=$a;
			}
		}
	}
}
if($dir) {
	syswrite(W, $fd, length($fd));
}
syswrite(W, $fw, length($fw));

close(W);

