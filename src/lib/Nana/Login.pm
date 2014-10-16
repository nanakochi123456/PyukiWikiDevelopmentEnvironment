######################################################################
# @@HEADER3_NANAMI@@
######################################################################

package	Nana::Login;
use 5.005;
use strict;
use integer;
use Exporter;
use vars qw($VERSION @ISA @EXPORTER @EXPORT_OK);
@EXPORT_OK = qw(lf ef ln);
use Nana::Crypt;
use Nana::RemoteHost;
use Nana::MD5 qq(md5_hex);

$VERSION = '0.1';

$login::logincmd_prefix="l";
$login::logincmd_errprefix="eg";

%login::logincmds=(
	service=>"s",
	openid=>"oi",
	oauth=>"oa",
	url=>"r",
	session=>"x",
	sessionpass=>"z",
	id=>"i",
	userid=>"u",
	password=>"p",
	pass1=>"s7",
	pass2=>"a2",,
	passenc=>"pe",
	passtoken=>"pt",
	nickname=>"n",
	sex=>"xe",
	email=>"m",
	emailchk=>"k",
	emailchk1=>"i5",
	emailchk2=>"h2",
	femail=>"fm",
	femailchk1=>"i3",
	femailchk2=>"h8",
	birthdayy=>"bm",
	birthdaym=>"yd",
	birthdayd=>"dm",
	expire=>"ix",
	confirm=>"o",
	generate=>"g",
	token=>"t",
	submit=>"0z",
	submit2=>"1z",
	back=>"1s",
	word1=>"kf",
	word2=>"zb",
	word3=>"ig",
);

sub lf {
	my($name)=@_;
	return $login::logincmd_prefix . $login::logincmds{$name} . "_$name";
}

%login::efbak;

sub ef {
	my($name)=@_;
	return $login::logincmd_errprefix . $login::logincmds{$name} . "_$name";
}

sub ln {
	my($name)=@_;
	return $login::logincmds{$name} . "_$name";
}

sub readsession {
	my($db, $session)=@_;
	&_dataread($db, $session);
}

sub searchsession {
	my($db, $name, $value)=@_;
	foreach (keys $db) {
		my %tmp=&_dataread($db, $_);
$::debug.="\$_=$_\ntmp{db}=$tmp{_db}\ntmp{$name}=$tmp{$name}\nvalue=$value\n";
		return $tmp{_db} if($tmp{$name} eq $value);
	}
	return undef;
}

sub hostinfo {
	my $hostinfo="$ENV{REMOTE_ADDR}\t$ENV{REMOTE_HOST}\t$ENV{HTTP_USER_AGENT}";
return $hostinfo;
	if(&load_module("aNana::NetIP")) {
		my $t=new Nana::NetIP(addr=>$ENV{REMOTE_ADDR});
		$hostinfo.=qq(\tnetname=@{[$t->get("netname")]},descr=@{[$t->get("descr")]},country=@{[$t->get("country")]},as=@{[$t->get("as")]},city=@{[$t->get("city")]},region_name=@{[$t->get("region_name")]});
		$hostinfo.=qq(\tcountry=@{[$t->get("country")]},mobile=@{[$t->get("mobile")]});
	}
	$hostinfo;
}

sub writesession {
	my($db, $session, %s)=@_;
#$::debug.="w $session\n";
	my %hash=&_dataread($db, $session);
	$hash{"counter"}++;
	&load_module("Nana::RemoteHost");
	Nana::RemoteHost::get();
	my $hostinfo=&hostinfo;
	$hash{"_" . time}=$hostinfo;
	$hash{"_"}=$hostinfo
		if($hash{"_"} eq "");

	$hash{"_update"}=time;
	$hash{"_create"}=time
		if($hash{"_create"} eq "");

	foreach(keys %s) {
		$hash{$_}=$s{$_};
	}
	foreach(keys %hash) {
		if($hash{$_} eq "") {
			delete $hash{$_};
			$hash{$_}="";
		}
	}

	&_datawrite($db, $session, %hash);
}

