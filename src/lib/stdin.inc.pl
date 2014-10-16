######################################################################
# @@HEADER2_NANAMI@@
######################################################################
# This is extented plugin.
# To use this plugin, rename to 'stdin.inc.cgi'
######################################################################

use strict;

sub plugin_stdin_init {
	# コマンドライン処理
	for(my $i=0; defined($ARGV[$i]); $i++) {
		if($ARGV[$i]=~/=/) {
			my($l, $r)=split(/=/, $ARGV[$i]);
			$::form{$l}=$r;
		}
	}

	if(lc $::form{cmd} eq "stdinwrite") {
		my $query;
		while(<STDIN>) {
			$query.=$_;
		}
		if ($query =~ /&/) {
			my @querys = split(/&/, $query);
			foreach (@querys) {
				if (/([^=]*)=(.*)$/) {
					$::form{&decode($1)} = &decode($2);
				}
			}
		}

		# 内部置換											# comment
		$::form{mymsg} =~ s/\&t;/\t/g;
		$::form{mymsg} =~ s/\&date;/&date($::date_format)/gex;
		$::form{mymsg} =~ s/\&time;/&date($::time_format)/gex;
		$::form{mymsg} =~ s/\&new;/\&new\{@{[&get_now]}\};/gx
			if(-r "$::plugin_dir/new.inc.pl");
		if($::usePukiWikiStyle eq 1) {
			$::form{mymsg} =~ s/\&now;/&date($::now_format)/gex;
			$::form{mymsg} =~ s/\&_(date|time|now);/\&$1\(\);/g;
			$::form{mymsg} =~ s/\&fpage;/$::form{mypage}/g;
			my $tmp=$::form{mypage};
			$tmp=~s/.*\///g;
			$::form{mymsg} =~ s/&page;/$tmp/g;
		}
		$::form{mymsg}=~s/\x0D\x0A|\x0D|\x0A/\n/g;

		# 書き込み動作										# comment
		if ($::form{mymsg}) {
			if(&is_exist_page($::form{mypage})) {
				$::database{$::form{mypage}} = $::form{mymsg};
			} else {
				$::database{$::form{mypage}} = $::form{mymsg};
			}
			&open_info_db;
			&set_info($::form{mypage}, $::info_ConflictChecker, '' . localtime);
			&set_info($::form{mypage}, $::info_UpdateTime, time);
			if(&get_info($::form{mypage}, $::info_CreateTime)+0 eq 0) {
				&set_info($::form{mypage}, $::info_CreateTime, time);
			}
			if(defined($::form{mytouchjs})) {
				if($::form{mytouchjs} eq "on") {
					&set_info($::form{mypage}, $::info_LastModified, '' . localtime);
					&set_info($::form{mypage}, $::info_LastModifiedTime, time);
					&update_recent_changes;
				}
			} elsif($::form{mytouch} eq "on") {
				&set_info($::form{mypage}, $::info_LastModified, '' . localtime);
				&set_info($::form{mypage}, $::info_LastModifiedTime, time);
				&update_recent_changes;
			}

			&set_info($::form{mypage}, $::info_IsFrozen, 0 + $::form{myfrozen});
			&close_info_db;

			# Making diff										# comment
			&open_diff;
			my @msg1 = split(/\n/, $::database{$::form{mypage}});
			my @msg2 = split(/\n/, $::form{mymsg});
			&load_module("Yuki::DiffText");
			$::diffbase{$::form{mypage}} = Yuki::DiffText::difftext(\@msg1, \@msg2);
			&close_diff;

			# Making backup#nocompact							# comment
			if($::useBackUp eq 1) {#nocompact
				$ENV{REMOTE_ADDR}="127.0.0.1";
				&getremotehost;
				my $backuptime=">>>>>>>>>> " . time . " $ENV{REMOTE_ADDR} $ENV{REMOTE_HOST}\n";#nocompact
				&open_backup;#nocompact
				my $backuptext=$::backupbase{$::form{mypage}};#nocompact
				$backuptext.=$backuptime . $::database{$::form{mypage}} . "\n";#nocompact
				$::backupbase{$::form{mypage}}=$backuptext#nocompact
					if($::database{$::form{mypage}} ne '');#nocompact
				&close_backup;#nocompact
			}#nocompact
		# 削除動作											# comment
		} else {
			&open_info_db;
			&send_mail_to_admin($::form{mypage}, $::mail_head{delete});
			delete $::database{$::form{mypage}};
			delete $::infobase{$::form{mypage}};
			&update_recent_changes
				if($::form{mytouchjs} eq "on"
				  || ($::form{mytouch} eq "on" && !defined($::form{mytouchjs})));
			&close_info_db;
			&close_db;
#			&skinex($::form{mypage}, &message($::resource{deleted}), 0);
#			&do_write_after($::form{mypage}, "Delete");
		}
		exit;
	}
}
1;
__DATA__
sub plugin_stdin_setup {
	return(
		en=>'PyukiWiki stdin Plugin',
		override'=>'_db',
		url=>'@@BASEURL@@/PyukiWiki/Plugin/ExPlugin/stdin/'
	);
__END__

=head1 NAME

stdin.inc.pl - PyukiWiki Administrators Plugin

=head1 SYNOPSIS

Batch make pages  for PyukiWiki

=head1 DESCRIPTION

Batch make page from script

=head1 USAGE

rename to stdin.inc.cgi

echo "mypage=title&mymsg=wikipage" | perl index.cgi cmd=write

=head1 OVERRIDE

none

=head1 SEE ALSO

=over 4

=item PyukiWiki/Plugin/ExPlugin/stdin

L<@@BASEURL@@/PyukiWiki/Plugin/ExPlugin/stdin/>

=item PyukiWiki CVS

L<@@CVSURL@@/PyukiWiki-Devel/lib/stdin.inc.pl>

=back

=head1 AUTHOR

=over 4

@@AUTHOR_NANAMI@@

@@AUTHOR_PYUKI@@

=back

=head1 LICENSE

@@LICENSE_NANAMI@@

=cut
