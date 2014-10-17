######################################################################
# @@HEADER4_NANAMI@@
######################################################################
# XSPKG : NanaXS::func 0.1

use strict;
use warnings;

use Test::More tests => 3;
BEGIN {
	push @INC, "./blib";
	push @INC, "./blib/lib";
	push @INC, "./blib/arch";
};
use_ok('NanaXS::func');

#########################

my $test=" !\"#\$\%\&\'\*+,-./0123456789:;<=>\?\@ABCDEFGHIJKLMNOPQRRSTUVWXYZ]^_`abcdefghijklmnopqrstuvwxyz{|}~";

my $test1;
my $test2;

$test1=$test;
$test1 =~ s/(.)/uc unpack('H2', $1)/eg;
$test1 =~ s/(.)/uc unpack('H2', $1)/eg;
$test2=NanaXS::func::undbmname($test);

cmp_ok($test1, '=', $test2, "undbmname (short)");

my $testbig;
for(my $i=0; $i < 100; $i++) {
	$testbig.=$test;
}
$test=$testbig;
for(my $i=0; $i < 50; $i++) {
	$testbig.=$test;
}

$test1=$testbig;
$test1 =~ s/(.)/uc unpack('H2', $1)/eg;
$test1 =~ s/(.)/uc unpack('H2', $1)/eg;
$test2=NanaXS::func::undbmname($test);

cmp_ok($test1, '=', $test2, "undbmname (big)");
