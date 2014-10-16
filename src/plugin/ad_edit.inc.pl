######################################################################
# @@HEADERPLUGIN_NANAMI@@
######################################################################

$PLUGIN="ad";
$VERSION="1.09";

use strict;
use Digest::MD5 qw(md5_hex);
#use Digest::Perl::MD5 qw(md5_hex);
use Time::Local;

my $ad_cols=$::cols;
my $ad_rows=5;
my $ad_text=70;

# 0.1.5未満, 0.1.6以降のクロス動作
sub plugin_ad_edit_start {
	my $path=(&plugin_ad_pyukiver ? $::res_dir : $::data_home) . "/ad_edit.$::lang.txt";
#	$::form{"mymsg"}=&code_convert(\$::form{"mymsg"},$::defaultcode,$::kanjicode);
	$::form{"memo"}=&htmlspecialchars(&code_convert(\$::form{"memo"},$::defaultcode,$::kanjicode));
	$::form{"space"}=&htmlspecialchars(&code_convert(\$::form{"space"},$::defaultcode,$::kanjicode));
	$::form{"newspace"}=&htmlspecialchars(&code_convert(\$::form{"newspace"},$::defaultcode,$::kanjicode));
	$::form{"selspace"}=&code_convert(\$::form{selspace},$::defaultcode,$::kanjicode);

	%::resource = &plugin_ad_read_resource($path,%::resource) if(-r $path);

	if(&plugin_ad_pyukiver) {
		eval {"&load_wiki_module('auth');"};
		%::auth=&authadminpassword("submit");
		return('msg'=>"\t$::resource{ad_plugin_title}",'body'=>$::auth{html})
			if($::auth{authed} eq 0);
	} elsif (valid_password($::form{mypassword})) {
		$::auth{html}=qq(<input type="hidden" name="mypassword" value="$::form{mypassword}" />);
		$::auth{authed}=1;
	} else {
		my $body=<<EOM;
<form action="$::script" method="POST">
$::resource{frozenpassword}:
<input type="password" name="mypassword" /><input type="submit" />
<input type="hidden" name="cmd" value="ad" />
</form>
EOM
		return('msg'=>"\t$::resource{ad_plugin_title}",'body'=>$body);
	}
	return &plugin_ad_edit;
}

# 0.1.6からの引用
sub plugin_ad_read_resource {
	my ($file,%buf) = @_;

	open(FILE, $file) or &print_error("(resource:$file)");
	while (<FILE>) {
		s/\r\n/\n/;
		chomp;
		next if /^#/;
		s/\\n/\n/g;
		my ($key, $value) = split(/=/, $_, 2);
		$buf{$key} = &code_convert(\$value, $::defaultcode eq '' ? $::kanjicode : $::defaultcode);
	}
	close(FILE);

	return %buf;
}

# DB書き込み

sub plugin_ad_writedb {
	if($#::AD_DB < 0) {
		delete $::database{$AD::DATABASE};
		delete $::infobase{$AD::DATABASE};
	} else {
		my $dbbody;
		&set_info($AD::DATABASE, $::info_IsFrozen, 1);
		$dbbody="$::resource{ad_plugin_wiki}\n";
		foreach my $space(@::AD_DB) {
			my $hex=$space;
			$hex=~ s/(.)/unpack('H2', $1)/eg;
			$dbbody.="**$space\t$::AD_DB{__width}{$hex}x$::AD_DB{__height}{$hex}\n";
			foreach my $id(split(/\f/,$::AD_DB{$hex})) {
				$dbbody.=qq(***$id\t$::AD_DB_MEMO{"$hex\_$id"}\t$::AD_DB_PRIORITY{"$hex\_$id"}\t$::AD_DB_START{"$hex\_$id"}\t$::AD_DB_EXPIRE{"$hex\_$id"}\t$::AD_DB_CREATE{"$hex\_$id"}\t$::AD_DB_UPDATE{"$hex\_$id"}\t$::AD_DB_ALT{"$hex\_$id"}\t$::AD_DB_URL{"$hex\_$id"}\n);
				foreach my $html(split(/\n/,$::AD_DB_HTML{"$hex\_$id"})) {
					$dbbody.=" $html\n";
				}
				$dbbody.="\n";
			}
		}
		$::database{$AD::DATABASE}=$dbbody;
	}
}

