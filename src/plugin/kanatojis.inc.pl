# ���ʢ�JIS�Ѵ�

$kj_maxlength=10000;

my @karay1 = (
	'�� ��',
	'�� ��',
	'�� ����',
	'�� ����',
	'�� ��',
	'�� ��',
	'�� ��',
	'�� ��',
	'�� ��',
	'�� ��',
	'�� ��',
	'�� ��',
	'�� ����',
	'�� ��',
	'�� �ݡ�',
	'�� �ݡ�',
	'�� ��',
	'�� ����',
	'�� �ݡ�',
	'�� ��',
	'�� ��',
	'�� ���',
	'�� ��',
	'�� ����',
	'�� ��',
	'�� ��',
	'�� ���',
	'�� ��',
	'�� ����',
	'�� ��',
	'�� ��',
	'�� ��',
	'�� ��',
	'�� ��',
	'�� ���',
	'�� ��',
	'�� ���',
	'�� ��',
	'�� ���',
	'�� ��',
	'�� ���',
	'�� ��',
	'�� ���',
	'�� ���',
	'�� ��',
	'�� ���',
	'�� ��',
	'�� ���',
	'�� ��',
	'�� ��',
	'�� ��',
	'�� ��',
	'�� ��',
	'�� ����',
	'�� ��',
	'�� ��',
	'�� ����',
	'�� ��',
	'�� ����',
	'�� ��',
	'�� ���',
	'�� ��',
	'�� ����',
	'�� ����',
	'�� ��',
	'�� ���',
	'�� ��',
	'�� ��',
	'�� ��',
	'�� ��',
	'�� ��',
	'�� ��',
	'�� ��',
	'�� ��',
	'�� ��',
	'�� ��',
	'�� ��',
	'�� ��',
	'�� ��',
	'�� (Shift+)��(����)',
	'�� ��',
	'�� ��',
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
	'�� a',
	'�� b',
	'�� c',
	'�� d',
	'�� e',
	'�� f',
	'�� g',
	'�� h',
	'�� i',
	'�� j',
	'�� k',
	'�� l',
	'�� m',
	'�� n',
	'�� o',
	'�� p',
	'�� q',
	'�� r',
	'�� s',
	'�� t',
	'�� u',
	'�� v',
	'�� w',
	'�� x',
	'�� y',
	'�� z',
	'�� A',
	'�� B',
	'�� C',
	'�� D',
	'�� E',
	'�� F',
	'�� G',
	'�� H',
	'�� I',
	'�� J',
	'�� K',
	'�� L',
	'�� M',
	'�� N',
	'�� O',
	'�� P',
	'�� Q',
	'�� R',
	'�� S',
	'�� T',
	'�� U',
	'�� V',
	'�� W',
	'�� X',
	'�� Y',
	'�� Z',
	'�� ��' # ���ڡ������

);

my @karay2 = (
	'�� ��',
	'�� ��',
	'�� ����',
	'�� ����',
	'�� ��',
	'�� ��',
	'�� ��',
	'�� ��',
	'�� ��',
	'�� ��',
	'�� ��',
	'�� ��',
	'�� ����',
	'�� ��',
	'�� �ݡ�',
	'�� �ݡ�',
	'�� ��',
	'�� ����',
	'�� �ݡ�',
	'�� ��',
	'�� ��',
	'�� ���',
	'�� ��',
	'�� ����',
	'�� ��',
	'�� ��',
	'�� ���',
	'�� ��',
	'�� ����',
	'�� ��',
	'�� ��',
	'�� ��',
	'�� ��',
	'�� ��',
	'�� ���',
	'�� ��',
	'�� ���',
	'�� ��',
	'�� ���',
	'�� ��',
	'�� ���',
	'�� ��',
	'�� ���',
	'�� ���',
	'�� ��',
	'�� ���',
	'�� ��',
	'�� ���',
	'�� ��',
	'�� ��',
	'�� ��',
	'�� ��',
	'�� ��',
	'�� ����',
	'�� ��',
	'�� ��',
	'�� ����',
	'�� ��',
	'�� ����',
	'�� ��',
	'�� ���',
	'�� ��',
	'�� ����',
	'�� ����',
	'�� ��',
	'�� ���',
	'�� ��',
	'�� ��',
	'�� ��',
	'�� ��',
	'�� ��',
	'�� ��',
	'�� (Shift+)��',
	'�� (Shift+)��',
	'�� (Shift+)��',
	'�� (Shift+)��',
	'�� (Shift+)����',
	'�� (Shift+)��',
	'�� (Shift+)��',
	'�� (Shift+)��(����)',
	'�� (Shift+)��',
	'�� (Shift+)��',
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
	'�� a',
	'�� b',
	'�� c',
	'�� d',
	'�� e',
	'�� f',
	'�� g',
	'�� h',
	'�� i',
	'�� j',
	'�� k',
	'�� l',
	'�� m',
	'�� n',
	'�� o',
	'�� p',
	'�� q',
	'�� r',
	'�� s',
	'�� t',
	'�� u',
	'�� v',
	'�� w',
	'�� x',
	'�� y',
	'�� z',
	'�� A',
	'�� B',
	'�� C',
	'�� D',
	'�� E',
	'�� F',
	'�� G',
	'�� H',
	'�� I',
	'�� J',
	'�� K',
	'�� L',
	'�� M',
	'�� N',
	'�� O',
	'�� P',
	'�� Q',
	'�� R',
	'�� S',
	'�� T',
	'�� U',
	'�� V',
	'�� W',
	'�� X',
	'�� Y',
	'�� Z',
	'�� ��' # ���ڡ������

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
		form.form2.value="ʸ�������Ϥ���Ƥ��ޤ���";
		return;
	}
	if(form.form1.value.length > $kj_maxlength) {
		fca(form);
		form.form2.value="ʸ����Ĺ�����ޤ���";
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
			char='��';
		}
		if(!ka[char]) {
			form.form2.value="�Ҥ餬�ʡ���ʸ���ʳ���¸�ߤ��ޤ���";
			return;
		} else {
			if(crlf==0) {
				if(ka[char] == '��') {
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
<input name="action" type="button" value="����ʸ����JIS�Ѵ�" onclick="kj(this.form);" onkeypress="kj(this.form)">
<input name="clear" type="button" value="���ꥢ" onclick="fca(this.form);" onkeypress="fca(this.form);">
<input name="shift" type="checkbox">���եȥ����򲡤������֤����
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
