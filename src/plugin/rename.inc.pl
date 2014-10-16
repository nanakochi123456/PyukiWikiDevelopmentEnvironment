######################################################################
# @@HEADER2_JUNICHI@@
######################################################################
# ���ꥸ�ʥ�Ȥ��ѹ���
# ��ɽ��ʸ�����꥽���������ɤ߹���
# �����ƤΥڡ���̾��ɽ�������Τ����������ƥ���Ū�����ꤢ�뤿��
#   �ǽ��ǧ�ڲ��̤˰�ư���롣
#   ����ǧ�ڥ����ƥ�λ��Ѥ��ѹ�
# ��Location�إå��ν�����ˡ���ѹ�
######################################################################

use constant PLUGIN_RENAME_LOGPAGE => ':RenameLog';

# %_rename_messages is deleted, moved to ./resource/rename.??.txt	# comment
# by nanami															# comment

sub plugin_rename_action {

	&load_wiki_module("auth");
	%::auth=&authadminpassword(submit);
	return('msg'=>"\t$::resource{rename_plugin_msg_title}",'body'=>$auth{html})
		if($auth{authed} eq 0);

	$method = &plugin_rename_getvar('method');
	if ($method eq 'regex') {
		my $src = &plugin_rename_getvar('src');
		if ($src eq '') {
			 return &plugin_rename_phase1();
		}

		$src_pattern = $src;
		$src_pattern=~s/\//\\\//g;
		my @arr0 = grep(/^$src_pattern/, sort keys %::database);

		if(@arr0 == 0){
			return &plugin_rename_phase1('nomatch');
		}

		my $dst = &plugin_rename_getvar('dst');

		my @arr1 = map {my $val = $_;$val=~s/$src_pattern/$dst/;$val} @arr0;

		foreach $page (@arr1) {
			if (! &is_pagename($page)) {
				return &plugin_rename_phase1('notvalid');
			}
		}

		return &plugin_rename_regex(\@arr0, \@arr1);
	} else {
		#  $method eq 'page'									# comment
		$page  = &plugin_rename_getvar('page');
		$refer = &plugin_rename_getvar('refer');

		if ($refer eq '') {
			return &plugin_rename_phase1();
		} elsif (! &is_exist_page($refer)) {
			return &plugin_rename_phase1('notpage', $refer);
		} elsif ($refer eq $whatsnew) {
			return &plugin_rename_phase1('norename', $refer);
		} elsif ($page eq '' || $page eq $refer) {
			return &plugin_rename_phase2();
		} elsif (not &is_pagename($page)) {
			return &plugin_rename_phase2('notvalid');
		} else {
			return &plugin_rename_refer();
		}
	}
}


#  �ѿ����������												# comment
sub plugin_rename_getvar {
	my ($key) = @_;

	return $::form{$key};
	return isset($vars[$key]) ? $vars[$key] : '';
}

#  ���顼��å���������										# comment
sub plugin_rename_err {
	my ($err,$page) = @_;

	if ($err eq '') {
		return '';
	}

	$body = $::resource{'rename_plugin_err_' . $err};
	if (ref($page) eq 'ARRAY') {
		$page = join(", ", @$page);
	}
	if ($page ne ''){
		 $body = sprintf($body, &htmlspecialchars($page));
	}

	$msg = sprintf($::resource{'rename_plugin_err'}, $body);
	return $msg;
}

# ����ʳ�:�ڡ���̾�ޤ�������ɽ��������							# comment
sub plugin_rename_phase1 {
	my ($err, $page) = @_;

	$msg    = &plugin_rename_err($err, $page);
	$refer  = &plugin_rename_getvar('refer');
	$method = &plugin_rename_getvar('method');

	$radio_regex = $radio_page = '';
	if ($method eq 'regex') {
		$radio_regex = ' checked="checked"';
	} else {
		$radio_page  = ' checked="checked"';
	}
	$select_refer = &plugin_rename_getselecttag($refer);

	$s_src = htmlspecialchars(&plugin_rename_getvar('src'));
	$s_dst = htmlspecialchars(&plugin_rename_getvar('dst'));

	%ret = ();
	$ret{'msg'}  = "\t$::resource{'rename_plugin_msg_title'}";
	$ret{'body'} = <<EOD;
$msg
<form action="$::script" method="post">
 <div>
  <input type="hidden" name="cmd" value="rename" />
  $auth{html}
  <input type="radio"  name="method" value="page"$radio_page />
  @{[$::resource{'rename_plugin_msg_page'}]}:$select_refer<br />
  <input type="radio" name="method" value="regex"$radio_regex />
  @{[$::resource{'rename_plugin_msg_regex'}]}:<br />
  From:<br />
  <input type="text" name="src" size="80" value="$s_src" /><br />
  To:<br />
  <input type="text" name="dst" size="80" value="$s_dst" /><br />
  <input type="submit" value="@{[$::resource{'rename_plugin_btn_next'}]}" /><br />
 </div>
</form>
EOD

	return %ret;
}

