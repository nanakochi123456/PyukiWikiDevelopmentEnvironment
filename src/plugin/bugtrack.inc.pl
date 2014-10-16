######################################################################
# @@HEADER2_NEKYO@@
######################################################################
# 変更履歴:
#  2012.11.05: 一部作り直し、ほぼ独自仕様
#  2002.06.17: 作り始め
#
# Id: bugtrack.inc.php,v 1.14 2003/05/17 11:18:22 arino Exp
#

$bugtrack::freeze=1
	if(!defined($bugtrack::freeze));

$bugtrack::backlink='[&backlink;]'
	if(!defined($bugtrack::backlink));

#
# メールのヘッダー
$bugtrack::mailheader = "$::mail_head{post}"
	if(!defined($bugtrack::mailheader));

sub plugin_bugtrack_action
{
	if ($::form{mode} eq 'submit') {
		foreach("base","pagename","summary","priority","state","category","version","body") {
			$::form{$_} = &code_convert(\$::form{$_}, $::defaultcode,$::kanjicode);
		}
		&plugin_bugtrack_write($::form{base}, $::form{pagename}, $::form{summary}, $::form{myname}, $::form{priority}, $::form{state}, $::form{category}, $::form{version}, $::form{body});
#		exit;
	}
	return ('msg'=>$bugtrack::title, 'body'=>&plugin_bugtrack_print_form($::form{category}));
}

sub plugin_bugtrack_print_form
{
	my ($base, @category) = @_;
	my $select_priority;
	my $select_state;
	my $loop=0;

	my $captcha_form;
	eval {
		$captcha_form=&plugin_captcha_form;
	};

	foreach my $priority_list (split(/,/,$::resource{bugtrack_priority_list})) {
		my $str=$::resource{"bugtrack_priority_$priority_list"};
		my $selected=$loop++ < 1 ? ' selected="selected"' : "";

		$select_priority .= "<option value=\"$str\"$selected>$str</option>\n";
	}

	foreach my $state_list (split(/,/,$::resource{bugtrack_state_list})) {
		my $str=$::resource{"bugtrack_state_$state_list"};
		my $selected=$loop++ < 1 ? ' selected="selected"' : "";

		$select_state .= "<option value=\"$str\"$selected>$str</option>\n";
	}

	my $encoded_category = '<input name="category" type="text" />';

	if (@category != 0) {
		$encoded_category = '<select name="category">';
		foreach my $_category (@category) {
			my $s_category = &htmlspecialchars($_category);
			$encoded_category .= "<option value=\"$s_category\">$s_category</option>\n";
		}
		$encoded_category .= '</select>';
	}

	$s_base = &htmlspecialchars($base);

	$body = <<"EOD";
<form action="$::script" method="post">
 <table border="0">
  <tr>
   <th>$::resource{bugtrack_name}</th>
   <td><input name="myname" size="20" type="text" value="$::name_cookie{myname}" /></td>
  </tr>
  <tr>
   <th>$::resource{bugtrack_category}</th>
   <td>$encoded_category</td>
  </tr>
  <tr>
   <th>$::resource{bugtrack_priority}</th>
   <td><select name="priority">$select_priority</select></td>
  </tr>
  <tr>
   <th>$::resource{bugtrack_state}</th>
   <td><select name="state">$select_state</select></td>
  </tr>
  <tr>
   <th>$::resource{bugtrack_pagename}</th>
   <td><input name="pagename" size="20" type="text" /><small>$::resource{bugtrack_pagename_comment}</small></td>
  </tr>
  <tr>
   <th>$::resource{bugtrack_version}</th>
   <td><input name="version" size="10" type="text" /><small>$::resource{bugtrack_version_comment}</small></td>
  </tr>
  <tr>
   <th>$::resource{bugtrack_summary}</th>
   <td><input name="summary" size="60" type="text" /></td>
  </tr>
  <tr>
   <th>$::resource{bugtrack_body}</th>
   <td><textarea name="body" cols="60" rows="6"></textarea></td>
  </tr>
@{[$captcha_form ne "" ? qq(<tr><td colspan="2" align="center">$captcha_form</td></tr>) : ""]}
  <tr>
   <td colspan="2" align="center">
    <input type="submit" value="$::resource{bugtrack_submit}" />
    <input type="hidden" name="cmd" value="bugtrack" />
    <input type="hidden" name="mode" value="submit" />
    <input type="hidden" name="base" value="$s_base" />
   </td>
  </tr>
 </table>
</form>
EOD
	return $body;
}

