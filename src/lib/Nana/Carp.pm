######################################################################
# @@HEADER3_NANAMI@@
######################################################################

package	Nana::Carp;
use 5.005;
use strict;
use integer;
use Exporter;

use Nana::Code;

$carp::width=600;

$Nana::Mail::sendmail=<<EOM;
/var/qmail/bin/sendmail -t
/usr/sbin/sendmail -t
/usr/bin/sendmail -t
EOM

BEGIN {
	require Carp;
	*CORE::GLOBAL::die = \&Nana::Carp::err;		# comment
	$main::SIG{__DIE__} = \&Nana::Carp::err;
#	$main::SIG{__WARN__} = \&Nana::Carp::warn;
}

use vars qw($VERSION @ISA @EXPORTER @EXPORT_OK);
$VERSION = '0.1';
@EXPORT_OK = qw();

######################################################################

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

sub send {
	my(%hash)=@_;
	my $to=$hash{to};
	my $from=$hash{from};
	my $subject=$hash{subject};
	$subject="$::mail_head $::basehref" if($subject eq '');
	my $data=$hash{data};
	return 1 if($to eq '' || $from eq '');
	my $mail=<<EOM;
To: $to
From: $from
Subject: $subject
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit

$data
EOM
	&sendmail($mail);
}

sub getcaller {
	my $count=0;
    my @result;
	my $evalflag=0;
	while(1) {
		my @c=caller($count++);
		last if($#c < 1);
		next if($c[3] =~ /^Nana::Carp::getcaller/);
		$evalflag=$c[3] =~ /^Nana::Carp/ ? 0 : $evalflag ? $evalflag : $c[3] eq "(eval)" ? 2 : 1;
		push(@result, "$c[0]\t$c[1]\t$c[2]\t$c[3] $evalflag\t$evalflag");
	}
	my @null;
	push(@null, "-");
	return @null if($evalflag eq 2);
	return @result;
}

sub readsrc {
	my($file, $line, $htmlflg)=@_;
	my $buf;
	if($htmlflg) {
		return if($::type eq "compact");
		return if($::type eq "release");
	}

	if(open(R, $file)) {
		foreach(<R>) {
			$buf.=$_;
		}
		close(R);
		my @buf;
		my $src;
		my @buf=split(/\n/,$buf);
		for(my $i=1; $i < $line + 5; $i++) {
			if($i >= $line - 3 && $i <= $line + 3) {
				$src.="<strong>" if($i eq $line && $htmlflg);
				$src.="$i : " . $buf[$i-1];
				$src.="</strong>" if($i eq $line && $htmlflg);
				$src .="<br />" if($htmlflg);
				$src .= "\n" if(!$htmlflg);
			}
		}
		close(R);
		return $src;
	}
}

sub msg {
	my($mode, $msg, @args)=@_;

	my $body=<<EOM;
<h1>PyukiWiki Runtime $mode</h1>
<hr />
EOM
	foreach(split(/\n/,$msg)) {
		$body.=qq(<strong>$_</strong><br />);
	}
	$body.=<<EOM;
<table border="1" width="$carp::width">
<tr><th colspan="4" align="center">Trace Info</th></tr>
<tr><th align="center">Package</th><th align="center">File</th><th align="center">Line</th><th align="center">FUnction</th></tr>
EOM
	foreach my $a(@args) {
		foreach(split(/\n/,$a)) {
			my @l=split(/\t/,$_);
			$body.=<<EOM;
<tr><td>$l[0]</td><td>$l[1]</td><td align="right">$l[2]</td><td>$l[3]</td></tr>
EOM
			my $src=&readsrc($l[1], $l[2], 1);
			$body.=<<EOM if($src ne "");
<tr><td colspan="4">$src</td></tr>
EOM
		}
	}

	$body.=<<EOM;
</table>
<hr />
<div align="right">
<i>PyukiWiki version $::version pkgtype $::type</i><br />
<i>Build on $::build BuildNumber $::buildnumber</i><br />
<i>Server Admin $ENV{SERVER_ADMIN}</i><br />
EOM
	print <<EOM;
Status: 503 Service unavailable
Content-type: text/html

<html><body>
EOM
	print $body;
	print <<EOM;
</body></html>
EOM

}

sub mail {
	my($flg, $mode, $msg, @args)=@_;

	my $subject="[Wiki][Error] $::basehref";
	my $from=$::modifier_mail eq "" ? $ENV{SERVER_ADMIN} : $::modifier_mail;
	my $to;
	if($flg) {
		return if($::sendmail_crash_to_admin eq 0);
		$to=$::modifier_mail;
	} else {
		return if($::sendmail_crash_to_author eq 0);
		$to=$::sendmail_crash_to_author_mail;
	}
	$to=~s/ \(at\) /\@/g;
	$to=~s/ \(dot\) /\./g;

	return if($from eq "");
	return if($to eq "");

	my $hr="------------------------------------------------------------";

	my $body=<<EOM;
PyukiWiki Runtime $mode
$::basehref
$hr
EOM
	foreach(split(/\n/,$msg)) {
		$body.=qq($_\n);
	}
	$body.=<<EOM;
EOM

	foreach my $a(@args) {
		foreach(split(/\n/,$a)) {
			my @l=split(/\t/,$_);
			$body.=<<EOM;
$hr
Package :$l[0]
File    :$l[1]
Line    :$l[2]
Function:$l[3]
EOM

			my $src=&readsrc($l[1], $l[2], 0);
			$body.=<<EOM if($src ne "");

$src
EOM
		}
	}

	$body.=<<EOM;
Form Data
$hr
EOM
	foreach(sort keys %::form) {
		$body.="$_=$::form{$_}\n";
	}

	$body.=<<EOM;
Environment
$hr
EOM
	foreach(sort keys %ENV) {
		$body.="$_=$ENV{$_}\n";
	}

	my $os=ucfirst($^O);
	$os=~s/bsd/BSD/;

	$body.=<<EOM;
$hr
PyukiWiki version $::version pkgtype $::type
Build on $::build BuildNumber $::buildnumber
Server Admin $ENV{SERVER_ADMIN}
Wiki Admin $::modifier_mail
$os Perl $]
EOM

	$body=Nana::Code::conv(\$body, 'jis', $::defaultcode);

	&send(from=>$from, to=>$to, subject=>$subject, data=>$body);
}

