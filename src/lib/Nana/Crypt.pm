######################################################################
# @@HEADER3_NANAMI@@
######################################################################

package	Nana::Crypt;
use 5.005;
use strict;
#use integer;
use Exporter;
use vars qw($VERSION);

$VERSION = '0.2';

sub encode {
	my ($str, $mode, $encode)=@_;
	my $mode=$mode eq '' ? $::CryptMethod : $mode;
	my $buf;
	if($mode eq "SHA512" || $mode eq "AUTO") {
		eval {
			&load_module("Digest::SHA");
			$buf=Digest::SHA::sha512_hex($str);
			my $v=$buf;
			$v=~s/[A-Fa-z]//g;
			$v=substr($v,0,2);
			for(my $i=0; $i<=$v+1; $i++) {
				$buf=&enc($buf);
				$buf=Digest::SHA::sha512_hex($buf);
			}
			if($encode eq "base64") {
 				$buf=Digest::SHA::sha512_base64($buf);
			}
		};
		return "{SHA512}$buf" if($buf ne "");
	} elsif($mode eq "SHA384" || $mode eq "AUTO") {
		eval {
			&load_module("Digest::SHA");
			$buf=Digest::SHA::sha384_hex($str);
			my $v=$buf;
			$v=~s/[A-Fa-z]//g;
			$v=substr($v,0,2);
			for(my $i=0; $i<=$v+1; $i++) {
				$buf=&enc($buf);
				$buf=Digest::SHA::sha384_hex($buf);
			}
			if($encode eq "base64") {
 				$buf=Digest::SHA::sha384_base64($buf);
			}
		};
		return "{SHA384}$buf" if($buf ne "");
	}
	if($mode eq "SHA256" || $mode eq "AUTO") {
		eval {
			&load_module("Digest::SHA");
			$buf=Digest::SHA::sha256_hex($str);
			my $v=$buf;
			$v=~s/[A-Fa-z]//g;
			$v=substr($v,0,2);
			for(my $i=0; $i<=$v+1; $i++) {
				$buf=&enc($buf);
				$buf=Digest::SHA::sha256_hex($buf);
			}
			if($encode eq "base64") {
 				$buf=Digest::SHA::sha256_base64($buf);
			}
		};
		return "{SHA256}$buf" if($buf ne "");
	}
	if($mode eq "SHA1" || $mode eq "AUTO") {
		eval {
			&load_module("Digest::SHA");
			$buf=Digest::SHA::sha1_hex($str);
			my $v=$buf;
			$v=~s/[A-Fa-z]//g;
			$v=substr($v,0,2);
			for(my $i=0; $i<=$v+1; $i++) {
				$buf=&enc($buf);
				$buf=Digest::SHA::sha1_hex($buf);
			}
			if($encode eq "base64") {
 				$buf=Digest::SHA::sha1_base64($buf);
			}
		};
		return "{SHA1}$buf" if($buf ne "");
	}
	if($mode eq "MD5" || $mode eq "AUTO") {
		eval {
			&load_module("Nana::MD5");
			$buf=Nana::MD5::md5_hex($str);
			my $v=$buf;
			$v=~s/[A-Fa-z]//g;
			$v=substr($v,0,2);
			for(my $i=0; $i<=$v+1; $i++) {
				$buf=&enc($buf);
				$buf=Nana::MD5::md5_hex($buf);
			}
			if($encode eq "base64") {
 				$buf=Nana::MD5::md5_base64($buf);
			}
		};
		return "{MD5}$buf" if($buf ne "");
	}
	if($mode eq "TEXT" || $mode eq "AUTO") {
		return "{TEXT}$str";
	}
	my ($sec, $min, $hour, $day, $mon, $year, $weekday) = localtime(time);
	my (@token) = ('0'..'9', 'A'..'Z', 'a'..'z');
	my $salt1 = $token[(time | $$) % scalar(@token)];
	my $salt2 = $token[($sec + $min*60 + $hour*60*60) % scalar(@token)];
	my $crypted = crypt($str, "$salt1$salt2");
	return "$crypted $salt1$salt2";
}

