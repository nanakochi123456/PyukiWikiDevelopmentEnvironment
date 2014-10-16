# ¤«¤Ê¢ªJISÊÑ´¹

$kj_maxlength=10000;

my @karay1 = (
	'¤Ì £±',
	'¤Õ £²',
	'¤Ö £²¡÷',
	'¤× £²¡Î',
	'¤¢ £³',
	'¤¦ £´',
	'¤¨ £µ',
	'¤ª £¶',
	'¤ä £·',
	'¤æ £¸',
	'¤è £¹',
	'¤ï £°',
	'¥ô £´¡÷',
	'¤Û ¡Ý',
	'¤Ü ¡Ý¡÷',
	'¤Ý ¡Ý¡Î',
	'¤Ø ¡°',
	'¤Ù ¡°¡÷',
	'¤Ú ¡Ý¡Î',
	'¡¼ ¡ï',
	'¤¿ £ñ',
	'¤À £ñ¡÷',
	'¤Æ £÷',
	'¤Ç £÷¡÷',
	'¤¤ £å',
	'¤¹ £ò',
	'¤º £ò¡÷',
	'¤« £ô',
	'¤¬ £ô¡÷',
	'¤ó £ù',
	'¤Ê £õ',
	'¤Ë £é',
	'¤é £ï',
	'¤» £ð',
	'¤¼ £ð¡÷',
	'¤Á £á',
	'¤Â £á¡÷',
	'¤È £ó',
	'¤É £ó¡÷',
	'¤· £ä',
	'¤¸ £ä¡÷',
	'¤Ï £æ',
	'¤Ð £æ¡÷',
	'¤Ñ £æ¡Î',
	'¤­ £ç',
	'¤® £ç¡÷',
	'¤¯ £è',
	'¤° £è¡÷',
	'¤Þ £ê',
	'¤Î £ë',
	'¤ê £ì',
	'¤ì ¡¨',
	'¤± ¡§',
	'¤² ¡§¡÷',
	'¤à ¡Ï',
	'¤Ä £ú',
	'¤Å £ú¡÷',
	'¤µ £ø',
	'¤¶ £ø¡÷',
	'¤½ £ã',
	'¤¾ £ã¡÷',
	'¤Ò £ö',
	'¤Ó £ö¡÷',
	'¤Ô £ö¡Î',
	'¤³ £â',
	'¤´ £â¡÷',
	'¤ß £î',
	'¤â £í',
	'¤Í ¡¤',
	'¤ë ¡¥',
	'¤á ¡¿',
	'¤í ¡À',
	'¤¡ ¡ô',
	'¤¥ ¡ð',
	'¤§ ¡ó',
	'¤© ¡õ',
	'¤ã ¡Ç',
	'¤å ¡Ê',
	'¤ç ¡Ë',
	'¤ò (Shift+)£°(¥¼¥í)',
	'¤£ £Å',
	'¤Ã £Ú',
	'a a',
	'b b',
	'c c',
	'd d',
	'e e',
	'f f',
	'g g',
	'h h',
	'i i',
	'j j',
	'k k',
	'l l',
	'm m',
	'n n',
	'o o',
	'p p',
	'q q',
	'r r',
	's s',
	't t',
	'u u',
	'v v',
	'w w',
	'x x',
	'y y',
	'z z',
	'A A',
	'B B',
	'C C',
	'D D',
	'E E',
	'F F',
	'G G',
	'H H',
	'I I',
	'J J',
	'K K',
	'L L',
	'M M',
	'N N',
	'O O',
	'P P',
	'Q Q',
	'R R',
	'S S',
	'T T',
	'U U',
	'V V',
	'W W',
	'X X',
	'Y Y',
	'Z Z',
	'£á a',
	'£â b',
	'£ã c',
	'£ä d',
	'£å e',
	'£æ f',
	'£ç g',
	'£è h',
	'£é i',
	'£ê j',
	'£ë k',
	'£ì l',
	'£í m',
	'£î n',
	'£ï o',
	'£ð p',
	'£ñ q',
	'£ò r',
	'£ó s',
	'£ô t',
	'£õ u',
	'£ö v',
	'£÷ w',
	'£ø x',
	'£ù y',
	'£ú z',
	'£Á A',
	'£Â B',
	'£Ã C',
	'£Ä D',
	'£Å E',
	'£Æ F',
	'£Ç G',
	'£È H',
	'£É I',
	'£Ê J',
	'£Ë K',
	'£Ì L',
	'£Í M',
	'£Î N',
	'£Ï O',
	'£Ð P',
	'£Ñ Q',
	'£Ò R',
	'£Ó S',
	'£Ô T',
	'£Õ U',
	'£Ö V',
	'£× W',
	'£Ø X',
	'£Ù Y',
	'£Ú Z',
	'¡¡ ¡¡' # ¥¹¥Ú¡¼¥¹ÄêµÁ

);

