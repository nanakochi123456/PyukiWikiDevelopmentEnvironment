######################################################################
# @@HEADEREXPLUGIN_NANAMI@@
######################################################################
# Based on ����ߤΥڡ��� http://koyomi8.com/
# Based on ����׻��饤�֥�� http://www3.biwako.ne.jp/~nobuaki/qreki/
######################################################################
# This is extented plugin.
# To use this plugin, rename to 'exdate.inc.cgi'
######################################################################
#    ����:SG:����/����/����/ʿ�� Sg:��/��/��/ʿ
#         SA:M/T/S/H Sa:��/��/��/��
#
#  ����ǯ:SY:1-2��(1��10��) Sy:0�䴰����2��(01��10��)
#         GY:����1-2��(��������������)
#         XY:����1-2��(�����������������󽽡��󽽰��)
#         Xy:����1-2��(��������졻��������󡻡�����)
#
#    ǯ�� N4SG N4Sg N4Sa N4SY N4Sy N4GY N4XY N4Xy �嵭����ǯƱ����������
#         N9SG N9Sg N9Sa N9SY N9Sy N9GY N9XY N9Xy �嵭����ǯ��Ʊ����������
#
#    ����:Y:����(4��)/y:����(2��) - **
#        :ZY:����4�� Zy:����2�� KY:�켷�������󡻡�����
#
#    ����:TY:����(4��)/Ty:����(2��) - **
#        :TZY:����4�� TZy:����2�� TzY:�켷�������󡻡�����
#
#����ǯ��:N4Y:����(4��)/N4y:����(2��)
#         N4ZY:����2�� N4Zy:����2�� N4KY:�켷�������󡻡�����
#         N9ZY: N9Zy N9KY : ����Ʊ���ǣ�������
#
#      ��:n:1-12/m:01-12/M:Jan-Dec/F:January-December - **
#         Zn:����1-2��(���ݣ���) Zm:0�䴰��������2��(�����ݣ�����
#         Kn:�����������/Km:����졻������
#         kn:�ӷ�,ǡ��...
#
#      ��:j:1-31/J:01-31 - **
#         Zj:����1-2��(���ݣ���) ZJ:0�䴰��������2��(�����ݣ�����
#         Kj:�������������󽽡�������/KJ:����졻��
#
#    ����:l:Sunday-Saturday/D:Sun-Sat/DL:������-������/lL:��-�� - **
#
#    ampm:a:am or pm/A:AM or PM/AL:���� or ��� - **
#
#      ��:g:1-12/G:0-23/h:01-12/H/00-23 - **
#         Zg:���ݣ���/ZG:���ݣ���/Zh:�����ݣ���/ZH/�����ݣ���
#         Kg:�����������/KG:��������������/�󽽻�
#         Kh:����졻������/KH:�����졻�������󡻡���
#
#      ʬ:k:0-59/i:00-59 - **
#         Zk:���ݣ���/Zi:�����ݣ���
#         Kk:����޽���/Ki:�����޶�
#
#      ��:S:0-59/s:00-59 - **
#         ZS:���ݣ���/Zs:�����ݣ���
#         KS:����޽���/Ks:�����޶�
#
#    ����:RS:��ö/Rs:(��ö) 1948ǯ������
#    �Ի�:RG:����/Rg:(����) 1948ǯ������
#  ��̱��:XG:��̱����/Xg:(��̱����) 1948ǯ������
#    ����:SZ:���ҤĤ���/Sz:Aries
#  ��ʬ��:MG:.../Mg:(...) 1948ǯ������
#  24�ᵨ:RK:Ω��/Rk:(Ω��)
#    ϻ��:RY:���/�ָ�/�辡/ͧ��/����/ʩ��
#  ǯ����:NK:�û�
#  ������:HK:����
#  ���ν�:HY:��
#  ����ǯ:QY:����(4��)/Qy:����(2��)
#        :QZY:����4�� QZy:����2�� QKY:�켷�������󡻡�����
#
#    ����:EY:����(4��)/Ey:����(2��)
#        :EZY:����4�� EZy:����2�� EzY:�켷�������󡻡�����
#
#      ��:Qn:1-12/Qm:01-12
#         QZn:����1-2��(���ݣ���) QZm:0�䴰��������2��(�����ݣ�����
#         QKn:�����������/QKm:����졻������
#         Qkn:�ӷ�,ǡ��...
#
#      ��:Qj:1-31/QJ:01-31 - **
#         QZj:����1-2��(���ݣ���) QZJ:0�䴰��������2��(�����ݣ�����
#         QKj:�������������󽽡�������/QKJ:����졻��
######################################################################
# �ʲ���wiki.cgi��Ʊ��
# t ���ꤷ����������� 28 ���� 31
# O   : ����˥å��Ȥλ��ֺ�
# r RFC 822 �ե����ޥåȤ��줿���� ��: Thu, 21 Dec 2000 16:01:07 +0200
# Z �����ॾ����Υ��ե��å��ÿ��� -43200 ���� 43200
# L ��ǯ�Ǥ��뤫�ɤ�����ɽ�������͡� 1�ʤ鱼ǯ��0�ʤ鱼ǯ�ǤϤʤ���
# B Swatch ���󥿡��ͥåȻ��� 000 ���� 999
# U Unix ��(1970ǯ1��1��0��0ʬ0��)������ÿ� See also time()
######################################################################

# �Ŀ��ѹԻ���������
@EXDATE::MY_GYOJI=(
#	"1900-/1/1:�����������",	# example
	"2005-/12/31:PyukiWiki�ץ������ȳ��ϵ�ǰ��"
) if(!defined(@EXDATE::MY_GYOJI));

# ����ꥹ�� �Ť���� ǯ/��/��:��̾:Ⱦ����ʸ����ʸ��
@EXDATE::GANGO=(
	"1868/9/8:����:��:M",	# ɬ�פʤ�������פʸ���򥳥��ȥ����Ȥ����
	"1912/7/30:����:��:T",	# �����ڤ��ʤ�ޤ�
	"1926/12/25:����:��:S",
	"1989/1/8:ʿ��:ʿ:H"
);

# ���񥭥�å���κ�����¸��
$exdate::cache_max=2000
	if(!defined($exdate::cache_max));

# ���񥭥�å���γ�ĥ��
$exdate::cache_ext="exdate"
	if(!defined($exdate::cache_ext));


######################################################################
#
# DB����
#
# �������դξ��
# (�ǽ��ǯ)-(�Ǹ��ǯ)/(�ǽ�η�)-(�Ǹ�η�)/(�ǽ����)-(�Ǹ����)
#
# �貿�����ξ��
# (�ǽ��ǯ)-(�Ǹ��ǯ)/(�ǽ�η�)-(�Ǹ�η�)/(������)/(������:0-6)
#
# �ü����
# 1973-2004ǯ��0/0 �ϵ켰�ο����ؤ������ν���
# 2005ǯ�ʹߤ�0/0 �� �����ο����ؤ������ν���
# 0-1948-/3/0 ��ʬ���� 3-1948-/9/0 ��ʬ����
# 0-1948-/3/0��3-1948-/9/0 �����
# ???-1948-/40/32:������
# ???-1948-/40/33:������
# 0-1948-/40/34:����"
# 0-1948-/40/35:������,
# 0-1948-/41/36:��ʬ

