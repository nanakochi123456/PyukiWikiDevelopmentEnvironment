######################################################################
# @@HEADER3_NANAMI@@
######################################################################

package Nana::YukiWikiDB_GZIP;
use strict;
use integer;
use Exporter;
use vars qw($VERSION);
$VERSION="0.9";
use Nana::File;
use Nana::GZIP;

# Constructor
sub new {
	return shift->TIEHASH(@_);
}

# error									# debug
sub die {								# debug
	$::debug.="YukiWikiDB_GZIP:$_[0]\n";# debug
	return undef;						# debug
}										# debug

# tying												# comment
sub TIEHASH {
	my ($class, $dbname) = @_;
	my $self = {
		dir => $dbname,
		keys => [],
		ext => $::db_extention{$dbname},
		gzip => new Nana::GZIP()
	};
	if (not -d $self->{dir}) {
		if (!mkdir($self->{dir}, 0777)) {
			return &die("mkdir $self->{dir} fail"); # debug
			return undef;
		}
	}
	return bless($self, $class);
}

# Store												# comment
sub STORE {
	my ($self, $key, $value) = @_;
	my ($mode, $filename) = &make_filename($self, $key);
	my ($mode, $filename_gz) = &make_filename_gz($self, $key);
	my $gz=$self->{gzip};
	if($gz->{init} eq 1) {
		Nana::File::lock_delete($filename);
		return
			Nana::File::lock_store($filename_gz, $gz->compress($value));
	}
	return Nana::File::lock_store($filename,$value);
}

# Fetch												# comment
sub FETCH {
	my ($self, $key) = @_;
	my ($mode, $filename) = &make_filename($self, $key);
	my ($mode, $filename_gz) = &make_filename_gz($self, $key);
	my $gz=$self->{gzip};
	if($gz->{init} eq 1) {
		if(-e $filename_gz) {
			return (stat($filename_gz))[9] if($mode eq "update");
			return
				($gz->uncompress(Nana::File::lock_fetch($filename_gz)));
		}
	}
	return (stat($filename))[9] if($mode eq "update");
	return Nana::File::lock_fetch($filename);
}

# Exists											# comment
sub EXISTS {
	my ($self, $key) = @_;
	my ($mode, $filename) = &make_filename($self, $key);
	my ($mode, $filename_gz) = &make_filename_gz($self, $key);
	return 1 if (-e $filename);
	return 1 if (-e $filename_gz);
	return 0;
}

# Delete											# comment
sub DELETE {
	my ($self, $key) = @_;
	my $filename = &make_filename($self, $key);
	my $filename_gz = &make_filename_gz($self, $key);
	Nana::File::lock_delete($filename);
	Nana::File::lock_delete($filename_gz);
}

sub FIRSTKEY {
	my ($self) = @_;
	if(opendir(DIR, $self->{dir})) {
		@{$self->{keys}} = grep /\.$self->{ext}\.gz$/, readdir(DIR);
		foreach my $name (@{$self->{keys}}) {
			$name =~ s/\.gz$//;
			$name =~ s/\.$self->{ext}$//;
			$name =~ s/([0-9A-F][0-9A-F])/$::_dbmname_decode{$1}/g;
		}
		closedir(DIR);
		return shift @{$self->{keys}};
	} else {											# debug
		return &die("FIRSTKEY: $self->{dir} fail"); 	# debug
	}
	return;
}

sub NEXTKEY {
	my ($self) = @_;
	return shift @{$self->{keys}};
}

sub make_filename {
	my ($self, $key) = @_;
	my $mode="";
	if($key=~/^\_\_(.+?)\_\_(.+?)$/) {
		$mode=$1;
		$key=$2;
	}
	$key =~ s/(.)/$::_dbmname_encode{$1}/g;
	return ($mode, $self->{dir} . "/$key.$self->{ext}");
}

sub make_filename_gz {
	my ($self, $key) = @_;
	my $mode="";
	if($key=~/^\_\_(.+?)\_\_(.+?)$/) {
		$mode=$1;
		$key=$2;
	}
	$key =~ s/(.)/$::_dbmname_encode{$1}/g;
	return ($mode, $self->{dir} . "/$key.$self->{ext}.gz");
}
1;
__END__

=head1 NAME

Nana::YukiWikiDB_GZIP - Gziped filebase hash database

=head1 SEE ALSO

=over 4

=item PyukiWiki CVS

L<@@CVSURL@@/PyukiWiki-Devel/lib/Nana/YukiWikiDB_GZIP.pm>

=back

=head1 AUTHOR

=over 4

@@AUTHOR_NANAMI@@

@@AUTHOR_YUKI@@

@@AUTHOR_PYUKI@@

=back

=head1 LICENSE

@@LICENSE_NANAMI@@

=cut
