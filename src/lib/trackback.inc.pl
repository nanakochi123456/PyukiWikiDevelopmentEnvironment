######################################################################
# @@HEADER2_NANAMI@@
######################################################################
# This is extented plugin.
# To use this plugin, rename to 'trackback.inc.cgi'
######################################################################

# ディレクトリ
$trackback::directory="$::data_home/trackback"
	if(!defined($trackback::directory));

use strict;
use Nana::MD5 qw(md5_hex);

@trackback::allowcmd=(
	"read",
	"edit",
	"adminedit",
	"diff",
	"backup",
	"setting",
	"tb",
);
%::trackbackbase;
$trackback::md5pagename;

sub plugin_trackback_init {
	&exec_explugin_sub("lang");
	&exec_explugin_sub("urlhack");
	&exec_explugin_sub("autometarobot");

	if($::_exec_plugined{lang} eq 2) {
		if($::defaultlang ne $::lang) {
			$trackback::directory.=".$::lang";
		}
	}
	my $err;
	my $err=&writechk($trackback::directory);
	if($err ne '') {
		&print_error($err);
		exit;
	}

	my $flg=0;
	foreach(@trackback::allowcmd) {
		$flg=1 if($_ eq $::form{cmd});
	}
	if($flg eq 1 && $::form{mypage} ne '') {
		$trackback::md5pagename=&tb_get_id($::form{mypage});
	} else {
		$flg=0;
	}

	return('init'=>0) if(&chkpage($::form{mypage}) eq 1);

	if($flg eq 1 && $::navi{"trackback_url"} eq '') {
		&dbopen($trackback::directory,\%::trackbackbase);
		# http://www.tohoho-web.com/lng/199912/99120066.htm # comment
		# http://www.aleph.co.jp/~fujiwara/perl/lc.pl # comment
		my $trackbackcount = ($::trackbackbase{$::form{mypage}} =~ tr/\n/\n/);
		&dbclose(\%::trackbackbase);
		push(@::addnavi,"trackback:help");
		my $langflg=$::_exec_plugined{lang}+0 eq 2 ? "lang=$::lang&amp;" : "";
		$::navi{"trackback_url"}="$::script?cmd=tb&amp;tb_id=$trackback::md5pagename&amp;@{[$langflg]}\__mode=view";
		$::navi{"trackback_name"}=$::resource{"trackbackbutton"};
		$::navi{"trackback_name"}=~s/\$COUNT/$trackbackcount/g;
		$::navi{"trackback_type"}="plugin";
	}
	return ('init'=>1
		, 'last_func'=>'&trackback_last;');
}

sub trackback_last {
}

# pukiwiki compatible function					# comment

sub tb_get_id {
	my($page)=@_;
	return md5_hex($page);
}

%trackback::cache;

sub tb_id2page {
	my($tb_id)=@_;

	return $trackback::cache{$tb_id}
		if($trackback::cache{$tb_id} ne '');

	foreach my $page (keys %::database) {
		my $_tb_id=&tb_get_id($page);
		$trackback::cache{$_tb_id}=$page;
		return $trackback::cache{$tb_id}
			if($tb_id eq $_tb_id);
	}
	$trackback::cache{$tb_id}="";
	return "";
}

sub chkpage {
	my ($page)=@_;
	if($page=~/$::resource{help}|$::resource{rulepage}|$::RecentChanges|$::MenuBar|$::SideBar|$::TitleHeader|$::Header|$::Footer$::BodyHeader$::BodyFooter|$::SkinFooter|$::SandBox|$::InterWikiName|$::InterWikiSandBox|$::non_list/
#		|| $::meta_keyword eq "" #|| lc $::meta_keyword eq "disable"
		|| &is_readable($page) eq 0) {
		return 1;
	}
	my $flg=0;
	foreach(@trackback::allowcmd) {
		$flg=1 if($_ eq $::form{cmd});
	}
	return 0 if($flg eq 1);
	return 1;
}

1;
__DATA__
sub plugin_trackback_setup {
	return(
		en=>'Send trackback.',
		jp=>'trackbackを処理する,
		override=>'none',
		url=>'@@BASEURL@@/PyukiWiki/Plugin/ExPlugin/trackback/'
	);
__END__

=head1 NAME

trackback.inc.pl - PyukiWiki Plugin

=head1 SYNOPSIS

Prosess weblog trackback.

=head1 DESCRIPTION

Prosess weblog trackback.

=head1 USAGE

rename to trackback.inc.cgi

Make directory "./trackback"

=head1 OVERRIDE

none

=head1 SEE ALSO

=over 4

=item PyukiWiki/Plugin/ExPlugin/trackback

L<@@BASEURL@@/PyukiWiki/Plugin/ExPlugin/trackback/>

=item PyukiWiki/Plugin/Standard/tb

L<@@BASEURL@@/PyukiWiki/Plugin/Standard/tb/>

=item PyukiWiki CVS

L<@@CVSURL@@/PyukiWiki-Devel/lib/trackback.inc.pl>

L<@@CVSURL@@/PyukiWiki-Devel/plugin/tb.inc.pl>

=head1 AUTHOR

=over 4

@@AUTHOR_NANAMI@@

@@AUTHOR_PYUKI@@

=back

=head1 LICENSE

@@LICENSE_NANAMI@@

=cut
