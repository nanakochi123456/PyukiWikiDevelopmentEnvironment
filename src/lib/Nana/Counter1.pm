######################################################################
# @@HEADER3_NANAMI@@
######################################################################
# Usage :
# Nana::Counter1::counter(dir, page, r or w);
######################################################################

package	Nana::Counter1;
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
	$default{date}=&dt;

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

	if($counters!~/date/) {
		%counter=&parse($counters);
	} else {
		&load_module("Nana::Counter2");
		%counter=Nana::Counter2::parse($counters);
	}

	if($rw eq "W" || $rw eq "w") {
		%counter=&addcounter(%counter);
		&write($file, %counter);
	}
	%counter;
}

sub addcounter {
	my(%counter)=@_;

	my $today=&dt;

	if($counter{date} ne $today) {
		$counter{total}++;
		$counter{yesterday}=$counter{today};
		$counter{today}=1;
		$counter{ip}=$ENV{REMOTE_ADDR};
		$counter{date}=$today;
	} elsif($ENV{REMOTE_ADDR} ne $counter{ip}) {
		$counter{total}++;
		$counter{today}++;
		$counter{date}=$today;
	}
	my $udate=&getudate;
	$counter{$udate}=$counter{today};
	$counter{$udate-1} = $counter{yesterday};
	return %counter;
}
sub read {
	my $file=shift;
	my $buf=Nana::File::lock_fetch($file);
	$buf;
}


sub write {
	my ($file, %counter)=@_;
	my @keys = sort keys(%default);
	my $buf;
	if($counter{date} eq "") {
		$counter{date}=&dt;
	}
	if($counter{ip} eq "") {
		$counter{ip}=$ENV{REMOTE_ADDR};
	}

	foreach my $keys(@keys) {
		$buf.="$counter{$keys}\n";
	}
	Nana::File::lock_store($file, $buf);
}

sub parse {
	my ($counter)=shift;
	my @tmp=split(/\n/,$counter);
	my %counter;

	my @keys = sort keys(%default);

	if($tmp[1]=~/[.\/]/ && $tmp[0]=~/\//) {
		@keys = sort keys(%default);
		$counter{version}=1;	# 正常なカウンタ	# comment
	} else {
		@keys=keys %default;
		$counter{version}=0;	# 壊れたカウンタ	# comment
	}
	my $i=0;
	foreach(@keys) {
		$counter{$_}=$tmp[$i];
		$i++;
	}

	$counter{total}+=0;
	$counter{today}+=0;
	$counter{yesterday}+=0;

	my $udate=&getudate;

	$counter{$udate}=$counter{today};
	$counter{$udate-1} = $counter{yesterday};

	%counter;
}

sub dt {
	my ($mday, $mon, $year) = (localtime)[3..5];
	$year += 1900;
	$mon += 1;
	return "$year/$mon/$mday";
}

1;
__END__