# �����ʳ�:������̾��������									# comment
sub plugin_rename_phase2 {
	my $err = shift;

	$msg   = &plugin_rename_err($err);
	$page  = &plugin_rename_getvar('page');
	$refer = &plugin_rename_getvar('refer');

	if ($page eq '') {
		$page = $refer;
	}

	$msg_related = '';
	@related = &plugin_rename_getrelated($refer);
	if (@related > 0) {
		$msg_related = $::resource{'rename_plugin_msg_do_related'} .
			'<input type="checkbox" name="related" value="1" checked="checked" /><br />';
	}

	$msg_rename = sprintf($::resource{'rename_plugin_msg_rename'}, &make_pagelink($refer));
	$s_page  = &htmlspecialchars($page);
	$s_refer = &htmlspecialchars($refer);

	%ret = ();
	$ret{'msg'}  = "\t$::resource{'rename_plugin_msg_title'}";
	$ret{'body'} = <<EOD;
$msg
<form action="$::script" method="post">
 <div>
  <input type="hidden" name="cmd" value="rename" />
  $auth{html}
  <input type="hidden" name="refer"  value="$s_refer" />
  $msg_rename<br />
  @{[$::resource{'rename_plugin_msg_newname'}]}:<input type="text" name="page" size="80" value="$s_page" /><br />
  $msg_related
  <input type="submit" value="@{[$::resource{'rename_plugin_btn_next'}]}" /><br />
 </div>
</form>
EOD

	if (@related > 0) {
		$ret{'body'} .= '<hr /><p>' . $::resource{'rename_plugin_msg_related'} . '</p><ul>';
		foreach $name (sort @related) {
			$ret{'body'} .= '<li>' . &make_pagelink($name) . '</li>';
		}
		$ret{'body'} .= '</ul>';
	}

	return %ret;
}

# �ڡ���̾�ȴ�Ϣ����ڡ�������󤷡�phase3��				# comment
sub plugin_rename_refer {
	$page  = &plugin_rename_getvar('page');
	$refer = &plugin_rename_getvar('refer');

	my %pages = ();
	$pages{&dbmname($refer)} = &dbmname($page);

	if (&plugin_rename_getvar('related') ne '') {
		$from = &strip_bracket($refer);
		$to   = &strip_bracket($page);

		foreach $_page (&plugin_rename_getrelated($refer)) {
			# $_page���ִ���̤�$_page_to������				# comment
			($_page_to = $_page)=~s/$from/$to/;
			$pages{&dbmname($_page)} = &dbmname($_page_to);
		}
	}
	# ���λ�����%pages�ˤϡ���ڡ���̾ => ���ڡ���̾ �Ȥ����ǡ��������äƤ���	# comment
	return &plugin_rename_phase3(%pages);
}

# ����ɽ���ǥڡ������ִ�									# comment
sub plugin_rename_regex {
	my ($arr_from, $arr_to) = @_;

	@exists = ();
	foreach my $page (@$arr_to) {
		if (&is_exist_page($page)) {
			push(@exists, $page);
		}
	}

	if (@exists > 0) {
		# �ִ���Υڡ���̾�����Ǥ�¸�ߤ�����				# comment
		return &plugin_rename_phase1('already', \@exists);
	} else {
		%pages = ();
		foreach $refer (@$arr_from) {
			$pages{&dbmname($refer)} = &dbmname(shift(@$arr_to));
		}
		return &plugin_rename_phase3(%pages);
	}
}