sub _longmess {
    my $message = Carp::longmess();
    $message =~ s,eval[^\n]+(ModPerl|Apache)/(?:Registry|Dispatch)\w*\.pm.*,,s
        if exists $ENV{MOD_PERL};
    return $message;
}

sub ineval {
  (exists $ENV{MOD_PERL} ? 0 : $^S) || _longmess() =~ /eval [\{\']/m
}

sub realdie {
	CORE::die(@_);
}

sub err {
	my ($str,@rest) = @_ ? @_ 
					: $@ ? "$@\t...propagated" 
					: "Died"
					;

	realdie $str if ineval();
	return if($str=~/time/ && $str=~/out/);
	my @cal=&getcaller;
	return if($cal[0] eq "-");
	&msg("Error", $str, @cal);
	&mail(0,"Error", $str, @cal);
	&mail(1,"Error", $str, @cal);
	exit;
}

sub warn {
	return;
}

sub syntaxcheck {
	my ($s)=@_;
	my $perlpath=&perlpath;
	if(open(PIPE, "|$perlpath -c")) {
		print PIPE $s;
		close(PIPE);
		if($? eq 0) {
			return 0;
		}
	}
	return 1;
}

sub perlpath {
	my $perlpath;
	if(open(R,"$0")) {
		$perlpath=<R>;
		close(R);
		$perlpath=~s/#!//g;
		$perlpath=~s/-//g;
		$perlpath=~s/ //g;
		$perlpath=~s/[\r\n]//g;
		return $perlpath;
	}
}

1;
__END__

=head1 NAME

Nana::Carp - Error capture

=head1 SEE ALSO

=over 4

=item PyukiWiki CVS

L<@@CVSURL@@/PyukiWiki-Devel/lib/Nana/Carp.pm>

=back

=head1 AUTHOR

=over 4

@@AUTHOR_NANAMI@@

@@AUTHOR_PYUKI@@

=back

=head1 LICENSE

@@LICENSE_NANAMI@@

=cut
