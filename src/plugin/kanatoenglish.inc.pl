# 英文字→かな変換 for PyukiWiki 0.1.6 Delopper version

$kj_maxlength=10000;

my @karay = (
	'ぬ ぬ,0',
	'ふ ふ,0',
	'ぶ ぶ,0',
	'ぷ ぷ,0',
	'あ あ,0',
	'う う,0',
	'え え,0',
	'お お,0',
	'や や,0',
	'ゆ ゆ,0',
	'よ よ,0',
	'わ わ,0',
	'ヴ ヴ,0',
	'ほ ほ,0',
	'ぼ ぼ,0',
	'ぽ ぽ,0',
	'へ へ,0',
	'べ べ,0',
	'ぺ ぺ,0',
	'ー ー,0',
	'た た,0',
	'だ だ,0',
	'て て,0',
	'で で,0',
	'い い,0',
	'す す,0',
	'ず ず,0',
	'か か,0',
	'が が,0',
	'ん ん,0',
	'な な,0',
	'に に,0',
	'ら ら,0',
	'せ せ,0',
	'ぜ ぜ,0',
	'ち ち,0',
	'ぢ ぢ,0',
	'と と,0',
	'ど ど,0',
	'し し,0',
	'じ じ,0',
	'は は,0',
	'ば ば,0',
	'ぱ ぱ,0',
	'き き,0',
	'ぎ ぎ,0',
	'く く,0',
	'ぐ ぐ,0',
	'ま ま,0',
	'の の,0',
	'り り,0',
	'れ れ,0',
	'け け,0',
	'げ げ,0',
	'む む,0',
	'つ つ,0',
	'づ づ,0',
	'さ さ,0',
	'ざ ざ,0',
	'そ そ,0',
	'ぞ ぞ,0',
	'ひ ひ,0',
	'び び,0',
	'ぴ ぴ,0',
	'こ こ,0',
	'ご ご,0',
	'み み,0',
	'も も,0',
	'ね ね,0',
	'る る,0',
	'め め,0',
	'ろ ろ,0',
	'ぁ ぁ,0',
	'ぅ ぅ,0',
	'ぇ ぇ,0',
	'ぉ ぉ,0',
	'ゃ ゃ,0',
	'ゅ ゅ,0',
	'ょ ょ,0',
	'を を,0',
	'ぃ ぃ,0',
	'っ っ,0',
	'a ち,1',
	'b こ,1',
	'c そ,1',
	'd し,1',
	'e い,1',
	'f は,1',
	'g き,1',
	'h く,1',
	'i に,1',
	'j ま,1',
	'k の,1',
	'l り,1',
	'm も,1',
	'n み,1',
	'o ら,1',
	'p せ,1',
	'q た,1',
	'r す,1',
	's と,1',
	't か,1',
	'u な,1',
	'v ひ,1',
	'w て,1',
	'x さ,1',
	'y ん,1',
	'z つ,1',
	'A ち,1',
	'B こ,1',
	'C そ,1',
	'D し,1',
	'E い,1',
	'F は,1',
	'G き,1',
	'H く,1',
	'I に,1',
	'J ま,1',
	'K の,1',
	'L り,1',
	'M も,1',
	'N み,1',
	'O ら,1',
	'P せ,1',
	'Q た,1',
	'R す,1',
	'S と,1',
	'T か,1',
	'U な,1',
	'V ひ,1',
	'W て,1',
	'X さ,1',
	'Y ん,1',
	'Z つ,1',
	'ａ ち,1',
	'ｂ こ,1',
	'ｃ そ,1',
	'ｄ し,1',
	'ｅ い,1',
	'ｆ は,1',
	'ｇ き,1',
	'ｈ く,1',
	'ｉ に,1',
	'ｊ ま,1',
	'ｋ の,1',
	'ｌ り,1',
	'ｍ も,1',
	'ｎ み,1',
	'ｏ ら,1',
	'ｐ せ,1',
	'ｑ た,1',
	'ｒ す,1',
	'ｓ と,1',
	'ｔ か,1',
	'ｕ な,1',
	'ｖ ひ,1',
	'ｗ て,1',
	'ｘ さ,1',
	'ｙ ん,1',
	'ｚ つ,1',
	'Ａ ち,1',
	'Ｂ こ,1',
	'Ｃ そ,1',
	'Ｄ し,1',
	'Ｅ い,1',
	'Ｆ は,1',
	'Ｇ き,1',
	'Ｈ く,1',
	'Ｉ に,1',
	'Ｊ ま,1',
	'Ｋ の,1',
	'Ｌ り,1',
	'Ｍ も,1',
	'Ｎ み,1',
	'Ｏ ら,1',
	'Ｐ せ,1',
	'Ｑ た,1',
	'Ｒ す,1',
	'Ｓ と,1',
	'Ｔ か,1',
	'Ｕ な,1',
	'Ｖ ひ,1',
	'Ｗ て,1',
	'Ｘ さ,1',
	'Ｙ ん,1',
	'Ｚ つ,1',
	'　 　,0' # スペース定義

);

