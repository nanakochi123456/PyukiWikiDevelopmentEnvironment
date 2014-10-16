######################################################################
# @@HEADER1@@
######################################################################

=head1 NAME

wiki_db.cgi - This is PyukiWiki, yet another Wiki clone.

=head1 SEE ALSO

=over 4

=item PyukiWiki/Dev/Specification/wiki_db.cgi

L<@@BASEURL@@/PyukiWiki/Dev/Specification/wiki_db.cgi/>

=item PyukiWiki CVS

L<@@CVSURL@@/PyukiWiki-Devel/lib/wiki_db.cgi>

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

=head2 open_db

=over 4

=item 入力値

なし

=item 出力

なし

=item オーバーライド

可

=item 概要

データベースを開く。

=back

=cut

sub _open_db {
	&dbopen($::data_dir,\%::database);
}


=lang ja

=head2 open_info_db

=over 4

=item 入力値

なし

=item 出力

なし

=item オーバーライド

可

=item 概要

infoデータベースを開く。

=back

=cut

sub _open_info_db {
	&dbopen($::info_dir,\%::infobase);
}

=lang ja

=head2 dbopen

=over 4

=item 入力値

&dbopen(dir, \%db [, extention]);

=item 出力

なし

=item オーバーライド

可

=item 概要

データベースを開く。

=back

=cut

sub _dbopen {
	my($dir,$db,$ext)=@_;
	$::db_extention{$dir}=$ext;
	$::db_extention{$dir}="txt" if($ext eq "");
	if ($modifier_dbtype eq 'dbmopen') {
		dbmopen(%$db, $dir, 0666) or &print_error("(dbmopen) $dir");
	} elsif($modifier_dbtype eq 'AnyDBM_File') {
		tie(%$db, "AnyDBM_File", $dir, O_RDWR|O_CREAT, 0666) or &print_error("(tie AnyDBM_File) $dir");
	} else {
		tie(%$db, "$modifier_dbtype", $dir) or &print_error("(tie $modifier_dbtype) $dir");
	}
	return %db;
}

=lang ja

=head2 dbopen_gz

=over 4

=item 入力値

&dbopen_gz(dir, \%db [, extention]);

=item 出力

なし

=item オーバーライド

可

=item 概要

gzip圧縮データベースを開く。

=back

=cut

sub _dbopen_gz {#nocompact
	my($dir,$db,$ext)=@_;#nocompact
	$::db_extention{$dir}=$ext;#nocompact
	$::db_extention{$dir}="txt" if($ext eq "");#nocompact
	if ($modifier_dbtype eq 'dbmopen') {#nocompact
		dbmopen(%$db, $dir, 0666) or &print_error("(dbmopen) $dir");#nocompact
	} elsif($modifier_dbtype eq 'AnyDBM_File') {#nocompact
		tie(%$db, "AnyDBM_File", $dir, O_RDWR|O_CREAT, 0666) or &print_error("(tie AnyDBM_File) $dir");#nocompact
	} elsif($modifier_dbtype eq "Nana::YukiWikiDB") {	# Nana::YukiWikiDB_GZIP	# comment#nocompact
		tie(%$db, "Nana::YukiWikiDB_GZIP", $dir) or &print_error("(tie Nana::YukiWikiDB_GZIP) $dir");#nocompact
	} else {#nocompact
		tie(%$db, "$modifier_dbtype", $dir) or &print_error("(tie $modifier_dbtype) $dir");#nocompact
	}#nocompact
	return %db;#nocompact
}#nocompact


=lang ja

=head2 close_db

=over 4

=item 入力値

なし

=item 出力

なし

=item オーバーライド

可

=item 概要

データベースを閉じる

=back

=cut

sub _close_db {
	&dbclose(\%::database);
}

=lang ja

=head2 close_info_db

=over 4

=item 入力値

なし

=item 出力

なし

=item オーバーライド

可

=item 概要

infoデータベースを閉じる

=back

=cut

sub _close_info_db {
	&dbclose(\%::infobase);
}

=lang ja

=head2 dbclose

=over 4

=item 入力値

&dbclose(\%db);

=item 出力

なし

=item オーバーライド

可

=item 概要

データベースを開く。

=back

=cut

sub _dbclose {
	my($db)=@_;
	if ($modifier_dbtype eq 'dbmopen') {
		dbmclose(%$db);
	} else {
		untie(%$db);
	}
}

=lang ja

=head2 opendiff

=over 4

=item 入力値

なし

=item 出力

なし

=item オーバーライド

可

=item 概要

diffデータベースを開く。

=back

=cut

sub _open_diff {
	&dbopen($::diff_dir,\%::diffbase);
}

=lang ja

=head2 close_diff

=over 4

=item 入力値

なし

=item 出力

なし

=item オーバーライド

可

=item 概要

diffデータベースを閉じる。

=back

=cut

sub _close_diff {
	&dbclose(\%::diffbase);
}

=lang ja

=head2 openbackup

=over 4

=item 入力値

なし

=item 出力

なし

=item オーバーライド

可

=item 概要

backupデータベースを開く。

=back

=cut

sub _open_backup {#nocompact
	&dbopen_gz($::backup_dir,\%::backupbase);#nocompact
}#nocompact

=lang ja

=head2 close_backup

=over 4

=item 入力値

なし

=item 出力

なし

=item オーバーライド

可

=item 概要

backupデータベースを閉じる。

=back

=cut

sub _close_backup {#nocompact
	&dbclose(\%::backupbase);#nocompact
}#nocompact

=lang ja

=head2 init_db

=over 4

=item 入力値

なし

=item 出力

なし

=item オーバーライド

可

=item 概要

データベースエンジンを初期化する

=back

=cut

sub _init_db {
	if($::modifier_dbtype eq 'Nana::YukiWikiDB') {
		&load_module("Nana::YukiWikiDB");
		&load_module("Nana::YukiWikiDB_GZIP");#nocompact
	} else {
		&load_module($::modifier_dbtype);
	}
}
1;
