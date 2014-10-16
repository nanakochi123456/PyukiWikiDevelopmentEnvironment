#!/usr/bin/perl
$|=1;
use Net::DNS;
use HTTP::Lite;
use Jcode;

my @list=(
	"mobile",
	"sp",
	"msnlive",
	"freemail",
	"disposable"
);

open(W, ">./resource/login_mailaddr.txt")||die;
print W <<EOM;
#
# PyukiWiki Resource file
# \@\@PYUKIWIKIVERSION\@\@
# \$Id\$
#

EOM
mkdir("temp");
foreach my $f(@list) {
	open(W, ">>./resource/login_mailaddr.txt")||die;
	my @l=();
	open(R, "./build/mail_$f.txt")||die;
	foreach my $l(<R>) {
		next if($l=~/^#/);
		chomp $l;
		my ($mm, $dm)=split(/\|/,$l);
		if(-r "temp/$mm.domaincache") {
			my $flg=0;
			foreach(@l) {
				$flg=1 if($_ eq $l);
			}
			push(@l, $l) if($flg eq 0);
			print STDERR "$f - \@$l found (cached)\n";
			open(WW, ">temp/$mm.domaincache");
			print WW "found";
			close(WW);
		} else {
#next;
			$SIG{ALRM}=sub{die "timeout";};
			alarm(1);
			my @mx;
			eval {
				@mx=Net::DNS::mx($mm);
			};
			if($@) {
				print STDERR "$f - \@$l timeout\n";
			} elsif($#mx>=0) {
				if($dm eq "") {
					$t=0;
					$SIG{ALRM}=sub{ die "timeout2"};
					alarm(1);
					my $body;
					eval {
						my $http=new HTTP::Lite;
						$http->method("GET");
						$http->http11_mode(1);
						$req=$http->request("http://$mm/");
						if($req eq 200) {
							$stat=0;
							$body=$http->body();
						} else {
							$stat=1;
							$body=""
						}
					};
					if($@) {
						print STDERR "$f - \@$l http timeout\n";
					} else {
						if($body=~/Hello/ && $body=~/[Ww]orld/) {
							print STDERR "$f - \@$l for sale\n";
							open(WW, ">temp/$mm.forsale");
							print WW "found";
							close(WW);
							next;
						} elsif($body=~/For/ && $body=~/Sale/) {
							print STDERR "$f - \@$l for sale\n";
							open(WW, ">temp/$mm.forsale");
							print WW "found";
							close(WW);
							next;
						} else {
							my $flg=1;
							$body=lc Jcode->new($body)->euc;
							$teststring="–³—¿,free,mail";
							$teststring=Jcode->new($teststring)->euc;
							foreach(split(/,/,$teststring)) {
								if($body=~/$_/) {
									$flg=1;
								}
							}
							if($flg) {
								my $flg=0;
								foreach(@l) {
									$flg=1 if($_ eq $l);
								}
								push(@l, $l) if($flg eq 0);
								print STDERR "$f - \@$l found\n";
								open(WW, ">temp/$mm.domaincache");
								print WW "found";
								close(WW);
								next;
							}
						}
						print STDERR "$f - \@$l not freemail\n";
					}
				} else {
					my $flg=0;
					foreach(@l) {
						$flg=1 if($_ eq $l);
					}
					push(@l, $l) if($flg eq 0);
					print STDERR "$f - \@$l found\n";
					open(WW, ">temp/$mm.domaincache");
					print WW "found";
					close(WW);
				}
			} else {
				print STDERR "$f - \@$l not found\n";
			}
		}
	}
	@l=sort @l;
	print W "login_$f=\\\n";
	foreach(@l) {
		print W "$_\\\n";
	}
	print W "\n";
	close(R);
	close(W);
}