sub createsession {
	my($db, $session)=@_;
	&_datacreate($db, $session);
}

sub existsession {
	my($db, $session)=@_;
	&_dataexist($db, $session);
}


sub readuser {
	my($db, $user, $admin)=@_;
	&_dataread($db, $user);
}

sub writeuser {
	my($db, $user, %s)=@_;
	my %hash=&_dataread($db, $user);

	$hash{"_update"}=time;
	$hash{"_create"}=time
		if($hash{"_create"} eq "");

	foreach(keys %s) {
		$hash{$_}=$s{$_};
	}
	foreach(keys %hash) {
		if($hash{$_} eq "") {
			delete $hash{$_};
			$hash{$_}="";
		}
	}

	&_datawrite($db, $user, %hash);
}

sub logindo {
	my($sessiondb, $userdb, $user, $passwd)=@_;
	if(&existuser($userdb, $user)) {
		my %tmpuser=&readuser($userdb, $user);
		my $session=$tmpuser{session};
		if(&existsession($sessiondb, $session)) {
			my %tmpsession=&readsession($sessiondb, $session);
			return "nouser" if($tmpsession{confirm} ne "");
			my $userid=$tmpsession{userid};
			&load_module("Nana::Crypt");
			if(Nana::Crypt::check($passwd, $tmpsession{password})) {
				return $userid;
			} else {
				return "nopasswd";
			}
		} else {
			return "nosession";
		}
	} else {
		return "nouser";
	}
}

sub createuser {
	my($db, $user)=@_;
	&_datacreate($db, $user);
}

sub existuser {
	my($db, $user)=@_;
	&_dataexist($db, $user);
}

sub deleteuser {
	my($db, $key)=@_;
	my $hash=substr($key, 0, 63);
	delete $$db{$hash};
}

sub deletesession {
	my($db, $key)=@_;
	my $hash=substr($key, 0, 63);
	delete $$db{$hash};
}

sub _dataread {
	my($tie, $key)=@_;
	my $hash=substr($key, 0, 63);
	return if($hash eq "");
	if(exists ($$tie{$hash})) {
		my %hash;
		foreach(split(/\n/,$$tie{$hash})) {
			my($name,$value)=split(/=/,$_);
			$hash{$name}=$value;
		}
#		if($hash{_db} eq $key) {
			return %hash;
#		}
	}
}

sub _datawrite {
	my($tie, $key, %s)=@_;
	my $hash=substr($key, 0, 63);
	return if($hash eq "");
	if(exists ($$tie{$hash})) {
		my %hash;
		foreach(split(/\n/,$$tie{$hash})) {
			my($name,$value)=split(/=/,$_);
			$hash{$name}=$value;
		}
		if($hash{_db} eq $key) {
			foreach(keys %s) {
				$hash{$_}=$s{$_};
			}
#			foreach(keys %s) {
#				if($hash{$_} eq "") {
#					delete $hash{$_};
#				}
#			}
			my $data;
			foreach(sort keys %hash) {
				$data.=qq($_=$hash{$_}\n);
			}
			$$tie{$hash}=$data;
			return 1;
		}
	}
	return 0;
}

sub _datacreate {
	my($tie, $key)=@_;
	my $hash=substr($key, 0, 63);

	return if($hash eq "");
	if(!exists($$tie{$hash})) {
		$$tie{$hash}=<<EOM;
_db=$key
_lang=$::lang
_kanjicode=$::kanjicode
_charset=$::charset
_create=@{[time]}
EOM
		$hash;
	}
}

sub _dataexist {
	my($tie, $key)=@_;
	$key=substr($key, 0, 63);
	return exists($$tie{$key});
}

sub load_module {
	my $funcp = $::functions{"load_module"};
	return &$funcp(@_);
}

1;
