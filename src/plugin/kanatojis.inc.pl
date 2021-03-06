# かな→JIS変換

$kj_maxlength=10000;

my @karay1 = (
	'ぬ １',
	'ふ ２',
	'ぶ ２＠',
	'ぷ ２［',
	'あ ３',
	'う ４',
	'え ５',
	'お ６',
	'や ７',
	'ゆ ８',
	'よ ９',
	'わ ０',
	'ヴ ４＠',
	'ほ −',
	'ぼ −＠',
	'ぽ −［',
	'へ ＾',
	'べ ＾＠',
	'ぺ −［',
	'ー ￥',
	'た ｑ',
	'だ ｑ＠',
	'て ｗ',
	'で ｗ＠',
	'い ｅ',
	'す ｒ',
	'ず ｒ＠',
	'か ｔ',
	'が ｔ＠',
	'ん ｙ',
	'な ｕ',
	'に ｉ',
	'ら ｏ',
	'せ ｐ',
	'ぜ ｐ＠',
	'ち ａ',
	'ぢ ａ＠',
	'と ｓ',
	'ど ｓ＠',
	'し ｄ',
	'じ ｄ＠',
	'は ｆ',
	'ば ｆ＠',
	'ぱ ｆ［',
	'き ｇ',
	'ぎ ｇ＠',
	'く ｈ',
	'ぐ ｈ＠',
	'ま ｊ',
	'の ｋ',
	'り ｌ',
	'れ ；',
	'け ：',
	'げ ：＠',
	'む ］',
	'つ ｚ',
	'づ ｚ＠',
	'さ ｘ',
	'ざ ｘ＠',
	'そ ｃ',
	'ぞ ｃ＠',
	'ひ ｖ',
	'び ｖ＠',
	'ぴ ｖ［',
	'こ ｂ',
	'ご ｂ＠',
	'み ｎ',
	'も ｍ',
	'ね ，',
	'る ．',
	'め ／',
	'ろ ＼',
	'ぁ ＃',
	'ぅ ＄',
	'ぇ ％',
	'ぉ ＆',
	'ゃ ’',
	'ゅ （',
	'ょ ）',
	'を (Shift+)０(ゼロ)',
	'ぃ Ｅ',
	'っ Ｚ',
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
	'ａ a',
	'ｂ b',
	'ｃ c',
	'ｄ d',
	'ｅ e',
	'ｆ f',
	'ｇ g',
	'ｈ h',
	'ｉ i',
	'ｊ j',
	'ｋ k',
	'ｌ l',
	'ｍ m',
	'ｎ n',
	'ｏ o',
	'ｐ p',
	'ｑ q',
	'ｒ r',
	'ｓ s',
	'ｔ t',
	'ｕ u',
	'ｖ v',
	'ｗ w',
	'ｘ x',
	'ｙ y',
	'ｚ z',
	'Ａ A',
	'Ｂ B',
	'Ｃ C',
	'Ｄ D',
	'Ｅ E',
	'Ｆ F',
	'Ｇ G',
	'Ｈ H',
	'Ｉ I',
	'Ｊ J',
	'Ｋ K',
	'Ｌ L',
	'Ｍ M',
	'Ｎ N',
	'Ｏ O',
	'Ｐ P',
	'Ｑ Q',
	'Ｒ R',
	'Ｓ S',
	'Ｔ T',
	'Ｕ U',
	'Ｖ V',
	'Ｗ W',
	'Ｘ X',
	'Ｙ Y',
	'Ｚ Z',
	'　 　' # スペース定義

);

my @karay2 = (
	'ぬ １',
	'ふ ２',
	'ぶ ２＠',
	'ぷ ２［',
	'あ ３',
	'う ４',
	'え ５',
	'お ６',
	'や ７',
	'ゆ ８',
	'よ ９',
	'わ ０',
	'ヴ ４＠',
	'ほ −',
	'ぼ −＠',
	'ぽ −［',
	'へ ＾',
	'べ ＾＠',
	'ぺ −［',
	'ー ￥',
	'た ｑ',
	'だ ｑ＠',
	'て ｗ',
	'で ｗ＠',
	'い ｅ',
	'す ｒ',
	'ず ｒ＠',
	'か ｔ',
	'が ｔ＠',
	'ん ｙ',
	'な ｕ',
	'に ｉ',
	'ら ｏ',
	'せ ｐ',
	'ぜ ｐ＠',
	'ち ａ',
	'ぢ ａ＠',
	'と ｓ',
	'ど ｓ＠',
	'し ｄ',
	'じ ｄ＠',
	'は ｆ',
	'ば ｆ＠',
	'ぱ ｆ［',
	'き ｇ',
	'ぎ ｇ＠',
	'く ｈ',
	'ぐ ｈ＠',
	'ま ｊ',
	'の ｋ',
	'り ｌ',
	'れ ；',
	'け ：',
	'げ ：＠',
	'む ］',
	'つ ｚ',
	'づ ｚ＠',
	'さ ｘ',
	'ざ ｘ＠',
	'そ ｃ',
	'ぞ ｃ＠',
	'ひ ｖ',
	'び ｖ＠',
	'ぴ ｖ［',
	'こ ｂ',
	'ご ｂ＠',
	'み ｎ',
	'も ｍ',
	'ね ，',
	'る ．',
	'め ／',
	'ろ ＼',
	'ぁ (Shift+)３',
	'ぅ (Shift+)４',
	'ぇ (Shift+)５',
	'ぉ (Shift+)６',
	'ゃ (Shift+)７’',
	'ゅ (Shift+)８',
	'ょ (Shift+)９',
	'を (Shift+)０(ゼロ)',
	'ぃ (Shift+)ｅ',
	'っ (Shift+)ｚ',
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
	'ａ a',
	'ｂ b',
	'ｃ c',
	'ｄ d',
	'ｅ e',
	'ｆ f',
	'ｇ g',
	'ｈ h',
	'ｉ i',
	'ｊ j',
	'ｋ k',
	'ｌ l',
	'ｍ m',
	'ｎ n',
	'ｏ o',
	'ｐ p',
	'ｑ q',
	'ｒ r',
	'ｓ s',
	'ｔ t',
	'ｕ u',
	'ｖ v',
	'ｗ w',
	'ｘ x',
	'ｙ y',
	'ｚ z',
	'Ａ A',
	'Ｂ B',
	'Ｃ C',
	'Ｄ D',
	'Ｅ E',
	'Ｆ F',
	'Ｇ G',
	'Ｈ H',
	'Ｉ I',
	'Ｊ J',
	'Ｋ K',
	'Ｌ L',
	'Ｍ M',
	'Ｎ N',
	'Ｏ O',
	'Ｐ P',
	'Ｑ Q',
	'Ｒ R',
	'Ｓ S',
	'Ｔ T',
	'Ｕ U',
	'Ｖ V',
	'Ｗ W',
	'Ｘ X',
	'Ｙ Y',
	'Ｚ Z',
	'　 　' # スペース定義

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
<input name="action" type="button" value="かな文字→JIS変換" onclick="kj(this.form);" onkeypress="kj(this.form)">
<input name="clear" type="button" value="クリア" onclick="fca(this.form);" onkeypress="fca(this.form);">
<input name="shift" type="checkbox">シフトキーを押した状態を出力
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
