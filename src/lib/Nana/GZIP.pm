######################################################################
# @@HEADER3_NANAMI@@
######################################################################
#
# use Nana::GZIP;
# my $gz=new Nana::GZIP(
#            prog=>"gzip or pigz or zlib or other",
#            level=>"fast or best or other",
#            path=>(gzip path optional)
#        );
# $compressdata=$gz->compress($data);
# $extractdata=$gz->uncompress($data);
#
# see
# http://suika.fam.cx/~wakaba/wiki/sw/n/Perl%E3%81%A7%E3%81%AEgzip%E3%81%AE%E5%9C%A7%E7%B8%AE%E3%83%BB%E5%B1%95%E9%96%8B
# http://www.submit.ne.jp/1500
# http://d.hatena.ne.jp/yukiex/20080227/
######################################################################
package Nana::GZIP;
$VERSION="0.3";
use strict;
use Nana::ServerInfo;
use integer;
#use Exporter;
use vars qw($VERSION);
$VERSION = '0.1';

$GZIP::INIT=0;
$GZIP::FORCEPIGZ=0;
$GZIP::FORCEGZIP=0;

######################################################################

$GZIP::INITED=0;
$GZIP::PATH;
$GZIP::FORCE;
$GZIP::FAST;
$GZIP::BEST;

$GZIP::BEFOREPROG="GZIP.pm test";
$GZIP::BEFORELEVE;
$GZIP::BEFORCOMPRESSFLAG;
$GZIP::BEFOREUNCOMPRESSFLAG;
$GZIP::BEFOREPATH;

# multicore gzip tips: http://www.submit.ne.jp/1500			# comment

# init														# comment

# $gz=new Nana::GZIP(prog=>"gzip or pigz", level="fast or best or default or 1..9");	# comment

sub new {
	my($class,%hash)=@_;
	my $ret;
$::debug.="GZIP.pm: init\n";
	if($hash{prog} ne $GZIP::BEFOREPROG || $hash{level} ne $GZIP::BEFORELEVEL) {
		my $pigz_command='pigz1';
		my $gzip_command='gzip1';
		my $zlib_command='zlib';

		my $prog=lc $hash{prog};
		my $path=lc $hash{prog};

		if($prog!~/^($gzip_command|$pigz_command|$zlib_command|nouse|)$/) {
			return bless {
				prog=>"",
				level=>"",
				path=>"",
				init=>0,
			}, $class;
		}

		# 信用して実行						# comment
		$path=(split(/ /, $path))[0];
		if($-x $path) {
			$::debug.="GZIP.pm: Force $path\n";			# comment
			return bless {
				prog=>"custom",
				path=>$hash{path},
				compressflag=>$hash{compressflag},
				uncompressflag=>$hash{uncompressflag},
				init=>1,
			}, $class;
		}

		# 検索する									# comment
		my $_execpath="/usr/local/bin:/usr/bin:/bin:$ENV{PATH}";
		my $_force="--force";
		my $_fast="--fast";
		my $_best="--best";
		my $_decompress="--decompress";
		my ($path, $pathbak);
		my ($forceflag, $fastflag, $bestflag, $decompressflag);
		my $info=new Nana::ServerInfo;

		if($prog eq "" || $prog eq $gzip_command) {
			my $found=0;
			foreach(split(/:/,$_execpath)) {
				if(-x "$_/$gzip_command") {
					$path="$_/$gzip_command" ;
#					$prog=$gzip_command;				# comment
					if(open(PIPE,"$path --help 2>&1|")) {
						foreach(<PIPE>) {
							$forceflag="$_force" if(/$_force/);
							$fastflag="$_fast" if(/$_fast/);
							$bestflag="$_best" if(/$_best/);
							$decompressflag=$_decompress if(/$_decompress/);
						}
						$found=1;
						close(PIPE);
					}
				}
			}
			$path="" if($found eq 0);
		}
		$pathbak=$path;
		if($prog eq "" && $info->core > 3 || $prog eq $pigz_command) {
			my $found=0;
			foreach(split(/:/,$_execpath)) {
				if(-x "$_/$pigz_command") {
					$path="$_/$pigz_command" ;
#					$prog=$gzip_command;				# comment
					if(open(PIPE,"$path --help 2>&1|")) {
						foreach(<PIPE>) {
							$forceflag="$_force" if(/$_force/);
							$fastflag="$_fast" if(/$_fast/);
							$bestflag="$_best" if(/$_best/);
							$decompressflag=$_decompress if(/$_decompress/);
						}
						$found=1;
						close(PIPE);
					}
				}
			}
			$path=$pathbak if($found eq 0);
		}
		$pathbak=$path;
		if($path eq "" || $prog eq $zlib_command) {
			if(&load_module("Compress::Zlib")) {
				$path="zlib";
			}
		}

		my $level=
			lc $hash{level} eq "best" ? " $forceflag $bestflag " :
			lc $hash{level} eq "fast" ? " $forceflag $fastflag " :
			" $forceflag $fastflag ";

		$decompressflag="$forceflag $decompressflag";
		$GZIP::BEFOREPROG=$hash{prog};
		$GZIP::BEFORELEVEL=$hash{level};
		$GZIP::BEFORCOMPRESSFLAG=$level;
		$GZIP::BEFOREUNCOMPRESSFLAG=$decompressflag;
		$GZIP::BEFOREPATH=$path;
		$::debug.="GZIP.pm: auto detect gzip (compress) : $GZIP::BEFOREPATH $GZIP::BEFORCOMPRESSFLAG\nGZIP.pm: auto detect gzip (uncompress) : $GZIP::BEFOREPATH $GZIP::BEFOREUNCOMPRESSFLAG\n";
		return bless {
			prog=>$hash{prog},
			level=>$hash{level},
			path=>$hash{path},
			compressflag=>$level,
			uncompressflag=>$decompressflag,
			_path=>$path,
			init=>1,
		}, $class;
	}
	return bless {
		prog=>$GZIP::BEFOREPROG,
		level=>$GZIP::BEFORELEVEL,
		path=>$hash{path},
		compressflag=>$GZIP::BEFORCOMPRESSFLAG,
		uncompressflag=>$GZIP::BEFOREUNCOMPRESSFLAG,
		_path=>$GZIP::BEFOREPATH,
		init=>1
	}, $class;
}