sub plugin_bugtrack_template
{
	my ($base, $summary, $name, $priority, $state, $category, $version, $msg) = @_;

	$name = &armor_name($name);
	$base = &armor_name($base);
	$body=<<EOM;
@{[$bugtrack::freeze ? "#freeze\n" : ""]}*$summary
$bugtrack::backlink

EOM
	foreach(split(/,/,$::resource{bugtrack_inputline})) {
		my $s=$::resource{"bugtrack_$_"};
		if(/pagename/) {
			$body.="-$s: $base\n";
		} elsif(/name/) {
			$body.="-$s: $name\n";
		} elsif(/priority/) {
			$body.="-$s: $priority\n";
		} elsif(/state/) {
			$body.="-$s: $state\n";
		} elsif(/category/) {
			$body.="-$s: $category\n";
		} elsif(/date/) {
			$body.="-$s: @{[&get_now]}\n";
		} elsif(/version/) {
			$body.="-$s: $version\n";
		} elsif(/summary/) {
			$body.="-$s: $summary\n";
		}
	}
	$body.=<<EOM;
**$::resource{bugtrack_body}
$msg
----

#comment
EOM
	$body;
}

sub plugin_bugtrack_write
{
	my ($base, $pagename, $summary, $name, $priority, $state, $category, $version, $body) = @_;

	$base = &unarmor_name($base);
	$pagename = &unarmor_name($pagename);

	my $postdata = &plugin_bugtrack_template($base, $summary, $name, $priority, $state, $category, $version, $body);
	$i = 0;
	do {
		$i++;
		$page = "$base$::separator$i";
	} while ($::database{$page});

	if ($pagename == '') {
		$::form{mypage} = $page;
		$::form{mymsg} = $postdata;
		$::form{mytouch} = 'on';
		&do_write("FrozenWrite", "", $bugtrack::mailheader);
		exit;
	} else {
		$::form{mypage} = "$base$::separator$pagename";
		$::form{mymsg} = $postdata . "\n----\n$::database{$page}";

		$::form{mytouch} = 'on';
		&do_write("FrozenWrite", "", $bugtrack::mailheader);
		exit;
	}

	return $page;
}

sub plugin_bugtrack_convert
{
	my $base = $::form{mypage};
	my @category = split(/,/, shift);
	if (@category > 0) {
		my $_base = &unarmor_name(shift(@category));
	#	$_base = get_fullname($_base, $base);						# comment
		if ($::database{$_base}) {
			$base = $_base;
		}
	}
	return &plugin_bugtrack_print_form($base, @category);
}

__DATA__

sub plugin_bugtrack_usage {
	return {
		name => 'bugtrack',
		version => '1.0',
		type => 'command,convert',
		author => '@@NEKYO@@',
		syntax => '#bugtrack',
		description => 'Bugtrack System',
		description_ja => 'バグトラックシステム',
		example => '#bugtrack',
	};
}

1;
__END__

=head1 NAME

bugtrack.inc.pl - PyukiWiki Plugin

=head1 SYNOPSIS

 #bugtrack(pagename, class1, class2, ...);

=head1 DESCRIPTION

Make bugtrack form in this place.

=back

=head1 BUGS

Japanese only

=head1 SEE ALSO

=over 4

=item PyukiWiki/Plugin/Standard/bugtrack

L<@@BASEURL@@/PyukiWiki/Plugin/Standard/bugtrack/>

=item PyukiWiki CVS

L<@@CVSURL@@/PyukiWiki-Devel/plugin/bugtrack.inc.pl>

=back

=head1 AUTHOR

=over 4

=head1 AUTHOR

=over 4

@@AUTHOR_NEKYO@@

@@AUTHOR_PYUKI@@

=back

=head1 LICENSE

@@LICENSE_NEKYO@@

=cut