# from http://koyomi.vis.ne.jp/syukujitsu.htm

# �����ꥹ��
@SYUKUJITSU=(
	"1973-2004/0/0:���ص���",	# �������Ƚ������Ťʤä�������������
	"2005-/0/0:���ص���",		# �������ʸ�ˤ����ƺǤ�ᤤ��̱�ν����Ǥʤ���
	"1948-/1/1:��ö",
	"1948-1999/1/15:���ͤ���",
	"2000-/1/2/1:���ͤ���",
	"1966-/2/11:����ǰ����",
	"0-1948-/3/32:��ʬ����",		# ��ʬ����
	"1948-1988/4/29:ŷ��������",
	"1989-2006/4/29:�ߤɤ����",
	"2007-/4/29:���¤���",
	"1948-/5/3:��ˡ��ǰ��",
	"1985-2006/5/4:��̱�ε���",
	"2007-/5/4:�ߤɤ����",
	"1948-/5/5:���ɤ����",
	"1995-2002/7/20:������",
	"2003-/7/3/1:������",
	"1966-2002/9/15:��Ϸ����",
	"2003-/9/3/1:��Ϸ����",
	"2003/9/22:��̱�ε���",
	"0-1948-/9/32:��ʬ����",		# ��ʬ����
	"1966-1999/10/10:�ΰ����",
	"2000-/10/2/1:�ΰ����",
	"1948-/11/3:ʸ������",
	"1948-/11/23:��ϫ���դ���",
	"1989-/12/23:ŷ��������",
	"1959/4/10:���������οƲ��η뺧�ε�",
	"1989/2/24:����ŷ�Ĥ����Ӥ���",
	"1990/11/22:¨�������¤ε�",
	"1993/6/9:���������οƲ��η뺧�ε�"
);

# ����Ū�ʹԻ�
@GYOJI=(
	"1948-/1/1-3:������",
	"1948-/1/7:����",
	"1948-/1/15:������",
	"1948-/1/20:��������",
	"1948-/2/14:�Х�󥿥���ǡ�",
	"1948-/3/14:�ۥ磻�ȥǡ�",
	"1948-/3/3:�Ҥʺפ�",
	"3-1948-/3/0:�����",	# ��ʬ����-3��+3��
	"1948-/4/1:�����ץ꡼��ա���",
	"1948-/5/1:�᡼�ǡ�",
	"1948-/5/5:�Գ������",
	"1948-/5/2/0:�����",
	"1948-/6/3/0:�����",
	"1948-/7/7:��ͼ",
	"1948-/7/15:�渵",
	"1948-/8/13-16:����",
	"1948-/8/15:���ﵭǰ��",
	"1948-/9/1:�ɺҤ���",
	"1948-/9/9:�Ƥ����",
	"3-1948-/9/0:�����",	# ��ʬ����-3��+3��
	"1948-/11/15:���޻�",
	"1948-/12/24:���ꥹ�ޥ�����",
	"1948-/12/25:���ꥹ�ޥ�",
	"1948-/12/31:�糢��",
	"297-1948-/40/32:������",	# �ʲ�ɬ�פʤ���С֤��٤ơץ����ȥ����Ȥ����
	"315-1948-/40/33:������",	# �����ڤ��ʤ�ޤ�
	"27-1948-/40/32:������",	# ���񤫤�׻��ǵ��ޤ���
	"45-1948-/40/33:������",	# �������λ��Ф˸����Զ�礬����ޤ���
	"117-1948-/40/32:������",
	"135-1948-/40/33:������",
	"207-1948-/40/32:������",
	"225-1948-/40/33:������",
	"0-1948-/40/34:����",
	"0-1948-/40/35:������",
	"0-1948-/41/36:��ʬ"		# �����ޤ�
);

# ��ƻ�ܸ����Ի�
@PREF_GYOJI=(
	"1948-/2/7:ʡ�温�դ뤵�Ȥ���",
	"1998-/2/7:Ĺ������ԥå����ꥢ��ǡ�",
	"1948-/2/9:�������ܻ�����",
	"1948-/2/20:��ɲ������ȯ­��ǰ��",
	"1948-/4/18:���Ÿ���̱����",
	"1948-/5/15:���츩����������ǰ��",
	"1948-/6/2:Ĺ���������ǰ��",
	"1948-/6/2:���ͳ�����ǰ��",
	"1948-/6/15:���ո���̱����",
	"1948-/6/15:���ڸ���̱����",
	"1948-/8/6:���縩ʿ�µ�ǰ��",
	"1948-/8/9:Ĺ�긶������",
	"1948-/8/21:ʡ�縩��̱����",
	"1948-/8/29:���ĸ���̱����",
	"1948-/9/12:Ļ�踩��̱����",
	"1948-/10/1:��̱����",
	"1948-/11/1:�����������",
	"1948-/11/13:��븩��̱����",
	"1948-/11/14:��ʬ����̱����",
	"1948-/11/14:��̸���̱����",
	"1948-/11/20:��������̱����",
	"1948-/11/22:�²λ����դ뤵��������",
	"1948-/12/7:���ͻԳ�����ǰ��",
	"1948-/1-12/29:�������ܻ�����",		# ���29��
	"1948-/1-12/23:�����ܤդߤ����"	# ���23��
);

# ����
@SEIZA=(
	"1948-/3/21-31:���ҤĤ���,Aries",
	"1948-/4/1-19:���ҤĤ���,Aries",
	"1948-/4/20-30:��������,Taurus",
	"1948-/5/1-20:��������,Taurus",
	"1948-/5/21-31:�դ�����,Gemini",
	"1948-/6/1-21:�դ�����,Gemini",
	"1948-/6/22-30:���˺�,Cancer",
	"1948-/7/1-22:���˺�,Cancer",
	"1948-/7/23-31:������,Leo",
	"1948-/8/1-22:������,Cancer",
	"1948-/8/23-31:���Ȥ��,Virgo",
	"1948-/9/1-22:���Ȥ��,Virgo",
	"1948-/9/23-30:�Ƥ�Ӥ��,Libra",
	"1948-/10/1-23:�Ƥ�Ӥ��,Libra",
	"1948-/10/24-31:�������,Scopio",
	"1948-/11/1-21:�������,Scopio",
	"1948-/11/22-30:���ƺ�,Sagitarius",
	"1948-/12/1-21:���ƺ�,Sagitarius",
	"1948-/12/22-31:�䤮��,Capricom",
	"1948-/1/1-19:�䤮��,Capricom",
	"1948-/1/20-31:�ߤ������,Aquarius",
	"1948-/2/1-18:�ߤ������,Aquarius",
	"1948-/2/19-30:������,Pisces",
	"1948-/3/1-20:������,Pisces"
);


# ����η�
@QMONTH=("�ӷ�","ǡ��","����","����","����","��̵��"
		,"ʸ��","�շ�","Ĺ��","��̵��","����","����");


# �Ƿ�
$YAMI="��";

# ϻ��
@ROKUYOU=("���","�ָ�","�辡","ͧ��","����","ʩ��");

