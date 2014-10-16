######################################################################
# @@HEADEREXPLUGIN_NANAMI@@
######################################################################
# Based on こよみのページ http://koyomi8.com/
# Based on 旧暦計算ライブラリ http://www3.biwako.ne.jp/~nobuaki/qreki/
######################################################################
# This is extented plugin.
# To use this plugin, rename to 'exdate.inc.cgi'
######################################################################
#    元号:SG:明治/大正/昭和/平成 Sg:明/大/昭/平
#         SA:M/T/S/H Sa:Ｍ/Ｔ/Ｓ/Ｈ
#
#  元号年:SY:1-2桁(1〜10〜) Sy:0補完して2桁(01〜10〜)
#         GY:全角1-2桁(元〜２〜１０〜)
#         XY:全角1-2桁(元〜二〜十〜十一〜二十〜二十一〜)
#         Xy:全角1-2桁(元〜二〜一〇〜十一〜二〇〜二一〜)
#
#    年度 N4SG N4Sg N4Sa N4SY N4Sy N4GY N4XY N4Xy 上記元号年同、４月を基点
#         N9SG N9Sg N9Sa N9SY N9Sy N9GY N9XY N9Xy 上記元号年と同、９月を基点
#
#    西暦:Y:西暦(4桁)/y:西暦(2桁) - **
#        :ZY:全角4桁 Zy:全角2桁 KY:一七七〇〜二〇〇〇〜
#
#    皇暦:TY:西暦(4桁)/Ty:西暦(2桁) - **
#        :TZY:全角4桁 TZy:全角2桁 TzY:一七七〇〜二〇〇〇〜
#
#西暦年度:N4Y:西暦(4桁)/N4y:西暦(2桁)
#         N4ZY:全角2桁 N4Zy:全角2桁 N4KY:一七七〇〜二〇〇〇〜
#         N9ZY: N9Zy N9KY : ↑と同じで９月を基点
#
#      月:n:1-12/m:01-12/M:Jan-Dec/F:January-December - **
#         Zn:全角1-2桁(１−１２) Zm:0補完して全角2桁(０１−１２）
#         Kn:一〜十〜十二/Km:一〜一〇〜一二
#         kn:睦月,如月...
#
#      日:j:1-31/J:01-31 - **
#         Zj:全角1-2桁(１−３１) ZJ:0補完して全角2桁(０１−３１）
#         Kj:一〜十〜十一〜二十〜三十一/KJ:一〜一〇〜
#
#    曜日:l:Sunday-Saturday/D:Sun-Sat/DL:日曜日-土曜日/lL:日-土 - **
#
#    ampm:a:am or pm/A:AM or PM/AL:午前 or 午後 - **
#
#      時:g:1-12/G:0-23/h:01-12/H/00-23 - **
#         Zg:１−１２/ZG:０−２３/Zh:０１−１２/ZH/００−２３
#         Kg:一〜十〜十二/KG:零〜十〜十一〜二十/二十三
#         Kh:一〜一〇〜一二/KH:〇〜一〇〜一一〜二〇〜二三
#
#      分:k:0-59/i:00-59 - **
#         Zk:０−５９/Zi:００−５９
#         Kk:零〜五十九/Ki:〇〜五九
#
#      秒:S:0-59/s:00-59 - **
#         ZS:０−５９/Zs:００−５９
#         KS:零〜五十九/Ks:〇〜五九
#
#    祝日:RS:元旦/Rs:(元旦) 1948年より出力
#    行事:RG:七草/Rg:(七草) 1948年より出力
#  県民の:XG:都民の日/Xg:(都民の日) 1948年より出力
#    星座:SZ:おひつじ座/Sz:Aries
#  自分の:MG:.../Mg:(...) 1948年より出力
#  24節季:RK:立夏/Rk:(立夏)
#    六曜:RY:大安/赤口/先勝/友引/先負/仏滅
#  年干支:NK:甲子
#  日干支:HK:乙卵
#  日の宿:HY:角
#  旧暦年:QY:西暦(4桁)/Qy:西暦(2桁)
#        :QZY:全角4桁 QZy:全角2桁 QKY:一七七〇〜二〇〇〇〜
#
#    皇暦:EY:西暦(4桁)/Ey:西暦(2桁)
#        :EZY:全角4桁 EZy:全角2桁 EzY:一七七〇〜二〇〇〇〜
#
#      月:Qn:1-12/Qm:01-12
#         QZn:全角1-2桁(１−１２) QZm:0補完して全角2桁(０１−１２）
#         QKn:一〜十〜十二/QKm:一〜一〇〜一二
#         Qkn:睦月,如月...
#
#      日:Qj:1-31/QJ:01-31 - **
#         QZj:全角1-2桁(１−３１) QZJ:0補完して全角2桁(０１−３１）
#         QKj:一〜十〜十一〜二十〜三十一/QKJ:一〜一〇〜
######################################################################
# 以下、wiki.cgiと同一
# t 指定した月の日数。 28 から 31
# O   : グリニッジとの時間差
# r RFC 822 フォーマットされた日付 例: Thu, 21 Dec 2000 16:01:07 +0200
# Z タイムゾーンのオフセット秒数。 -43200 から 43200
# L 閏年であるかどうかを表す論理値。 1なら閏年。0なら閏年ではない。
# B Swatch インターネット時間 000 から 999
# U Unix 時(1970年1月1日0時0分0秒)からの秒数 See also time()
######################################################################