sub check {
	my ($str, $check)=@_;
	$str=~s/\t.*//g;

	$check=~/^\{(.+?)\}(.+?)$/;
	my $md=$1;
	my $chunk=$2;

	if($md eq "MD5") {
		&load_module("Nana::MD5");
		my $buf;
		$buf=Nana::MD5::md5_hex($str);
		my $v=$buf;
		$v=~s/[A-Fa-z]//g;
		$v=substr($v,0,2);
		for(my $i=0; $i<=$v+1; $i++) {
			$buf=&enc($buf);
			$buf=Nana::MD5::md5_hex($buf);
		}
		return ($buf eq $chunk) ? 1 : 0;
	} elsif($1 eq "SHA1") {
		&load_module("Digest::SHA");
		my $buf;
		$buf=Digest::SHA::sha1_hex($str);
		my $v=$buf;
		$v=~s/[A-Fa-z]//g;
		$v=substr($v,0,2);
		for(my $i=0; $i<=$v+1; $i++) {
			$buf=&enc($buf);
			$buf=Digest::SHA::sha1_hex($buf);
		}
		return ($buf eq $chunk) ? 1 : 0;
	} elsif($1 eq "SHA256") {
		&load_module("Digest::SHA");
		my $buf;
		$buf=Digest::SHA::sha256_hex($str);
		my $v=$buf;
		$v=~s/[A-Fa-z]//g;
		$v=substr($v,0,2);
		for(my $i=0; $i<=$v+1; $i++) {
			$buf=&enc($buf);
			$buf=Digest::SHA::sha256_hex($buf);
		}
		return ($buf eq $chunk) ? 1 : 0;
	} elsif($1 eq "SHA384") {
		&load_module("Digest::SHA");
		my $buf;
		$buf=Digest::SHA::sha384_hex($str);
		my $v=$buf;
		$v=~s/[A-Fa-z]//g;
		$v=substr($v,0,2);
		for(my $i=0; $i<=$v+1; $i++) {
			$buf=&enc($buf);
			$buf=Digest::SHA::sha384_hex($buf);
		}
		return ($buf eq $chunk) ? 1 : 0;
	} elsif($1 eq "SHA512") {
		&load_module("Digest::SHA");
		my $buf;
		$buf=Digest::SHA::sha512_hex($str);
		my $v=$buf;
		$v=~s/[A-Fa-z]//g;
		$v=substr($v,0,2);
		for(my $i=0; $i<=$v+1; $i++) {
			$buf=&enc($buf);
			$buf=Digest::SHA::sha512_hex($buf);
		}
		return ($buf eq $chunk) ? 1 : 0;
	} elsif($1 eq "TEXT") {
		return ($str eq $chunk) ? 1 : 0;
	} else {
		my ($try, $salt)=split(/ /,$check);
		if($salt ne "") {
			return (crypt($str, $salt) eq $try) ? 1 : 0;
		} else {
			return (crypt($str, "AA") eq $try) ? 1 : 0;
		}
	}
}

sub enc {
	my ($str)=@_;
	my $buf;
	for(my $i=0; $i < length($str); $i++) {
		$buf.=length($str);
		if($i % 2 == 0) {
			$buf.= uc substr($str, $i, 1);
		} else {
			$buf.= lc substr($str, $i, 1);
		}
		$buf.=length($str);
		$buf.=length($buf);
	}
	return $buf;
}

sub load_module {
	my $funcp = $::functions{"load_module"};
	return &$funcp(@_);
}

1;
__END__

=head1 NAME

Nana::Crypt - Multiple password encoder

=head1 SEE ALSO

=over 4

=item PyukiWiki CVS

L<@@CVSURL@@/PyukiWiki-Devel/lib/Nana/Crypt.pm>

=back

=head1 AUTHOR

=over 4

@@AUTHOR_NANAMI@@

@@AUTHOR_PYUKI@@

=back

=head1 LICENSE

@@LICENSE_NANAMI@@

=cut