my $kj_javascript=<<EOM;
<script type="text/javascript"><!--
ka = new Array();
kf = new Array();
DATA

function kj(form) {
	br=unescape('%0A');

	if(form.form1.value.length == 0) {
		fca(form);
		form.form2.value="文字列が入力されていません。";
		return;
	}
	if(form.form1.value.length > $kj_maxlength) {
		fca(form);
		form.form2.value="文字列が長すぎます。";
		return;
	}
	fc(form.form2);
	ot = form.form1.value;
	jt = new String();
	pt = new String();
	la = new String();
	crlf=0;
	fst=1;
	ec=0;
	elc=0;
	for(i = 0; i < ot.length; i++) {
		char=ot.charAt(i);
		if(char == '\\r') {
			continue;
		}
		if(char == '\\n') {
			if(crlf != 0) {
				if(fst == 0) {
					if(form.engonly.checked) {
						if(elc!=0) {
							pt = pt.concat(br);
						}
					} else {
						pt = pt.concat(br);
					}
				}
				if(form.engonly.checked) {
				if(elc!=0) {
						elc=0;
						pt = pt.concat(la);
						pt = pt.concat(br);
						pt = pt.concat(jt)
						pt = pt.concat(br);
						crlf=0;
						fst=0;
					}
				} else {
					elc=0;
					pt = pt.concat(la);
					pt = pt.concat(br);
					pt = pt.concat(jt)
					pt = pt.concat(br);
					crlf=0;
					fst=0;
				}
				la='';
				jt='';

			}
			continue;
		}
		if(char == ' ') {
			char='　';
		}
		if(!ka[char]) {
			form.form2.value="ひらがな、英文字以外が存在します。";
			return;
		} else {
			if(crlf==0) {
				if(ka[char] == '　') {
					continue;
				}
			}
			la=la.concat(char);
			jt=jt.concat(ka[char]);
			if(kf[char]==1) {
				ec++;
				elc++;
			}
			crlf++;
		}
	}
	if(crlf != 0) {
		if(fst == 0) {
			pt = pt.concat(br);
		}
		if(form.engonly.checked) {
			if(elc!=0) {
				pt = pt.concat(la);
				pt = pt.concat(br);
				pt = pt.concat(jt)
				pt = pt.concat(br);
			}
		} else {
			pt = pt.concat(la);
			pt = pt.concat(br);
			pt = pt.concat(jt)
			pt = pt.concat(br);
		}
	}
	if(ec==0) {
		form.form2.value="英文字が存在しません。";
		return;
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
<input name="action" type="button" value="英文字→かなキー相当変換" onclick="kj(this.form);" onkeypress="kj(this.form)">
<input name="clear" type="button" value="クリア" onclick="fca(this.form);" onkeypress="fca(this.form);">
<input name="engonly" type="checkbox">英文字行が存在する行のみを出力
<br />
<textarea name="form2" rows="@{[sprintf("%d",$::rows/2)]}" cols="$::cols"></textarea>
</form>
EOM

sub plugin_kanatoenglish_convert {
	my $data;
	foreach $line (@karay) {
		my($kana,$jis_temp)=split(/ /,$line);
		my($jis,$flg)=split(/,/,$jis_temp);
		$data.="ka[\"$kana\"]=\"$jis\";";
		$data.="kf[\"$kana\"]=\"$flg\";";
	}

	$kj_javascript=~s/DATA/$data/g;
	$::IN_HEAD.=$kj_javascript;

	return $kj_html;
}
1;
__END__