# 個人用行事の日設定
@EXDATE::MY_GYOJI=(
#	"1900-/1/1:彼女の誕生日",	# example
	"2005-/12/31:PyukiWikiプロジェクト開始記念日"
) if(!defined(@EXDATE::MY_GYOJI));

# 元号リスト 古い順に 年/月/日:和名:半角大文字１文字
@EXDATE::GANGO=(
	"1868/9/8:明治:明:M",	# 必要なければ不要な元号をコメントアウトすると
	"1912/7/30:大正:大:T",	# 少し軽くなります
	"1926/12/25:昭和:昭:S",
	"1989/1/8:平成:平:H"
);

# 旧暦キャッシュの最大保存数
$exdate::cache_max=2000
	if(!defined($exdate::cache_max));

# 旧暦キャッシュの拡張子
$exdate::cache_ext="exdate"
	if(!defined($exdate::cache_ext));


######################################################################
#
# DB形式
#
# 固定日付の場合
# (最初の年)-(最後の年)/(最初の月)-(最後の月)/(最初の日)-(最後の日)
#
# 第何曜日の場合
# (最初の年)-(最後の年)/(最初の月)-(最後の月)/(何週目)/(何曜日:0-6)
#
# 特殊処理
# 1973-2004年の0/0 は旧式の振り替え休日の処理
# 2005年以降の0/0 は 新式の振り替え休日の処理
# 0-1948-/3/0 春分の日 3-1948-/9/0 秋分の日
# 0-1948-/3/0、3-1948-/9/0 お彼岸
# ???-1948-/40/32:土用入
# ???-1948-/40/33:土用明
# 0-1948-/40/34:間日"
# 0-1948-/40/35:丑の日,
# 0-1948-/41/36:節分

# from http://koyomi.vis.ne.jp/syukujitsu.htm

# 祝日リスト
@SYUKUJITSU=(
	"1973-2004/0/0:振替休日",	# 日曜日と祝日が重なった場合翌日を休日
	"2005-/0/0:振替休日",		# その日以後において最も近い国民の祝日でない日
	"1948-/1/1:元旦",
	"1948-1999/1/15:成人の日",
	"2000-/1/2/1:成人の日",
	"1966-/2/11:建国記念の日",
	"0-1948-/3/32:春分の日",		# 春分処理
	"1948-1988/4/29:天皇誕生日",
	"1989-2006/4/29:みどりの日",
	"2007-/4/29:昭和の日",
	"1948-/5/3:憲法記念日",
	"1985-2006/5/4:国民の休日",
	"2007-/5/4:みどりの日",
	"1948-/5/5:こどもの日",
	"1995-2002/7/20:海の日",
	"2003-/7/3/1:海の日",
	"1966-2002/9/15:敬老の日",
	"2003-/9/3/1:敬老の日",
	"2003/9/22:国民の休日",
	"0-1948-/9/32:秋分の日",		# 秋分処理
	"1966-1999/10/10:体育の日",
	"2000-/10/2/1:体育の日",
	"1948-/11/3:文化の日",
	"1948-/11/23:勤労感謝の日",
	"1989-/12/23:天皇誕生日",
	"1959/4/10:皇太子明仁親王の結婚の儀",
	"1989/2/24:昭和天皇の大喪の礼",
	"1990/11/22:即位礼正殿の儀",
	"1993/6/9:皇太子徳仁親王の結婚の儀"
);

