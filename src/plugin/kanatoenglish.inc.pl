# ��ʸ���������Ѵ� for PyukiWiki 0.1.6 Delopper version

$kj_maxlength=10000;

my @karay = (
	'�� ��,0',
	'�� ��,0',
	'�� ��,0',
	'�� ��,0',
	'�� ��,0',
	'�� ��,0',
	'�� ��,0',
	'�� ��,0',
	'�� ��,0',
	'�� ��,0',
	'�� ��,0',
	'�� ��,0',
	'�� ��,0',
	'�� ��,0',
	'�� ��,0',
	'�� ��,0',
	'�� ��,0',
	'�� ��,0',
	'�� ��,0',
	'�� ��,0',
	'�� ��,0',
	'�� ��,0',
	'�� ��,0',
	'�� ��,0',
	'�� ��,0',
	'�� ��,0',
	'�� ��,0',
	'�� ��,0',
	'�� ��,0',
	'�� ��,0',
	'�� ��,0',
	'�� ��,0',
	'�� ��,0',
	'�� ��,0',
	'�� ��,0',
	'�� ��,0',
	'�� ��,0',
	'�� ��,0',
	'�� ��,0',
	'�� ��,0',
	'�� ��,0',
	'�� ��,0',
	'�� ��,0',
	'�� ��,0',
	'�� ��,0',
	'�� ��,0',
	'�� ��,0',
	'�� ��,0',
	'�� ��,0',
	'�� ��,0',
	'�� ��,0',
	'�� ��,0',
	'�� ��,0',
	'�� ��,0',
	'�� ��,0',
	'�� ��,0',
	'�� ��,0',
	'�� ��,0',
	'�� ��,0',
	'�� ��,0',
	'�� ��,0',
	'�� ��,0',
	'�� ��,0',
	'�� ��,0',
	'�� ��,0',
	'�� ��,0',
	'�� ��,0',
	'�� ��,0',
	'�� ��,0',
	'�� ��,0',
	'�� ��,0',
	'�� ��,0',
	'�� ��,0',
	'�� ��,0',
	'�� ��,0',
	'�� ��,0',
	'�� ��,0',
	'�� ��,0',
	'�� ��,0',
	'�� ��,0',
	'�� ��,0',
	'�� ��,0',
	'a ��,1',
	'b ��,1',
	'c ��,1',
	'd ��,1',
	'e ��,1',
	'f ��,1',
	'g ��,1',
	'h ��,1',
	'i ��,1',
	'j ��,1',
	'k ��,1',
	'l ��,1',
	'm ��,1',
	'n ��,1',
	'o ��,1',
	'p ��,1',
	'q ��,1',
	'r ��,1',
	's ��,1',
	't ��,1',
	'u ��,1',
	'v ��,1',
	'w ��,1',
	'x ��,1',
	'y ��,1',
	'z ��,1',
	'A ��,1',
	'B ��,1',
	'C ��,1',
	'D ��,1',
	'E ��,1',
	'F ��,1',
	'G ��,1',
	'H ��,1',
	'I ��,1',
	'J ��,1',
	'K ��,1',
	'L ��,1',
	'M ��,1',
	'N ��,1',
	'O ��,1',
	'P ��,1',
	'Q ��,1',
	'R ��,1',
	'S ��,1',
	'T ��,1',
	'U ��,1',
	'V ��,1',
	'W ��,1',
	'X ��,1',
	'Y ��,1',
	'Z ��,1',
	'�� ��,1',
	'�� ��,1',
	'�� ��,1',
	'�� ��,1',
	'�� ��,1',
	'�� ��,1',
	'�� ��,1',
	'�� ��,1',
	'�� ��,1',
	'�� ��,1',
	'�� ��,1',
	'�� ��,1',
	'�� ��,1',
	'�� ��,1',
	'�� ��,1',
	'�� ��,1',
	'�� ��,1',
	'�� ��,1',
	'�� ��,1',
	'�� ��,1',
	'�� ��,1',
	'�� ��,1',
	'�� ��,1',
	'�� ��,1',
	'�� ��,1',
	'�� ��,1',
	'�� ��,1',
	'�� ��,1',
	'�� ��,1',
	'�� ��,1',
	'�� ��,1',
	'�� ��,1',
	'�� ��,1',
	'�� ��,1',
	'�� ��,1',
	'�� ��,1',
	'�� ��,1',
	'�� ��,1',
	'�� ��,1',
	'�� ��,1',
	'�� ��,1',
	'�� ��,1',
	'�� ��,1',
	'�� ��,1',
	'�� ��,1',
	'�� ��,1',
	'�� ��,1',
	'�� ��,1',
	'�� ��,1',
	'�� ��,1',
	'�� ��,1',
	'�� ��,1',
	'�� ��,0' # ���ڡ������

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
		form.form2.value="��ʸ����¸�ߤ��ޤ���";
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
<input name="action" type="button" value="��ʸ�������ʥ��������Ѵ�" onclick="kj(this.form);" onkeypress="kj(this.form)">
<input name="clear" type="button" value="���ꥢ" onclick="fca(this.form);" onkeypress="fca(this.form);">
<input name="engonly" type="checkbox">��ʸ���Ԥ�¸�ߤ���ԤΤߤ����
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
