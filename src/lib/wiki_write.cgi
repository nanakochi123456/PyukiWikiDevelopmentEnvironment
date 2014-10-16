######################################################################
# @@HEADER1@@
######################################################################

=head1 NAME

wiki_write.cgi - This is PyukiWiki, yet another Wiki clone.

=head1 DESCRIPTION

PyukiWiki is yet another Wiki clone. Based on YukiWiki

PyukiWiki can treat Japanese WikiNames (enclosed with [[ and ]]).
PyukiWiki provides 'InterWiki' feature, RDF Site Summary (RSS),
and some embedded commands (such as [[# comment]] to add comments).

=head1 SEE ALSO

=over 4

=item PyukiWiki/Dev/Specification/wiki_write.cgi

L<@@BASEURL@@/PyukiWiki/Dev/Specification/wiki_write.cgi/>

=item PyukiWiki CVS

L<@@CVSURL@@/PyukiWiki-Devel/lib/wiki_write.cgi>

=back

=head1 AUTHOR

=over 4

@@AUTHOR_NEKYO@@

@@AUTHOR_NANAMI@@

@@AUTHOR_PYUKI@@

=back

=head1 LICENSE

@@LICENSE_NEKYO@@

=cut

=lang ja

=head2 set_info

=over 4

=item ������

&set_info(�ڡ���̾, ����, ����);


=item ����

�ʤ�

=item �����С��饤��

��

=item ����

InfoBase�˾�������ꤹ�롣

=back

=cut

sub _set_info {
	my ($page, $key, $value) = @_;
	if ($key eq $info_IsFrozen) {	# ���							# comment
		# ���Ѥ�													# comment
		if ($::database{$page} =~ /\n?#freeze\r?\n/) {
			if ($value == 0) {	# �����							# comment
				$::database{$page} =~ s/\n?#freeze\r?\n//g;
			}
		} elsif ($value == 1) {	# ���								# comment
			$::database{$page} = "#freeze\n" . $::database{$page}
				if($::database{$page} !~ /\n?#freeze\r?\n/);;
		}
		return;
	}
	my %info = map { split(/=/, $_, 2) } split(/\n/, $infobase{$page});
	$info{$key} = $value;
	my $s = '';
	for (keys %info) {
		$s .= "$_=$info{$_}\n";
	}
	$infobase{$page} = $s;
}

=lang ja

=head2 disablewords

=over 4

=item ������

&disablewords(�ڡ���̾�ޤ��ϥ�å�����, ��ʸ, �����å��Ѽ���, ��̤Τߤξ��1);

=item ����

�ʤ�

=item �����С��饤��

�Բ�

=item ����

�ػߥ�ɤ�¸�ߤ��뤫�����å��򤹤�

=back

=cut

sub _disablewords {
	my($page, $msg, $words, $flgonly)=@_;
	my $org=$msg;
	$words=~s/[\t\r\n\s]/\n/g;
	$msg=uc $msg;
	$words=uc $words;
	foreach(split(/\n/,$words)) {
		s/\./\\\./g;
		s/\//\\\//g;
		if($msg=~/$_/) {
			if($flgonly+0 eq 0) {
				&send_mail_to_admin($page, $::mail_head{deny}, "Deny word : $_\n--------\n$org");
				&skinex($page, &message($::resource{auth_writefobidden}), 0);
			}
			return 1;
		}
	}
	0;
}

=lang ja

=head2 do_write

=over 4

=item ������

&do_write(�ʤ� �ޤ��� FrozenWrite ��ʸ����, �񤭹��߸�ɽ������ڡ���);

=item ����

�ʤ�

=item �����С��饤��

�Բ�

=item ����

�ڡ�����񤭹��ߤ��������ؿ�

=back

=cut

sub _do_write {
	my($FrozenWrite, $viewpage, $mailhead)=@_;
	if (not &is_editable($::form{mypage})) {
		&skinex($::form{mypage}, &message($::resource{cantchange}), 0);
		return 0;
	}

	# �񤭹��߶ػߥ�����ɤ��ޤޤ�Ƥ�����				# comment
	return 0 if(&disablewords($::form{mypage}, $::form{mymsg}, $::disablewords));
	return 0 if(&disablewords($::form{mypage}, $::form{mymsg}, $::disablewords{$::lang}));


	# ���ڡ����Υץ饰���󤫤�ν񤭹��ߵ���				# comment
	if($FrozenWrite eq 'FrozenWrite') {
		return 0 if(&disablewords($::form{mypage}, $::form{mymsg}, $::disablewords_frozenwrite));
		return 0 if(&disablewords($::form{mypage}, $::form{mymsg}, $::disablewords_frozenwrite{$::lang}));

		if($::writefrozenplugin eq 1) {
			$::form{myfrozen} = &get_info($::form{mypage}, $info_IsFrozen);
		} elsif(&get_info($::form{mypage}, $info_IsFrozen)) {
			$::form{myfrozen}=1;
			if (&frozen_reject()) {
				$::form{cmd}=$::form{refercmd};
				$::form{mypreview} = "";
				&print_error($::resource{auth_writefobidden});
				return 1;
			}
		}
	} else {
		if (&frozen_reject) {
			$::form{cmd}=$::form{refercmd};
			$::form{mypreview} = "";
			return 1;
		}
	}

	return 0 if (&conflict($::form{mypage}, $::form{mymsg}));

	# 2005.11.2 pochi: ��ʬ�Խ����ǽ��					# comment
	if ($::form{mypart} =~ /^\d+$/o and $::form{mypart}) {
		$::form{mymsg} =~ s/\x0D\x0A|\x0D|\x0A/\n/og;
		$::form{mymsg} .= "\n" unless ($::form{mymsg} =~ /\n$/o);
		my @parts = &read_by_part($::form{mypage});
		$parts[$::form{mypart} - 1] = $::form{mymsg};
		$::form{mymsg} = join('', @parts);
	}

	# �����ִ�											# comment
	$::form{mymsg} =~ s/\&t;/\t/g;
	$::form{mymsg} =~ s/\&date;/&date($::date_format)/gex;
	$::form{mymsg} =~ s/\&time;/&date($::time_format)/gex;
	$::form{mymsg} =~ s/\&new;/\&new\{@{[&get_now]}\};/gx
		if(-r "$plugin_dir/new.inc.pl");
	if($::usePukiWikiStyle eq 1) {
		$::form{mymsg} =~ s/\&now;/&date($::now_format)/gex;
		$::form{mymsg} =~ s/\&(date|time|now);/\&$1\(\);/g;
		$::form{mymsg} =~ s/\&fpage;/$::form{mypage}/g;
		my $tmp=$::form{mypage};
		$tmp=~s/.*\///g;
		$::form{mymsg} =~ s/&page;/$tmp/g;
	}
	$::form{mymsg}=~s/\x0D\x0A|\x0D|\x0A/\n/g;

	# ���ѥ�ե��륿��									# comment
	&spam_filter($::form{mymsg}, 0, $::chk_wiki_uri_count)
		if ($::chk_wiki_uri_count >= 1);
	&spam_filter($::form{mymsg}, 1) if ($::chk_write_jp_only eq 1);

	&do_diff($::form{mypage}, $::form{mymsg});
	&do_backup($::form{mypage});

	# �񤭹���ư��										# comment
	if ($::form{mymsg}) {
		&do_write_page($::form{mypage}, $::form{mymsg}, $mailhead);
		&do_write_info($::form{mypage});
		if($::setting_cookie{savename}+0>0 && $::form{myname} ne '') {
			&plugin_setting_savename($::form{myname});
		}
		# �㤦�ڡ�����ɽ��������						# comment
		my $pushmypage=$::form{mypage};
		if($viewpage ne '') {
			$::form{mypage}=$viewpage
				if(&is_exist_page($viewpage));
		}
		# Location��ư									# comment
		if($::write_location eq 1) {
			&location("$::basehref?@{[&encode($::form{mypage})]}", 302, $::HTTP_HEADER);
			close(STDOUT);
			&exec_explugin_last;
			&close_db;
			exit;
		# �ڡ���ɽ��									# comment
		} else {
			&do_read();
		}
		$::form{mypage}=$pushmypage;
	# ���ư��											# comment
	} else {
		&do_delete_page($::form{mypage});
		&do_delete_info($::form{mypage});
		&update_recent_changes
			if($::form{mytouchjs} eq "on"
			  || ($::form{mytouch} eq "on" && !defined($::form{mytouchjs})));
		&close_db;
		&skinex($::form{mypage}, &message($::resource{deleted}), 0);
		&do_write_after($::form{mypage}, "Delete");
	}
	return 0;
}

=lang ja

=head2 do_diff

=over 4

=item ������

&do_diff(�ڡ���̾)

=item ����

�ʤ�

=item �����С��饤��

��

=item ����

�ڡ����κ�ʬ��񤭹��������ؿ�

=back

=cut

sub do_diff {
	my($page, $msg)=@_;

	&open_diff;
	my @msg1 = split(/\n/, $::database{$page});
	my @msg2 = split(/\n/, $msg);
	&load_module("Yuki::DiffText");
	$::diffbase{$page} = Yuki::DiffText::difftext(\@msg1, \@msg2);
	&close_diff;
}

=lang ja

=head2 do_backup

=over 4

=item ������

&do_backup(�ڡ���̾)

=item ����

�ʤ�

=item �����С��饤��

��

=item ����

�Хå����åפ�������������ؿ�

=back

=cut

sub _do_backup {#nocompact
	if($::useBackUp eq 1) {#nocompact
		my($page)=@_;#nocompact
		&getremotehost;#nocompact
		my $backuptime=">>>>>>>>>> " . time . " $ENV{REMOTE_ADDR} $ENV{REMOTE_HOST}\n";#nocompact
		&open_backup;#nocompact
		my $backuptext=$::backupbase{$page};#nocompact
		$backuptext.=$backuptime . $::database{$page} . "\n";#nocompact
		$backupbase{$page}=$backuptext#nocompact
			if($::database{$page} ne '');#nocompact
		&close_backup;#nocompact
	}#nocompact
}#nocompact

=lang ja

=head2 do_write_page

=over 4

=item ������

&do_write_page(�ڡ���̾, �񤭹�������, �����ƥ�ڡ�����1)

=item ����

�ʤ�

=item �����С��饤��

��

=item ����

�ڡ�����񤭹��������ؿ�

=back

=cut

sub _do_write_page {
	my($page, $msg, $flg, $mailhead)=@_;

	if(&is_exist_page($page)) {
		$::database{$page} = $msg;
		return if($flg eq 1);

		$mailhead=$mailhead eq "" ? $::mail_head{modify} : $mailhead;
		&send_mail_to_admin($page, $mailhead);
		&do_write_after($page, "Modify");
	} else {
		$::database{$page} = $msg;
		return if($flg eq 1);

		$mailhead=$mailhead eq "" ? $::mail_head{new} : $mailhead;
		&send_mail_to_admin($page, $mailhead);
		&do_write_after($page, "New");
	}
}

=lang ja

=head2 do_write_info

=over 4

=item ������

&do_write_info(�ڡ���̾)

=item ����

�ʤ�

=item �����С��饤��

��

=item ����

infobase��񤭹��������ؿ�

=back

=cut

sub _do_write_info {
	my($page)=@_;

	&open_info_db;
	&set_info($page, $::info_ConflictChecker, '' . localtime);
	&set_info($page, $::info_UpdateTime, time);
	if(&get_info($page, $::info_CreateTime)+0 eq 0) {
		&set_info($page, $::info_CreateTime, time);
	}
	if(defined($::form{mytouchjs})) {
		if($::form{mytouchjs} eq "on") {
			&set_info($page, $::info_LastModified, '' . localtime);
			&set_info($page, $::info_LastModifiedTime, time);
			&update_recent_changes;
		}
	} elsif($::form{mytouch} eq "on") {
		&set_info($page, $::info_LastModified, '' . localtime);
		&set_info($page, $::info_LastModifiedTime, time);
		&update_recent_changes;
	}

	&set_info($page, $::info_IsFrozen, 0 + $::form{myfrozen});
	&close_info_db;
}

=lang ja

=head2 do_delete_page

=over 4

=item ������

&do_delete_page(�ڡ���̾, �����ƥ�ڡ�����1)

=item ����

�ʤ�

=item �����С��饤��

��

=item ����

�ڡ����������������ؿ�

=back

=cut

sub _do_delete_page {
	my($page, $flg, $mailhead)=@_;

	delete $::database{$page};
	return if($flg eq 1);

	$mailhead=$mailhead eq "" ? $::mail_head{delete} : $mailhead;
	&send_mail_to_admin($page, $mailhead);
}

=lang ja

=head2 do_delete_info

=over 4

=item ������

&do_delete_info(�ڡ���̾)

=item ����

�ʤ�

=item �����С��饤��

��

=item ����

infobase�������������ؿ�

=back

=cut

sub _do_delete_info {
	my($page)=@_;

	&open_info_db;
	delete $infobase{$page};
	&close_info_db;
}

=lang ja

=head2 do_write_after

=over 4

=item ������

&do_write_after(�ڡ���̾, ��ư�򼨤�ʸ����);

=item ����

�ʤ�

=item �����С��饤��

�Բ�

=item ����

�ڡ�����񤭹��ߤθ�����򤹤���ߡ��ؿ�

=back

=cut

sub _do_write_after {
	my($page, $mode)=@_;
}

=lang ja

=head2 conflict

=over 4

=item ������

&conflict(�ڡ���̾, ��ʸ��);

=item ����

0:���ͤʤ� 1:����

=item �����С��饤��

��

=item ����

�ڡ��������ξ��ͤ򸡺����롣

=back

=cut

sub _conflict {
	my ($page, $rawmsg) = @_;
	if ($::form{myConflictChecker} eq &get_info($page, $::info_ConflictChecker)) {
		return 0;
	}
	%::resource = &read_resource("$::res_dir/conflict.$::lang.txt");

	#v0.2.1 read to resource
	my $content=$::reosource{conflict};

	my $body = &text_to_html($content);
	if (&exist_plugin('edit') == 1) {
		$body .= &plugin_edit_editform($rawmsg, $::form{myConflictChecker}, frozen=>0, conflict=>1);
	}

	&skinex($page, $body, 0);
	return 1;
}

=lang ja

=head2 update_recent_changes

=over 4

=item ������

�ʤ�

=item ����

�ʤ�

=item �����С��饤��

��

=item ����

RecentChanges�ڡ����򹹿����롣

=back

=cut


sub _update_recent_changes {
	my $update = "- @{[&get_now]} @{[&armor_name($::form{mypage})]} @{[&get_subjectline($::form{mypage})]}";
	my @oldupdates = split(/\r?\n/, $::database{$::RecentChanges});
	my @updates;
	foreach (@oldupdates) {
		/^\- \d\d\d\d\-\d\d\-\d\d \(...\) \d\d:\d\d:\d\d (.*?)\ \ \-/;	# date format.
		my $name = &unarmor_name($1);
		if (&is_exist_page($name) and ($name ne $::form{mypage})) {
			push(@updates, $_);
		}
	}
	unshift(@updates, $update) if (&is_exist_page($::form{mypage}));
	splice(@updates, $::maxrecent + 1);
	$::database{$::RecentChanges} = join("\n", @updates);
}

=lang ja

=head2 send_mail_to_admin

=over 4

=item ������

&send_mail_to_admin(�ڡ���̾,$mode);

=item ����

�ʤ�

=item �����С��饤��

��

=item ����

�����Ը�����wiki�ι������Ƥ�᡼�뤹�롣

=back

=cut

sub _send_mail_to_admin {
	my($page, $mode, $data)=@_;
	&load_module("Nana::Mail");
	Nana::Mail::toadmin($mode, $page, $data);
}

=lang ja

=head2 read_by_part

=over 4

=item ������

&read_by_part(�ڡ���̾);

=item ����

�ѡ��Ȥ��ȤΥڡ������Ƥ�����

=item �����С��饤��

��

=item ����

��ʬ�Խ��Τ���ˡ��ڤ�Ф������ڡ������Ƥ��֤���

=back

=cut

	# 2005.11.2 pochi: ��ʬ�Խ����ǽ��					# comment
sub _read_by_part {
	my ($page) = @_;
	return unless &is_exist_page($page);
	my @lines = map { $_."\n" }
			split(/\x0D\x0A|\x0D|\x0A/o, $::database{$page});
	my @parts = ('');
	foreach my $line (@lines) {
		if ($line =~ /^(\*{1,5})(.+)/) {
			push(@parts, $line);
		} else {
			$parts[$#parts] .= $line;
		}
	}
	return @parts;
}

=lang ja

=head2 frozen_reject

=over 4

=item ������

($::form{mypage});

=item ����

0:��뤵��Ƥ��ʤ����ޤ���ǧ�ںѤ� 1:��뤵��Ƥ��롣

=item �����С��饤��

��

=item ����

����ǧ�ڤ�Ԥʤ���

=back

=cut

sub _frozen_reject {
	my ($isfrozen) = &get_info($::form{mypage}, $info_IsFrozen);
	my ($willbefrozen) = $::form{myfrozen};
	my %auth;
	if (not $isfrozen and not $willbefrozen) {
		# You need no check.
		return 0;
	} else {
		%auth=&authadminpassword(form,"","frozen");
		return ($auth{authed} eq 0 ? 1 : 0);
	}
	return 0;
}

1;
