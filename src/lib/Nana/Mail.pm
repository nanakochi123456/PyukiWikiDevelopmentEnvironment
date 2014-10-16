######################################################################
# @@HEADER3_NANAMI@@
######################################################################
# require perl version >= 5.8.1
######################################################################

package	Nana::Mail;
use 5.8.1;
use strict;
use integer;
use vars qw($VERSION);
$VERSION = '0.7';

# sendmail¥Ñ¥¹¸¡º÷¸õÊä
$Nana::Mail::sendmail=<<EOM;
/var/qmail/bin/sendmail -t
/usr/sbin/sendmail -t
/usr/bin/sendmail -t
EOM

# gpg¥Ñ¥¹¸¡º÷¸õÊä
$Nana::Mail::gpg=<<EOM;
/usr/bin/gpg --always-trust
/usr/local/bin/gpg --always-trust
/usr/bin/gpg
/usr/local/bin/gpg
EOM

######################################################################

use Nana::Code;

sub utf8mail {
	my $flg=0;
	if($::send_utf8_mail ne 0) {
		if(&load_module("MIME::Base64")) {
			return 1;
		}
	}
	return 0;
}

sub mime_conv {
	my($str,$code)=@_;
	if (&utf8mail) {
		return "" if($str eq "");
		$str=Nana::Code::conv(\$str, "utf8", $code);
		$str=MIME::Base64::encode_base64($str, "");
		$str='=?utf-8?B?' . $str . '?=';
	} else {
		$str=Nana::Code::conv(\$str, "jis", $code);
		$str=Nana::Code::mime_encode($str);
	}
	return $str;
}

sub mime_conv_body {
	my($data,$code)=@_;
	if (&utf8mail) {
		$data=Nana::Code::conv(\$data, "utf8", $code);
		$data=MIME::Base64::encode_base64($data);
	} else {
		$data=Nana::Code::conv(\$data, "jis", $code);
	}
	return $data;
}

sub send {
	my(%hash)=@_;
	$::send_utf8_mail=0 if($::modifier_pgp_name ne "");
	my $pgpflg=1 if($::modifier_pgp_name ne "");
	$pgpflg=0 if($hash{pgp} eq "0");
	my $to=$hash{to};
	my $to_name=&mime_conv($hash{to_name},$::defaultcode);
	my $from=$hash{from};
	my $from_name=&mime_conv($hash{from_name},$::defaultcode);
	my $subject=$hash{subject};
	$subject="$::mail_head $::basehref" if($subject eq '');
	$subject=&mime_conv($subject,$::defaultcode);
	my $data=&mime_conv_body($hash{data},$::defaultcode);
	return 1 if($to eq '' || $from eq '');
	$to=qq($to_name\n <$to>) if($to_name ne '');
	$from=qq($from_name\n <$from>) if($from_name ne '');
	my $mail;
	my $part=time;

	if (&utf8mail) {
		$mail=<<EOM;
To: $to
From: $from
Subject: $subject
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_Part_$part"
Content-Transfer-Encoding: 7bit

------=_Part_$part
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64

$data
------=_Part_$part--
EOM
	} elsif($pgpflg) {
		my $enc=&pgp($data);
		return if($enc eq "");
		$mail=<<EOM;
To: $to
From: $from
Subject: $subject
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit

$enc
EOM
	} else {
		$mail=<<EOM;
To: $to
From: $from
Subject: $subject
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit

$data
EOM
	}
	&sendmail($mail);
}

sub sendmail {
	my($mail)=@_;
	foreach(split(/\n/,"$::modifier_sendmail\n$Nana::Mail::sendmail")) {
		my($exec,$opt1, $opt2, $opt3, $opt4, $opt5)=split(/ /,$_);
		next if($exec eq "");
		if(-f $exec) {
			open(MAIL, "| $exec $opt1 $opt2 $opt3 $opt4 $opt5");
			print MAIL $mail;
			close(MAIL);
			return 0;
		}
	}
	print "no";
	return 1
}

sub pgp {
	my($mail)=@_;
	&load_module("Nana::Temp");
	my($fh, $cachefile)=Nana::Temp::tempfile(
		"", DIR=>$::cache_dir, SUFFIX=>".pgptemp");

	foreach(split(/\n/,"$::modifier_pgp\n$Nana::Mail::pgp")) {
		my($exec,$opt1, $opt2, $opt3, $opt4, $opt5)=split(/ /,$_);
		next if($exec eq "");
		if(-f $exec) {
			open(W, "| $exec -ear '$::modifier_pgp_name' $opt1 $opt2 $opt3 $opt4 $opt5 > $cachefile 2>/dev/null");
			print W $mail;
			close(W);

			my $buf;
			open(R, "$cachefile") || die "Can't open $cachefile";
			foreach(<R>) {
				$buf.=$_;
			}
			close(R);
			unlink($cachefile);
			return $buf;
		}
	}
	print "no";
	return "";
}

sub toadmin {
	my($mode,$page,$data)=@_;
	$data=$::database{$page} if($data eq '');
	$mode=$::mail_head_plus eq "" ? $mode : $::mail_head_plus;

	my $getremotehost = $::functions{"getremotehost"};
	&$getremotehost;

	my $message = <<"EOD";
--------
WIKI = $::modifier_rss_title
MODE = $mode
REMOTE_ADDR = $ENV{REMOTE_ADDR}
REMOTE_HOST = $ENV{REMOTE_HOST}
--------
$page
--------
$data
--------
EOD

	&send(to=>$::modifier_mail, from=>$::modifier_mail,
		  subject=>"$::mail_head$mode $::basehref", data=>$message);
}

sub load_module {
	my $funcp = $::functions{"load_module"};
	return &$funcp(@_);
}
1;
__END__

=head1 NAME

Nana::Mail - Mail send module

=head1 SEE ALSO

=over 4

=item PyukiWiki CVS

L<@@CVSURL@@/PyukiWiki-Devel/lib/Nana/Mail.pm>

=back

=head1 AUTHOR

=over 4

@@AUTHOR_NANAMI@@

@@AUTHOR_PYUKI@@

=back

=head1 LICENSE

@@LICENSE_NANAMI@@

=cut
