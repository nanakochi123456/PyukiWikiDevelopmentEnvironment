######################################################################
# @@HEADER2_NEKYO@@
######################################################################
# 2012/02/27 v0.2 ��ĥ
# 2004/12/06 v0.2 �Զ�罤����
######################################################################

$vote::addvotestrings=100
	if(!defined($vote::addvotestrings));
$vote::classicvote=0
	if(!defined($vote::classicvote));

#
# �᡼��Υإå���
$vote::mailheader = "$::mail_head{vote}"
	if(!defined($vote::mailheader));

use strict;

sub plugin_vote_action
{
	my $lines = $::database{$::form{mypage}};
	my @lines = split(/\r?\n/, $lines);

	my $vote_no = 0;
	my $title = '';
	my $body = '';
	my $postdata = '';
	my @args = ();
	my $cnt = 0;
	my $write = 0;
	my $vote_str = '';

	my $addflg=0;

	if($vote::classicvote eq 0) {
		if($::form{mymsg} ne '') {
			$::form{mymsg}="" if(lc $::form{mymsg} eq "complete");
			&::spam_filter($::form{mymsg}, 2, $::chk_article_uri_count, $::chk_article_mail_count);
			foreach (@lines) {
				if (/^#vote\(([^\)]*)\)s*$/) {
					if (++$vote_no != $::form{vote_no}) {
						$postdata .= $_ . "\n";
						next;
					}
					@args = split(/,/, $1);
					$vote_str = '';
					foreach my $arg (@args) {
						$cnt = 0;
						if ($arg =~ /^(.+)\[(\d+)\]$/) {
							$arg = $1;
							$cnt = $2;
							if($arg eq &htmlspecialchars($::form{mymsg})) {
								$cnt++;
								$::form{mymsg}="";
							}
						}
						if(lc $arg eq "add") {
							$addflg=1;
							next;
						}
						my $e_arg = &encode($arg);
						my $vote_e_arg = "vote_" . $e_arg;

						if ($vote_str ne '') {
							$vote_str .= ',';
						}
						$vote_str .= $arg . '[' . $cnt . ']';
					}
					if($::form{mymsg} ne '') {
						if($vote_str eq '') {
							$vote_str = '#vote(' . $vote_str;
							$vote_str .=  &htmlspecialchars($::form{mymsg}) . '[1]';
						} else {
							$vote_str = '#vote(' . $vote_str;
							$vote_str .=  ',' . &htmlspecialchars($::form{mymsg}) . '[1]';
						}
					} else {
						$vote_str = '#vote(' . $vote_str;
					}
					$vote_str .= ",add" if($addflg eq 1);
					$vote_str .= ")\n";
					$postdata .= $vote_str;
					$write = 1;
				} else {
					$postdata .= $_ . "\n";
				}
			}

		} else {
			foreach (@lines) {
				if (/^#vote\(([^\)]*)\)s*$/) {
					if (++$vote_no != $::form{vote_no}) {
						$postdata .= $_ . "\n";
						next;
					}
					@args = split(/,/, $1);
					$vote_str = '';
					foreach my $arg (@args) {
						$cnt = 0;
						if ($arg =~ /^(.+)\[(\d+)\]$/) {
							$arg = $1;
							$cnt = $2;
						}
						my $e_arg = &encode($arg);
						my $vote_e_arg = "vote_" . $e_arg;

						if ($::form{$vote_e_arg} && ($::form{$vote_e_arg} eq $::resource{vote_plugin_votes})) {
							$cnt++;
						}
						if ($vote_str ne '') {
							$vote_str .= ',';
						}
						$vote_str .= $arg . '[' . $cnt . ']';
					}
					$vote_str = '#vote(' . $vote_str . ")\n";
					$postdata .= $vote_str;
					$write = 1;
				} else {
					$postdata .= $_ . "\n";
				}
			}
		}

		if ($write) {
			$::form{mymsg} = $postdata;
			$::form{mytouch} = 'on';
			&do_write("FrozenWrite", "", $vote::mailheader);
		} else {
			$::form{cmd} = 'read';
			&do_read;
		}
		&close_db;
		exit;
	} else {
		foreach (@lines) {
			if (/^#vote\(([^\)]*)\)s*$/) {
				if (++$vote_no != $::form{vote_no}) {
					$postdata .= $_ . "\n";
					next;
				}
				@args = split(/,/, $1);
				$vote_str = '';
				foreach my $arg (@args) {
					$cnt = 0;
					if ($arg =~ /^(.+)\[(\d+)\]$/) {
						$arg = $1;
						$cnt = $2;
					}
					my $e_arg = &encode($arg);
					my $vote_e_arg = "vote_" . $e_arg;

					if ($::form{$vote_e_arg} && ($::form{$vote_e_arg} eq $::resource{vote_plugin_votes})) {
						$cnt++;
					}
					if ($vote_str ne '') {
						$vote_str .= ',';
					}
					$vote_str .= $arg . '[' . $cnt . ']';
				}
				$vote_str = '#vote(' . $vote_str . ")\n";
				$postdata .= $vote_str;
				$write = 1;
			} else {
				$postdata .= $_ . "\n";
			}
		}
		if ($write) {
			$::form{mymsg} = $postdata;
			$::form{mytouch} = 'on';
			&do_write("FrozenWrite", "", $vote::mailheader);
		} else {
			$::form{cmd} = 'read';
			&do_read;
		}
		&close_db;
		exit;
	}
}

