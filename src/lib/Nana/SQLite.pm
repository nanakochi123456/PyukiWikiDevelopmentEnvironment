######################################################################
# @@HEADER3_NANAMI@@
######################################################################

package Nana::SQLite;
use strict;
use integer;
use vars qw($VERSION);
$VERSION="0.1";

use DBI;

# Constructor
sub new {
	return shift->TIEHASH(@_);
}

# error									# debug
sub die {								# debug
	$::debug.="SQLite:die:[$_[0]]\n";	# debug
	return undef;						# debug
}										# debug

# print query							# debug
sub debugquery {						# debug
	my ($a,$q)=@_;						# debug
	$q=~s/(\r|\n)//g;					# debug
	$::debug.=qq(--------\n") if($::debug!~/\-\-\-\-\n$/); # debug
	$::debug.=qq(SQLite:$a:printquery\n$q\n--------\n); # debug
}										# debug

# tying												# comment
sub TIEHASH {
	my ($class, $dbname) = @_;
	my $escapedbname=$dbname;
	$escapedbname=~s/\.\///g;

	my $filename="$dbname/$escapedbname.sqlite";
	my $self = {
		dir => $dbname,
		name => $escapedbname,
		type => "SQLite",
		keys => [],
		obj => {},
		ext => $::db_extention{$dbname},
		connect => "dbi:SQLite:dbname=$filename",
		connectopt => {
			PrintError => 1,
			AutoCommit => 0
		}
	};
	if (not -d $self->{dir}) {
		if (!mkdir($self->{dir}, 0777)) {
			return &die("mkdir $self->{dir} fail"); # debug
			return undef;
		}
	}

	if(-r $filename || -s $filename eq 0) {
		if(&_connect($self) eq undef) {
			return &die("connect $self->{connect} fail"); # debug
			return undef;
		}
	} else {
		if(&_connect($self) eq undef) {
			return &die("connect $self->{connect} fail"); # debug
			return undef;
		} else {
			my $query=<<EOM;
create table $self->{name} (
	name blob not null unique,
	$self->{ext} blob,
	createtime integer not null,
	updatetime integer not null
);
EOM
			if(&_do($self, $query) eq undef) {
				return undef;
			}
		}
	}
	return bless($self, $class);
}

sub _do {
	my($self, $query)=@_;
	my $c=0;
	do {
		eval {
			&debugquery("do",$query); # debug
			$self->{obj}->do($query);
			$self->{obj}->commit;
		};
		if($@) {
			$self->{obj}->rollback;
			$self->{obj}->disconnect;
			&die("$@");	# debug
			return if($c++ < $SQLite::Verify);

			select undef, undef, undef, $SQLite::Wait;
			if(&_connect($self) eq undef) {
				return &die("reconnect $query fail"); # debug
				return undef;
			}
		} else {
			return;
		}
	} while(1);
}

sub _execute {
	my($self, $query)=@_;
	my ($sth, $buf);
	eval {
		&debugquery("execute",$query); # debug
		$sth = $self->{obj}->prepare($query);
		$sth->execute;
	};
	if($@) {
		$self->{obj}->rollback;
		$self->{obj}->disconnect;
		&die ("$@");	# debug
		return undef;
	}

	while (my @row = $sth->fetchrow_array) {
		$buf.=join("", @row);
	}
	return $buf;
}

sub _connect {
	my ($self)=@_;
	if(!($self->{obj} = DBI->connect($self->{connect}, "", "", $self->{connectopt}))) {
		&die($self->{obj}); # debug
		return undef;
	}
	return $self;
}

sub UNTIE {
	my ($self) = @_;
	if($self->{obj}) {
		$self->{obj}->disconnect;
	}
}

# Store												# comment
sub STORE {
	my ($self, $key, $value) = @_;
	my ($mode, $filename) = &make_filename($self, $key);

	my $create=&_get($self, "create", $filename) + 0;
	&_delete($self, $filename);
	&_insert($self, $filename, $value, $create+0 eq 0 ? time : $create, time);

}

sub _insert {
	my ($self, $key, $value, $create, $update)=@_;

	$key=&dbmname($key);
	$value=&dbmname($value);
#	$key =~ s/(.)/$::_dbmname_encode{$1}/g;
#	$value =~ s/(.)/$::_dbmname_encode{$1}/g;
	my $c=0;
	do {
		my $query=<<EOM;
insert into $self->{name} (
	name, $self->{ext}, createtime, updatetime)
values (
	'$key', '$value', '$create', '$update'
);
EOM
		if(&_do($self, $query) eq undef) {
			return undef;
		}

		return if($SQLite::Verify eq 0);

		my $query=<<EOM;
select $self->{ext} from $self->{name} where name='$key';
EOM
		return if(&_execute($self, $query) eq $value);

		$self->{obj}->rollback;
		$self->{obj}->disconnect;
		select undef, undef, undef, $SQLite::Wait;

		if(&_connect($self) eq undef) {
			return undef;
		}
	} while($c++ < $SQLite::Verify);
}

# Fetch												# comment
sub FETCH {
	my ($self, $key) = @_;
	my ($mode, $filename) = &make_filename($self, $key);
	return &_get($self, $mode, $filename);
}

sub _get {
	my ($self, $field, $key)=@_;
	my $buf;
	my $hkey=$key;
	$hkey=&dbmname($hkey);
#	$hkey =~ s/(.)/$::_dbmname_encode{$1}/g;
	if($field eq "") {
		my $query=<<EOM;
select $self->{ext} from $self->{name} where name='$hkey';
EOM
		$buf=&_execute($self, $query);
		$buf=&undbmname($buf);
#		$buf =~ s/([0-9A-F][0-9A-F])/$::_dbmname_decode{$1}/g;
		return $buf;
	} else {
		$field.="time";
		my $query=<<EOM;
select $field from $self->{name} where name='$hkey';
EOM
		return &_execute($self, $query);
	}
}

# Exists											# comment
sub EXISTS {
	my ($self, $key) = @_;
	my ($mode, $filename) = &make_filename($self, $key);
	return (&_get($self, $mode, $filename) ne "" ? 1 : 0);
}

# Delete											# comment
sub DELETE {
	my ($self, $key) = @_;
	my ($mode, $filename) = &make_filename($self, $key);
	&_delete($self, $filename);
}

sub _delete {
	my ($self, $key)=@_;
	my $hkey=$key;
	$hkey=&dbmname($hkey);
#	$hkey =~ s/(.)/$::_dbmname_encode{$1}/g;
	my $query=<<EOM;
delete from $self->{name} where name='$hkey';
EOM
	if(&_do($self, $query) eq undef) {
		return undef;
	}
}

sub _list {
	my ($self)=@_;
	my $query=<<EOM;
select name from $self->{name};
EOM
	my $sth;
	eval {
		&debugquery("list",$query); # debug
		$sth = $self->{obj}->prepare($query);
		$sth->execute;
	};
	if($@) {
		$self->{obj}->rollback;
		$self->{obj}->disconnect;
		&die ("$@");	# debug
		return undef;
	}
	my @list;
	while (my @row = $sth->fetchrow_array) {
		push(@list, join("", @row));
	}
	return @list;
}

sub FIRSTKEY {
	my ($self) = @_;
	@{$self->{keys}} = &_list($self);
	my $key=shift @{$self->{keys}};
	my ($mode, $filename) = &make_filename($self, $key);
	$filename=&undbmname($filename);
#	$filename =~ s/([0-9A-F][0-9A-F])/$::_dbmname_decode{$1}/g;
	return  $filename;
}

sub NEXTKEY {
	my ($self) = @_;
	do {
		my $key=shift @{$self->{keys}};
		my ($mode, $filename) = &make_filename($self, $key);
		$filename=&undbmname($filename);
#		$filename =~ s/([0-9A-F][0-9A-F])/$::_dbmname_decode{$1}/g;
		return $filename if($mode ne "update");
	} while(1);
}

sub make_filename {
	my ($self, $key) = @_;
	my $mode="";
	if($key=~/^\_\_(.+?)\_\_(.+?)$/) {
		$mode=$1;
		$key=$2;
	}
	return ($mode, $key);
}

sub dbmname {
	my $funcp = $::functions{"dbmname"};
	return &$funcp(@_);
}
sub undbmname {
	my $funcp = $::functions{"undbmname"};
	return &$funcp(@_);
}

1;
__END__

=head1 NAME

Nana::SQLite - SQLite wrapper module

=head1 SEE ALSO

=over 4

=item PyukiWiki CVS

L<@@CVSURL@@/PyukiWiki-Devel/lib/Nana/SQLite.pm>

=back

=head1 AUTHOR

=over 4

@@AUTHOR_NANAMI@@

@@AUTHOR_PYUKI@@

=back

=head1 LICENSE

@@LICENSE_NANAMI@@

=cut
