#!/usr/bin/perl
# release file perl script for pyukiwiki
# $Id$

use Jcode;
$fo="./build/list_hiragana.txt";
$f1="./build/list_hiragana_euc.txt";
$f2="./build/list_hiragana_utf8.txt";

$buf="";

# read file

open(R, $fo);
foreach(<R>) {
	chomp;
	next if(/^#/);
	next if($_ eq "");

	if(/^=trzen/) {
		s/\,/\|/g;
		$buf.=qq(\t"trzen"=>") . substr($_, 6) . qq(",\n);
	}elsif(/^=/) {
		s/\,/\|/g;
		$buf.=qq(\t"kigou"=>") . substr($_, 1) . qq(",\n);
	}elsif(/^\^/) {
		@chr=split(/,/,substr($_, 1));
		$buf.=qq(\t"$chr[0]"=>");
		for(my $i=1; $chr[$i] ne ""; $i++) {
			$buf.="$chr[$i]|";
		}
		$buf=~s/\|$//g;
		$buf.=qq(",\n);
	} else {
		my @chr=split(//,$_);
		my $i=0;
		my @str=();
		foreach(@chr) {
			if($i%2 eq 0) {
				push(@str,$chr[$i] . $chr[$i+1]);
			}
			$i++;
		}
		my $i=0;
		my $line="";
		foreach(@str) {
			if($i eq 0) {
				$line.=qq(\t"$_"=>");
			} elsif($i eq 1) {
				$line.=qq($_);
			} else {
				$line.=qq(|$_);
			}
			$i++;
		}
		$line.=qq(",\n);
		$buf.=$line;
	}
	$buf.=$line;
}
close(R);

# do not make utf8
#$utf8=Jcode->new($buf)->utf8;

# only make euc
$buf=Jcode->new($buf)->euc;

open(W, ">$f1");
#$buf =~ s/(\W)/'%' . unpack('H2', $1)/eg;		# comment
$buf =~ s/(\W)/ord($1) > 128 ? '\\x' . unpack('H2', $1) :"$1"/eg;
print W $buf;
close(W);

#open(W, ">$f2");
#$utf8 =~ s/(\W)/ord($1) > 127 ? '\\x' . unpack('H2', $1) :"$1"/eg;
#print W $utf8;
#close(W);