my $vote_no = 0;

sub plugin_vote_convert {
	$vote_no++;
	my @args = split(/,/, shift);
	return '' if (@args == 0);

	my $escapedmypage = &escape($::form{mypage});
	my $conflictchecker = &get_info($::form{mypage}, $::info_ConflictChecker);
	my $body;
	if($vote::classicvote eq 0) {
		my $total;
		my $totalvotes;
		my $complete=0;

		my $tdcnt = 0;
		my $cnt = 0;
		my ($link, $e_arg, $cls);

		foreach (@args) {
			if (/^(.+)\[(\d+)\]$/) {
				$total++ if(lc $1 ne "add");
				$totalvotes += $2+0 if($2+0 > 0);
				$complete=1 if(lc $_ eq "complete");
				$complete=1 if(lc $_ eq "end");
				$complete=1 if(lc $_ eq "close");
			} else {
				$total++ if(lc $_ ne "add");
				$complete=1 if(lc $_ eq "complete");
				$complete=1 if(lc $_ eq "end");
				$complete=1 if(lc $_ eq "close");
			}
		}

		$body = <<"EOD";
<form action="$::script" method="post">
 <div class="ie5">
 <table cellspacing="0" cellpadding="2" class="style_table" summary="vote">
  <tr>
   <td align="left" class="vote_label" style="padding-left:1em;padding-right:1em"><strong>$::resource{vote_plugin_choice}</strong>
    <input type="hidden" name="vote_no" value="$vote_no" />
    <input type="hidden" name="cmd" value="vote" />
    <input type="hidden" name="mypage" value="$escapedmypage" />
    <input type="hidden" name="myConflictChecker" value="$conflictchecker" />
    <input type="hidden" name="mytouch" value="on" />
   </td>
   <td align="center" class="vote_label"><strong>$::resource{vote_plugin_votecount}</strong></td>
   <td align="center" class="vote_label"><strong>$::resource{vote_plugin_votecount}</strong></td>
@{[$complete eq 0 ? qq(   <td align="center" class="vote_label"><strong>$::resource{vote_plugin_votes}</strong></td>) : '']}
  </tr>
EOD


		foreach (@args) {
			$cnt = 0;

			if (/^(.+)\[(\d+)\]$/) {
				$link = $1;
				$cnt = $2;
			} else {
				$link = $_;
			}
			$e_arg = &encode($link);
			$cls = ($tdcnt++ % 2)  ? 'vote_td1' : 'vote_td2';
			next if(lc $link eq "complete");
			if(lc $link eq "add") {
				$body .= <<"EOD" if($complete eq 0);
  <tr>
   <td align="left" class="$cls" style="padding-left:1em;padding-right:1em;" colspan="3">
	$::resource{vote_plugin_addinput}:<input type="text" name="mymsg" value="" maxlength="$vote::addvotestrings" />
	</td>
   <td align="right" class="$cls">
    <input type="submit" name="vote_$e_arg" value="$::resource{vote_plugin_votes}" class="submit" />
   </td>
  </tr>
EOD
			} else {
				$body .= <<"EOD";
  <tr>
   <td align="left" class="$cls" style="padding-left:1em;padding-right:1em;">$link</td>
   <td align="right" class="$cls">$cnt</td>
   <td align="right" class="$cls">@{[$totalvotes+0 eq 0 ? '-' : sprintf("%.1f%",$cnt / $totalvotes * 100)]}</td>
@{[$complete eq 0 ? qq(<td align="right" class="$cls"><input type="submit" name="vote_$e_arg" value="$::resource{vote_plugin_votes}" class="submit" /></td>) : '']}
  </tr>
EOD
			}
		}

		$cls = ($tdcnt++ % 2)  ? 'vote_td1' : 'vote_td2';
		$body .= <<"EOD";
  <tr>
   <td align="left" class="$cls" style="padding-left:1em;padding-right:1em;">$::resource{vote_plugin_totalvote}</td>
   <td align="right" class="$cls">@{[$totalvotes+0]}</td>
   <td align="right" class="$cls">&nbsp;</td>
@{[$complete eq 0 ? qq(   <td align="right" class="$cls">&nbsp;</td>) : '']}
  </tr>
EOD
	} else {
		$body = <<"EOD";
<form action="$::script" method="post">
 <div class="ie5">
 <table cellspacing="0" cellpadding="2" class="style_table" summary="vote">
  <tr>
   <td align="left" class="vote_label" style="padding-left:1em;padding-right:1em"><strong>$::resource{vote_plugin_choice}</strong>
    <input type="hidden" name="vote_no" value="$vote_no" />
    <input type="hidden" name="cmd" value="vote" />
    <input type="hidden" name="mypage" value="$escapedmypage" />
    <input type="hidden" name="myConflictChecker" value="$conflictchecker" />
    <input type="hidden" name="mytouch" value="on" />
   </td>
   <td align="center" class="vote_label"><strong>$::resource{vote_plugin_votes}</strong></td>
  </tr>
EOD

		my $tdcnt = 0;
		my $cnt = 0;
		my ($link, $e_arg, $cls);
		foreach (@args) {
			$cnt = 0;

			if (/^(.+)\[(\d+)\]$/) {
				$link = $1;
				$cnt = $2;
			} else {
				$link = $_;
			}
			$e_arg = &encode($link);
			$cls = ($tdcnt++ % 2)  ? 'vote_td1' : 'vote_td2';
			$body .= <<"EOD";
  <tr>
   <td align="left" class="$cls" style="padding-left:1em;padding-right:1em;">$link</td>
   <td align="right" class="$cls">$cnt&nbsp;&nbsp;
    <input type="submit" name="vote_$e_arg" value="$::resource{vote_plugin_votes}" class="submit" />
   </td>
  </tr>
EOD
		}
	}
	$body .= <<"EOD";
 </table>
 </div>
</form>
EOD
	return $body;
}
1;
__END__

=head1 NAME

vote.inc.pl - PyukiWiki Plugin

=head1 SYNOPSIS

 #vote(choice1,choice2,choice3[votes],[[WikiName][votes],...)
 #vote(choice1,choice2,choice3[votes],[[WikiName][votes],...,add)
 #vote(choice1,choice2,choice3[votes],[[WikiName][votes],...,complete)

=head1 DESCRIPTION

The form with which the choice and the vote button were located in a line is displayed.

=head1 USAGE

=over 4

=item add

Visitors to be able to enter a free choice.

=item complete

To exit the voting.

=back

=head1 SEE ALSO

=over 4

=item PyukiWiki/Plugin/Standard/vote

L<@@BASEURL@@/PyukiWiki/Plugin/Standard/vote/>

=item PyukiWiki CVS

L<@@CVSURL@@/PyukiWiki-Devel/plugin/vote.inc.pl>

=back

=head1 AUTHOR

=over 4

@@AUTHOR_NEKYO@@

@@AUTHOR_PYUKI@@

=back

=head1 LICENSE

@@LICENSE_NEKYO@@

=cut