sub fifo {
	my ($cmd, $post)=@_;

	&load_module("Nana::Temp");
	my($fh, $path)=Nana::Temp::tempfile(
		"", DIR=>$::cache_dir, SUFFIX=>".fifo");
	close($fh);

	my $mode = 0600;
	unlink($path);

	use POSIX;
	if(! mkfifo($path, $mode) ) {
		die "can not mkfifo($path, $mode): $!";
	}

	my $pid = fork();
	if ($pid ==0) {
		open(FIFO, "| $cmd > $path")
			or die "can not open $path: $!";
		print FIFO $post;
		close(FIFO);
		exit;
	}

	open(FIFO, "< ${path}")
		or die "can not open ${path}: $!";
	my $get;
	while(<FIFO>) {
		$get.=$_;
	}

	wait;
	close(FIFO);

	unlink($path);
	return $get;
}

sub mktemp {
	my($seed)=shift;
	my $sd=0;
	for(my $l=0; $l < 50; $l++) {
		for(my $i=0; $i < length($seed); $i++) {
			$sd += chr(substr($seed, $i, 1)) + length($sd) + $l;
		}
		last if(!-f "$::cache/$sd.fifo");
	}
	return "$::cache_dir/$sd.fifo";
}

sub init {
	my ($self, $data)=@_;
 	return $self->{init};
}

sub compress {
	my ($self, $data)=@_;
	$::debug.="GZIP.pm compress cmd:$self->{_path}\n";
	if($self->{init}) {
		if($self->{_path} ne "zlib") {
			my $cmd=$self->{_path} . " " . $self->{compressflag};
			my $gziped=&fifo("$cmd", $data);
			return $gziped;
		}
		$::debug.="zlib writed\n";
		return Compress::Zlib::memGzip($data);
	}
	return $data;
}

sub uncompress {
	my ($self, $input)=@_;
	$::debug.="GZIP.pm extract cmd:$self->{_path}\n";
	if($self->{init}) {
		if($self->{_path} ne "zlib" ) {
			my $cmd=$self->{_path} . " " . $self->{uncompressflag};
			my $output=&fifo("$cmd", $input);
			return $output;
		}
		## Taken from Namazu <http://www.namazu.org/>, filter/gzip.pl
		my ($data)=shift;
		my ($s)=$input;
		my $flags = unpack('C', substr($s, 3, 1));
		$s = substr($s, 10);
		$s = substr($s, 2)  if ($flags & 0x04);
		$s =~ s/^[^\0]*\0// if ($flags & 0x08);
		$s =~ s/^[^\0]*\0// if ($flags & 0x10);
		$s = substr($s, 2)  if ($flags & 0x02);

		my $zl = Compress::Zlib::inflateInit
			(-WindowBits => - Compress::Zlib::MAX_WBITS());
		my ($inf, $stat) = $zl->inflate ($s);
		if ($stat == Compress::Zlib::Z_OK()
			|| $stat == Compress::Zlib::Z_STREAM_END()) {
			return $inf;
		} else {
			return 'Bad compressed data';
		}
	}
	return $input;
}

sub load_module {
	my $funcp = $::functions{"load_module"};
	return &$funcp(@_);
}

sub print_error {
	my $funcp = $::functions{"print_error"};
	return &$funcp(@_);
}

1;
__END__

=head1 NAME

Nana::GZIP - GZIP compressor module

=head1 SEE ALSO

=over 4

=item PyukiWiki CVS

L<@@CVSURL@@/PyukiWiki-Devel/lib/Nana/GZIP.pm>

=back

=head1 AUTHOR

=over 4

@@AUTHOR_NANAMI@@

@@AUTHOR_PYUKI@@

=back

=head1 LICENSE

@@LICENSE_NANAMI@@

=cut