# ����
@KAN= ("��","��","ʺ","��","��","��","��","��","��","�");

# �����
@SHI = ("��","��","��","��","ä","̦","��","̤","��","��","��","��");

# ��Ȭ��
@SHUKU = ("��","ж","<U>��</U>","˼","��","��","̧",
		"��","��","��","��","��","��","��",
		"��","Ϭ","��","��","ɭ","�","��",
		"��","��","��","��","ĥ","��","��");

# �����ᵤ
@SEKKI24=("��ʬ","����","��","Ω��","����","���","�ƻ�","����","���","Ω��","���","��Ϫ",
		 "��ʬ","��Ϫ","����","Ω��","����","����","�߻�","����","�紨","Ω��","����","���");

%::SYUKUJITSU;
%::GYOJI;
%::PREF_GYOJI;
%::SEIZA;
%::MY_GYOJI;
$::EXDATE_CACHE;

$EXPLUGIN="exdate";
$VERSION="1.05";

use Nana::Cache;
use Jcode;

sub plugin_exdate_init {
	$::EXDATE_CACHE=new Nana::Cache (
		ext=>$exdate::cache_ext,
		files=>$exdate::cache_max,
		dir=>$::cache_dir,
		size=>100000,
		use=>1,
		expire=>86400,
	);
	$::EXDATE_CACHE->check(
		"$::explugin_dir/exdate.inc.cgi",
		"$::explugin_dir/exdate-qreki.pl",
		"$::explugin_dir/Nana/Cache.pm"
	);
	return('init'=>1,'func'=>'date','date'=>\&date);
}

