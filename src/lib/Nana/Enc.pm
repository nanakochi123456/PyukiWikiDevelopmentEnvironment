######################################################################
# @@HEADER3_NANAMI@@
######################################################################

package	Nana::Enc;
use 5.005;
use strict;
use integer;
use Exporter;
use vars qw($VERSION);
$VERSION = '0.2';

######################################################################

sub maketoken {
	my $js;
	if($::Token eq '') {
		my (@token) = ('0'..'9', 'A'..'Z', 'a'..'z');
		$::Token="";
		my $add=0;
		for(my $i=0; $i<16;) {
			my $token;
			$token=$token[(time + $add++ + $i + int(rand(62))) % 62];
				 # 62 is scalar(@token)								# comment
			if($::Token!~/$token/) {
				$::Token.=$token;
				$i++;
			}
		}
	}
	$js=qq(var cs = "$::Token";\n);
	return $js;
}

sub iscryptpass {
	if($::Use_CryptPass) {
		if($::Token eq '') {
			$::IN_JSHEADVALUE.=&maketoken;
			my $funcp = $::functions{"jscss_include"};
			$::IN_HEAD.=&$funcp("passwd");
		}
		return 1;
	}
	return 0;
}

# pure code of http://ninja.index.ne.jp/~toshi/soft/untispam.shtml	# comment

sub decode {
	my($passwd,$enc,$token)=@_;
	my $dec;

	if($passwd eq '' && $enc ne '' && $token ne '' && &iscryptpass) {

		for(my $i=0; $i<length($enc); $i+=4) {
			my $dif=index($token,substr($enc,$i,1)) * length($token) + index($token,substr($enc,$i+1,1));
			my $c=index($token,substr($enc,$i+2,1));
			my $d=$c * length($token) + index($token,substr($enc,$i+3,1)) - $dif;
			$dec=$dec . chr($d);
		}
		return $dec;
	}
	if($passwd=~/\t/) {
		my($pass, $t)=split(/\t/, $passwd);
		return $pass if(time - 86400 > $t+0 && $t+0 && time+86400);
		return "";
	}
#	return "";
	return $passwd;
}

# reverse code of http://ninja.index.ne.jp/~toshi/soft/untispam.shtml	# comment

sub encode {
	my($str, $token) = @_;
	my($i, $dd, $res, $dif );
	my $enc_list = $token;
	for( $i = 0 ; $i < length( $str ) ; $i ++ ) {
		$dif = (int(rand(127))+$i)%127;
		$res .= substr($enc_list,$dif/0x10,1).substr($enc_list,$dif%0x10,1);
		$dd = ord(substr($str,$i,1))+$dif;
		$res .= substr($enc_list,$dd/0x10,1).substr($enc_list,$dd%0x10,1);
	}
	return( $res );
}


1;
__END__

=head1 NAME

Nana::Enc - Simple encoder, decoder

=head1 SEE ALSO

=over 4

=item PyukiWiki CVS

L<@@CVSURL@@/PyukiWiki-Devel/lib/Nana/Enc.pm>

=item The measure against a collection contractor (an automatic collection program and robot) of a mail address

L<http://ninja.index.ne.jp/~toshi/soft/untispam.shtml>

=back

=head1 AUTHOR

=over 4

@@AUTHOR_NANAMI@@

=item Toshi(NINJA104)

L<http://ninja.index.ne.jp/~toshi/>

@@AUTHOR_PYUKI@@

=back

=head1 LICENSE

@@LICENSE_NANAMI@@

=cut
