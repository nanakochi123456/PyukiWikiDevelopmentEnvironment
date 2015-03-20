######################################################################
# @@HEADER3_NANAMI@@
######################################################################
# Usage :
# Nana::Counter2::counter(dir, page, r or w);
######################################################################

package	Nana::Counter2;
use 5.005;
use strict;
use integer;
use Exporter;
use vars qw($VERSION);
$VERSION = '0.1';
use Nana::File;

my %default = (
	'total'     => 0,
	'date'      => '',
	'today'     => 0,
	'yesterday' => 0,
	'ip'        => ''
);

sub getudate {
	return int((time+$::TZ*3600) / 86400);
}

sub encode {
	my $funcp = $::functions{"encode"};
	return &$funcp(@_);
}

sub dbmname {
	my $funcp = $::functions{"dbmname"};
	return &$funcp(@_);
}

sub load_module {
	my $funcp = $::functions{"load_module"};
	return &$funcp(@_);
}

sub counter {
	my($dir, $page, $rw)=@_;
	$rw="r" if($rw=~/[Rr]/);
	my %counter = %default;
	my $counters;

	my $hex=&dbmname($page);
	my $new=$hex;
	my $file = "$dir/$new$::counter_ext";
	my $v3filechk = "$dir/$new.ip$::counter_ext";
	my %udate;

	my @keys;
	@keys = sort keys(%default);
	my $modify = 0;

	my $buf;

	if(-r $v3filechk) {
		&load_module("Nana::Counter3");
		$counters=Nana::Counter3::read("$dir/$new");
		Nana::Counter3::delete("$dir/$new");
	} else {
		$counters=&read($file);
	}
	if($counters eq "") {
		my $old=&encode($page);
		my $oldfile = $dir . "/" . $old . $::counter_ext;
		$counters=Nana::File::lock_fetch($oldfile);
		$modify = 1;
		Nana::File::lock_delete($oldfile);
	}
	if($counters=~/date/) {
		%counter=&parse($counters);
	} else {
		&load_module("Nana::Counter1");
		%counter=Nana::Counter1::parse($counters);
		my %udate;
		$udate{today}=&getudate;
		$udate{yesterday}=$udate{today}-1;
		$counter{today}=$counter{$udate{today}};
		$counter{yesterday}=$counter{$udate{yesterday}};

	}
	if($rw eq "W" || $rw eq "w") {
		%counter=&addcounter(%counter);
		&write($file, %counter);
	}
	%counter;
}

sub addcounter {
	my(%counter)=@_;

	my %udate;
	$udate{today}=&getudate;
	$udate{yesterday}=$udate{today}-1;

	my $update=0;

	if($ENV{REMOTE_ADDR} ne $counter{ip} || $counter{date} ne $udate{today}) {
		$counter{total}++;
		$counter{$udate{today}}++;
		$counter{date}=$udate{today};
		$counter{ip}=$ENV{REMOTE_ADDR};
	}
	$counter{today}=$counter{$udate{today}};
	$counter{yesterday}=$counter{$udate{yesterday}};

	%counter;
}

sub read {
	my $file=shift;
	my $buf=Nana::File::lock_fetch($file);
	$buf;
}

sub parse {
	my ($counter)=shift;
	my @tmp=split(/\n/,$counter);
	my %counter;

	foreach(@tmp) {
		my($l, $r)=split(/\t/, $_);
		$counter{$l}=$r eq "" ? 0 : $r;
	}
	$counter{Version}=2;
	%counter;
}

sub write {
	my ($file, %counter)=@_;

	$::CounterDates=1000 if($::CounterDates > 1000);
	$::CounterDates=14 if($::CounterDates < 15);

	my $buf=<<EOM;
date\t$counter{date}
ip\t$counter{ip}
total\t$counter{total}
EOM
	my $udate=&getudate;
	for(my $i=$udate; $i>$udate - $::CounterDates; $i--) {
		$buf.=qq($i\t$counter{$i}\n);
	}
	Nana::File::lock_store($file, $buf);
}

1;
__END__
