######################################################################
# @@HEADER4_NANAMI@@
######################################################################
# XSPKG : NanaXS::func 0.1

use strict;
#use warnings;
use Time::HiRes qw(gettimeofday tv_interval);

use Test::More tests => 4;
BEGIN {
	push @INC, "./blib";
	push @INC, "./blib/lib";
	push @INC, "./blib/arch";
	push @INC, "./blib/arch/auto";
	push @INC, "../../lib";	# for Nana::Date
};
diag("Nana::Date load\n");
use_ok('Nana::Date');

diag("NanaXS::func load\n");
use_ok('NanaXS::func');

#########################

$::lang="ja";
$::resource{"date_ampm_en"}="am,pm";
$::resource{"date_ampm_".$::lang}="am,pm";
$::resource{"date_weekday_en"}="Sun,Mon,Tur,Wed,Tun,Fri,Sat";
$::resource{"date_weekday_en_short"}="Sun,Mon,Tur,Wed,Tun,Fri,Sat";
$::resource{"date_weekday_".$::lang}="Sun,Mon,Tur,Wed,Tun,Fri,Sat";
$::resource{"date_weekday_".$::lang."_short"}="Sun,Mon,Tur,Wed,Tun,Fri,Sat";

my @dtptn=(
	"Y-m-d(lL) H_i_s",
#	"Y-m-d(D) H_i_s",
#	"Y-m-d(lL) A h_i_s",
	"Y-m-d(D) A h_i_s",
#	"Y-m-d(lL) h_i_s",
#	"Y-m-d(D) h_i_s",
	"y-m-d(lL) H_i_s",
#	"y-m-d(D) H_i_s",
#	"y-m-d(lL) A h_i_s",
#	"y-m-d(D) A h_i_s",
#	"y-m-d(lL) h_i_s",
#	"y-m-d(D) h_i_s",
	"D M d H_i_s Y",
#	"D M d A h_i_s Y",
#	"D M d h_i_s Y"
);

my $tt=time;
my @dtsmp=(
	((2000-1970)*365*24*24*60)+ 15 * 24*24*60,
	$tt,
	((2000-1982)*365*24*24*60)+ 273 * 24*24*60,
	$tt - 2 * 365*24*24*60 + 153 * 24*24*60,
#	$tt
);
for(my $i=0; $i < 30; $i++) {
	my $y=$i*365*60*60*24;
	for(my $d=0; $d < 365; $d++) {
		my $m=$d*60*60*24;
		push(@dtsmp,$y+$m);
	}
}

$::TZ=9;

my $d1;
my $d2;
my $ok=1;

diag("Nana::XS::func::date test\n");

foreach my $dtsmp(@dtsmp) {
	foreach my $dtptn(@dtptn) {
		$d1=Nana::Date::date($dtptn, $dtsmp, 0);
		$d2=NanaXS::func::date($dtptn, $dtsmp, 0);
		if($d1 ne $d2) {
			diag("Diff [$d1]\n [$d2]\n");
			$ok=0;
		}
	}
}

ok($ok, "date (test)");

#diag("date pure perl bench\n");

my $t0 = [gettimeofday];
#foreach my $dtsmp(@dtsmp) {
#	foreach my $dtptn(@dtptn) {
#		$d1=Nana::Date::date($dtptn, $dtsmp, 0);
#	}
#}

my $t1 = [gettimeofday];
#diag(tv_interval ($t0, $t1) . "sec\n");

diag("Nana::XS::func::date xs bench\n");

foreach my $dtsmp(@dtsmp) {
	foreach my $dtptn(@dtptn) {
		$d2=NanaXS::func::date($dtptn, $dtsmp, 0);
	}
}
my $t2 = [gettimeofday];
diag(tv_interval ($t1, $t2) . "sec\n");
ok($ok, "date (bench complete)");
