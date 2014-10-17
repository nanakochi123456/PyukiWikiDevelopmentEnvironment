######################################################################
# @@HEADER4_NANAMI@@
######################################################################

# XS module builder for pyukiwiki

use 5.008100;
use ExtUtils::MakeMaker;

my $testfile="pyukiwikixs.testfile";
my $cclist=<<EOM;
llvm-gcc
gcc
cc
EOM

for(my $i=40; $i<=50; $i++) {
	$cclist="gcc$i\n$cclist";
}

my $ccopts=<<EOM;
-O3
-O2
-O

EOM

my $cflags="-DPIC -fPIC";

sub cc {
	my($mode)=shift;

	my $testsrc=<<EOM;
#include <stdio.h>

int main(void) {
	printf("Hello test world\\n");
	exit(0);
}
EOM

	&writefile("$testfile.c", $testsrc);

	my ($path, $opt)=&execchk("$testfile.c", $cclist, $ccopts);

	unlink("$testfile.c");
	unlink("$testfile.o");
	unlink("a.out");
	if($mode eq "cmd") {
		return $path;
	} elsif($mode eq "optimize" || $mode eq "opt") {
		return $opt;
	}
	return "$path $opt";
}

sub execchk {
	my($testfile, $execlist, $optlist)=@_;

	foreach my $cmd(split(/\n/,$execlist)) {
		$cmd=~s/.*\///g;
		$cmd=~s/.*\\//g;
		foreach my $opt(split(/\n/,$optlist)) {
			if($ENV{PATH}=~/:/) {
				foreach my $path(split(/:/,$ENV{PATH})) {
					my $ret=system("$path/$cmd $opt $cflags $testfile >/dev/null 2>/dev/null");
					if($ret eq 0) {
						return ("$path/$cmd","$opt $cflags");
					}
				}
			} elsif($ENV{PATH}=~/;/) {
				foreach my $path(split(/;/,$ENV{PATH})) {
					my $ret=system("$path\\$cmd $opt $cflags $testfile >/dev/null 2>/dev/null");
					if($ret eq 0) {
						return ("$path\\$cmd","$opt $cflags");
					}
				}
			}
		}
	}
	return ("", "");
}

sub writefile {
	my($fname, $data)=@_;
	open my $fh, ">$fname" || die;
	print $fh $data;
	close($fh);
}

sub writemakefile {
	my(%hash)=@_;
	WriteMakefile(
		NAME				=> $hash{Module},
		VERSION_FROM		=> $hash{File},
		PREREQ_PM			=> {},
	    ($] >= 5.005 ?
	      (ABSTRACT_FROM  => $hash{File},
	       AUTHOR         => $hash{Author}) : ()),
		CC					=> &cc("cmd"),
		OPTIMIZE			=> &cc("opt"),
		LIBS				=> $hash{Libs},
		DEFINE				=> $hash{Define},
		INC					=> $hash{Inc} eq "" ? "-I" : $hash{Inc},
		OBJECT            => '$(O_FILES)',

	);
}
