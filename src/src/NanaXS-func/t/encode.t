######################################################################
# @@HEADER4_NANAMI@@
######################################################################
# XSPKG : NanaXS::func 0.1

use strict;
use warnings;
use Time::HiRes qw(gettimeofday tv_interval);

use Test::More tests => 3;
BEGIN {
	push @INC, "./blib";
	push @INC, "./blib/lib";
	push @INC, "./blib/arch";
	push @INC, "./blib/arch/auto";
};
diag("NanaXS::func load\n");
use_ok('NanaXS::func');

#########################


my $test=q( !"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ]^_`abcdefghijklmnopqrstuvwxyz{|}~);


my $test1;
my $test2;

$test1=$test;
$test1 =~ s/(\W)/'%' . unpack('H2', $1)/eg;
$test1 =~ s/\%20/+/g;
$test2=NanaXS::func::encode($test);

diag("NanaXS::func::encode(short)\n");
ok($test1 eq $test2, "encode (short)");

print "$test1\n$test2\n";
my $t0 = [gettimeofday];

diag("NanaXS::func::encode(prepare big data)\n");
my $testbig;
for(my $i=0; $i < 100; $i++) {
	$testbig.=$test;
}
$test=$testbig;
for(my $i=0; $i < 50; $i++) {
	$testbig.=$test;
}

my $t1 = [gettimeofday];
diag(tv_interval ($t0, $t1) . "sec\n");

diag("Nana::XS::func::encode(pure perl)");
$test=$testbig;
$test1=$testbig;
$test1 =~ s/(\W)/'%' . unpack('H2', $1)/eg;
$test1 =~ s/\%20/+/g;

my $t2 = [gettimeofday];
diag(tv_interval ($t1, $t2) . "sec\n");

diag("NanaXS::func::encode(big)\n");
$test2=NanaXS::func::encode($test);
ok($test1 eq $test2, "encode (big)");

my $t3 = [gettimeofday];
diag(tv_interval ($t2, $t3) . "sec\n");

exit(0);
