######################################################################
# @@HEADER2_NANAMI@@
######################################################################

use strict;
use Nana::GZIP;
use Nana::File;

sub plugin_recovery_action {
	my $body;
	&load_wiki_module("auth");
	%::auth=&authadminpassword(submit);
	return('msg'=>"\t$::resource{recovery_plugin_title}",'body'=>$::auth{html})
		if($::auth{authed} eq 0);
	my (@list)=&do_recovery;
	$body=&do_recovery_form(@list);
	return ('msg'=>"\t$::resource{recovery_plugin_title}", 'body'=>$body);
}

sub do_recovery {
	my($page)=@_;
	my $t=$::type;
	$t="devel" if ($t eq "develop");
	my $recovery_file="$::res_dir/wiki-$t.$::lang.txt.gz";

	my $gz = new Nana::GZIP();
	my $data=$gz->uncompress(Nana::File::lock_fetch($recovery_file));
	$data=&code_convert(\$data, $::kanjicode);

	my @list;
	my $dt;
	my $pg;
	foreach my $line(split(/\n/, $data)) {
		my ($dmy, $pagename, $type, $lang, $code);
		if($line=~/^>>>>>>>>>>/) {
			($dmy, $pagename, $type, $lang, $code)=split(/\t/, $line);
			$pg=$pagename;
			if($pagename=~/^\$/) {
				$pg=eval "$pagename;";
			}
			push(@list, "$pg\t$pagename\t$type\t$lang\t$code");
		} else {
			$dt.="$line\n" if($pg eq $page);
		}
	}
	return $dt if($page ne "");
	return @list;
}
sub do_recovery_form {
	my (@pagelist)=@_;

	$::IN_JSHEADVALUE.=<<EOM;
function allcheckbox(b){var c=document.getElementById("sel"),a=c.elements.length;for(i=0;i<a;i++){l=c.elements[i];if(l.type=="checkbox"){if(b==1){if(!l.checked){l.click()}}else{if(l.checked){l.click()}}}}};
EOM
	my $body=<<EOM;
<h2>$::resource{recovery_plugin_title}</h2>
$::resource{recovery_plugin_msg}
<form action="$::script" method="post" name="sel" id="sel">
<input type="hidden" name="cmd" value="recovery" />
$::auth{html}
<input type="submit" name="exec" value="$::resource{recovery_plugin_btn_submit}" />
<input type="button" value="$::resource{recovery_plugin_btn_checkon}" onclick="allcheckbox(1);" />
<input type="button" value="$::resource{recovery_plugin_btn_checkoff}" onclick="allcheckbox(0);" />
<input type="reset" value="$::resource{recovery_plugin_btn_reset}" />
<hr />
EOM
	foreach(@pagelist) {
		my ($page, $pagename, $type, $lang, $code)=split(/\t/,$_);
		my $go=
			$type=~/auto/ ?
				&is_exist_page($page) ? 0 : 1
		:	$type=~/default/ && $::form{all} eq 1 ?
				&is_exist_page($page) ? 1 : 1
		:	$type=~/force/ ?
				&is_exist_page($page) ? 1 : 1
		:	$type=~/opt/ ?
				&is_exist_page($page) ? 0 : 0
		: 0;

		my $hex=&dbmname($page);
		my $result;
		if($::form{"go_$hex"} eq 1) {
			my $dt=&do_recovery($page);
			&do_write_recovery($page, $dt);
			$result=qq(<span class="error">$::resource{recovery_plugin_btn_write}</span> $::fdata{$page});
		}
		$body.=<<EOM;
<input type="checkbox" name="go_$hex" value="1"@{[$go eq 0 ? '' : ' checked="checked"']} />
<input type="hidden" name="exist_$hex" value="@{[&is_exist_page($page) ? 1 : 0]}" />
@{[&is_exist_page($page) ? qq(<a href="$::script?cmd=read;mypage=@{[&encode($page)]}">$page</a>) : $page]}
@{[$page ne $pagename ? "($pagename)" : ""]}
$result
<br />
EOM
	}
	$body.="</form>\n";
	$body;
}

sub do_write_recovery {
	my($mypage, $mymsg)=@_;
	require "$::sys_dir/wiki_write.cgi";
	return 0 if (&conflict($mypage, $mymsg));
	my $mailhead="test";
	# 内部置換											# comment
	$mymsg =~ s/\&t;/\t/g;
	$mymsg =~ s/\&date;/&date($::date_format)/gex;
	$mymsg =~ s/\&time;/&date($::time_format)/gex;
	$mymsg =~ s/\&new;/\&new\{@{[&get_now]}\};/gx
		if(-r "$::plugin_dir/new.inc.pl");
	if($::usePukiWikiStyle eq 1) {
		$mymsg =~ s/\&now;/&date($::now_format)/gex;
		$mymsg =~ s/\&(date|time|now);/\&$1\(\);/g;
		$mymsg =~ s/\&fpage;/$mypage/g;
		my $tmp=$mypage;
		$tmp=~s/.*\///g;
		$mymsg =~ s/&page;/$tmp/g;
	}
	$mymsg=~s/\x0D\x0A|\x0D|\x0A/\n/g;

	&do_diff($mypage, $mymsg);
	&do_backup($mypage);							# nocompact

	if ($mymsg) {
		&do_write_page($mypage, $mymsg, , $mailhead);
		&do_write_info($mypage);
		&do_write_after($mypage, "RecoveryModify");
	} else {
		&do_delete_page($mypage);
		&do_delete_info($mypage);
		&do_write_after($mypage, "RecoveryDelete");
	}
	&update_recent_changes;
	&close_db;
	&open_db;
	return 0;
}

1;
__DATA__

sub plugin_recovery_usage {
	return {
		name => 'recovery',
		version => '1.0',
		type => 'admin,command',
		author => 'Nanami',
		syntax => '?cmd=recovery',
		description => "Recovery initial wiki page",
		description_ja => 'デフォルトのwikiページを復元する。",
	};
}

1;
__END__

=head1 NAME

recovery.inc.pl - PyukiWiki Administrator's Plugin

=head1 SYNOPSIS

 ?cmd=recovery

=head1 DESCRIPTION

Recovery initial wiki page.

=head1 SEE ALSO

=over 4

=item PyukiWiki/Plugin/Admin/admin

L<@@BASEURL@@/PyukiWiki/Plugin/Admin/recovery/>

=item PyukiWiki CVS

L<@@CVSURL@@/PyukiWiki-Devel/plugin/recovery.inc.pl>

=back

=head1 AUTHOR

=over 4

@@AUTHOR_NANAMI@@

@@AUTHOR_PYUKI@@

=back

=head1 LICENSE

@@LICENSE_NANAMI@@

=cut