# 一般的な行事
@GYOJI=(
	"1948-/1/1-3:お正月",
	"1948-/1/7:七草",
	"1948-/1/15:小正月",
	"1948-/1/20:二十日正月",
	"1948-/2/14:バレンタインデー",
	"1948-/3/14:ホワイトデー",
	"1948-/3/3:ひな祭り",
	"3-1948-/3/0:お彼岸",	# 春分から-3〜+3日
	"1948-/4/1:エイプリールフール",
	"1948-/5/1:メーデー",
	"1948-/5/5:菖蒲の節句",
	"1948-/5/2/0:母の日",
	"1948-/6/3/0:父の日",
	"1948-/7/7:七夕",
	"1948-/7/15:中元",
	"1948-/8/13-16:お盆",
	"1948-/8/15:終戦記念日",
	"1948-/9/1:防災の日",
	"1948-/9/9:菊の節句",
	"3-1948-/9/0:お彼岸",	# 秋分から-3〜+3日
	"1948-/11/15:七五三",
	"1948-/12/24:クリスマスイヴ",
	"1948-/12/25:クリスマス",
	"1948-/12/31:大晦日",
	"297-1948-/40/32:土用入",	# 以下必要なければ「すべて」コメントアウトすると
	"315-1948-/40/33:土用明",	# 少し軽くなります
	"27-1948-/40/32:土用入",	# 旧暦から計算で求めます。
	"45-1948-/40/33:土用明",	# 土用明の算出に現在不具合があります。
	"117-1948-/40/32:土用入",
	"135-1948-/40/33:土用明",
	"207-1948-/40/32:土用入",
	"225-1948-/40/33:土用明",
	"0-1948-/40/34:間日",
	"0-1948-/40/35:丑の日",
	"0-1948-/41/36:節分"		# ここまで
);

# 都道府県等行事
@PREF_GYOJI=(
	"1948-/2/7:福井県ふるさとの日",
	"1998-/2/7:長野県オリンピックメモリアルデー",
	"1948-/2/9:鹿児島畜産の日",
	"1948-/2/20:愛媛県県政発足記念日",
	"1948-/4/18:三重県県民の日",
	"1948-/5/15:沖縄県本土復帰記念日",
	"1948-/6/2:長崎港開港記念日",
	"1948-/6/2:横浜開港記念日",
	"1948-/6/15:千葉県県民の日",
	"1948-/6/15:栃木県県民の日",
	"1948-/8/6:広島県平和記念日",
	"1948-/8/9:長崎原爆の日",
	"1948-/8/21:福島県県民の日",
	"1948-/8/29:秋田県県民の日",
	"1948-/9/12:鳥取県県民の日",
	"1948-/10/1:都民の日",
	"1948-/11/1:岡山教育の日",
	"1948-/11/13:茨城県県民の日",
	"1948-/11/14:大分県県民の日",
	"1948-/11/14:埼玉県県民の日",
	"1948-/11/20:山梨県県民の日",
	"1948-/11/22:和歌山県ふるさと誕生日",
	"1948-/12/7:神戸市開港記念日",
	"1948-/1-12/29:鹿児島畜産の日",		# 毎月29日
	"1948-/1-12/23:京都府ふみんの日"	# 毎月23日
);

# 星座
@SEIZA=(
	"1948-/3/21-31:おひつじ座,Aries",
	"1948-/4/1-19:おひつじ座,Aries",
	"1948-/4/20-30:おうし座,Taurus",
	"1948-/5/1-20:おうし座,Taurus",
	"1948-/5/21-31:ふたご座,Gemini",
	"1948-/6/1-21:ふたご座,Gemini",
	"1948-/6/22-30:かに座,Cancer",
	"1948-/7/1-22:かに座,Cancer",
	"1948-/7/23-31:しし座,Leo",
	"1948-/8/1-22:しし座,Cancer",
	"1948-/8/23-31:おとめ座,Virgo",
	"1948-/9/1-22:おとめ座,Virgo",
	"1948-/9/23-30:てんびん座,Libra",
	"1948-/10/1-23:てんびん座,Libra",
	"1948-/10/24-31:さそり座,Scopio",
	"1948-/11/1-21:さそり座,Scopio",
	"1948-/11/22-30:いて座,Sagitarius",
	"1948-/12/1-21:いて座,Sagitarius",
	"1948-/12/22-31:やぎ座,Capricom",
	"1948-/1/1-19:やぎ座,Capricom",
	"1948-/1/20-31:みずがめ座,Aquarius",
	"1948-/2/1-18:みずがめ座,Aquarius",
	"1948-/2/19-30:うお座,Pisces",
	"1948-/3/1-20:うお座,Pisces"
);


# 陰暦の月
@QMONTH=("睦月","如月","弥生","卯月","皐月","水無月"
		,"文月","葉月","長月","神無月","霜月","師走");


# 闇月
$YAMI="闇";

# 六曜
@ROKUYOU=("大安","赤口","先勝","友引","先負","仏滅");

# 十干
@KAN= ("甲","乙","丙","丁","戊","己","庚","辛","壬","癸");

# 十二支
@SHI = ("子","丑","寅","卯","辰","巳","午","未","申","酉","戌","亥");

# 二十八宿
@SHUKU = ("角","亢","<U>氏</U>","房","心","尾","箕",
		"斗","牛","女","虚","危","室","壁",
		"奎","婁","胃","昴","畢","觜","参",
		"井","鬼","柳","星","張","翼","軫");

# ２４節気
@SEKKI24=("春分","清明","穀雨","立夏","小満","芒種","夏至","小暑","大暑","立秋","処暑","白露",
		 "秋分","寒露","霜降","立冬","小雪","大雪","冬至","小寒","大寒","立春","雨水","啓蟄");

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