my @karay2 = (
	'¤Ì £±',
	'¤Õ £²',
	'¤Ö £²¡÷',
	'¤× £²¡Î',
	'¤¢ £³',
	'¤¦ £´',
	'¤¨ £µ',
	'¤ª £¶',
	'¤ä £·',
	'¤æ £¸',
	'¤è £¹',
	'¤ï £°',
	'¥ô £´¡÷',
	'¤Û ¡Ý',
	'¤Ü ¡Ý¡÷',
	'¤Ý ¡Ý¡Î',
	'¤Ø ¡°',
	'¤Ù ¡°¡÷',
	'¤Ú ¡Ý¡Î',
	'¡¼ ¡ï',
	'¤¿ £ñ',
	'¤À £ñ¡÷',
	'¤Æ £÷',
	'¤Ç £÷¡÷',
	'¤¤ £å',
	'¤¹ £ò',
	'¤º £ò¡÷',
	'¤« £ô',
	'¤¬ £ô¡÷',
	'¤ó £ù',
	'¤Ê £õ',
	'¤Ë £é',
	'¤é £ï',
	'¤» £ð',
	'¤¼ £ð¡÷',
	'¤Á £á',
	'¤Â £á¡÷',
	'¤È £ó',
	'¤É £ó¡÷',
	'¤· £ä',
	'¤¸ £ä¡÷',
	'¤Ï £æ',
	'¤Ð £æ¡÷',
	'¤Ñ £æ¡Î',
	'¤­ £ç',
	'¤® £ç¡÷',
	'¤¯ £è',
	'¤° £è¡÷',
	'¤Þ £ê',
	'¤Î £ë',
	'¤ê £ì',
	'¤ì ¡¨',
	'¤± ¡§',
	'¤² ¡§¡÷',
	'¤à ¡Ï',
	'¤Ä £ú',
	'¤Å £ú¡÷',
	'¤µ £ø',
	'¤¶ £ø¡÷',
	'¤½ £ã',
	'¤¾ £ã¡÷',
	'¤Ò £ö',
	'¤Ó £ö¡÷',
	'¤Ô £ö¡Î',
	'¤³ £â',
	'¤´ £â¡÷',
	'¤ß £î',
	'¤â £í',
	'¤Í ¡¤',
	'¤ë ¡¥',
	'¤á ¡¿',
	'¤í ¡À',
	'¤¡ (Shift+)£³',
	'¤¥ (Shift+)£´',
	'¤§ (Shift+)£µ',
	'¤© (Shift+)£¶',
	'¤ã (Shift+)£·¡Ç',
	'¤å (Shift+)£¸',
	'¤ç (Shift+)£¹',
	'¤ò (Shift+)£°(¥¼¥í)',
	'¤£ (Shift+)£å',
	'¤Ã (Shift+)£ú',
	'a a',
	'b b',
	'c c',
	'd d',
	'e e',
	'f f',
	'g g',
	'h h',
	'i i',
	'j j',
	'k k',
	'l l',
	'm m',
	'n n',
	'o o',
	'p p',
	'q q',
	'r r',
	's s',
	't t',
	'u u',
	'v v',
	'w w',
	'x x',
	'y y',
	'z z',
	'A A',
	'B B',
	'C C',
	'D D',
	'E E',
	'F F',
	'G G',
	'H H',
	'I I',
	'J J',
	'K K',
	'L L',
	'M M',
	'N N',
	'O O',
	'P P',
	'Q Q',
	'R R',
	'S S',
	'T T',
	'U U',
	'V V',
	'W W',
	'X X',
	'Y Y',
	'Z Z',
	'£á a',
	'£â b',
	'£ã c',
	'£ä d',
	'£å e',
	'£æ f',
	'£ç g',
	'£è h',
	'£é i',
	'£ê j',
	'£ë k',
	'£ì l',
	'£í m',
	'£î n',
	'£ï o',
	'£ð p',
	'£ñ q',
	'£ò r',
	'£ó s',
	'£ô t',
	'£õ u',
	'£ö v',
	'£÷ w',
	'£ø x',
	'£ù y',
	'£ú z',
	'£Á A',
	'£Â B',
	'£Ã C',
	'£Ä D',
	'£Å E',
	'£Æ F',
	'£Ç G',
	'£È H',
	'£É I',
	'£Ê J',
	'£Ë K',
	'£Ì L',
	'£Í M',
	'£Î N',
	'£Ï O',
	'£Ð P',
	'£Ñ Q',
	'£Ò R',
	'£Ó S',
	'£Ô T',
	'£Õ U',
	'£Ö V',
	'£× W',
	'£Ø X',
	'£Ù Y',
	'£Ú Z',
	'¡¡ ¡¡' # ¥¹¥Ú¡¼¥¹ÄêµÁ

);