# ���������DB��Ÿ������
sub daterange {
	my($str)=@_;
	my($y,$m,$d,$w)=split(/\//,$_);
	my $body='';
	my %date;
	my $min;
	my $max;
	my $tmp;
	if($y=~/\-/) {
		($min,$max,$tmp)=split(/\-/,$y);
		# ��ʬ����ʬ����������
		if($min < 1000) {
			$max=1000 if($max+0 eq 0);
			$tmp=9999 if($tmp+0 eq 0);
			$date{year_min}=$max;
			$date{year_max}=$tmp;
			$date{syunbun}=$min;
			$date{mon_min}=$m;
			$date{mon_max}=$m;
			$date{day_min}=$d;
			return %date;
		} else {
			$min=1000 if($min+0 eq 0);
			$max=9999 if($max+0 eq 0);
			$date{year_min}=$min;
			$date{year_max}=$max;
		}
	} else {
		$date{year_min}=$y;
		$date{year_max}=$y;
	}
	if($m=~/\-/) {
		($min,$max)=split(/\-/,$m);
		$min=1 if($min+0 eq 0);
		$max=12 if($max+0 eq 0);
		$date{mon_min}=$min;
		$date{mon_max}=$max;
	} else {
		$date{mon_min}=$m;
		$date{mon_max}=$m;
	}
	if($w ne '') {
		# �貿��������
		$date{week_syu}=$d;
		$date{week_youbi}=$w;
	} elsif($d=~/\-/) {
		($min,$max)=split(/\-/,$d);
		$min=1 if($min+0 eq 0);
		$max=(31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31)[$date{mon_min} - 1] if($max+0 eq 0);
		$date{day_min}=$min;
		$date{day_max}=$max;
	} else {
		$date{day_min}=$d;
		$date{day_max}=$d;
	}
	return %date;
}

# ��������
sub get_gango {
	my($year,$mon,$mday)=@_;
	my $gango="";
	my $gshort="";
	my $gyear="";
	foreach(@EXDATE::GANGO) {
		my($mymd,$mgango,$mgango2,$mshort)=split(/:/,$_);
		my($my,$mm,$md)=split(/\//,$mymd);
		if(		$year+0>$my+0
				|| ($mon > $mm+0 && $year+0 eq $my+0)
				|| ($mday+0 >= $md+0 && $mon eq $mm+0 && $year+0 eq $my+0)
			) {
			$gango=$mgango;
			$gango2=$mgango2;
			$gshort=$mshort;
			$gyear=$year-$my+1;
		}
	}
	return($gango,$gango2,$gshort,$gyear);
}

# 1��­��
sub addday {
	my($y,$m,$d)=@_;
	$d++;
	if($d > &lastday($y,$m)) {
		$d=1;
		$m++;
		if($m > 12) {
			$y++;
			$m=1;
		}
	}
	return($y,$m,$d);
}

# ����ǯ�ν����Ի������
sub get_event {
	my $year=shift;
	my $fname=shift;
	my %event=$::EXDATE_CACHE->hash_read("$fname-$year");
	if($event{$year} eq 1) {
		return %event;
	}
	@hurikae=();
	my $_format="%04d_%02d_%02d";
	my @doyou=();
	my @doyou_names=();
	foreach(@_) {
		my($date,$name)=split(/:/,$_);
		my %date=&daterange($date);
			# ��ʬ
		if($date{mon_min} eq 41) {
			if(&req_qreki) {
				my $jd=qreki::sun2jd($year-1,2*30-3+4/9);
				$event{sprintf($_format,$year,2,(&get_jd2ymdt($jd))[2])}="$name:";
			}
		} elsif($date{mon_min} eq 40) {
			if($date{syunbun}+0 eq 0) {
				@doyou_names[$date{day_min}]=$name;
			} else {
				$date{day_min}=~s/\:.*//g;
				push(@doyou,"$year\t$date{syunbun}\t$date{day_min}\t$name");
			}
			# �����ؤ�������push
		} elsif($date{mon_min}+$date{mon_max}+$date{day_min}+$date{day_max} eq 0) {
			push(@hurikae,"$date{year_min}:$date{year_max}:$name");
			next;
		} elsif($date{year_min} <= $year && $year <= $date{year_max}) {
			# �����Τߤν���
			if($date{week_syu} ne '') {
				# http://www.din.or.jp/~ohzaki/perl.htm#NthW2Date
				my $wday1=&getwday($year,$date{mon_min},1);
				my $mday=1 + ($date{week_youbi} - $wday1) % 7 + 7 * ($date{week_syu} - 1);
				$event{sprintf($_format,$year,$date{mon_min},$mday)}.="$name:";
			# ��ʬ����ʬ�������
			} elsif($date{syunbun} ne '') {
				my $mday=&calc_syunbun($year,$date{mon_min});
				$event{sprintf($_format,$year,$date{mon_min},$mday)}.="$name:";
				if($date{syunbun} > 0) {
					for(my $i=-$date{syunbun}+0; $i<=$date{syunbun}+0; $i++) {
						next if($i eq 0);
						$event{sprintf($_format,$year,$date{mon_min},$mday+$i)}.="$name:";
					}
				}
			} else {
				my $m=$date{mon_min};
				do {
					my $d=$date{day_min};
					do {
						$event{sprintf($_format,$year,$m,$d)}.="$name:";
						$d++;
					} while($d<=$date{day_max});
					$m++;
				} while($m<=$date{mon_max});
			}
		}
	}
	# �����ؤ������ν���
	foreach(@hurikae) {
		my($y_min,$y_max,$name)=split(/:/,$_);
		if($y_min <= $year && $year <= $y_max) {
			foreach(keys %event) {
				my($y,$m,$d)=split(/_/,$_);
				my($wday)=&getwday($y,$m,$d);
				if($wday eq 0) {
					my($_y,$_m,$_d)=&addday($y,$m,$d);
					# �켰
					if($y <= 2004) {
						if($event{sprintf($_format,$_y,$_m,$_d)} eq '') {
							$event{sprintf($_format,$_y,$_m,$_d)}="$name:";
						}
					} else {
						my $flag=1;
						do {
							if($event{sprintf($_format,$_y,$_m,$_d)} eq '') {
								$event{sprintf($_format,$_y,$_m,$_d)}="$name:";
								$flag=0;
							} else {
								($_y,$_m,$_d)=&addday($_y,$_m,$_d);
							}
						} while($flag);
					}
				}
			}
		}
	}
	# ���Ѥν���
	if(@doyou > 0) {
		if(&req_qreki) {
			my $start_jd;
			my $end_jd;
			foreach $e(@doyou) {
				my($yy,$koudou,$mode,$name)=split(/\t/,$e);
				my $dt=-15;
				if($mode eq 32) {
					$start_jd=qreki::sun2jd($yy,$koudou+$dt);
					@qreki=&get_jd2ymdt($start_jd);
					$event{sprintf($_format,$qreki[0],$qreki[1],$qreki[2])}="$name:";
				# ���������������ʤ��Ȼפ���Τǡ�ɽ���Τ߾ä��Ƥ���ޤ�
				# ���������λ��Фˤ�ɬ�פǤ�
				} elsif($mode eq 33) {
					$end_jd=qreki::sun2jd($yy,$koudou+$dt-4/9);
					@qreki=&get_jd2ymdt($end_jd);
# todo...
#					$event{sprintf($_format,$qreki[0],$qreki[1],$qreki[2])}="$name:";
					for(my $i=$start_jd; $i<=$end_jd; $i++) {
						my $shi=($i + 2) % 12;
						# ����
						if($shi eq 1) {
							@qreki=&get_jd2ymdt($i);
							$event{sprintf($_format,$qreki[0],$qreki[1],$qreki[2])}.="$doyou_names[35]:";
						} elsif($qreki[1]<3) {	# ������ �� �� ̦
							if($shi eq 2 || $shi eq 3 || $shi eq 5) {
								@qreki=&get_jd2ymdt($i);
								$event{sprintf($_format,$qreki[0],$qreki[1],$qreki[2])}.="$doyou_names[34]:";
							}
						} elsif($qreki[1]<6) { # ������ ̦ �� ��
							if($shi eq 5 || $shi eq 6 || $shi eq 9) {
								@qreki=&get_jd2ymdt($i);
								$event{sprintf($_format,$qreki[0],$qreki[1],$qreki[2])}.="$doyou_names[34]:";
							}
						} elsif($qreki[1]<9) { # ������ ����ä����
							if($shi eq 3 || $shi eq 4 || $shi eq 8) {
								@qreki=&get_jd2ymdt($i);
								$event{sprintf($_format,$qreki[0],$qreki[1],$qreki[2])}.="$doyou_names[34]:";
							}
						} else {               # ������ ̤���ӡ���
							if($shi eq 7 || $shi eq 9 || $shi eq 11) {
								@qreki=&get_jd2ymdt($i);
								$event{sprintf($_format,$qreki[0],$qreki[1],$qreki[2])}.="$doyou_names[34]:";
							}
						}
					}
				}
			}
		}
	}

	# �ǽ�����
	foreach $e(keys %event) {
		my($y,$m,$d)=split(/_/,$e);
		if($d>&lastday($y,$m)) {
			delete $event{$e};
		} else {
			$event{$e}=~s/\:$//g;
		}
	}

	$event{$year}=1;
	$::EXDATE_CACHE->hash_write("$fname-$year",%event);

	return %event;
}

# ϻ�ˤ����
sub get_rokuyou {
	my($y,$m,$d)=@_;
	my ($q_yaer,$uruu,$q_mon,$q_day) = &get_qreki($y,$m,$d);
	return $ROKUYOU[($q_mon + $q_day) % 6];
}

# �������� return [0]=Year [1]=Month [2]=day [3]=ʿ����� flag
sub get_qreki {
	my($y,$m,$d)=@_;
	my $f=sprintf("qreki-%04d%02d%02d",$y,$m,$d);
	my $buf=$::EXDATE_CACHE->read($f);
	if($buf ne '') {
		my @qreki=split(/\//,$buf);
		return($qreki[0],$qreki[2],$qreki[3],$qreki[4]);
	}
	return "" if(!&req_qreki);
	my @qreki=qreki::calc_kyureki($y,$m,$d);
	$::EXDATE_CACHE->write($f,"$qreki[0]/$qreki[1]/$qreki[2]/$qreki[3]\n");
	return($qreki[0],$qreki[2],$qreki[3],$qreki[4]);
}

sub get_ymdt2jd {
	my($y,$m,$d)=@_;
	my $f=sprintf("ymdt2jd-%04d%02d%02d",$y,$m,$d);
	my $buf=$::EXDATE_CACHE->read($f);
	if($buf ne '') {
		chomp $buf;
		return $buf;
	}
	$buf=qreki::YMDT2JD($y,$m,$d,0,0,0);
	$::EXDATE_CACHE->write($f,"$buf\n");
	return $buf;
}

sub get_jd2ymdt {
	my($jd)=@_;
	return qreki::JD2YMDT($jd);
}

# ǯ�δ��٤η׻�
sub get_kanshi_year {
	my($y,$m,$d)=@_;
	my @qreki=&get_qreki($y,$m,$d);
	return $KAN[($qreki[0] + 6) % 10] . $SHI[($qreki[0] - 4) % 12];
}

# ���δ��٤η׻�
sub get_kanshi_day {
	my($y,$m,$d)=@_;
	return "" if(!&req_qreki);
	my $jd=int(&get_ymdt2jd($y,$m,$d));
	return $KAN[$jd % 10] . $SHI[($jd + 2) % 12];
}

# ���νɤη׻�
sub get_syuku {
	my($y,$m,$d)=@_;
	return "" if(!&req_qreki);
	my $jd=int(&get_ymdt2jd($y,$m,$d));
	return $SHUKU[($jd + 12) % 28];
}

# �����ᵤ�����
sub get_24sekki {
	my($y,$m,$d)=@_;
	return "" if(!&req_qreki);
	my $sekki=qreki::check_24sekki($y,$m,$d);
	return "" if($sekki eq -1);
	return $SEKKI24[$sekki];


	my $f=sprintf("24sekki-%04d%02d%02d",$y,$m,$d);
	my ($dmy,$buf)=split(/,/,$::EXDATE_CACHE->read($f));
	if($dmy ne '') {
		chomp $buf;
		return $buf;
	}
	return "" if(!&req_qreki);
	$buf=qreki::check_24sekki($y,$m,$d);
	$buf=$SEKKI24[$buf];
	$::EXDATE_CACHE->write($f,"$buf\n");
	return($buf);
}

# qreki.pl�򥤥󥯥롼��
sub req_qreki {
	my @file=("lib/exdate-qreki.pl","exdate-qreki.pl");
	return 1 if(@::QREKI_PL_INCLUDED eq 1);
	foreach(@file) {
		if(-r $_) {
			require $_;
			@::QREKI_PL_INCLUDED=1;
			return 1;
		}
	}
	return 0;
}

#
# ��ʬ��������ʬ���������
# http://www.asahi-net.or.jp/~CI5M-NMR/misc/equinox.html
# http://koyomi.vis.ne.jp/reki_doc/doc_1710.htm
#

sub calc_syunbun {
	my($year,$month)=@_;
	my $day;
	my $x=6829570000;	# 1970ǯ�ν�ʬ���̲�����ǯ�餫��Υߥ��áʿ��공����
	my $y=22935091700;	# 1970ǯ�ν�ʬ���̲�����ǯ�餫��Υߥ��áʿ��공����
	my $z=31556926000;	# �ϵ��ž�����Υߥ��áʥߥ���ñ�̤Ǥ������Τ��⡩��
	$year-=1970;

	if($month eq 3) {
		$day=($z*$year+$x)/1000;
	} elsif($month eq 9) {
		$day=($z*$year+$y)/1000;
	} else {
		return '';
	}
	$day=(localtime($day))[3];
	return $day;
}

# from http://neko.mimi.gr.jp/~fge/pastime/ideo_digit.html
sub itoa_ja {
#
# zero
#  0 : ��
#  1 : ��
#
# ���ͤ����λ��ν���
#  0 : ichi�Ǽ����줿���
#  1 : ��

	(my $num = scalar reverse shift) =~ tr/,//d;
	my $zeroflag=shift;
	my $number1flag=shift;

	my $zero=$zeroflag eq 0 ? "��" : "��";
	my @kansuuji=("","��","��","��","��","��","ϻ","��","Ȭ","��");
	my @digit_sub=("","��","ɴ","��");
	my @digit=("","��","��","��","��");
	my $gan=$number1flag eq 0 ? $kansuuji[1] : "��";

	return '' if($num=~/\D/);
	return '' if(length($num) > scalar(@digit) * 4);
	return $zero if($num eq 0);
	return $gan if($num eq 1);

	my @buf;
	my $c=0;
	# 4�夺�Ķ��ڤ�
	if($zeroflag eq 0) {
		foreach(split //, $num) {
			unshift @buf, $_ eq 0 ? $zero : $kansuuji[$_];
		}
	} else {
		foreach my $sub_num ($num =~ m/\d{1,4}/g) {
			# ����������
			unshift @buf, $digit[$c++];
			# ��夺�Ķ��ڤ�
			my  @sub_num    = split //, $sub_num;
			unshift @buf, $_		   eq 0 ? $kansuuji[$sub_num[$_]]
						: $sub_num[$_] eq 0 ? ''
						: $sub_num[$_] eq 1 ? $digit_sub[$_]
						: ( $kansuuji[$sub_num[$_]], $digit_sub[$_] )
			foreach 0 .. $#sub_num;
		}
	}
	return join '', @buf;
}


# Ⱦ�Ѣ������Ѵ�
sub h2z() {
	my ($parm)=@_;
	my $buf=$::EXDATE_CACHE->read("h2z-$parm");
	if($buf ne '') {
		chomp $buf;
		return $buf;
	}
	$zen='���ɡ������ǡʡˡ��ܡ��ݡ������������������������������䡩�����£ãģţƣǣȣɣʣˣ̣ͣΣϣУѣңӣԣգ֣ףأ٣ڡΡ�ϡ����ƣ���������������������������������Сá�';
	$han='!"#$%&\'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}';
	if($::versionnumber > 0 * 10000 + 21 * 100 + 4) {
		if($::defaultcode eq 'euc') {
			&load_module("Nana::Code");
			$buf=Nana::Code::h2z($parm);
			$buf=Nana::Code::hanzen($parm, "euc");
		} else {
			$parm=&code_convert(\$parm, "euc", "utf8");
			$buf=Nana::Code::h2z($parm);
			$buf=Nana::Code::hanzen($buf, "utf8");
			$buf=&code_convert(\$parm, "utf8", "euc");
		}

	if($::defaultcode eq 'euc') {
		$buf=Jcode->new($parm)->h2z->tr($han,$zen);
	} else {
		$zen=Jcode->new($zen,'utf8')->euc;
		$parm=Jcode->new($parm,'utf8')->euc;
		$buf=Jcode->new($parm)->h2z->tr($han,$zen)->utf8;
	}
	$::EXDATE_CACHE->write("h2z-$parm","$buf\n");
	return $buf;
}

sub ex_date1 {
	my($format,$sec,$min,$hour,$hr12,$mday,$mon,$year,$wday,$yday,$isdst)=@_;
	my $nendo;

	# ����ν��� SA�Τߥ���������
	$format=~s/SA/\x11\x11/g;	# SA:escape ����(H)

	# ���������Υ���������
	$format=~s/RS/\x12\x11/g;
	$format=~s/Rs/\x12\x12/g;
	$format=~s/RG/\x12\x13/g;
	$format=~s/Rg/\x12\x14/g;
	$format=~s/XG/\x12\x15/g;
	$format=~s/Xg/\x12\x16/g;
	$format=~s/SZ/\x12\x17/g;
	$format=~s/Sz/\x12\x18/g;
	$format=~s/MG/\x12\x19/g;
	$format=~s/Mg/\x12\x1a/g;
	$format=~s/RK/\x13\x13/g;
	$format=~s/Rk/\x13\x14/g;
	$format=~s/RY/\x13\x15/g;
	$format=~s/NK/\x13\x16/g;
	$format=~s/HK/\x13\x17/g;
	$format=~s/HY/\x13\x18/g;

	# ����
	if($format=~m/(QY|Qy|QZY|QZy|QKY|EY|Ey|EZY|EZy|EzY
				  |Qn|QZn|QZm|QKn|QKm|Qkn|Qj|QZj|QZJ|QKj|QKJ)/) {
		my($qy,$qm,$qd,$qf)=&get_qreki($year,$mon,$mday);
		my $yami=$qf ? $YAMI : '';
		$nendo=$qy+660;
		# ǯ
		$format=~s/QKY/&itoa_ja($qy,0,1)/ge;		# �󡻡�ϻ
		$format=~s/QZY/&h2z($qy)/ge;				# ��������
		$format=~s/QZy/substr(&h2z($qy),4,4)/ge;	# ����
		$format=~s/QY/sprintf("%d",$qy)/ge;			# 2006
		$format=~s/Qy/substr($qy,2,2)/ge;			# 06
		# ����
		$format=~s/EKY/&itoa_ja($nendo,0,1)/ge;		# �󡻡�ϻ
		$format=~s/EZY/&h2z($nendo)/ge;				# ��������
		$format=~s/EZy/substr(&h2z($nendo),4,4)/ge;	# ����
		$format=~s/EY/sprintf("%d",$nendo)/ge;		# 2006
		$format=~s/Ey/substr($nendo,2,2)/ge;		# 06
		# ��
		$format=~s/QZn/$yami . &h2z($qm)/ge;				# ��������
		$format=~s/QZm/$yami . &h2z(sprintf("%02d",$qm))/ge;# ����������
		$format=~s/QKn/$yami . &itoa_ja($qm,1,0)/ge;		# ��������
		$format=~s/QKm/$yami . &itoa_ja($qm,0,0)/ge;		# �������졻��
		$format=~s/Qkn/$yami . $QMONTH[$qm-1]/ge;			# �ӷ�
		$format=~s/Qn/$yami . $qm/ge;						# 1-12
		$format=~s/Qm/$yami . sprintf("%02d",$qm)/ge;		# 01-12
		# ��
		$format=~s/QZj/&h2z($qd)/ge;				# ��������
		$format=~s/QZJ/&h2z(sprintf("%02d",$qd))/ge;# ����������
		$format=~s/QKj/&itoa_ja($qd,1,0)/ge;		# ��������
		$format=~s/QKJ/&itoa_ja($qd,0,0)/ge;		# �������졻��
		$format=~s/Qj/$qd/ge;						# 1-12
		$format=~s/QJ/sprintf("%02d",$qd)/ge;		# 01-31
	}

	# ����
	if($format=~m/(TY|Ty|TZY|TZy|TzY)/) {
		$nendo=$year+660;
		$format=~s/TzY/&itoa_ja($nendo,0,1)/ge;		# �󡻡�ϻ
		$format=~s/TZY/&h2z($nendo)/ge;				# ��������
		$format=~s/TZy/substr(&h2z($nendo),4,4)/ge;	# ����
		$format=~s/TY/sprintf("%d",$nendo)/ge;		# 2006
		$format=~s/Ty/substr($nendo,2,2)/ge;		# 06
	}

	# �����ǯ��
	if($format=~m/N(\d{1,2})(SG|Sg|Sa|SY|Sy|GY|XY|Xy)/g) {
		my $tmp=$1;
		$nendo=$year-($mon < $tmp ? 1 : 0);
		my($_gango,$_gango2,$_gshort,$_gyear)=&get_gango($nendo,$1,1);
		$format=~s/N$tmp\SG/$_gango/ge;					# ʿ��
		$format=~s/N$tmp\Sg/$_gango2/ge;		# ʿ
		$format=~s/N$tmp\Sa/&h2z($_gshort)/ge;			# ��
		$format=~s/N$tmp\GY/($_gyear eq 1 ? '��' : &h2z($_gyear))/ge;	# ������
		$format=~s/N$tmp\XY/&itoa_ja($_gyear,1,1)/ge;	# ���������
		$format=~s/N$tmp\Xy/&itoa_ja($_gyear,0,1)/ge;	# ��������졻��
		$format=~s/N$tmp\SY/sprintf("%d",$_gyear)/ge;	# 1-10-...
		$format=~s/N$tmp\Sy/sprintf("%02d",$_gyear)/ge;	# 01-10-...
	}
	# ����
	if($format=~m/(SG|Sg|Sa|SY|Sy|GY|XY|Xy)/g) {
		my($_gango,$_gango2,$_gshort,$_gyear)=&get_gango($year,$mon,$mday);
		$format=~s/SG/$_gango/ge;						# ʿ��
		$format=~s/Sg/$_gango2/ge;						# ʿ
		$format=~s/Sa/&h2z($_gshort)/ge;				# ��
		$format=~s/GY/($_gyear eq 1 ? '��' : &h2z($_gyear))/ge;	# ������
		$format=~s/XY/&itoa_ja($_gyear,1,1)/ge;			# ���������
		$format=~s/Xy/&itoa_ja($_gyear,0,1)/ge;			# ��������졻��
		$format=~s/SY/sprintf("%d",$_gyear)/ge;			# 1-10-...
		$format=~s/Sy/sprintf("%02d",$_gyear)/ge;		# 01-10-...
	}
	# ����ǯ��
	if($format=~m/N(\d{1,2})(Y|y|ZY|Zy|KY)/g) {
		my $tmp=$1;
		$nendo=$year-($mon < $tmp ? 1 : 0);
		$format=~s/N$tmp\KY/&itoa_ja($nendo,0,1)/ge;	# �󡻡�ϻ
		$format=~s/N$tmp\ZY/&h2z($nendo)/ge;			# ��������
		$format=~s/N$tmp\Zy/substr(&h2z($nendo),4,4)/ge;# ����
		$format=~s/N$tmp\Y/sprintf("%d",$nendo)/ge;		# 2006
		$format=~s/N$tmp\y/substr($nendo,2,2)/ge;		# 06
	}
	# ����
	$format=~s/KY/&itoa_ja($year,0,1)/ge;				# �󡻡�ϻ
	$format=~s/ZY/&h2z($year)/ge;						# ��������
	$format=~s/Zy/substr(&h2z($year),4,4)/ge;			# ����

	# ��
	$format=~s/Zn/&h2z($mon)/ge;						# ��������
	$format=~s/Zm/&h2z(sprintf("%02d",$mon))/ge;		# ����������
	$format=~s/Kn/&itoa_ja($mon,1,0)/ge;				# ��������
	$format=~s/Km/&itoa_ja($mon,0,0)/ge;				# �������졻��
	$format=~s/kn/$QMONTH[$mon-1]/ge;					# �ӷ�

	# ��
	$format=~s/Zj/&h2z($mday)/ge;						# ��������
	$format=~s/ZJ/&h2z(sprintf("%02d",$mday))/ge;		# ����������
	$format=~s/Kj/&itoa_ja($mday,1,0)/ge;				# ��������
	$format=~s/KJ/&itoa_ja($mday,0,0)/ge;				# �������졻��

	# ��
	$format=~s/Zg/&h2z($hr12)/ge;						# ��������
	$format=~s/Zh/&h2z(sprintf("%02d",$hr12))/ge;		# ����������
	$format=~s/Kg/&itoa_ja($hr12,1,0)/ge;				# ��������
	$format=~s/Kh/&itoa_ja($hr12,0,0)/ge;				# �������졻��
	$format=~s/ZG/&h2z($hour)/ge;						# ��������
	$format=~s/ZH/&h2z(sprintf("%02d",$hour))/ge;		# ����������
	$format=~s/KG/&itoa_ja($hour,1,0)/ge;				# ��������
	$format=~s/KH/&itoa_ja($hour,0,0)/ge;				# �������졻��

	# ʬ
	$format=~s/Zk/&h2z($min)/ge;						# ��������
	$format=~s/Zi/&h2z(sprintf("%02d",$min))/ge;		# ����������
	$format=~s/Kk/&itoa_ja($min,1,0)/ge;				# �������
	$format=~s/Ki/&itoa_ja($min,0,0)/ge;				# �����졻��

	# ��
	$format=~s/ZS/&h2z($sec)/ge;						# ��������
	$format=~s/Zs/&h2z(sprintf("%02d",$sec))/ge;		# ����������
	$format=~s/KS/&itoa_ja($sec,1,0)/ge;				# �������
	$format=~s/Ks/&itoa_ja($sec,0,0)/ge;				# �����졻��

	return $format;
}

sub ex_date2 {
	my($format,$sec,$min,$hour,$hr12,$mday,$mon,$year,$wday,$yday,$isdst)=@_;

	# ����
	if($format=~m/\x11\x11/g) {
		$nendo=$year-($mon < $tmp ? 1 : 0);
		my($_gango,$_gango2,$_gshort,$_gyear)=&get_gango($year,$mon,$mday);
		$format=~s/\x11\x11/$_gshort/ge;				# H
	}
	# ����
	if($format=~/\x12[\x12\x13]/) {
		my $event;
		%::SYUKUJITSU=&get_event($year,"syukujitsu",@SYUKUJITSU) if($::SYUKUJITSU{$year} ne 1);
		$event=$::SYUKUJITSU{sprintf("%04d_%02d_%02d",$year,$mon,$mday)};
		$format=~s/\x12\x11/$event/ge;					# ��ö
		$event="($event)" if($event ne '');
		$format=~s/\x12\x12/$event/ge;					# (��ö)
	}
	# �Ի�
	if($format=~/\x12[\x13\x14]/) {
		my $event;
		%::GYOJI=&get_event($year,"gyoji",@GYOJI) if($::GYOJI{$year} ne 1);
		$event=$::GYOJI{sprintf("%04d_%02d_%02d",$year,$mon,$mday)};
		$format=~s/\x12\x13/$event/ge;					# ��ö
		$event="($event)" if($event ne '');
		$format=~s/\x12\x14/$event/ge;					# (��ö)
	}
	# ��̱�ιԻ�
	if($format=~/\x12[\x15\x16]/) {
		my $event;
		%::PREF_GYOJI=&get_event($year,"pref_gyoji",@PREF_GYOJI) if($::PREF_GYOJI{$year} ne 1);
		$event=$::PREF_GYOJI{sprintf("%04d_%02d_%02d",$year,$mon,$mday)};
		$format=~s/\x12\x15/$event/ge;					# ��ö
		$event="($event)" if($event ne '');
		$format=~s/\x12\x16/$event/ge;					# (��ö)
	}
	# ����
	if($format=~/\x12[\x17\x18]/) {
		my $event;
		%::SEIZA=&get_event($year,"seiza",@SEIZA) if($::SEIZA{$year} ne 1);
		$event=$::SEIZA{sprintf("%04d_%02d_%02d",$year,$mon,$mday)};
		$format=~s!\x12\x17!(split(/,/,$event))[0]!ge;	# ���ҤĤ���
		$event="($event)" if($event ne '');
		$format=~s!\x12\x18!(split(/,/,$event))[1]!ge;	# �Ѹ�̾
	}
	# ��ʬ�ιԻ�
	if($format=~/\x12[\x19\x1a]/) {
		my $event;
		%::MY_GYOJI=&get_event($year,"my_gyoji",@EXDATE::MY_GYOJI) if($::MY_GYOJI{$year} ne 1);
		$event=$::MY_GYOJI{sprintf("%04d_%02d_%02d",$year,$mon,$mday)};
		$format=~s/\x12\x19/$event/ge;					# ��ö
		$event="($event)" if($event ne '');
		$format=~s/\x12\x1a/$event/ge;					# (��ö)
	}
	# ϻ�ˡ�24�ᵨ�����١���
	if($format=~/\x13[\x13-\x18]/) {
		my $sekki=&get_24sekki($year,$mon,$mday);
		$format=~s/\x13\x13/$sekki/ge;						# Ω��
		$sekki="($sekki)" if($sekki ne '');
		$format=~s/\x13\x14/$sekki/ge;						# (Ω��)
		$format=~s/\x13\x15/&get_rokuyou($year,$mon,$mday)/ge;# ϻ��
		$format=~s/\x13\x16/&get_kanshi_year($year,$mon,$mday)/ge;#ǯ�δ���
		$format=~s/\x13\x17/&get_kanshi_day($year,$mon,$mday)/ge;#���δ���
		$format=~s/\x13\x18/&get_syuku($year,$mon,$mday)/ge;	#���ν�
	}
	return $format;
}

#
# �ʲ������С��饤�ɤ���ؿ�
#

sub dateinit {
	my $i=0;
	foreach(split(/,/,$::resource{"date_ampm_en"})) {
		$::_date_ampm[$i++]=$_;
	}
	$i=0;
	foreach(split(/,/,$::resource{"date_ampm_".$::lang})) {
		$::_date_ampm_locale[$i++]=$_;
	}
	$i=0;
	foreach(split(/,/,$::resource{"date_weekday_en"})) {
		$::_date_weekday[$i++]=$_;
	}
	$i=0;
	foreach(split(/,/,$::resource{"date_weekday_".$::lang})) {
		$::_date_weekday_locale[$i++]=$_;
	}
	$i=0;
	foreach(split(/,/,$::resource{"date_weekday_en_short"})) {
		$::_date_weekday_short[$i++]=$_;
	}
	$i=0;
	foreach(split(/,/,$::resource{"date_weekday_".$::lang."_short"})) {
		$::_date_weekday_locale_short[$i++]=$_;
	}
}

sub date {
	my ($format, $tm, $gmtime) = @_;
	my %weekday;
	my $weekday_lang;
	my $ampm_lang;
	my %ampm;
	my ($_year,$_mon);

	# yday:0-365 $isdst Summertime:1/not:0
	my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) =
		$gmtime ne '' && @_ > 2
			? ($tm+0 > 0 ? gmtime($tm) : gmtime(time))
			: ($tm+0 > 0 ? localtime($tm) : localtime(time));

	$year += 1900;
	my $hr12=$hour=>12 ? $hour-12:$hour;

	$format=&ex_date1($format,$sec,$min,$hour,$hr12,$mday,$mon+1,$year,$wday,$yday,$isdst);

	# am / pm strings										# comment
	$ampm{en}=$::_date_ampm[$hour>11 ? 1 : 0];
	$ampm{$::lang}=$::_date_ampm_locale[$hour>11 ? 1 : 0];

	# weekday strings										# comment
	$weekday{en}=$::_date_weekday[$wday];
	$weekday{en_short}=$::_date_weekday_short[$wday];
	$weekday{$::lang}=$::_date_weekday_locale[$wday];
	$weekday{$::lang."_short"}=$::_date_weekday_locale_short[$wday];

	$weekday_lang=$weekday{$::lang} eq '' ? 'en' : $::lang;
	$ampm_lang=$ampm{$::lang} eq '' ? 'en' : $::lang;

	# RFC 822 (only this)
	if($format=~/r/) {
		return &date("D, j M Y H:i:s O",$tm,$gmtime);
	}
	# gmtime & ���󥿡��ͥåȻ���
	if($format=~/[OZB]/) {
		my $gmt = ((localtime(time))[2] + (localtime(time))[3] * 24)
				- ((gmtime(time))[2] + (gmtime(time))[3] * 24);
		$format =~ s/O/sprintf("%+03d:00", $gmt)/ge;	# GMT Time
		$format =~ s/Z/sprintf("%d", $gmt*3600)/ge;		# GMT Time secs...
		my $swatch=(($tm-$gmt+90000)/86400*1000)%1000;	# GMT +1:00�ˤ��ơ�������1000beat�ˤ���
														# ���ܻ��֤ξ�硢AM08:00=000
		$format =~ s/B/sprintf("%03d", int($swatch))/ge;# internet time
	}

	# UNIX time
	$format=~s/U/sprintf("%u",$tm)/ge;	# unix time

	$format=~s/lL/\x2\x13/g;	# lL:escape ��-��
	$format=~s/DL/\x2\x14/g;	# DL:escape ������-������
	$format=~s/l/\x2\x11/g;		# l:escape Sunday-Saturday
	$format=~s/D/\x2\x12/g;		# D:escape Sun-Sat
	$format=~s/aL/\x1\x13/g;	# aL:escape ���� or ���
	$format=~s/AL/\x1\x14/g;	# AL:escape ������ʸ��
	$format=~s/a/\x1\x11/g;		# a:escape am pm
	$format=~s/A/\x1\x12/g;		# A:escape AM PM
	$format=~s/M/\x3\x11/g;		# M:escape Jan-Dec
	$format=~s/F/\x3\x12/g;		# F:escape January-December

	# ���뤦ǯ�����η������
	if($format=~/[Lt]/) {
		my $uru=($year % 4 == 0 and ($year % 400 == 0 or $year % 100 != 0)) ? 1 : 0;
		$format=~s/L/$uru/ge;
		$format=~s/t/(31, $uru ? 29 : 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31)[$mon]/ge;
	}

	# year
	$format =~ s/Y/$year/g;	# Y:4char ex)1999 or 2003
	$_year = $year % 100;
	$_year = "0" . $_year if ($_year < 10);
	$format =~ s/y/$_year/g;	# y:2char ex)99 or 03

	# month
	my $month = ('January','February','March','April','May','June','July','August','September','October','November','December')[$mon];
	$mon++;									# mon is 0 to 11 add 1
	$format =~ s/n/$mon/g;					# n:1-12
	if ($mon < 10) {
		$_mon = "0" . $mon;
	} else {
		$_mon=$mon;
	}
	$format =~ s/m/$_mon/g;				# m:01-12

	# day
	$format =~ s/j/$mday/g;				# j:1-31
	$mday = "0" . $mday if ($mday < 10);
	$format =~ s/d/$mday/g;				# d:01-31

	# hour
	$format =~ s/g/$hr12/g;				# g:1-12
	$format =~ s/G/$hour/g;				# G:0-23
	$hr12 = "0" . $hr12 if ($hr12 < 10);
	$hour = "0" . $hour if ($hour < 10);
	$format =~ s/h/$hr12/g;				# h:01-12
	$format =~ s/H/$hour/g;				# H:00-23

	# minutes
	$format =~ s/k/$min/g;					# k:0-59
	$min = "0" . $min if ($min < 10);
	$format =~ s/i/$min/g;					# i:00-59

	# second
	$format =~ s/S/$sec/g;					# S:0-59
	$sec = "0" . $sec if ($sec < 10);
	$format =~ s/s/$sec/g;					# s:00-59

	$format =~ s/w/$wday/g;				# w:0(Sunday)-6(Saturday)


	$format =~ s/I/$isdst/g;	# I(Upper i):1 Summertime/0:Not

	$format =~ s/\x1\x12/uc $ampm{en}/ge;		# A:AM or PM		# comment
	$format =~ s/\x1\x13/$ampm{$::lang}/ge;		# A:���� or ���	# comment
	$format =~ s/\x1\x14/uc $ampm{$::lang}/ge;	# ������ʸ��		# comment

	$format =~ s/\x2\x11/$weekday{en}/ge;		# l(lower L):Sunday-Saturday	# comment
	$format =~ s/\x2\x12/$weekday{en_short}/ge;	# D:Mon-Sun	# comment
	$format =~ s/\x2\x13/$weekday{"$::lang" . "_short"}/ge;	# D:Mon-Sun	# comment
	$format =~ s/\x2\x14/$weekday{$::lang}/ge;

	$format =~ s/\x3\x11/substr($month,0,3)/ge;	# M:Jan-Dec
	$format =~ s/\x3\x12/$month/g;				# F:January-December

	# v0.1.6�Ǽ���
	# O ����˥å�ɸ���(GMT)�Ȥλ��ֺ� Example: +0200
	# r RFC 822 �ե����ޥåȤ��줿���� ��: Thu, 21 Dec 2000 16:01:07 +0200
	# Z �����ॾ����Υ��ե��å��ÿ��� -43200 ���� 43200
	# L ��ǯ�Ǥ��뤫�ɤ�����ɽ�������͡� 1�ʤ鱼ǯ��0�ʤ鱼ǯ�ǤϤʤ���
	# lL:���ߤΥ�����θ���Ǥ�������û��
	# DL:���ߤΥ�����θ���Ǥ�������Ĺ��
	# aL:���ߤΥ�����θ���Ǥθ���������ʸ����
	# AL:���ߤΥ�����θ���Ǥθ������ʾ�ʸ����
	# L ��ǯ�Ǥ��뤫�ɤ�����ɽ�������͡� 1�ʤ鱼ǯ��0�ʤ鱼ǯ�ǤϤʤ���
	# t ���ꤷ����������� 28 ���� 31
	# B Swatch ���󥿡��ͥåȻ��� 000 ���� 999
	# U Unix ��(1970ǯ1��1��0��0ʬ0��)������ÿ� See also time()

	# Not Allowed
	# W ISO-8601 �������˻Ϥޤ�ǯñ�̤ν��ֹ� (PHP 4.1.0���ɲ�) ��: 42 (��ǯ����42����)
	# S �Ѹ�����ν�����ɽ�����ե��å�����2 ʸ���� st, nd, rd or th. Works well with j
	# T ���Υޥ�����Υ����ॾ��������ꡣ Examples: EST, MDT ...
	$format =~ s/z/$yday/ge;	# z:days/year 0-366

	$format=&ex_date2($format,$sec,$min,$hour,$hr12,$mday,$mon,$year,$wday,$yday,$isdst);
	return $format;
}
1;
__DATA__
sub plugin_exdate_setup {
	return(
	'ja'=>'����ɽ�����ĥ����',
	'en'=>'Extended view date format',
	'use_req'=>'Jcode,Nana::Cache',
	'override'=>'date',
	'url'=>'http://pyukiwiki.sourceforge.jp/PyukiWiki/Plugin/Nanami/exdate/'
	);
__END__

1;

=head1 NAME

exdate.inc.pl - PyukiWiki Plugin

=head1 SYNOPSIS

The time display for Japan is extended.

=head1 DESCRIPTION

Detailed explanation should look at a Japanese document.

=head1 USAGE

rename to exdate.inc.cgi

=head1 OVERRIDE

date function was overrided.

=head1 SEE ALSO

=over 4

=item PyukiWiki/Plugin/Nanami/exdate

L<@@BASEURL@@/PyukiWiki/Plugin/Nanami/exdate/>

=item PyukiWiki CVS

L<@@CVSURL@@/PyukiWiki-Devel/lib/exdate.inc.pl>

L<@@CVSURL@@/PyukiWiki-Devel/lib/exdate-qreki.inc.pl>

=back

==head1 AUTHOR

=over 4

@@AUTHOR_NANAMI@@

@@AUTHOR_PYUKI@@

=back

=head1 LICENSE

@@LICENSE_NANAMI@@

=cut
