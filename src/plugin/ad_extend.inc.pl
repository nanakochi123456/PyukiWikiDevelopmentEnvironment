sub ad_extend {
	my($ret, $_title, $_url, $id)=@_;
	my $loop=1;
	my $title=$_title ? $_title : $_url ? $_url : "";
	my $displayurl=$_url ? $_url : "";
	my $title_a=$title ? qq( title="$title") : "";
	my $title_img=$title ? qq( alt="$title") : "";
	my $url=$displayurl ? qq( onclick="window.status='$displayurl';return true;" onmouseout="window.status='';return true;") : "";
	$ret=~s/[\x0a|\x0d]//g;
	$ret=~s/<[Aa]\s/\f /g;
	my $ret1=$ret;
	my $ret2=$ret;

	$ret1=~s/\f(([^<]*))[Hh][Rr][Ee][Ff]="?(($::isurl_ad))"?(([^<]*?))>(([^\f]*?))<\/[Aa]>/<a href="$4" target="_blank" class="adlink" rel="nofollow">$8<\/a>/g;
	$ret1=~s/($::isurl_ad)/@{["$::script?cmd=ad&amp;c=@{[$loop++]}&amp;p=@{[&dbmname($::form{mypage})]}&amp;l=$id"]}/gm;
	$ret1=~s/<[Ii][Mm][Gg] (([^<]*)) [Ww][Ii][Dd][Tt][Hh]="1p?x?" [Hh][Ee][Ii][Gg][Hh][Tt]="1p?x?" (([^<]*))>/<img $1 class="addmy" $3>/g;
	$ret1=~s/<[Ii][Mm][Gg] (([^<]*)) [Hh][Ee][Ii][Gg][Hh][Tt]="1p?x?" [Ww][Ii][Dd][Tt][Hh]="1p?x?" (([^<]*))>/<img $1 class="addmy" $3>/g;
	$ret1=~s/\<img /\<img $title_img /g;
	$ret1=~s/ class="adlink"\>/ class="adlink"$title_a\>/g;

	if($displayurl ne "") {
		$loop=1;
		$::AD_CNT++;
		$ret1=<<EOM;
<noscript>$ret1</noscript><span id="az$::AD_CNT"></span>
EOM
		$ret2=~s/\f(([^<]*))[Hh][Rr][Ee][Ff]="?(($::isurl_ad))"?(([^<]*?))>(([^\f]*?))<\/[Aa]>/<a href="__displayurl__" target="_blank" class="adlink"  rel="nofollow" js=\f$4\f>$8<\/a>/g;
		$ret2=~s/($::isurl_ad)/@{["$::script?cmd=ad&amp;c=@{[$loop++]}&amp;p=@{[&dbmname($::form{mypage})]}&amp;l=$id"]}/gm;
		$ret2=~s/js=\f(.+?)\f/@{[&mkurl_ad($1,"onclick","b")]}@{[&mkurl_ad($1,"oncontextmenu","r")]}/g;
		$ret2=~s/<[Ii][Mm][Gg] (([^<]*)) [Ww][Ii][Dd][Tt][Hh]="1p?x?" [Hh][Ee][Ii][Gg][Hh][Tt]="1p?x?" (([^<]*))>/<img $1 class="addmy" $3>/g;
		$ret2=~s/<[Ii][Mm][Gg] (([^<]*)) [Hh][Ee][Ii][Gg][Hh][Tt]="1p?x?" [Ww][Ii][Dd][Tt][Hh]="1p?x?" (([^<]*))>/<img $1 class="addmy" $3>/g;
		$ret2=~s/\<img /\<img $title_img /g;
		$ret2=~s/ class="adlink"\>/ class="adlink"$title_a\>/g;
		$ret2=~s/__displayurl__/$displayurl/g;
#		my $u=&mkurl_ad($displayurl,
#		$ret2=~s/__onclicks__/@{[$displayurl/g;
		$ret=$ret1;
		my $r=$ret2;
		$r=~s/\n//g;
#		$r=~s/\'/\\\\\\\'/g;
		$::IN_JSHEAD.=<<EOM;
sinss("az$::AD_CNT", '$r');
EOM
	} else {
		$ret=$ret1;
	}
	return $ret;
}
1;