sub plugin_rename_phase3 {
	my(%pages) = @_;

	my $msg = my $input = '';
	my %files = &plugin_rename_get_files(%pages);


	%exists = ();
	foreach $_page (keys %files) {
		my $arr = $files{$_page};
		foreach $old (keys %{$arr}) {
			$new = $arr->{$old};
			if (-e $new) {
				$exists{$_page}{$old} = $new;
			}
		}
	}

	$pass = &plugin_rename_getvar('mypassword');
#	v0.1.6 changed by nanami							# comment
#	if ($pass ne '' && &valid_password($pass)) {		# comment
	if (&plugin_rename_getvar('exec') eq 1) {
		return &plugin_rename_proceed(\%pages, \%files, \%exists);
#	} elsif ($pass ne '') {								# comment
#		$msg = &plugin_rename_err('adminpass');			# comment
	}

	$method = &plugin_rename_getvar('method');
	if ($method eq 'regex') {
		$s_src = &htmlspecialchars(&plugin_rename_getvar('src'));
		$s_dst = &htmlspecialchars(&plugin_rename_getvar('dst'));
		$msg   .= $::resource{'rename_plugin_msg_regex'} . '<br />';
		$input .= '<input type="hidden" name="method" value="regex" />';
		$input .= '<input type="hidden" name="src"    value="' . $s_src . '" />';
		$input .= '<input type="hidden" name="dst"    value="' . $s_dst . '" />';
	} else {
		$s_refer   = &htmlspecialchars(&plugin_rename_getvar('refer'));
		$s_page    = &htmlspecialchars(&plugin_rename_getvar('page'));
		$s_related = &htmlspecialchars(&plugin_rename_getvar('related'));
		$msg   .= $::resource{'rename_plugin_msg_page'} . '<br />';
		$input .= '<input type="hidden" name="method"  value="page" />';
		$input .= '<input type="hidden" name="refer"   value="' . $s_refer   . '" />';
		$input .= '<input type="hidden" name="page"    value="' . $s_page    . '" />';
		$input .= '<input type="hidden" name="related" value="' . $s_related . '" />';
	}

	if ((keys %exists) >0) {
		$msg .= $::resource{'rename_plugin_err_already_below'} . '<ul>';
		foreach $page (keys %exists) {
			my $arr = $exists{$page};

			$msg .= '<li>' . &make_pagelink(&dbmname_decode($page));
			$msg .= $::resource{'rename_plugin_msg_arrow'};
			$msg .= &htmlspecialchars(&dbmname_decode($pages{$page}));
			if ((keys %$arr) > 0) {
				$msg .= '<ul>' . "\n";
				foreach $ofile (keys %$arr) {
					$nfile = $arr->{$ofile};
					$msg .= '<li>' . $ofile .
					$::resource{'rename_plugin_msg_arrow'} . $nfile . '</li>' . "\n";
				}
				$msg .= '</ul>';
			}
			$msg .= '</li>' . "\n";
		}
		$msg .= '</ul><hr />' . "\n";

		$input .= '<input type="radio" name="exist" value="0" checked="checked" />' .
			$::resource{'rename_plugin_msg_exist_none'} . '<br />';
		$input .= '<input type="radio" name="exist" value="1" />' .
			$::resource{'rename_plugin_msg_exist_overwrite'} . '<br />';
	}

	%ret = ();
	$ret{'msg'} = "\t$::resource{'rename_plugin_msg_title'}";
	# v0.1.6 changed by nanami									# comment
	$ret{'body'} = <<EOD;
<p>$msg</p>
<table><tr><td>
@{[$::resource{'rename_plugin_msg_confirm'}]}
</td><td>
<form action="$::script" method="post">
 <div>
  $auth{html}
  <input type="hidden" name="cmd" value="rename" />
  <input type="hidden" name="exec" value="1" />
  $input
  <input type="submit" value="$::resource{'rename_plugin_btn_submit'}" />
 </div>
</form>
</td></tr>
</table>
EOD
#  @{[$::resource{'rename_plugin_msg_adminpass'}]}				# comment
#  <input type="password" name="mypassword" value="" />			# comment

	$ret{'body'} .= '<ul>' . "\n";
	foreach $old (reverse sort keys %pages) {
		$new = $pages{$old};
		$ret{'body'} .= '<li>' .  &make_pagelink(&dbmname_decode($old)) .
			$::resource{'rename_plugin_msg_arrow'} .
			&htmlspecialchars(&dbmname_decode($new)) .  '</li>' . "\n";
	}
	$ret{'body'} .= '</ul>' . "\n";
	return %ret;
}