sub plugin_ad_edit {
	my $body;

	my $mymsg;
	my $mode;
	my $flow;
	my $title;
	my $form;
	my $finish=0;
	my $height=0;
	my $width=0;
	my $err="";
	my $last;
	my $id;
	my $space;
	my $viewnavi=1;

	&plugin_ad_readdb;

	foreach(keys %::form) {
		if(/^mode\_(.*)/) {
			$mode=$1;
			last;
		}
	}
	$mode='' if($::form{cancel} ne '' || $::form{finish} ne '');
	if($mode ne '') {
		$flow=$::form{flow}+0;
		$flow-- if($::form{back} ne '');
		$flow++ if($::form{next} ne '');
		$flow=0 if($flow < 0);
	}
	if($mode eq 'delete') {
		if($flow eq 2) {
			my @tmp;
			foreach(@::AD_DB) {
				my $hex=$_;
				$hex=~ s/(.)/unpack('H2', $1)/eg;
				push(@tmp,$_) if($hex ne $::form{selspace});
			}
			@::AD_DB=@tmp;
			&plugin_ad_writedb;

			my $space=$::form{selspace};
			$space=~s/([A-Fa-f0-9][A-Fa-f0-9])/pack("C", hex($1))/eg;
			$title=$::resource{ad_plugin_title_delete};
			$form=sprintf($::resource{ad_plugin_msg_finishdelete},$space);
			$form.="<hr />";
			$finish=1;
		} elsif($flow eq 1) {
			$title=$::resource{ad_plugin_msg_confirmdelete};
			my $space=$::form{selspace};
			$space=~s/([A-Fa-f0-9][A-Fa-f0-9])/pack("C", hex($1))/eg;
			$form=sprintf($::resource{ad_plugin_msg_confirmdelete2},$space);
			$form.=qq(<input type="hidden" name="selspace" value="$::form{selspace}" /><hr />);
			my $i=0;
			foreach(@::AD_DB) {
				my $hex=$_;
				$hex=~ s/(.)/unpack('H2', $1)/eg;
				if($hex eq $::form{selspace} || $::form{selspace} eq '') {
					foreach my $id(split(/\f/,$::AD_DB{$hex})) {
						$i++;
						$last.=<<EOM;
<h3>$_<br />$id</h3>
$::AD_DB_HTML{"$hex\_$id"}<hr />
<table><tr><td colspan="2">
$::resource{ad_plugin_msg_memo}:$::AD_DB_MEMO{"$hex\_$id"}
</td></tr><tr><td valign="top">
$::resource{ad_plugin_msg_create}:@{[&selectdate("format","create",$::AD_DB_CREATE{"$hex\_$id"})]}<br />
$::resource{ad_plugin_msg_update}:@{[&selectdate("format","update",$::AD_DB_UPDATE{"$hex\_$id"})]}<br />
</td><td valign="top" width="250">
$::resource{ad_plugin_msg_priority}:@{[&selectnum("view","priority\_$hex\_$id",0,10,$::AD_DB_PRIORITY{"$hex\_$id"})]}<br />
$::resource{ad_plugin_msg_start}:@{[&selectdate("format","start\_$hex\_$id",$::AD_DB_START{"$hex\_$id"})]}<br />
$::resource{ad_plugin_msg_end}:@{[&selectdate("format","expire\_$hex\_$id",$::AD_DB_EXPIRE{"$hex\_$id"})]}<br /></td></tr>
</td></tr></table>
<hr />
EOM
					}
				}
			}
		}
		if($flow eq 0) {
			if($#::AD_DB < 0) {
				$mode="";
				$err=$::resource{ad_plugin_err_nospace};
			} else {
				$title=$::resource{ad_plugin_title_delete};
				$form=qq($::resource{ad_plugin_msg_delete}$::resource{ad_plugin_msg_spacesel}:<br /><select name="selspace">);
				foreach(@::AD_DB) {
					my $hex=$_;
					$hex=~ s/(.)/unpack('H2', $1)/eg;
					$form.=qq(<option value="$hex">@{[&getspacename($_)]}</option>);
				}
				$form.=qq(</select>\n);
			}
		}
	} elsif($mode eq 'edit') {
		if($flow eq 1) {
			my $hex;
			$form="";
			foreach(keys %::form) {
				if(/^(delete|edit|update)\_(.+)\_(.+)/) {
					my $_mode=$1;
					my $_hex=$2;
					my $_id=$3;
					if($_mode eq 'update') {
						$::AD_DB_MEMO{"$_hex\_$_id"}=&code_convert(\$::form{"memo\_$_hex\_$_id"},$::defaultcode,$::kanjicode);
						$::AD_DB_ALT{"$_hex\_$_id"}=&code_convert(\$::form{"alt\_$_hex\_$_id"},$::defaultcode,$::kanjicode);
						$::AD_DB_URL{"$_hex\_$_id"}=&code_convert(\$::form{"url\_$_hex\_$_id"},$::defaultcode,$::kanjicode);
						$::AD_DB_UPDATE{"$_hex\_$_id"}=time;
						$::AD_DB_START{"$_hex\_$_id"}=&selectdate("view","start\_$_hex\_$_id",-1);
						$::AD_DB_EXPIRE{"$_hex\_$_id"}=&selectdate("view","expire\_$_hex\_$_id",0);
						$::AD_DB_PRIORITY{"$_hex\_$_id"}=&selectnum("view","priority\_$_hex\_$_id",0,10,3);
						$::AD_DB_HTML{"$_hex\_$_id"}=&code_convert(\$::form{"input\_$_hex\_$_id"},$::defaultcode,$::kanjicode);
					}
					$title=sprintf($::resource{ad_plugin_msg_editfinish}, $::resource{"ad_plugin_btn_" . $_mode});
					$space=$_hex;
					$space=~s/([A-Fa-f0-9][A-Fa-f0-9])/pack("C", hex($1))/eg;
					$form.=<<EOM;
<h3>$space<br />$_id</h3>
<table><tr><td>
$::resource{ad_plugin_msg_memo}:$::AD_DB_MEMO{"$_hex\_$_id"}
$::resource{ad_plugin_msg_displayurlconfirm}:$::AD_DB_URL{"$_hex\_$_\url"}<br />
$::resource{ad_plugin_msg_altconfirm}:$::AD_DB_ALT{"$_hex\_$_id"}<br />
$::resource{ad_plugin_msg_displayurlconfirm}:$::AD_DB_URL{"$_hex\_$_id"}<br />
</td></tr><tr><td valign="top">
$::resource{ad_plugin_msg_create}:@{[&selectdate("format","create",$::AD_DB_CREATE{"$_hex\_$_id"})]}<br />
$::resource{ad_plugin_msg_update}:@{[&selectdate("format","update",$::AD_DB_UPDATE{"$_hex\_$_id"})]}<br />
$::resource{ad_plugin_msg_priority}:@{[&selectnum("view","priority\_$_hex\_$_id",0,10,$::AD_DB_PRIORITY{"$_hex\_$_id"})]}<br />
$::resource{ad_plugin_msg_start}:@{[&selectdate("format","start\_$_hex\_$_id",$::AD_DB_START{"$_hex\_$_id"})]}<br />
$::resource{ad_plugin_msg_end}:@{[&selectdate("format","expire\_$_hex\_$_id",$::AD_DB_EXPIRE{"$_hex\_$_id"})]}<br /></td></tr></table>
<hr />
$::AD_DB_HTML{"$_hex\_$_id"}
<hr />
EOM
					if($_mode eq 'delete') {
						my $tmp;
						foreach (split(/\f/,$::AD_DB{$_hex})) {
							$tmp.="$_\f" if($_ ne $_id);
						}
						$::AD_DB{$_hex}=$tmp;
					}
					$finish=1;
					&plugin_ad_writedb;
					last;
				}
			}
			if($form eq '') {
				foreach(@::AD_DB) {
					$hex=$_;
					$hex=~ s/(.)/unpack('H2', $1)/eg;
					if($hex eq $::form{selspace}) {
						$space=$_;
						last;
					}
				}
				if($space ne '') {
					$form.=qq($::resource{ad_plugin_msg_pluginusage}:<input type="text" name="dummy\_$hex\_$id" value="&$::form{cmd}($space);" size="$ad_text" /><hr />);
				}
				$space=$::resource{ad_plugin_msg_allsel} if($space eq '');
				$title="$::resource{ad_plugin_title_edit} : $space";
				my $i=0;
				foreach(@::AD_DB) {
					$hex=$_;
					$hex=~ s/(.)/unpack('H2', $1)/eg;
					if($hex eq $::form{selspace} || $::form{selspace} eq '') {
						foreach my $id(split(/\f/,$::AD_DB{$hex})) {
							$i++;
							$::IN_HEAD.=<<EOM if($::IN_HEAD!~/Display/);
<script type="text/javascript"><!--
//\@\@yuicompressor_js="./plugin/ad_edit.inc.js"\@\@
function Display(id,mode){
	if(d.all || d.getElementById){	//IE4, NN6 or later
		if(d.all){
			obj = d.all(id).style;
		}else if(d.getElementById){
			obj = d.getElementById(id).style;
		}
		if(mode == "view") {
			obj.display = "block";
		} else if(mode == "none") {
			obj.display = "none";
		} else if(obj.display == "block"){
			obj.display = "none";		//hidden
		}else if(obj.display == "none"){
			obj.display = "block";		//view
		}
	}
}

//--></script>
EOM

							$form.=<<EOM;
<h3>$_<br />$id</h3>
<table><tr><td colspan="2">
$::resource{ad_plugin_msg_alt}:<input type="text" name="alt\_$hex\_$id" value="$::AD_DB_ALT{"$hex\_$id"}" size="$ad_text" /><br />
$::resource{ad_plugin_msg_displayurl}:<input type="text" name="displayurl\_$hex\_$id" value="$::AD_DB_URL{"$hex\_$id"}" size="$ad_text" /><br />
$::resource{ad_plugin_msg_memo}:<input type="text" name="memo\_$hex\_$id" value="$::AD_DB_MEMO{"$hex\_$id"}" size="$ad_text" />
</td></tr><tr><td valign="top">
$::resource{ad_plugin_msg_create}:@{[&selectdate("format","create",$::AD_DB_CREATE{"$hex\_$id"})]}<br />
$::resource{ad_plugin_msg_update}:@{[&selectdate("format","update",$::AD_DB_UPDATE{"$hex\_$id"})]}<br />
</td><td valign="top" width="250">
$::resource{ad_plugin_msg_priority}:@{[&selectnum("sel","priority\_$hex\_$id",0,10,$::AD_DB_PRIORITY{"$hex\_$id"})]}<br />
$::resource{ad_plugin_msg_start}:@{[&selectdate("sel","start\_$hex\_$id",$::AD_DB_START{"$hex\_$id"})]}<br />
$::resource{ad_plugin_msg_end}:@{[&selectdate("sel","expire\_$hex\_$id",$::AD_DB_EXPIRE{"$hex\_$id"})]}<br /></td></tr>
<tr><td colspan="2" align="right">
<input type="submit" name="cancel" value="$::resource{ad_plugin_btn_cancel}"@{[$finish eq 1 ? ' disabled="disabled"' : '']} />
<input type="submit" name="back" value="$::resource{ad_plugin_btn_back}"@{[$flow eq 0 || $finish eq 1 ? ' disabled="disabled"' : '']} />
<input type="submit" name="edit\_$hex\_$id" value="$::resource{ad_plugin_btn_edit}" onclick="Display('editarea\_$hex\_$id','view');return false;" />
<input type="submit" name="delete\_$hex\_$id" value="$::resource{ad_plugin_btn_delete}" onclick="return confirm('$::resource{ad_plugin_btn_delete}$::resource{ad_plugin_btn_jsconfirm}');" />
<input type="submit" name="update\_$hex\_$id" value="$::resource{ad_plugin_btn_update}" onclick="return confirm('$::resource{ad_plugin_btn_update}$::resource{ad_plugin_btn_jsconfirm}');" />
</td></tr></table>
<hr />
<div id="editarea\_$hex\_$id" style="display: none;">
<textarea name="input\_$hex\_$id" cols="$ad_cols" rows="$ad_rows">@{[&htmlspecialchars($::AD_DB_HTML{"$hex\_$id"})]}</textarea><hr />
</div>
<div id="ad\_$hex\_$id">$::AD_DB_HTML{"$hex\_$id"}</div><hr />
EOM
						}
					}
				}
				if($i eq 0) {
					$err=$::resource{ad_plugin_err_notfound};
					$flow=0;
				} else {
					$viewnavi=0;
				}
			}
		}
		if($flow eq 0) {
			if($#::AD_DB < 0) {
				$mode="";
				$err=$::resource{ad_plugin_err_nospace};
			} else {
				$title=$::resource{ad_plugin_title_edit};
				$form=qq($::resource{ad_plugin_msg_edit}$::resource{ad_plugin_msg_spacesel}:<br /><select name="selspace"><option value="">$::resource{ad_plugin_msg_allsel}</option>);
				foreach(@::AD_DB) {
					my $hex=$_;
					$hex=~ s/(.)/unpack('H2', $1)/eg;
					$form.=qq(<option value="$hex">@{[&getspacename($_)]}</option>);
				}
				$form.=qq(</select>\n);
			}
		}
	} elsif($mode eq 'add') {
		# 完了
		if($flow eq 3) {
			if($::form{mymsg}!~/[<>]/) {
				$flow=0;
				$err=$::resource{ad_plugin_err_adhtml};
			} elsif($::form{space} eq '') {
				$flow=1;
				$err=$::resource{ad_plugin_err_spacename};
			} else {
				$id=md5_hex(sprintf("%s:%03d:%03d",$::form{mymsg},$::form{width},$::form{height}));
				if($id ne $::form{id}) {
					$flow=2;
					$err=$::resource{ad_plugin_err_changed};
				} else {
					$finish=1;
					my $memo;
					$height=$::form{height};
					$width=$::form{width};
					$title=$::resource{ad_plugin_msg_finish};
					my $alt=$::form{alt};
					my $displayurl=$::form{displayurl};
					my $size;
					if($width eq 1) {
						$size=sprintf($::resource{ad_plugin_msg_adtext});
					} elsif($height eq 1) {
						$size=sprintf($::resource{ad_plugin_msg_w}, $width);
					} else {
						$size=sprintf($::resource{ad_plugin_msg_wh}, $width, $height);
					}
					$mymsg=$::form{mymsg};
					$memo=$::form{memo};
					$space=$::form{space};
					$form.=<<EOM;
$::resource{ad_plugin_msg_space}: $space<br />
$::resource{ad_plugin_msg_id}: $id<br />
$::resource{ad_plugin_msg_altconfirm}: @{[$alt eq "" ? $::resource{ad_plugin_msg_altconfirm_none} : $alt]}<br />
$::resource{ad_plugin_msg_displayurlconfirm}: @{[$displayurl eq "" ? $::resource{ad_plugin_msg_displayurlconfirm_none} : $displayurl]}<br />
$size<br />
$::resource{ad_plugin_msg_priority}:@{[&selectnum("view","priority",0,10,3)]}<br />
$::resource{ad_plugin_msg_start}:@{[&selectdate("format","start",-1)]}<br />
$::resource{ad_plugin_msg_end}:@{[&selectdate("format","expire",0)]}<br />
$::resource{ad_plugin_msg_memo}: $memo<br />
$::resource{ad_plugin_msg_html}: <br />
<textarea cols="$ad_cols" rows="$ad_rows" name="mymsg">$mymsg</textarea><br />
EOM
					$last.=qq(<hr />$::form{mymsg});

					my $flg=0;
					foreach my $tmp(@::AD_DB) {
						$flg=1 if($tmp eq $space);
					}
					if($flg eq 0) {
						push(@::AD_DB,$space);
						$space=~ s/(.)/unpack('H2', $1)/eg;
						$::AD_DB{__width}{$space}=$width;
						$::AD_DB{__height}{$space}=$height;
					} else {
						$space=~ s/(.)/unpack('H2', $1)/eg;
					}
					$::AD_DB{$space}.="$id\f";
					$::AD_DB_MEMO{"$space\_$id"}=$memo;
					$::AD_DB_HTML{"$space\_$id"}=$::form{mymsg};
					$::AD_DB_CREATE{"$space\_$id"}=time;
					$::AD_DB_UPDATE{"$space\_$id"}=time;
					$::AD_DB_displayurl{"$space\_$id"}=$alt;
					$::AD_DB_START{"$space\_$id"}=&selectdate("view","start",-1);
					$::AD_DB_EXPIRE{"$space\_$id"}=&selectdate("view","expire",0);
					$::AD_DB_PRIORITY{"$space\_$id"}=&selectnum("view","priority",0,10,3);
					$::AD_DB_ALT{"$space\_$id"}=$::form{alt};
					$::AD_DB_URL{"$space\_$id"}=$::form{displayurl};

					&plugin_ad_writedb;
				}
			}
		}
		# 確認、日付設定
		if($flow eq 2) {
			if($::form{mymsg}!~/[<>]/) {
				$flow--;
				$err=$::resource{ad_plugin_err_adhtml};
				$space="";
			}
			my $newspace=$::form{"newspace"};
			if(&is_adeditable($newspace)) {
				$space=$newspace;
			} elsif($newspace eq '') {
				$mymsg=$::form{selspace};
				foreach(@::AD_DB) {
					my $hex=$_;
					$hex=~s/(.)/unpack('H2', $1)/eg;
					$space=$_ if($hex eq $mymsg);
				}
				$mymsg="";
			}
			if($space eq '') {
				$err=$::resource{ad_plugin_err_spacename};
				$flow--;
			} else {
				my $flg=0;
				$height=$::form{height};
				$width=$::form{width};
				$title=$::resource{ad_plugin_msg_confirm};
				my $size;
				if($width eq 1) {
					$size=sprintf($::resource{ad_plugin_msg_adtext});
				} elsif($height eq 1) {
					$size=sprintf($::resource{ad_plugin_msg_w}, $width);
				} else {
					$size=sprintf($::resource{ad_plugin_msg_wh}, $width, $height);
				}
				$mymsg=&htmlspecialchars($::form{mymsg});
				$::form{space}=$space;
				$id=md5_hex(sprintf("%s:%03d:%03d",$::form{mymsg},$::form{width},$::form{height}));
				my $alt=$::form{alt};
				my $displayurl=$::form{displayurl};
				foreach my $spc(@::AD_DB) {
					my $tmph=$spc;
					$tmph=~ s/(.)/unpack('H2', $1)/eg;
					foreach my $tmp(split(/\f/,$::AD_DB{$tmph})) {
						$flg=1 if($id eq $tmp && $spc eq $::form{space});
					}
				}
				if($flg eq 1) {
					$err=$::resource{ad_plugin_err_dup};
					$flow--;
				} else {
					$form.=<<EOM;
$::resource{ad_plugin_msg_space}: $space<br />
$::resource{ad_plugin_msg_id}: $id<br />
$::resource{ad_plugin_msg_altconfirm}: @{[$alt eq "" ? $::resource{ad_plugin_msg_altconfirm_none} : $alt]}<br />
$::resource{ad_plugin_msg_displayurlconfirm}: @{[$displayurl eq "" ? $::resource{ad_plugin_msg_displayurlconfirm_none} : $displayurl]}<br />
$size<br />
$::resource{ad_plugin_msg_html}: <br />
<textarea cols="$ad_cols" rows="$ad_rows" name="mymsg">$mymsg</textarea><br />
$::resource{ad_plugin_msg_priority}:@{[&selectnum("sel","priority",0,10,3)]}<br />
$::resource{ad_plugin_msg_start}:@{[&selectdate("sel","start",-1)]}<br />
$::resource{ad_plugin_msg_end}:@{[&selectdate("sel","expire",0)]}<br />
$::resource{ad_plugin_msg_memo}:<input type="text" name="memo" value="$::form{memo}" size="$ad_text" /><br />
<input type="hidden" name="space" value="$space" />
<input type="hidden" name="id" value="$id" />
<input type="hidden" name="newspace" value="$::form{newspace}" />
<input type="hidden" name="selspace" value="$::form{selspace}" />
<input type="hidden" name="width" value="$width" />
<input type="hidden" name="height" value="$height" />
<input type="hidden" name="alt" value="$alt" />
<input type="hidden" name="displayurl" value="$displayurl" />
EOM
					$last.=qq(<hr />$::form{mymsg});
				}
			}
		}
		# 広告確認＆スペース選択
		if($flow eq 1) {
			foreach("<",">",":","/","\"") {
				if($::form{mymsg}!~/$_/) {
					$flow=0;
					$err=$::resource{ad_plugin_err_adhtml};
					$::form{mymsg}="";
				}
			}
			$mymsg=$::form{mymsg};
			foreach($mymsg=~/(?:height\s*?=\s*?["'](\d+)["'])|(?:height\s*?[=:]\s*?(\d+))/) {
				$height=$1+$2+0 if($height+0<$1+$2+0);
			}
			foreach($mymsg=~/(?:width\s*?=\s*?["'](\d+)["'])|(?:width\s*?[=:]\s*?(\d+))/) {
				$width=$1+$2+0 if($width+0<$1+$2+0);
			}
			if($width<10) {
				$width=1;
				$height=1;
			}
			$height=1 if($height<10);
			$title=$::resource{ad_plugin_title_selspace};
			$form.=sprintf($::resource{$height ne 1 ? 'ad_plugin_msg_html_wh' : $width ne 1 ? 'ad_plugin_msg_html_w' : 'ad_plugin_msg_html_text'}
				,$width,$height);
			$last.=qq(<hr />$mymsg);
			$mymsg=&htmlspecialchars($mymsg);
			my ($sel,$hex);
			foreach(@::AD_DB) {
				$hex=$_;
				$hex=~ s/(.)/unpack('H2', $1)/eg;
				if($::AD_DB{__width}{$hex} eq $width && $::AD_DB{__height}{$hex} eq $height) {
					$sel.=qq(<option value="$hex"@{[$::form{selspace} eq $_ ? " selected" : ""]}>@{[&getspacename($_)]}</option>);
				}
			}
			$sel=qq(<option value="">$::resource{ad_plugin_msg_nospace}</option>) if($sel eq '');
			$form.=<<EOM;
<input type="hidden" name="width" value="$width" />
<input type="hidden" name="height" value="$height" />
<input type="hidden" name="mymsg" value="$mymsg" /><br />
<hr />
$::resource{ad_plugin_msg_newspace}:<input type="text" name="newspace" value="$::form{newspace}" size="$ad_text" /><br />
$::resource{ad_plugin_msg_alt}:<input type="text" name="alt" value="$::form{alt}" size="$ad_text" /><br />
$::resource{ad_plugin_msg_displayurl}:<input type="text" name="displayurl" value="$::form{displayurl}" size="$ad_text" /><br />
$::resource{ad_plugin_msg_selspace}:<select name="selspace">$sel</select>
EOM
		}
		# 初期入力画面
		if($flow eq 0) {
			$title=$::resource{ad_plugin_title_add};
			$mymsg=&htmlspecialchars($::form{mymsg});
			$form=<<EOM;
$::resource{ad_plugin_msg_add}<br />
<textarea cols="$ad_cols" rows="$ad_rows" name="mymsg">$mymsg</textarea><br />
EOM
		}
		$body.=<<EOM;
</form>
EOM
	}
	if($mode eq '') {
		$title=$::resource{ad_plugin_title};
		$form.=qq(<input type="submit" name="mode_add" value="$::resource{ad_plugin_title_add}" />);
		$form.=qq(<input type="submit" name="mode_edit" value="$::resource{ad_plugin_title_edit}" />);
		$form.=qq(<input type="submit" name="mode_delete" value="$::resource{ad_plugin_title_delete}" />);
	}

	$body=<<EOM;
<h2>$title</h2>
<form atcion="$::script" method="POST">
<input type="hidden" name="cmd" value="ad" />
<input type="hidden" name="flow" value="$flow" />
@{[$mode ne '' ? qq(<input type="hidden" name="mode_$mode" value="1" />) : '']}
@{[$mode ne '' ? qq(<input type="hidden" name="flow" value="$flow" />) : '']}
$::auth{html}
@{[$err ne '' ? qq(<div class="error">$err</div>) : ""]}
$form
<br />
EOM
	if($mode ne '' && $viewnavi eq 1) {
		$body.=<<EOM;
<input type="submit" name="back" value="$::resource{ad_plugin_btn_back}"@{[$flow eq 0 || $finish eq 1 ? ' disabled="disabled"' : '']} />
<input type="submit" name="next" value="$::resource{ad_plugin_btn_next}"@{[$finish eq 1 ? ' disabled="disabled"' : '']} />
<input type="submit" name="finish" value="$::resource{ad_plugin_btn_finish}"@{[$finish ne 1 ? ' disabled="disabled"' : '']} />
<input type="submit" name="cancel" value="$::resource{ad_plugin_btn_cancel}"@{[$finish eq 1 ? ' disabled="disabled"' : '']} />
EOM
	}
	$body.=<<EOM;
</form>
$last
EOM
	return('msg'=>"\t$::resource{ad_plugin_title}", 'body'=>$body);
}

sub is_adeditable {
	my ($page) = @_;
	return 0 if (&is_bracket_name($page));
	return 0 if ($page=~/\s/);
	return 0 if ($page=~/[();#&]/);
	return 0 if ($page=~/^$::interwiki_name1$/ || $page=~/^\#/);
	return 0 if ($page =~ /(^|\/)\.{1,2}(\/|$)/); # ./ ../ is ng
	return 0 if ($page=~/^\// || $page=~/\/$/);
	return 0 if ($page eq '' || not $page);
	return 1;
}

sub selectnum {
	my($md,$s,$st,$en,$v)=@_;
	my $str;
	my $sel;
	if($::form{$s} ne '') {
		if($st<=$::form{$s}+0 && $::form{$s}+0<=$en) {
			$v=$::form{$s}+0;
		}
	}
	$str.=qq(<select name="$s">);
	for(my $i=$st; $i<=$en; $i++) {
		$str.=qq(<option value="$i"@{[$i eq $v ? ' selected="selected"' : '']}>$i</option>);
	}
	$str.=qq(</select>\n);
	return $str if($md eq 'sel');
	return $v;
}

sub getspacename {
	my ($name)=@_;
	my $hex=$name;
	$hex=~ s/(.)/unpack('H2', $1)/eg;
	my $height=$::AD_DB{__height}{$hex};
	my $width=$::AD_DB{__width}{$hex};
	if($width < 10) {
		return "$name ($::resource{ad_plugin_msg_text})";
	} elsif($height < 10) {
		return "$name ($width x $::resource{ad_plugin_msg_unknown})";
	}
	return "$name($width x $height)";
}

sub selectdate {
	my($md,$s,$t,$y,$m,$d)=@_;
	my $str;
	my $sel;
	if($::form{"$s\_y"}+0>1900 && $::form{"$s\_m"}+0>0 && $::form{"$s\_d"}+0>0) {
		eval { $t=Time::Local::timelocal(0,0,0,$::form{"$s\_d"},$::form{"$s\_m"}-1,$::form{"$s\_y"}-1900);};
		$t=0 if($@);
	} elsif($t eq -1) {
		$t=time;
	} elsif($y+0>1900 && $m+0>0 && $d+0>0) {
		eval { $t=Time::Local::timelocal(0,0,0,$d,$m-1,$y-1900)};
		$t=0 if($@);
	}
	my ($sec, $min, $hour, $day, $mon, $year, $weekday) = localtime($t);
	my ($_sec, $_min, $_hour, $_day, $_mon, $_year, $_weekday) = localtime(time);
	$str=qq(<select name="$s\_y"><option value="">$::resource{ad_plugin_sel_nosel}</option>);
	for(my $i=$_year+1900;$i<=$_year+1900+5; $i++) {
		$str.=qq(<option value="$i"@{[$i eq $year+1900 ? ' selected="selected"' : '']}>$i$::resource{ad_plugin_sel_year}</option>);
	}
	if($year+1900<2000) {
		$mon=-1; $day=0;
	}
	$str.=qq(</select><select name="$s\_m"><option value="">$::resource{ad_plugin_sel_nosel}</option>);
	for(my $i=1; $i<=12; $i++) {
		$str.=qq(<option value="$i"@{[$i eq $mon+1 ? ' selected="selected"' : '']}>$i$::resource{ad_plugin_sel_month}</option>);
	}
	$str.=qq(</select><select name="$s\_d"><option value="">$::resource{ad_plugin_sel_nosel}</option>);
	for(my $i=1; $i<=31; $i++) {
		$str.=qq(<option value="$i"@{[$i eq $day ? ' selected="selected"' : '']}>$i$::resource{ad_plugin_sel_day}</option>);
	}
	$str.=qq(</select>\n);
	return $str if($md eq 'sel');
	if($md eq 'format') {
		return $::resource{ad_plugin_sel_nosel} if($t+0 eq 0);
		return &date("Y-m-d",$t);
	}
	return $t;
}

1;
__END__

=head1 NAME

ad_edit.inc.pl - PyukiWiki Administrator's Plugin

=head1 SYNOPSIS

This is ad.inc.pl's sub plugin, Look ad.inc.pl's perl pod

=head1 SEE ALSO

=over 4

=item PyukiWiki/Plugin/Nanami/ad/

L<@@BASEURL@@/PyukiWiki/Plugin/Nanami/ad/>

=item PyukiWiki CVS

L<@@CVSURL@@/PyukiWiki-Devel/plugin/ad.inc.pl>

L<@@CVSURL@@/PyukiWiki-Devel/plugin/ad_edit.inc.pl>

=back

=head1 AUTHOR

=over 4

@@AUTHOR_NANAMI@@

@@AUTHOR_PYUKI@@

=back

=head1 LICENSE

@@LICENSE_NANAMI@@

=cut