my $kj_javascript=<<EOM;
<script type="text/javascript"><!--
ka1 = new Array();
ka2 = new Array();
DATA

function kj(form) {
	br=unescape('%0A');

	if(form.shift.checked) {
		ka=ka2;
	} else {
		ka=ka1;
	}
	if(form.form1.value.length == 0) {
		fca(form);
		form.form2.value="Ê¸»úÎó¤¬ÆþÎÏ¤µ¤ì¤Æ¤¤¤Þ¤»¤ó¡£";
		return;
	}
	if(form.form1.value.length > $kj_maxlength) {
		fca(form);
		form.form2.value="Ê¸»úÎó¤¬Ä¹¤¹¤®¤Þ¤¹¡£";
		return;
	}
	fc(form.form2);
	ot = form.form1.value;
	jt = new String();
	pt = new String();
	la = new String();
	crlf=0;
	fst=1;
	for(i = 0; i < ot.length; i++) {
		char=ot.charAt(i);
		if(char == '\\r') {
			continue;
		}
		if(char == '\\n') {
			if(crlf != 0) {
				if(fst == 0) {
					pt = pt.concat(br);
				}
				pt = pt.concat(la);
				pt = pt.concat(br);
				pt = pt.concat(jt)
				pt = pt.concat(br);
				la='';
				jt='';
				crlf=0;
				fst=0;

			}
			continue;
		}
		if(char == ' ') {
			char='¡¡';
		}
		if(!ka[char]) {
			form.form2.value="¤Ò¤é¤¬¤Ê¡¢±ÑÊ¸»ú°Ê³°¤¬Â¸ºß¤·¤Þ¤¹¡£";
			return;
		} else {
			if(crlf==0) {
				if(ka[char] == '¡¡') {
					continue;
				}
			}
			la=la.concat(char);
			jt = jt.concat(ka[char]);
			crlf++;
		}
	}
	if(crlf != 0) {
		if(fst == 0) {
			pt = pt.concat(br);
		}
		pt = pt.concat(la);
		pt = pt.concat(br);
		pt = pt.concat(jt);
		pt = pt.concat(br);
	}
	form.form2.value=pt;
	return;
}

function fca(form) {
	fc(form.form1);
	fc(form.form2);
}

function fc(form) {
	form.value='';
}
//--></script>
EOM

my $kj_html=<<EOM;
<form id="convert">
<textarea name="form1" rows="@{[sprintf("%d",$::rows/2)]}" cols="$::cols"></textarea><br />
<input name="action" type="button" value="¤«¤ÊÊ¸»ú¢ªJISÊÑ´¹" onclick="kj(this.form);" onkeypress="kj(this.form)">
<input name="clear" type="button" value="¥¯¥ê¥¢" onclick="fca(this.form);" onkeypress="fca(this.form);">
<input name="shift" type="checkbox">¥·¥Õ¥È¥­¡¼¤ò²¡¤·¤¿¾õÂÖ¤ò½ÐÎÏ
<br />
<textarea name="form2" rows="@{[sprintf("%d",$::rows/2)]}" cols="$::cols"></textarea>
</form>
EOM

sub plugin_kanatojis_convert {
	my $data;
	foreach $line (@karay1) {
		my($kana,$jis)=split(/ /,$line);
		$data.="ka1[\"$kana\"]=\"$jis\";";
	}
	foreach $line (@karay2) {
		my($kana,$jis)=split(/ /,$line);
		$data.="ka2[\"$kana\"]=\"$jis\";";
	}

	$kj_javascript=~s/DATA/$data/g;
	$::IN_HEAD.=$kj_javascript;

	return $kj_html;
}
1;
__END__