# �����оݤΥե�����ξ���ʸ��ե�����ѥ������ե�����ѥ��ˤΰ������������	# comment
sub plugin_rename_get_files {
	my (%pages) = @_;

	my %files = ();
	@dirs  = ($::diff_dir, $::data_dir, $::counter_dir, $::info_dir);#compact
	@dirs  = ($::diff_dir, $::data_dir, $::counter_dir, $::info_dir, $::backup_dir);#nocompact
	if (&exist_plugin('attach')){
		push (@dirs, $::upload_dir);
	}
	if (&exist_plugin('rename')) {
		push (@dirs, $::rename_dir);
	}
	#  and more ...										# comment

	foreach $path (@dirs) {
		opendir(DH,$path);
		if (! DH){
			next;
		}

		# PyukiWiki�Υǥ��쥯�ȥ�����ǺǸ夬/�Ǥʤ������ղä��롣	# comment
		if($path=~/.*[^\/]$/) {
			$path .= '/';
		}

		while ($file = readdir(DH)) {
			if ($file eq '.' || $file eq '..'){
				next;
			}
			
			foreach $from (keys %pages) {

				$to = $pages{$from};

#				# �����󥿡��ξ��ϡ����٥ǥ����ɤ���&encode()���롣	# comment
#				if($path=~/$::rename_dir/) {						# comment
#					$from = &encode(&dbmname_decode($from));		# comment
#					$to = &encode(&dbmname_decode($to));			# comment
#				}													# comment

				# / �� \/ ���ִ�									# comment
				$from=~s/\//\\\//g;

				# �ѥ�����κǸ�� ([._].+) ��Pyuki�Ǥ����פȻפ���	# comment
				my $pattern = '^' . $from . '([._].+)$';
				if (not $file=~/$pattern/) {
					next;
				}

				$newfile = $to . $1;
				$files{$from}{$path . $file} = $path . $newfile;
			}
		}
	}

	return %files;
}

# ��������															# comment
sub plugin_rename_proceed {
	my ($pages, $files, $exists) = @_;

	# �ѥ�᡼��exist��1(���)�Ǥʤ����¸�ߤ���ڡ���������оݤ���Ϥ���	# comment
	if (&plugin_rename_getvar('exist') ne '1') {

		foreach my $key (keys %$exists) {
			my $arr = $exists->{$key};
			delete $files->{$key};
		}
	}

#	set_time_limit(0);												# comment
	foreach $page(keys %$files) {
		$arr = $files->{$page};

		foreach $old (keys %$arr) {
			$new = $arr->{$old};

			# ¸�ߤ��Ƥ��ơ����ġ��ͤ���Ǽ����Ƥ����� $new��������	# comment
			if (exists($exists->{$page}{$old}) && defined($exists->{$page}{$old})){
				unlink($new);
			}
			rename($old, $new);
			#  link�ǡ����١����򹹿����� BugTrack/327 arino		# comment
#			links_update($old);										# comment
#			links_update($new);										# comment
		}
	}

	# ���ڡ����Υǡ�����������ơ��ɵ�							# comment
	$postdata = $::database{PLUGIN_RENAME_LOGPAGE};
	$postdata .= '*' . &date($::date_format . " " . $::time_format . " (D)") . "\n";
	if (&plugin_rename_getvar('method') eq 'regex') {
		$postdata .= '-' . $::resource{'rename_plugin_msg_regex'} . "\n";
		$postdata .= '--From:[[' . &plugin_rename_getvar('src') . ']]' . "\n";
		$postdata .= '--To:[['   . &plugin_rename_getvar('dst') . ']]' . "\n";
	} else {
		$postdata .= '-' . $::resource{'rename_plugin_msg_page'} . "\n";
		$postdata .= '--From:[[' . &plugin_rename_getvar('refer') . ']]' . "\n";
		$postdata .= '--To:[['   . &plugin_rename_getvar('page')  . ']]' . "\n";
	}

	if ((keys %$exists) > 0) {
		$postdata .= "\n" . $::resource{'rename_plugin_msg_result'} . "\n";
		foreach  $page (keys %$exists) {
			$arr = $exists->{$page};
			$postdata .= '-' . &dbmname_decode($page) .
				$::resource{'rename_plugin_msg_arrow'} . &dbmname_decode($pages->{$page}) . "\n";
			foreach $ofile (keys %$arr) {
				$nfile = $arr->{$ofile};
				$postdata .= '--' . $ofile .
					$::resource{'rename_plugin_msg_arrow'} . $nfile . "\n";
			}
		}
		$postdata .= '----' . "\n";
	}

	foreach $old (keys %$pages) {
		$new = $pages->{$old};
		$postdata .= '-' . &dbmname_decode($old) .
			$::resource{'rename_plugin_msg_arrow'} . &dbmname_decode($new) . "\n";
	}


	#  �����ξ��ͤϥ����å����ʤ���								# comment

	#  �ե�����ν񤭹���										# comment
	$::database{::PLUGIN_RENAME_LOGPAGE} = $postdata;
	&close_db();

	# ������쥯��												# comment
	$page = &plugin_rename_getvar('page');
	if ($page eq '') {
		$page = PLUGIN_RENAME_LOGPAGE;
	}

#	pkwk_headers_sent();										# comment
#	header('Location: ' . get_script_uri() . '?' . rawurlencode($page));	# comment
#	v0.1.6 changed by nanami									# comment
#	print "Location: $::script?@{[&encode($page)]}\n\n";		# comment
#	exit;														# comment
	&location("$::basehref?@{[&encode($page)]}", 302);
}