# 配列の日付DBを展開する
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
		# 春分、秋分処理、土用
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
		# 第何週何曜日
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

# 元号を取得
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

# 1日足す
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

# その年の祝日行事を取得
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
			# 節分
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
			# 振り替え休日をpush
		} elsif($date{mon_min}+$date{mon_max}+$date{day_min}+$date{day_max} eq 0) {
			push(@hurikae,"$date{year_min}:$date{year_max}:$name");
			next;
		} elsif($date{year_min} <= $year && $year <= $date{year_max}) {
			# 曜日のみの処理
			if($date{week_syu} ne '') {
				# http://www.din.or.jp/~ohzaki/perl.htm#NthW2Date
				my $wday1=&getwday($year,$date{mon_min},1);
				my $mday=1 + ($date{week_youbi} - $wday1) % 7 + 7 * ($date{week_syu} - 1);
				$event{sprintf($_format,$year,$date{mon_min},$mday)}.="$name:";
			# 春分・秋分・お彼岸
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
	# 振り替え休日の処理
	foreach(@hurikae) {
		my($y_min,$y_max,$name)=split(/:/,$_);
		if($y_min <= $year && $year <= $y_max) {
			foreach(keys %event) {
				my($y,$m,$d)=split(/_/,$_);
				my($wday)=&getwday($y,$m,$d);
				if($wday eq 0) {
					my($_y,$_m,$_d)=&addday($y,$m,$d);
					# 旧式
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
	# 土用の処理
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
				# 土用明、正しくないと思われるので、表示のみ消してあります
				# 丑の日等の算出には必要です
				} elsif($mode eq 33) {
					$end_jd=qreki::sun2jd($yy,$koudou+$dt-4/9);
					@qreki=&get_jd2ymdt($end_jd);
# todo...
#					$event{sprintf($_format,$qreki[0],$qreki[1],$qreki[2])}="$name:";
					for(my $i=$start_jd; $i<=$end_jd; $i++) {
						my $shi=($i + 2) % 12;
						# 土用
						if($shi eq 1) {
							@qreki=&get_jd2ymdt($i);
							$event{sprintf($_format,$qreki[0],$qreki[1],$qreki[2])}.="$doyou_names[35]:";
						} elsif($qreki[1]<3) {	# 冬土用 寅 卯 巳
							if($shi eq 2 || $shi eq 3 || $shi eq 5) {
								@qreki=&get_jd2ymdt($i);
								$event{sprintf($_format,$qreki[0],$qreki[1],$qreki[2])}.="$doyou_names[34]:";
							}
						} elsif($qreki[1]<6) { # 春土用 巳 午 酉
							if($shi eq 5 || $shi eq 6 || $shi eq 9) {
								@qreki=&get_jd2ymdt($i);
								$event{sprintf($_format,$qreki[0],$qreki[1],$qreki[2])}.="$doyou_names[34]:";
							}
						} elsif($qreki[1]<9) { # 夏土用 卯・辰・申
							if($shi eq 3 || $shi eq 4 || $shi eq 8) {
								@qreki=&get_jd2ymdt($i);
								$event{sprintf($_format,$qreki[0],$qreki[1],$qreki[2])}.="$doyou_names[34]:";
							}
						} else {               # 秋土用 未・酉・亥
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

	# 最終処理
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

# 六曜を取得
sub get_rokuyou {
	my($y,$m,$d)=@_;
	my ($q_yaer,$uruu,$q_mon,$q_day) = &get_qreki($y,$m,$d);
	return $ROKUYOU[($q_mon + $q_day) % 6];
}

# 旧暦を取得 return [0]=Year [1]=Month [2]=day [3]=平月／閏月 flag
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

# 年の干支の計算
sub get_kanshi_year {
	my($y,$m,$d)=@_;
	my @qreki=&get_qreki($y,$m,$d);
	return $KAN[($qreki[0] + 6) % 10] . $SHI[($qreki[0] - 4) % 12];
}

# 日の干支の計算
sub get_kanshi_day {
	my($y,$m,$d)=@_;
	return "" if(!&req_qreki);
	my $jd=int(&get_ymdt2jd($y,$m,$d));
	return $KAN[$jd % 10] . $SHI[($jd + 2) % 12];
}

# 日の宿の計算
sub get_syuku {
	my($y,$m,$d)=@_;
	return "" if(!&req_qreki);
	my $jd=int(&get_ymdt2jd($y,$m,$d));
	return $SHUKU[($jd + 12) % 28];
}

# ２４節気を取得
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

# qreki.plをインクルード
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
# 春分の日、秋分の日を求める
# http://www.asahi-net.or.jp/~CI5M-NMR/misc/equinox.html
# http://koyomi.vis.ne.jp/reki_doc/doc_1710.htm
#

sub calc_syunbun {
	my($year,$month)=@_;
	my $day;
	my $x=6829570000;	# 1970年の春分点通過時刻の年初からのミリ秒（推定概算）
	my $y=22935091700;	# 1970年の秋分点通過時刻の年初からのミリ秒（推定概算）
	my $z=31556926000;	# 地球公転周期のミリ秒（ミリ秒単位では不正確かも？）
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
#  0 : 〇
#  1 : 零
#
# 数値が１の時の処理
#  0 : ichiで示されたもの
#  1 : 元

	(my $num = scalar reverse shift) =~ tr/,//d;
	my $zeroflag=shift;
	my $number1flag=shift;

	my $zero=$zeroflag eq 0 ? "〇" : "零";
	my @kansuuji=("","一","二","三","四","五","六","七","八","九");
	my @digit_sub=("","十","百","千");
	my @digit=("","万","億","兆","京");
	my $gan=$number1flag eq 0 ? $kansuuji[1] : "元";

	return '' if($num=~/\D/);
	return '' if(length($num) > scalar(@digit) * 4);
	return $zero if($num eq 0);
	return $gan if($num eq 1);

	my @buf;
	my $c=0;
	# 4桁ずつ区切る
	if($zeroflag eq 0) {
		foreach(split //, $num) {
			unshift @buf, $_ eq 0 ? $zero : $kansuuji[$_];
		}
	} else {
		foreach my $sub_num ($num =~ m/\d{1,4}/g) {
			# 万・億・兆
			unshift @buf, $digit[$c++];
			# 一桁ずつ区切る
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


# 半角→全角変換
sub h2z() {
	my ($parm)=@_;
	my $buf=$::EXDATE_CACHE->read("h2z-$parm");
	if($buf ne '') {
		chomp $buf;
		return $buf;
	}
	$zen='！”＃＄％＆’（）＊＋，−．／０１２３４５６７８９：；＜＝＞？＠ＡＢＣＤＥＦＧＨＩＪＫＬＭＮＯＰＱＲＳＴＵＶＷＸＹＺ［￥］＾＿‘ａｂｃｄｅｆｇｈｉｊｋｌｍｎｏｐｑｒｓｔｕｖｗｘｙｚ｛｜｝';
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

	# 元号の処理 SAのみエスケープ
	$format=~s/SA/\x11\x11/g;	# SA:escape 元号(H)

	# 祝日の等のエスケープ
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

	# 旧暦
	if($format=~m/(QY|Qy|QZY|QZy|QKY|EY|Ey|EZY|EZy|EzY
				  |Qn|QZn|QZm|QKn|QKm|Qkn|Qj|QZj|QZJ|QKj|QKJ)/) {
		my($qy,$qm,$qd,$qf)=&get_qreki($year,$mon,$mday);
		my $yami=$qf ? $YAMI : '';
		$nendo=$qy+660;
		# 年
		$format=~s/QKY/&itoa_ja($qy,0,1)/ge;		# 二〇〇六
		$format=~s/QZY/&h2z($qy)/ge;				# ２００６
		$format=~s/QZy/substr(&h2z($qy),4,4)/ge;	# ０６
		$format=~s/QY/sprintf("%d",$qy)/ge;			# 2006
		$format=~s/Qy/substr($qy,2,2)/ge;			# 06
		# 皇暦
		$format=~s/EKY/&itoa_ja($nendo,0,1)/ge;		# 二〇〇六
		$format=~s/EZY/&h2z($nendo)/ge;				# ２００６
		$format=~s/EZy/substr(&h2z($nendo),4,4)/ge;	# ０６
		$format=~s/EY/sprintf("%d",$nendo)/ge;		# 2006
		$format=~s/Ey/substr($nendo,2,2)/ge;		# 06
		# 月
		$format=~s/QZn/$yami . &h2z($qm)/ge;				# １〜１２
		$format=~s/QZm/$yami . &h2z(sprintf("%02d",$qm))/ge;# ０１〜１２
		$format=~s/QKn/$yami . &itoa_ja($qm,1,0)/ge;		# 一〜二〜十
		$format=~s/QKm/$yami . &itoa_ja($qm,0,0)/ge;		# 一〜二〜一〇〜
		$format=~s/Qkn/$yami . $QMONTH[$qm-1]/ge;			# 睦月
		$format=~s/Qn/$yami . $qm/ge;						# 1-12
		$format=~s/Qm/$yami . sprintf("%02d",$qm)/ge;		# 01-12
		# 日
		$format=~s/QZj/&h2z($qd)/ge;				# １〜３１
		$format=~s/QZJ/&h2z(sprintf("%02d",$qd))/ge;# ０１〜３１
		$format=~s/QKj/&itoa_ja($qd,1,0)/ge;		# 一〜二〜十
		$format=~s/QKJ/&itoa_ja($qd,0,0)/ge;		# 一〜二〜一〇〜
		$format=~s/Qj/$qd/ge;						# 1-12
		$format=~s/QJ/sprintf("%02d",$qd)/ge;		# 01-31
	}

	# 皇歴
	if($format=~m/(TY|Ty|TZY|TZy|TzY)/) {
		$nendo=$year+660;
		$format=~s/TzY/&itoa_ja($nendo,0,1)/ge;		# 二〇〇六
		$format=~s/TZY/&h2z($nendo)/ge;				# ２００６
		$format=~s/TZy/substr(&h2z($nendo),4,4)/ge;	# ０６
		$format=~s/TY/sprintf("%d",$nendo)/ge;		# 2006
		$format=~s/Ty/substr($nendo,2,2)/ge;		# 06
	}

	# 元号＋年度
	if($format=~m/N(\d{1,2})(SG|Sg|Sa|SY|Sy|GY|XY|Xy)/g) {
		my $tmp=$1;
		$nendo=$year-($mon < $tmp ? 1 : 0);
		my($_gango,$_gango2,$_gshort,$_gyear)=&get_gango($nendo,$1,1);
		$format=~s/N$tmp\SG/$_gango/ge;					# 平成
		$format=~s/N$tmp\Sg/$_gango2/ge;		# 平
		$format=~s/N$tmp\Sa/&h2z($_gshort)/ge;			# Ｈ
		$format=~s/N$tmp\GY/($_gyear eq 1 ? '元' : &h2z($_gyear))/ge;	# 元〜２
		$format=~s/N$tmp\XY/&itoa_ja($_gyear,1,1)/ge;	# 元〜二〜十
		$format=~s/N$tmp\Xy/&itoa_ja($_gyear,0,1)/ge;	# 元〜二〜一〇〜
		$format=~s/N$tmp\SY/sprintf("%d",$_gyear)/ge;	# 1-10-...
		$format=~s/N$tmp\Sy/sprintf("%02d",$_gyear)/ge;	# 01-10-...
	}
	# 元号
	if($format=~m/(SG|Sg|Sa|SY|Sy|GY|XY|Xy)/g) {
		my($_gango,$_gango2,$_gshort,$_gyear)=&get_gango($year,$mon,$mday);
		$format=~s/SG/$_gango/ge;						# 平成
		$format=~s/Sg/$_gango2/ge;						# 平
		$format=~s/Sa/&h2z($_gshort)/ge;				# Ｈ
		$format=~s/GY/($_gyear eq 1 ? '元' : &h2z($_gyear))/ge;	# 元〜２
		$format=~s/XY/&itoa_ja($_gyear,1,1)/ge;			# 元〜二〜十
		$format=~s/Xy/&itoa_ja($_gyear,0,1)/ge;			# 元〜二〜一〇〜
		$format=~s/SY/sprintf("%d",$_gyear)/ge;			# 1-10-...
		$format=~s/Sy/sprintf("%02d",$_gyear)/ge;		# 01-10-...
	}
	# 西暦年度
	if($format=~m/N(\d{1,2})(Y|y|ZY|Zy|KY)/g) {
		my $tmp=$1;
		$nendo=$year-($mon < $tmp ? 1 : 0);
		$format=~s/N$tmp\KY/&itoa_ja($nendo,0,1)/ge;	# 二〇〇六
		$format=~s/N$tmp\ZY/&h2z($nendo)/ge;			# ２００６
		$format=~s/N$tmp\Zy/substr(&h2z($nendo),4,4)/ge;# ０６
		$format=~s/N$tmp\Y/sprintf("%d",$nendo)/ge;		# 2006
		$format=~s/N$tmp\y/substr($nendo,2,2)/ge;		# 06
	}
	# 西暦
	$format=~s/KY/&itoa_ja($year,0,1)/ge;				# 二〇〇六
	$format=~s/ZY/&h2z($year)/ge;						# ２００６
	$format=~s/Zy/substr(&h2z($year),4,4)/ge;			# ０６

	# 月
	$format=~s/Zn/&h2z($mon)/ge;						# １〜１２
	$format=~s/Zm/&h2z(sprintf("%02d",$mon))/ge;		# ０１〜１２
	$format=~s/Kn/&itoa_ja($mon,1,0)/ge;				# 一〜二〜十
	$format=~s/Km/&itoa_ja($mon,0,0)/ge;				# 一〜二〜一〇〜
	$format=~s/kn/$QMONTH[$mon-1]/ge;					# 睦月

	# 日
	$format=~s/Zj/&h2z($mday)/ge;						# １〜３１
	$format=~s/ZJ/&h2z(sprintf("%02d",$mday))/ge;		# ０１〜３１
	$format=~s/Kj/&itoa_ja($mday,1,0)/ge;				# 一〜二〜十
	$format=~s/KJ/&itoa_ja($mday,0,0)/ge;				# 一〜二〜一〇〜

	# 時
	$format=~s/Zg/&h2z($hr12)/ge;						# １〜１２
	$format=~s/Zh/&h2z(sprintf("%02d",$hr12))/ge;		# ０１〜１２
	$format=~s/Kg/&itoa_ja($hr12,1,0)/ge;				# 一〜二〜十
	$format=~s/Kh/&itoa_ja($hr12,0,0)/ge;				# 一〜二〜一〇〜
	$format=~s/ZG/&h2z($hour)/ge;						# １〜１２
	$format=~s/ZH/&h2z(sprintf("%02d",$hour))/ge;		# ０１〜１２
	$format=~s/KG/&itoa_ja($hour,1,0)/ge;				# 一〜二〜十
	$format=~s/KH/&itoa_ja($hour,0,0)/ge;				# 一〜二〜一〇〜

	# 分
	$format=~s/Zk/&h2z($min)/ge;						# ０〜５９
	$format=~s/Zi/&h2z(sprintf("%02d",$min))/ge;		# ００〜５９
	$format=~s/Kk/&itoa_ja($min,1,0)/ge;				# 零〜十〜
	$format=~s/Ki/&itoa_ja($min,0,0)/ge;				# 〇〜一〇〜

	# 秒
	$format=~s/ZS/&h2z($sec)/ge;						# ０〜５９
	$format=~s/Zs/&h2z(sprintf("%02d",$sec))/ge;		# ００〜５９
	$format=~s/KS/&itoa_ja($sec,1,0)/ge;				# 零〜十〜
	$format=~s/Ks/&itoa_ja($sec,0,0)/ge;				# 〇〜一〇〜

	return $format;
}

sub ex_date2 {
	my($format,$sec,$min,$hour,$hr12,$mday,$mon,$year,$wday,$yday,$isdst)=@_;

	# 元号
	if($format=~m/\x11\x11/g) {
		$nendo=$year-($mon < $tmp ? 1 : 0);
		my($_gango,$_gango2,$_gshort,$_gyear)=&get_gango($year,$mon,$mday);
		$format=~s/\x11\x11/$_gshort/ge;				# H
	}
	# 祝日
	if($format=~/\x12[\x12\x13]/) {
		my $event;
		%::SYUKUJITSU=&get_event($year,"syukujitsu",@SYUKUJITSU) if($::SYUKUJITSU{$year} ne 1);
		$event=$::SYUKUJITSU{sprintf("%04d_%02d_%02d",$year,$mon,$mday)};
		$format=~s/\x12\x11/$event/ge;					# 元旦
		$event="($event)" if($event ne '');
		$format=~s/\x12\x12/$event/ge;					# (元旦)
	}
	# 行事
	if($format=~/\x12[\x13\x14]/) {
		my $event;
		%::GYOJI=&get_event($year,"gyoji",@GYOJI) if($::GYOJI{$year} ne 1);
		$event=$::GYOJI{sprintf("%04d_%02d_%02d",$year,$mon,$mday)};
		$format=~s/\x12\x13/$event/ge;					# 元旦
		$event="($event)" if($event ne '');
		$format=~s/\x12\x14/$event/ge;					# (元旦)
	}
	# 県民の行事
	if($format=~/\x12[\x15\x16]/) {
		my $event;
		%::PREF_GYOJI=&get_event($year,"pref_gyoji",@PREF_GYOJI) if($::PREF_GYOJI{$year} ne 1);
		$event=$::PREF_GYOJI{sprintf("%04d_%02d_%02d",$year,$mon,$mday)};
		$format=~s/\x12\x15/$event/ge;					# 元旦
		$event="($event)" if($event ne '');
		$format=~s/\x12\x16/$event/ge;					# (元旦)
	}
	# 星座
	if($format=~/\x12[\x17\x18]/) {
		my $event;
		%::SEIZA=&get_event($year,"seiza",@SEIZA) if($::SEIZA{$year} ne 1);
		$event=$::SEIZA{sprintf("%04d_%02d_%02d",$year,$mon,$mday)};
		$format=~s!\x12\x17!(split(/,/,$event))[0]!ge;	# おひつじ座
		$event="($event)" if($event ne '');
		$format=~s!\x12\x18!(split(/,/,$event))[1]!ge;	# 英語名
	}
	# 自分の行事
	if($format=~/\x12[\x19\x1a]/) {
		my $event;
		%::MY_GYOJI=&get_event($year,"my_gyoji",@EXDATE::MY_GYOJI) if($::MY_GYOJI{$year} ne 1);
		$event=$::MY_GYOJI{sprintf("%04d_%02d_%02d",$year,$mon,$mday)};
		$format=~s/\x12\x19/$event/ge;					# 元旦
		$event="($event)" if($event ne '');
		$format=~s/\x12\x1a/$event/ge;					# (元旦)
	}
	# 六曜・24節季・干支・宿
	if($format=~/\x13[\x13-\x18]/) {
		my $sekki=&get_24sekki($year,$mon,$mday);
		$format=~s/\x13\x13/$sekki/ge;						# 立夏
		$sekki="($sekki)" if($sekki ne '');
		$format=~s/\x13\x14/$sekki/ge;						# (立夏)
		$format=~s/\x13\x15/&get_rokuyou($year,$mon,$mday)/ge;# 六曜
		$format=~s/\x13\x16/&get_kanshi_year($year,$mon,$mday)/ge;#年の干支
		$format=~s/\x13\x17/&get_kanshi_day($year,$mon,$mday)/ge;#日の干支
		$format=~s/\x13\x18/&get_syuku($year,$mon,$mday)/ge;	#日の宿
	}
	return $format;
}

#
# 以下オーバーライドする関数
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
	# gmtime & インターネット時間
	if($format=~/[OZB]/) {
		my $gmt = ((localtime(time))[2] + (localtime(time))[3] * 24)
				- ((gmtime(time))[2] + (gmtime(time))[3] * 24);
		$format =~ s/O/sprintf("%+03d:00", $gmt)/ge;	# GMT Time
		$format =~ s/Z/sprintf("%d", $gmt*3600)/ge;		# GMT Time secs...
		my $swatch=(($tm-$gmt+90000)/86400*1000)%1000;	# GMT +1:00にして、１日を1000beatにする
														# 日本時間の場合、AM08:00=000
		$format =~ s/B/sprintf("%03d", int($swatch))/ge;# internet time
	}

	# UNIX time
	$format=~s/U/sprintf("%u",$tm)/ge;	# unix time

	$format=~s/lL/\x2\x13/g;	# lL:escape 日-土
	$format=~s/DL/\x2\x14/g;	# DL:escape 日曜日-土曜日
	$format=~s/l/\x2\x11/g;		# l:escape Sunday-Saturday
	$format=~s/D/\x2\x12/g;		# D:escape Sun-Sat
	$format=~s/aL/\x1\x13/g;	# aL:escape 午前 or 午後
	$format=~s/AL/\x1\x14/g;	# AL:escape ↑の大文字
	$format=~s/a/\x1\x11/g;		# a:escape am pm
	$format=~s/A/\x1\x12/g;		# A:escape AM PM
	$format=~s/M/\x3\x11/g;		# M:escape Jan-Dec
	$format=~s/F/\x3\x12/g;		# F:escape January-December

	# うるう年、この月の日数
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
	$format =~ s/\x1\x13/$ampm{$::lang}/ge;		# A:午前 or 午後	# comment
	$format =~ s/\x1\x14/uc $ampm{$::lang}/ge;	# ↑の大文字		# comment

	$format =~ s/\x2\x11/$weekday{en}/ge;		# l(lower L):Sunday-Saturday	# comment
	$format =~ s/\x2\x12/$weekday{en_short}/ge;	# D:Mon-Sun	# comment
	$format =~ s/\x2\x13/$weekday{"$::lang" . "_short"}/ge;	# D:Mon-Sun	# comment
	$format =~ s/\x2\x14/$weekday{$::lang}/ge;

	$format =~ s/\x3\x11/substr($month,0,3)/ge;	# M:Jan-Dec
	$format =~ s/\x3\x12/$month/g;				# F:January-December

	# v0.1.6で実装
	# O グリニッジ標準時(GMT)との時間差 Example: +0200
	# r RFC 822 フォーマットされた日付 例: Thu, 21 Dec 2000 16:01:07 +0200
	# Z タイムゾーンのオフセット秒数。 -43200 から 43200
	# L 閏年であるかどうかを表す論理値。 1なら閏年。0なら閏年ではない。
	# lL:現在のロケールの言語での曜日（短）
	# DL:現在のロケールの言語での曜日（長）
	# aL:現在のロケールの言語での午前午後（大文字）
	# AL:現在のロケールの言語での午前午後（小文字）
	# L 閏年であるかどうかを表す論理値。 1なら閏年。0なら閏年ではない。
	# t 指定した月の日数。 28 から 31
	# B Swatch インターネット時間 000 から 999
	# U Unix 時(1970年1月1日0時0分0秒)からの秒数 See also time()

	# Not Allowed
	# W ISO-8601 月曜日に始まる年単位の週番号 (PHP 4.1.0で追加) 例: 42 (１年の第42週目)
	# S 英語形式の序数を表すサフィックス。2 文字。 st, nd, rd or th. Works well with j
	# T このマシーンのタイムゾーンの設定。 Examples: EST, MDT ...
	$format =~ s/z/$yday/ge;	# z:days/year 0-366

	$format=&ex_date2($format,$sec,$min,$hour,$hr12,$mday,$mon,$year,$wday,$yday,$isdst);
	return $format;
}
1;
__DATA__
sub plugin_exdate_setup {
	return(
	'ja'=>'日付表示を拡張する',
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