sub plugin_rename_getrelated {
	my ($page) = @_;

	@related = ();
	@pages = keys %::database;

	($striped_page = &strip_bracket($page))=~s/\//\\\//g;
	$pattern = '(?:^|\/)' . $striped_page . '(?:\/|$)';

	foreach  $name (@pages) {
		if ($name eq $page) {
			next;
		}
		if ($name=~/$pattern/) {
			push(@related, $name);
		}
	}

	return @related;
}


# ¸�ߤ���ڡ������٤ƤΥץ����������							# comment
sub plugin_rename_getselecttag {
	my ($page) = @_;

	my %pages = ();
	foreach $_page (sort keys %::database) {
#		if ($_page == $whatsnew) {									# comment
#			next;													# comment
#		}															# comment

		$selected = ($_page eq $page) ? ' selected' : '';
		$s_page = &htmlspecialchars($_page);
		$pages{$_page} = '<option value="' . $s_page . '"' . $selected . '>' .
			$s_page . '</option>';

	}

	my @pages = sort values %pages;

	$list = join("\n ", @pages);

	return <<EOD;
<select name="refer">
 <option value=""></option>
 $list
</select>
EOD

}

# �ڡ���̾�Υǥ����ɡ�<==> dbmname									# comment
sub dbmname_decode {
	my $name = shift;
	return ($name =~/^[0-9a-f]+$/i) ? pack('H*', $name ) : $name ;
}

# [[ ]] �������													# comment
# from PukiWiki lib/func.php										# comment
sub strip_bracket {
	my ($str) = @_;

	if ($str=~/^\[\[(.*)\]\]$/) {
		return $1;
	} else {
		return $str;
	}
}

# from PukiWiki lib/make_link.php									# comment
# ��ʬ�����Ǥ���													# comment
sub make_pagelink {
	my $page = shift;
	return qq|<a href="$::script?@{[&encode($page)]}">$page</a>|;
}

# �ڡ���̾�Ȥ������������ɤ��������å�								# comment
# from PukiWiki lib/func.php										# comment
sub is_pagename {
	my ($str) = @_;
	my $is_pagename= (not &is_interwiki($str) &&
						$str=~/^(?!\/)$bracket_name$(?<!\/$)/ &&
						$str=~/(^|\/)\.{1,2}(\/|$)/);
	# SOURCE_ENCODING�˳�����������Ͼ�ά							# comment
	return $is_pagename;
}

# from PukiWiki lib/func.php										# comment
sub is_interwiki {
	my ($str) = @_;

	# Ƚ��ˤϡ������PyukiWiki��$interwiki_name2�����				# comment

	# from PukiWiki lib/init.php									# comment
	# my $InterWikiName = '(\[\[)?((?:(?!\s|:|\]\]).)+):(.+)(?(1)\]\])';	# comment

	# from PyukiWiki index.cgi										# comment
	# my $interwiki_name = '([^:]+):([^:].*)';						# comment
	# my $interwiki_name2 = '([^:]+):([^:#].*?)(#.*)?';				# comment

	return $str=~/^$interwiki_name$/;
}


1;
__END__

=head1 NAME

rename.inc.pl - PyukiWiki Administrator's Plugin

=head1 SYNOPSIS

 ?cmd=rename[&refer=encoded_page_name]

=head1 DESCRIPTION

Changing a Wiki page name.

rename, difference (diff), and an attached file are also united and renamed.

Transplant from PukiWiki.

The portion which is not mounted by PyukiWiki is omitted.

=head1 BUGS

Updating is not applied to recent.

=head1 SEE ALSO

=over 4

L<@@BASEURL@@/PyukiWiki/Plugin/Admin/rename/>

=item PyukiWiki CVS

L<@@CVSURL@@/PyukiWiki-Devel/plugin/rename.inc.pl>

=item Site manufacture/PyukiWiki/Plugin/Rename

It is the correspondence version to 0.1.5.

L<http://www.re-birth.com/pyuki/wiki.cgi?%a5%b5%a5%a4%a5%c8%c0%a9%ba%ee%2fPyukiWiki%2f%a5%d7%a5%e9%a5%b0%a5%a4%a5%f3%2f%a5%ea%a5%cd%a1%bc%a5%e0>

=back

=head1 AUTHOR

=over 4

@@AUTHOR_JUNICHI@@

@@AUTHOR_PYUKI@@

=back

=head1 LICENSE

@@LICENSE_JUNICHI@@

=cut
