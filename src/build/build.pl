#!/usr/bin/perl
# release file perl script for pyukiwiki
# $Id$

$|=1;

use Jcode;

$CHARSET="euc" if($CHARSET eq '');

$FIRSTBUILD=0;
$FIRSTBUILD=1;		#notbuild

require 'build/text.pl';

$MODE=$ARGV[0];

if($MODE eq "mk") {
	$TEMP=$ARGV[1];
	$OUTPUT=$ARGV[2];
	$MAKEFILE=$ARGV[3];
	$TYPE=$ARGV[4];
	$CRLF=$ARGV[5];
	$CODE=$ARGV[6];
	$ALLFLG=$ARGV[7];
}

if($MODE eq "cp") {
	$TEMP=$ARGV[1];
	$CHMOD=$ARGV[2];
	$OLD=$ARGV[3];
	$NEW=$ARGV[4];
	$TYPE=$ARGV[5];
	$CRLF=$ARGV[6];
	$CHARSET=$ARGV[7];
	$ALLFLG=$ARGV[8];

	open(R,"lib/wiki.cgi");
	foreach(<R>) {
		if(/^\$\:\:version/) {
			eval  $_ ;
		}
	}
	close(R);

}

$releasepatch="./releasepatch";

$binary_files='(\.(jpg|png|gif|dat|key|zip|sfx|swf|ico|gz)$)|(^unicode\.pl|favicon\.ico$|\.wiki$)';

$cvs_ignore='^3A|\.sum$|\.sign$|^cold|^line|^sfdev|74657374|setup.ini.cgi|\.bak$|\.lk$';
$all_ignore='^magic\.head$|\.sum$|\.sign$|setup.ini.cgi|\.BAK$|\.bak$|\.lk$|^kanato|pyukiwiki\.admin|blog|oneclickdiary';
$common_ignore=$all_ignore . '|^qrcode|^cold|^line|^Google|^sitemaps\.|^xrea|^unicode\.pl|^3A|74657374|^counter2|^sh\.|^popular2|^bookmark|^clipcopy|^exdate|^ad\.|^ad\_edit|^v\.cgi|^playvideo|^powerusage|setup.ini.cgi|flowplayer|video-js.css.org|video-js.css|video.js|video.js.src|videoresize.js|videoresize.js.src|video-js.swf|video-js.png|videoresize.js|videoresize.js.src|^head\.inc|^html\.inc|^sh\.inc|^v\_css\.css|video|^smedia\.en|^smedia\.ja|^smedia\.unicode|^smedia\.sjis|^smedia\.utf8|tube|UserAgent';
$release_ignore=$common_ignore . '|^img.*\.css\.org$|^debug|\.pod$|magic_compact\.txt|\.zip|\.src$|\.inc\.js|^v\_css\.css|video|^common\.ja\.js$|^common\.sjis\.ja\.js$|^common\.utf8\.ja\.js$|^smedia\.ja\.js$|^smedia\.sjis\.ja\.js$|^smedia\.utf8\.ja\.js$|^wiki-compact|^wiki-devel';
$release_ignore=$release_ignore . "|tdiary";	# まだ開発版のみにする
$update_ignore=$common_ignore . '|\.pod$|magic_compact\.txt|\.zip$|\.src$|htaccess|htpasswd|\.inc\.js|^v\_css\.css|video|stdin';
$release_ignore.="|specification.html|specification.txt|specification_wikicgi.html|specification_wikicgi.txt|DEVEL.html|DEVEL.ja.txt";

$compact_ignore='|^img.*\.css\.org$|\.css\.gz$|\.js\.gz$|^login|^sitemaps|^Sitemaps|^ogp|^canonical|^google|^stdin|GDBM\.pm$|^img\-login|^img\-lang|^IndexSearch\.pm$|^Kana\.pm$|^Login\.pm$|^Logs\.pm$|^NetIP\.pm$|^OAuth\.pm$|^OpenID\.pm$|^OPML\.pm$|^SQLite\.pm$|^UserAgent\.pm$|^common\.ja\.js$|^common\.sjis\.ja\.js$|^common\.utf8\.ja\.js$|^agent|^aguse|^xframe|^google\_analytics|^linktrack|^ck.inc.pl|^ipv6check|^backup|^pcomment|^back|^hr|^navi|^setlinebreak|^yetlist|^slashpage|^qrcode|^lang\.|^topicpath|^pathmenu|^setting|^debug|^Jcode|^Jcode\.pm|magic\.txt|\.en\.(js|css|cgi|txt)|^bugtrack|^(fr|no).*\.inc\.pl|^servererror|^server|^sitemap|^showrss|^perlpod|^Pod|^versionlist|^listfrozen|^urlhack|^punyurl|^opml|^HTTP|^Lite\.pm|^OPML|^atom|^ATOM|^search\_fuzzy|^Search\.pm$|^login|^popup|^pcomment|^bugtrack|^captcha|^sbookmark|^multi|^smedia|^ck|^rss10page|^rsspage|^backup|^sitemaps|^tb|^links|^skin|^opml|^head|^html|^stdin|^star|^blog|^showrss|^ipv6check|^twitter|\.en\.txt$|GZIP|compressbackup|^logs|^smedia|^GZIP|\.inc\.js|^v\_css\.css|video|jquery\.js|jquery-1\.js|jquery-2\.js|marker.png|mask.png|wheel.png|twitstat.js|mikachan|multi|font|pagenavi|sbookmark|source|google_translate|canonical|links';
$compact_ignore.='\.css\.gz|\.js\.gz|^lang\_|^hinad|^lirs|^copy|^ping|^tb|^trackback|^captcha';
$releasec_ignore=$common_ignore . $compact_ignore . '|^debug\.inc\.pl|\.pod$|magic\.txt|\.zip|\.src$|^wiki-full|^wiki-develimg-icon|icon.png';
$updatec_ignore=$common_ignore . $compact_ignore. '|^debug\.inc\.pl|\.pod$|magic\.txt|\.zip$|\.src$|htaccess|htpasswd';
#$compact_filter="./build/obfuscator.pl";

$updated_ignore=$common_ignore . '|\.zip$' . '|htaccess|htpasswd';

$ignore_crlfcut='README.ja.txt|DEVEL.ja.txt|COPYRIGHT.txt|COPYRIGHT.ja.txt|\.htaccess|.htpasswd|pyukiwiki.ini.cgi|wiki\/(.+)?\.txt$';
$ignore_codecheck="build.pl";

@release_dirs=(
	"attach:nodata:0777:0644",
	"backup:nodata:0777:0644",
	"cache:nodata:0777:0644",
	"counter:nodata:0777:0644",
	"diff:nodata:0777:0644",
	"document::0755:0644",
	"info::0777:666",
	"wiki::0777:0666",
	"image::0755:0644",
#	"image/face::0755:0644",
	"lib::0755:0644",
	"lib/Algorithm::0755:0644",
	"lib/File::0755:0644",
	"lib/HTTP::0755:0644",
	"lib/Jcode::0755:0644",
	"lib/Jcode/Unicode::0755:0644",
	"lib/AWS::0755:0644",
	"lib/Nana::0755:0644",
	"lib/Time::0755:0644",
	"lib/Yuki::0755:0644",
	"lib/Digest::0755:0644",
	"lib/Digest/Perl::0755:0644",
	"lib/IDNA::0755:0644",
	"plugin::0755:0644",
	"resource::0755:0644",
	"sample::0755:0644",
	"skin::0755:0644",
	"skin/jquery::0755:0644",
);

@releasec_dirs=(
	"attach:nodata:0777:0644",
	"cache:nodata:0777:0644",
	"counter:nodata:0777:0644",
	"diff:nodata:0777:0644",
	"document::0755:0644",
	"info::0777:666",
	"wiki::0777:0666",
	"image::0755:0644",
#	"image/face::0755:0644",
	"lib::0755:0644",
	"lib/Algorithm::0755:0644",
	"lib/File::0755:0644",
	"lib/Nana::0755:0644",
	"lib/Time::0755:0644",
	"lib/Yuki::0755:0644",
	"plugin::0755:0644",
	"resource::0755:0644",
	"sample::0755:0644",
	"skin::0755:0644".
	"skin/jquery::0755:0644",
);

@update_dirs=(
	"attach:nodata:0777:0644",
	"backup:nodata:0777:0644",
	"cache:nodata:0777:0644",
	"counter:nodata:0777:0644",
	"diff:nodata:0777:0644",
	"document::0755:0644",
	"info:nodata:0777:666",
	"wiki:nodata:0777:0666",
	"image::0755:0644",
#	"image/face::0755:0644",
	"lib::0755:0644",
	"lib/Algorithm::0755:0644",
	"lib/File::0755:0644",
	"lib/HTTP::0755:0644",
	"lib/Jcode::0755:0644",
	"lib/Jcode/Unicode::0755:0644",
	"lib/AWS::0755:0644",
	"lib/Nana::0755:0644",
	"lib/Time::0755:0644",
	"lib/Yuki::0755:0644",
	"lib/Digest::0755:0644",
	"lib/Digest/Perl::0755:0644",
	"lib/IDNA::0755:0644",
	"plugin::0755:0644",
	"resource::0755:0644",
	"sample::0755:0644",
	"skin::0755:0644",
	"skin/jquery::0755:0644",
);

@updatec_dirs=(
	"attach:nodata:0777:0644",
	"backup:nodata:0777:0644",
	"cache:nodata:0777:0644",
	"counter:nodata:0777:0644",
	"diff:nodata:0777:0644",
	"document::0755:0644",
	"info:nodata:0777:666",
	"wiki:nodata:0777:0666",
	"image::0755:0644",
#	"image/face::0755:0644",
	"lib::0755:0644",
	"lib/Algorithm::0755:0644",
	"lib/File::0755:0644",
	"lib/Nana::0755:0644",
	"lib/Time::0755:0644",
	"lib/Yuki::0755:0644",
	"plugin::0755:0644",
	"resource::0755:0644",
	"sample::0755:0644",
	"skin::0755:0644",
	"skin/jquery::0755:0644",
);

@devel_dirs=(
	"attach:nodata:0777:0644",
	"backup:nodata:0777:0644",
	"build::0755:0644",
	"cache:nodata:0777:0644",
	"counter:nodata:0777:0644",
	"doc::0755:0644",
	"document::0755:0644",
	"diff:nodata:0777:0644",
	"info::0777:666",
	"wiki::0777:0666",
	"image::0755:0644",
	"image/src::0755:0644",
	"image/src/_icon::0755:0644",
	"image/src/_lang::0755:0644",
	"image/src/_login::0755:0644",
	"image/src/exedit::0755:0644",
	"image/src/face::0755:0644",
	"image/src/lang::0755:0644",
	"image/src/login16::0755:0644",
	"image/src/login32::0755:0644",
	"image/src/navi::0755:0644",
	"image/src/org::0755:0644",
	"image/src/icon::0755:0644",
	"lib::0755:0644",
	"lib/Algorithm::0755:0644",
	"lib/File::0755:0644",
	"lib/HTTP::0755:0644",
	"lib/Jcode::0755:0644",
	"lib/Jcode/Unicode::0755:0644",
	"lib/AWS::0755:0644",
	"lib/Nana::0755:0644",
	"lib/Time::0755:0644",
	"lib/Yuki::0755:0644",
	"lib/IDNA::0755:0644",
	"lib/Digest::0755:0644",
	"lib/Digest/Perl::0755:0644",
	"plugin::0755:0644",
	"resource::0755:0644",
	"sample::0755:0644",
	"skin::0755:0644",
	"skin/jquery::0755:0644",
	"src::0755:0644",
	"src::0755:0644",
	"src/wiki::0755:0644",
	"src/NanaXS-func::0755:0644",
	"src/NanaXS-func/t::0755:0644",
	"src/xslib::0755:0644",
	"src/xsmake::0755:0644",
#	"releasepatch::0755:0644",
#	"releasepatch/attach:nodata:0777:0644",
#	"releasepatch/build::0755:0644",
#	"releasepatch/cache:nodata:0777:0644",
#	"releasepatch/counter:nodata:0777:0644",
#	"releasepatch/diff:nodata:0777:0644",
#	"releasepatch/info::0777:666",
#	"releasepatch/wiki::0777:0666",
#	"releasepatch/image::0755:0644",
#	"releasepatch/image/face::0755:0644",
#	"releasepatch/lib::0755:0644",
#	"releasepatch/lib/Algorithm::0755:0644",
#	"releasepatch/lib/Jcode::0755:0644",
#	"releasepatch/lib/Jcode/Unicode::0755:0644",
#	"releasepatch/lib/Nana::0755:0644",
#	"releasepatch/lib/Yuki::0755:0644",
#	"releasepatch/lib/Digest::0755:0644",
#	"releasepatch/plugin::0755:0644",
#	"releasepatch/resource::0755:0644",
#	"releasepatch/sample::0755:0644",
#	"releasepatch/skin::0755:0644"
);

@updated_dirs=(
	"attach:nodata:0777:0644",
	"backup:nodata:0777:0644",
	"cache:nodata:0777:0644",
	"counter:nodata:0777:0644",
	"doc::0755:0644",
	"document::0755:0644",
	"diff:nodata:0777:0644",
	"info:nodata:0777:666",
	"wiki:nodata:0777:0666",
	"image::0755:0644",
	"image/src::0755:0644",
	"image/src/_lang::0755:0644",
	"image/src/_login::0755:0644",
	"image/src/exedit::0755:0644",
	"image/src/face::0755:0644",
	"image/src/lang::0755:0644",
	"image/src/login16::0755:0644",
	"image/src/login32::0755:0644",
	"image/src/navi::0755:0644",
	"image/src/org::0755:0644",
	"lib::0755:0644",
	"lib/Algorithm::0755:0644",
	"lib/File::0755:0644",
	"lib/HTTP::0755:0644",
	"lib/Jcode::0755:0644",
	"lib/Jcode/Unicode::0755:0644",
	"lib/AWS::0755:0644",
	"lib/Nana::0755:0644",
	"lib/Time::0755:0644",
	"lib/Yuki::0755:0644",
	"lib/IDNA::0755:0644",
	"lib/Digest::0755:0644",
	"lib/Digest/Perl::0755:0644",
	"plugin::0755:0644",
	"resource::0755:0644",
	"sample::0755:0644",
	"skin::0755:0644",
	"skin/jquery::0755:0644",
	"src::0755:0644",
	"src::0755:0644",
	"src/wiki::0755:0644",
	"src/NanaXS-func::0755:0644",
	"src/NanaXS-func/t::0755:0644",
	"src/xslib::0755:0644",
	"src/xsmake::0755:0644",
#	"releasepatch::0755:0644",
#	"releasepatch/attach:nodata:0777:0644",
#	"releasepatch/build::0755:0644",
#	"releasepatch/cache:nodata:0777:0644",
#	"releasepatch/counter:nodata:0777:0644",
#	"releasepatch/diff:nodata:0777:0644",
#	"releasepatch/info::0777:666",
#	"releasepatch/wiki::0777:0666",
#	"releasepatch/image::0755:0644",
#	"releasepatch/image/face::0755:0644",
#	"releasepatch/lib::0755:0644",
#	"releasepatch/lib/Algorithm::0755:0644",
#	"releasepatch/lib/Jcode::0755:0644",
#	"releasepatch/lib/Jcode/Unicode::0755:0644",
#	"releasepatch/lib/Nana::0755:0644",
#	"releasepatch/lib/Yuki::0755:0644",
#	"releasepatch/lib/Digest::0755:0644",
#	"releasepatch/plugin::0755:0644",
#	"releasepatch/resource::0755:0644",
#	"releasepatch/sample::0755:0644",
#	"releasepatch/skin::0755:0644"
);

if($ALLFLG eq 'all') {
	$devel_ignore=$all_ignore . '|\.zip$';
	push(@devel_dirs,"skin/syntaxhighlighter::0755:0644");
	push(@updated_dirs,"skin/syntaxhighlighter::0755:0644");
	push(@devel_dirs,"skin/player::0755:0644");
	push(@updated_dirs,"skin/player::0755:0644");
} else {
	$devel_ignore=$common_ignore . '|\.zip$';
}

@cvs_dirs=@devel_dirs;

@release_files=(
	".htaccess:0644",
	".htpasswd:0644",
	"COPYRIGHT.ja.txt:0644",
	"COPYRIGHT.txt:0644",
	"index.cgi:0755",
	"pyukiwiki.ini.cgi:0644",
	"ngwords.ini.cgi:0644",
	"favicon.ico:0644",
	"robots.txt:0644",
	"README.ja.txt:0644",
	"README.ja.html:0644",
);

@releasec_files=(
	".htaccess:0644",
	".htpasswd:0644",
	"COPYRIGHT.ja.txt:0644",
	"COPYRIGHT.txt:0644",
	"index.cgi:0755",
	"pyukiwiki.ini.cgi:0644",
	"ngwords.ini.cgi:0644",
	"favicon.ico:0644",
	"robots.txt:0644",
	"README.ja.txt:0644",
	"README.ja.html:0644",
);

@update_files=(
	"COPYRIGHT.ja.txt:0644",
	"COPYRIGHT.txt:0644",
	"index.cgi:0755",
	"pyukiwiki.ini.cgi:0644",
	"ngwords.ini.cgi:0644",
	"README.ja.txt:0644",
	"README.ja.html:0644",
);

@updatec_files=(
	"COPYRIGHT.ja.txt:0644",
	"COPYRIGHT.txt:0644",
	"index.cgi:0755",
	"pyukiwiki.ini.cgi:0644",
	"ngwords.ini.cgi:0644",
	"README.ja.txt:0644",
	"README.ja.html:0644",
);

@devel_files=(
	".htaccess:0644",
	".htpasswd:0644",
	"COPYRIGHT.ja.txt:0644",
	"COPYRIGHT.txt:0644",
	"index.cgi:0755",
	"pyukiwiki.ini.cgi:0644",
	"ngwords.ini.cgi:0644",
	"favicon.ico:0644",
	"robots.txt:0644",
	"Makefile:0644",
	"README.ja.txt:0644",
	"README.ja.html:0644",
	"DEVEL.ja.txt:0644",
#	"v.cgi:0755",	# for mente
);

@develc_files=(
#	".htaccess:0644",
	"COPYRIGHT.ja.txt:0644",
	"COPYRIGHT.txt:0644",
	"index.cgi:0755",
	"pyukiwiki.ini.cgi:0644",
	"ngwords.ini.cgi:0644",
	"favicon.ico:0644",
	"robots.txt:0644",
	"Makefile:0644",
	"README.ja.txt:0644",
	"README.ja.html:0644",
	"DEVEL.ja.txt:0644",
#	"v.cgi:0755",	# for mente
);

@cvs_files=@devel_files;

if($TYPE eq 'release') {
	@dirs=@release_dirs;
	@files=@release_files;
	$ignore=$release_ignore;
	$checktimestamp=0;
	$debug=0;
	$podcut=1;
	$commentcut=1;
	$touchonly=0;
}elsif($TYPE eq 'compact') {
	@dirs=@releasec_dirs;
	@files=@releasec_files;
	$ignore=$releasec_ignore;
	$checktimestamp=0;
	$debug=0;
	$podcut=1;
	$commentcut=1;
	$touchonly=0;
} elsif($TYPE eq 'update') {
	@dirs=@update_dirs;
	@files=@update_files;
	$ignore=$update_ignore;
	$checktimestamp=0;
	$debug=0;
	$podcut=1;
	$commentcut=1;
	$touchonly=0;
} elsif($TYPE eq 'updatecompact') {
	@dirs=@updatec_dirs;
	@files=@updatec_files;
	$ignore=$updatec_ignore;
	$checktimestamp=0;
	$debug=0;
	$podcut=1;
	$commentcut=1;
	$touchonly=0;
} elsif($TYPE eq 'devel') {
	@dirs=@devel_dirs;
	@files=@devel_files;
	$ignore=$devel_ignore;
	$checktimestamp=0;
	$debug=1;
	$podcut=0;
	$commentcut=0;
	$touchonly=0;
} elsif($TYPE eq 'updatedevel') {
	@dirs=@updated_dirs;
	@files=@develc_files;
	$ignore=$devel_ignore;
	$checktimestamp=0;
	$debug=1;
	$podcut=0;
	$commentcut=0;
	$touchonly=0;
} elsif($TYPE eq 'cvs') {
	@dirs=@cvs_dirs;
	@files=@cvs_files;
	$ignore=$cvs_ignore;
	$checktimestamp=1;
	$debug=1;
	$podcut=0;
	$commentcut=0;
	$touchonly=0;
} elsif($TYPE eq 'touch') {
	@dirs=@devel_dirs;
	@files=@devel_files;
	$ignore=$devel_ignore;
	$touchonly=1;
	$podcut=0;
	$commentcut=0;
	$debug=0;
#} else {
#	print STDERR "$0:Type not defined\n";
#	exit 1;
}

if($MODE eq "mk") {
	open(R,"lib/wiki.cgi");
	foreach(<R>) {
		if(/^\$\:\:version/) {
			eval  $_ ;
		}
	}
	close(R);

	foreach my $i (0x00 .. 0xFF) {
		$::_urlescape{chr($i)} = sprintf('%%%02x', $i);
		$::_dbmname_encode{chr($i)} = sprintf('%02X', $i);
		$::_dbmname_decode{sprintf('%02X', $i)} = chr($i);
	}
	&makemakefile($TEMP, $OUTPUT, $MAKEFILE, $TYPE, $CRLF, $CODE, $ALLFLG);
}

if($MODE eq "cp") {
	foreach my $i (0x00 .. 0xFF) {
		$::_urlescape{chr($i)} = sprintf('%%%02x', $i);
		$::_dbmname_encode{chr($i)} = sprintf('%02X', $i);
		$::_dbmname_decode{sprintf('%02X', $i)} = chr($i);
	}
	&copyascii($CHMOD, $OLD, $NEW, $TYPE, $CRLF, $CHARSET, $ALLFLG);
	exit(0);
}


sub makemakefile {
	my ($TEMP, $OUTPUT, $MAKEFILE, $TYPE, $CRLF, $CODE, $ALLFLG)=@_;
	my $cr="n";
	my $spc="          ";

	my $files=0;
	foreach(@dirs) {
		my ($dir,$_mode,$dir_chmod,$file_chmod)=split(/:/,$_);

		$makefiledir{$dir}=<<EOM;
	\@mkdir -p $OUTPUT/$dir 2>/dev/null
	\@chmod $dir_chmod $OUTPUT/$dir 2>/dev/null
EOM
		opendir(DIR, $dir)||die;
		@ff = grep { !m/^(\.|\.\.|CVS)$/g } readdir(DIR);
		foreach $file(@ff) {
			if(! (-d "$dir/$file")) {
				$newfile=$file;
				if($_mode eq 'nodata') {
					next if(!($file eq 'index.html' || $file eq '.htaccess'));
				}

				next if($file=~/$ignore/);

				if($dir=~/wiki/ && $file=~/\.txt$/ && $CODE eq 'utf8') {
					if($file=~/(.+)?\.txt$/) {
						$dbm=~s/\.txt//g;
						$dbm=&undbmname($file);
						$dbm=~s/\.txt//g;
						&Jcode::convert($dbm, "utf8");
						$dbm=&dbmname($dbm);
						$newfile="$dbm.txt";
					} else {
						$newfile=$file;
					}
				} else {
					$newfile=$file;
				}

				if($file=~/$binary_files/) {
					$makefilefile{"$dir/$newfile"}=<<EOM;
$OUTPUT/$dir/$newfile : $dir/$file
	\@perl -e \'print \"Copy  \" . substr(\"$dir/$file -> $newfile\",0,70) . \"$spc\\$cr\";\'
$makefiledir{$dir}
	\@cp $dir/$file $OUTPUT/$dir/$newfile
	\@chmod $file_chmod $OUTPUT/$dir/$newfile 2>/dev/null

EOM

					$binfiles++;
					$files++;
				} else {
					if($file=~/\.inc\.cgi$/) {
						$file2=$file;
						$file2=~s/cgi$/pl/g;
					} else {
						$file2=$file;
					}
					$makefilefile{"$dir/$newfile"}=<<EOM;
$OUTPUT/$dir/$newfile: $dir/$file
	\@perl -e \'print \"Build \" . substr(\"$dir/$file -> $newfile\",0,70) . \"$spc\\$cr\";\'
$makefiledir{$dir}
	\@perl build/build.pl cp "$TEMP" "$file_chmod" "$dir/$file" "$OUTPUT/$dir/$newfile" "$TYPE" "$CRLF" "$CODE" "$ALLFLG" >/dev/null

EOM
					$asciifiles++;
					$files++;
				}
			}
			closedir(DIR);
		}
		foreach (@files) {
			($file,$file_chmod)=split(/:/,$_);
			$newfile=$file;
				if($file=~/$binary_files/) {
					$makefilefile{"$newfile"}=<<EOM;
$OUTPUT/$newfile: $file
	\@perl -e \'print \"Copy  \" . substr(\"$file -> $newfile\",0,70) . \"$spc\\$cr\";\'
$makefiledir{$dir}
	\@cp $file $OUTPUT/$newfile
	\@chmod $file_chmod $OUTPUT/$newfile 2>/dev/null

EOM
					$binfiles++;
					$files++;
				} else {
					$makefilefile{"$newfile"}=<<EOM;
$OUTPUT/$newfile: $file
	\@perl -e \'print \"Build \". substr(\"$file -> $newfile\",0,70) . \"$spc\\$cr\";\'
	\@perl build/build.pl cp "$TEMP" "$file_chmod" "$file" "$OUTPUT/$newfile" "$TYPE" "$CRLF" "$CODE" "$ALLFLG" >/dev/null

EOM
				$asciifiles++;
				$files++;
				}
		}
	}

	open(W,">$MAKEFILE");
	print W <<EOM;
#
# PyukiWiki build makefile for $::version
#
EOM

	@f=();
	foreach (keys %makefilefile) {
		push(@f, $_);
	}
	@f=sort @f;
	$count=$#f;
	print W "MAX=$count\nCOUNT=0\nFILES= \\\n";
	foreach(@f) {
		print W "\t$OUTPUT/$_ \\\n";
	}
	if($TYPE eq "compact") {
#		print W <<EOM;
#	./resource/wiki-compact.en.txt.gz \\
#	./resource/wiki-compact.ja.txt.gz \\
#EOM
	} elsif($TYPE eq "release") {
#		print W <<EOM;
#	./resource/wiki-full.en.txt.gz \\
#	./resource/wiki-full.ja.txt.gz \\
#EOM
	}
	if($TYPE=~/^d/) {
		print W <<EOM;
	./temp/installer.css
EOM
	}

	print W "\n\nall:\${FILES}\n\n";

	foreach(@f) {
		print W $makefilefile{$_};
	}

	print W "\n\n";

	if($TYPE=~/^d/) {
		print W <<EOM;
./temp/installer.css: ./build/installer.css
	mkdir -p \${TEMP}
	perl build/compressfile.pl css ./temp/installer.css ./build/installer.css

EOM
	}
	print W "\n\n";
	close(W);
}

##############################3
sub copyfile {
	my($temp,$filemode)=@_;
	my $files=0;
	foreach(@dirs) {
		($dir,$_mode,$dir_chmod,$file_chmod)=split(/:/,$_);
		&mkdir("$temp/$dir",$dir_chmod);
		opendir(DIR,"$dir");
		while($file=readdir(DIR)) {
			next if($file=~/CVS/);
			if(! (-d "$dir/$file")) {
				if($_mode eq 'nodata') {
					next if(!($file eq 'index.html' || $file eq '.htaccess'));
				}
				next if($file=~/$ignore/);
				if($file=~/$binary_files/) {
					&copybin($file_chmod,"$dir/$file","$temp/$dir/$file");
					$files++;
					$binfiles++;
				}else{
					if($file=~/\.inc\.cgi$/) {
						$file2=$file;
						$file2=~s/cgi$/pl/g;
					} else {
						$file2=$file;
					}
					&copyascii($file_chmod,"$dir/$file","$temp/$dir/$file2",$filemode);
					$files++;
					$asciifiles++;
				}
				print STDERR "\r => $files files";
#				print STDERR "\r => $files files ($file)";
			}
		}
		closedir(DIR);
	}
	foreach(@files) {
		($file,$file_chmod)=split(/:/,$_);
		&copyascii($file_chmod,$file,"$temp/$file",$filemode);
		$files++;
		$asciifiles++;
#			print STDERR "\r => $files files ($file)";
			print STDERR "\r => $files files";
	}
	print STDERR "\r => $files files - OK                            \n";
}


sub shell {
	my($shell)=@_;
#	print STDERR "$shell\n";
	open(PIPE,"$shell 2>/dev/null|");
	foreach(<PIPE>) {
#		print STDERR "$_\n";
#		chomp;
	}
	close(PIPE);
}

sub copyascii {
	my($chmod,$old,$new,$filemode)=@_;
	my $path;
	my $dbm;
	if($touchonly eq 1) {
		&shell("touch $old");
		return;
	}

	return if((stat($old))[9]<(stat($new))[9] && $checktimestamp eq 1);

	print "copy $old $new($chmod ascii)\n";
	&textinit($old,$::version,$filemode,$TYPE,$CHARSET);
	if(-r "$releasepatch/$old") {
		$oldfile="$releasepatch/$old";
	} else {
		$oldfile="$old";
	}

	my $buf;
	$utf8temp="";
	if($CHARSET eq 'utf8') {
		$utf8temp=&mktemp("$oldfile.utf8.tmp");
#		&shell("nkf -W <$oldfile >$utf8temp");
		&convertutf8("$oldfile", $utf8temp);
		open(R,"$oldfile");
		$buf="";
		foreach(<R>) {
			$buf.=$_;
		}
		close(R);
		open(W,">$utf8temp");
		&Jcode::convert($buf, "utf8");
		print W $buf;
		close(W);
		$oldfile=$utf8temp;
	}
	undef $buf;
	open(R,"$oldfile")||die("Read $oldfile ($utf8tmp) $CHARSET");
	open(W,">$new");
	my $cut=0;
	$buf="";
	foreach(<R>) {
		chomp;
		if($oldfile=~/build.mk$/) {
			next if(/bookmark.js/);
			next if(/video/);
			next if(/flowplayer/);
			next if(/tube/);
			next if(/ad\.css/);
			next if(/syntaxhighlighter/);
			next if(/DEVEL/);
			next if(/specification/);
		}
		if(/\x23 all/ && /\x23 devel/) {
			if($TYPE eq "all" || $TYPE eq "devel") {
				s/([\s\t])?\x23 all//g;
				s/([\s\t])?\x23 devel//g;
			} else {
				next;
			}
		}
		if(/\x23 devel/) {
			if($TYPE eq "devel") {
				s/([\s\t])?\x23 devel//g;
			} else {
				next;
			}
		}

		if(/\x23 all/) {
			if($TYPE eq "all") {
				s/([\s\t])?\x23 all//g;
			} else {
				next;
			}
		}
		if(/\x23 devel/) {
			if($TYPE eq "devel") {
				s/([\s\t])?\x23 devel//g;
			} else {
				next;
			}
		}
		if($old!~/$ignore_codecheck/) {
			if(/\=encoding euc-jp/ && $CHARSET eq 'utf8') {
				$_ = '=encoding utf-8';
			}
			if(/\x23\s?euc/) {
				if($CHARSET ne 'euc') {
					$_="";
					next;
				}
				s/([\s\t])?\x23\s?euc//g;
			} elsif(/\#\s?utf8/) {
				if($CHARSET ne 'utf8') {
					$_="";
					next;
				}
				s/([\s\t])?\x23\s?utf8//g;
			}
		}
		next if((/\x23euc/) || (/\x23utf8/));
		$flg=0;
		# for sorceforge url
		s/L\<\@\@CVSURL\@\@(.*)\>/L\<\@\@CVSURL\@\@$1\?view\=log\>/g;

		# for yuicompress direct source
		if(/\@\@yuicompressor\_(.+)\=\"(.+)\"\@\@/) {
			my $mode=$1;
			my $compressfile=$2;
			$fixed=$oldfile;
			$fixed=~s/\//-/g;
			$cmpfile=&mktemp("$new-$compressfile");
			&shell("perl ./build/compressfile.pl $mode $cmpfile $compressfile nohead");
			open(YUI,"$cmpfile") || die("$cmpfile ($oldfile) err");
			my $yui="";
			foreach $y(<YUI>) {
				$yui.=$y;
			}
			close(YUI);
#			unlink("$cmpfile");
			s/\@\@yuicompressor\_(.+)\=\"(.+)\"\@\@/$yui/;
		}

		# direct include
		if(/\@\@include\=\"(.+)\"\@\@/) {
			my $file=$1;
			open(FILE,"$file") || die("$file ($oldfile) err");
			my $FILE="";
			foreach $y(<FILE>) {
				$FILE.=$y;
			}
			close(FILE);
			s/\@\@include\=\"(.+)\"\@\@/$FILE/;
		}

		# for direct exec file
		if(/\@\@exec\=\"(.+)\"\@\@/) {
			my $execfile=$1;
			$execbuf="";
			open(PIPE,"perl $execfile|");
			foreach $p(<PIPE>) {
				$execbuf.=$p;
			}
			close(PIPE);
			s/\@\@exec\=\"(.+)\"\@\@/$execbuf/;
		}

		# for compact source (release v0.2.0)
		if($TYPE=~/compact/) {
			$flg=1 if(/#\s?nocompact$/);
		} else {
			$flg=1 if(/#\s?compact$/);
		}
		s/#\s?nocompact$//g;
		s/#\s?compact$//g;

		# for release source (release v0.2.1)
		if($TYPE=~/release/) {
			$flg=1 if(/#\s?norelease$/);
		} else {
			$flg=1 if(/#\s?release$/);
		}
		s/#\s?norelease$//g;
		s/#\s?release$//g;

		# for devel source (release v0.2.1)
		if($TYPE=~/devel/) {
			$flg=1 if(/#\s?nodevel$/);
		} else {
			$flg=1 if(/#\s?devel$/);
		}
		s/#\s?nodevel$//g;
		s/#\s?devel$//g;

		# delete only (release v0.2.1)
		$flg=1 if(/#\s?delete$/);
		s/#\s?delete$//g;

		# for build source
		$flg=1 if(/#notbuild/);
		next if($flg eq 1);

		$cut=1 if(/^\=(head|lang)/);
		if(/^\=cut/) {
			$cut=0;
			$flg=1 if($podcut eq 1);
		}
		$flg=1 if($cut eq 1 && $podcut eq 1);
		$flg=1 if(/nanami\=true/);
		$flg=1 if(/\#\s{0,3}nanami/);
		$flg=1 if(/^#\t/ && $commentcut eq 1 && $old!~/\.ini/);
#		next if(/^#\t/ && $commentcut eq 1 && $old!~/\.ini/);

		if($flg eq 1) {
			$_="";
			next;
		}

#		# 内部コード変換
#		if($new=~/\.pl$|\.cgi$/ && $new!~/\.ini\.cgi$/) {
#			s/([\x80-\xff])/'\\' . unpack('H2', $1)/eg
#				if(!/#/);
#		}

		if(/\#\s{0,3}debug/ && !/\#\s{0,3}debug\.inc\./&& $debug eq 1) {
			s/\#\s{0,3}debug//g;
		}
		if(/\#\s{0,3}debug/ && !/\#\s{0,3}debug\.inc\./ && $debug eq 0) {
			$_ = "";
			$flg=1;
			next;
		}
		if(/\#([\s\t]+)?comment/ && commentcut eq 1) {
			s/\#([\s\t]+)?comment//g;
		}
		if(/\#([\s\t]+)?comment/ && commentcut eq 0) {
			$_ = "";
			$flg=1;
			next;
		}

#if(0) {
#		if(!/\#\s{0,3}debug/ || /\#([\s\t]+)?comment/ || $debug eq 1) {
		$ii=0;
#			if($commentcut eq 1) {
#				#s/([\s\t]+)?\#([\s\t]+)?#([\s\t]+)?comment//g;
#				if(/^\#.*comment/) {
#				#if(/^\#/ && /\#([\s\t]+)?comment$/) {
#					$_="";
#				}
#				if(/\#([\s\t]+)?comment$/) {
#					s/([\s\t]+)?\#.*//g;
#					s/^\#.*//g;
#				}
#				s/\t+#.*$//g if($commentcut eq 1 && $old!~/\.ini/);
#			} else {
##				s/([\s\t]+)?\#([\s\t]+)?comment$//g;
#			}
#}

		s/([\s\t]+)?$//g;
		$s=$_;
		if($s=~/\@\@CVSURL\@\@/) {
			$tmps=$s;
			$tmps=~s!\@\@CVSURL\@\@/PyukiWiki\-Devel/!\@\@CVSURL\@\@/PyukiWiki\-Devel\-UTF8/!g;
			$s.="\n\n$tmps";
			$tmps=$s;
			$tmps=~s!\@\@CVSURL\@\@/!\@\@CVSURLDEV\@\@/!g;
			$tmps=~s!\?view\=log$!!g;
			$s.="\n\n$tmps";
		}
		while($s=~/\@\@(.+?)\@\@/) {
			$rep=$1;
			$s=~s/\@\@$rep\@\@/$text{$rep}/g;
			if($filemode eq 'crlf') {
				$s=~s/\x0D\x0A|\x0D|\x0A/\r\n/g;
			} else {
				$s=~s/\x0D\x0A|\x0D|\x0A/\n/g;
			}
			last if($ii++>10);
		}
		while($s=~/\\\@\\\@\\\@(.+?)\\\@\\\@\\\@/) {
			$rep=$1;
			$s=~s/\\\@\\\@\\\@$rep\\\@\\\@\\\@/$text{$rep}/g;
			if($filemode eq 'crlf') {
				$s=~s/\x0D\x0A|\x0D|\x0A/\r\n/g;
			} else {
				$s=~s/\x0D\x0A|\x0D|\x0A/\n/g;
			}
			last if($ii++>10);
		}

		if(!($file=~/\.txt$/ && $s=~/test/) || $debug eq 1) {
			chomp $s;
			if($s ne '' || $commentcut eq 0 || $old=~/$ignore_crlfcut/) {
				$s=&email($s);
				if($filemode eq 'crlf') {
					$buf.="$s\r\n";
#					print W "$s\r\n";
				} else {
					$buf.="$s\n";
#					print W "$s\n";
				}
			}
		}
	}
	if($podcut) {
		$buf=~s/\=head(.*?)\=cut\n//gm;
		$buf=~s/\=head(.*?)\=cut//gm;
	}
	print W $buf;
	close(W);
	close(R);

#	unlink("$utf8temp") if($utf8temp ne "");

	# syntax check
	if($new=~/\.(cgi|pl|pm)$/ && $new!~/build\.pl/) {
		$chk="";
		$fixed=&mktemp($new);
		open(R,$new)||exit 2;
		open(W,">$fixed")||exit 3;
		foreach(<R>) {
			next if(/^[\s\t]+use[\s\t].*;/);
			print W $_;
		}
		close(R);
		close(W);
		open(PIPE,"perl -c $fixed >/dev/stdout 2>/dev/stdout|");
		foreach(<PIPE>) {
			$chk.=$_;
		}
		close(PIPE);
		if($chk=~/errors/) {
			unlink($new);
			print STDERR "$new syntax error\n$chk\n";
			exit 1;
		}
		unlink($fixed);

#		# output perl html
#		if($CHARSET ne 'utf8') {
#			&convertutf8("$newfile", "utf8.tmp");
#			&shell("perltidy -html -nnn --nohtml-entities utf8.tmp");
#			rename("utf8.tmp.html", "$newfile.html");
#			unlink("utf8.tmp");
#		} else {
#			&shell("perltidy -html -nnn --nohtml-entities $newfile");
#		}
	}

	# for compact
if(0) {
	if($TYPE=~/compact/ && $new=~/\.pl$|\.cgi$/ && $new!~/\.ini\.cgi$/) {
		open(R,"$new");
		my $all;
		my $head;
		my $flg=0;
		foreach(<R>) {
			if(/^#/ && $flg eq 0) {
				$head.=$_;
			} else {
				$flg++;
				$all.=$_;
			}
		}
		close(R);
		open(W,">tmp");
		print W $all;
		close(W);
		my $out;
		my $path;
		foreach(split(/:/,$ENV{PATH})) {
			$path="$_/perl";
			last if(-x $path && -r $path);
			$path="not found";
		}
		open(PIPE,"$path $compact_filter tmp|");
		foreach(<PIPE>) {
			next if(/^#/ || $_ eq '');
			$out.=$_;
		}
		close(PIPE);
		unlink("tmp");
		open(W,">$new");
		print W $head;
		$out=~s/\_\_DATA\_\_/\n\_\_DATA\_\_\n/g;
		$out=~s/\_\_END\_\_/\n\_\_END\_\_\n/g;
		while($out=~/\n\n/) {
			$out=~s/\n\n/\n/g;
		}
		print W $out;
		close(W);
	}
	}
	chmod(oct($chmod),"$new");
	unlink("$oldfile.utf8.tmp");
}

sub copybin {
	my($chmod,$old,$new)=@_;

	if($touchonly eq 1) {
		&shell("touch $old");
		return;
	}
	return if((stat($old))[9]<(stat($new))[9] && $checktimestamp eq 1);

	print "copy $old $new ($chmod bin)\n";
	$old="$releasepatch/$old"if(-r "$releasepatch/$old");
	&shell("cp $old $new");
	chmod(oct($chmod),"$new");
}

sub mkdir {
	my($dir,$chmod)=@_;
	unless(-d "$dir") {
		print "mkdir $dir ($chmod)\n";
		mkdir($dir);
		chmod(oct($chmod),"$dir");
	}
}


sub email {
	my($s)=@_;
$esc         = '\\\\';               $Period      = '\.';
$space       = '\040';
$OpenBR      = '\[';                 $CloseBR     = '\]';
$NonASCII    = '\x80-\xff';          $ctrl        = '\000-\037';
$CRlist      = '\n\015';
$qtext       = qq/[^$esc$NonASCII$CRlist\"]/;
$dtext       = qq/[^$esc$NonASCII$CRlist$OpenBR$CloseBR]/;
$quoted_pair = qq<${esc}[^$NonASCII]>;
$atom_char   = qq/[^($space)<>\@,;:\".\'$esc$OpenBR$CloseBR$ctrl$NonASCII]/;
$atom        = qq<$atom_char+(?!$atom_char)>;
$quoted_str  = qq<\"$qtext*(?:$quoted_pair$qtext*)*\">;
$word        = qq<(?:$atom|$quoted_str)>;
$domain_ref  = $atom;
$domain_lit  = qq<$OpenBR(?:$dtext|$quoted_pair)*$CloseBR>;
$sub_domain  = qq<(?:$domain_ref|$domain_lit)>;
$domain      = qq<$sub_domain(?:$Period$sub_domain)+>;
$local_part  = qq<$word(?:$Period$word)*>;
$addr_spec   = qq<$local_part\@$domain>;
$mail_regex  = $addr_spec;

	$s=~s!<($mail_regex)>!&emailsub($1)!gex;
	$s=~s!($mail_regex)!&emailsub($1)!gex;
	return $s;
}

sub emailsub {
	my($ss)=@_;
	$ss=~s/\@/ \(at\) /g;
	$ss=~s/\./ \(dot\) /g;
	return "<$ss>";
}

sub dbmname {
	my ($name) = @_;
#	$name =~ s/(.)/uc unpack('H2', $1)/eg;
	$name =~ s/(.)/$::_dbmname_encode{$1}/g;
	return $name;
}

sub undbmname {
	my ($name) = @_;
#	$name =~ s/(.)/uc unpack('H2', $1)/eg;
	$name =~ s/([0-9A-F][0-9A-F])/$::_dbmname_decode{$1}/g;
	return $name;
}


sub convertutf8 {
	my($old, $new)=@_;
	if($FIRSTBUILD eq 0) {
		&shell("cp $old $new");
		return;
	}
	&shell("perl ./build/Jcode-convert.pl utf8 $new $old euc");
#	&shell("nkf -O  -w $old");
#	&shell("cp nkf.out $new");
#	unlink("nkf.out");
}

sub convertsjis {
	my($old, $new)=@_;
	if($FIRSTBUILD eq 0) {
		&shell("cp $old $new");
		return;
	}
	&shell("perl ./build/Jcode-convert.pl sjis $new $old euc");
#	&shell("nkf -O  -s $old");
#	&shell("cp nkf.out $new");
#	unlink("nkf.out");
}

sub mktemp {
	my ($f)=shift;
	$f=~s/\//-/g;
	mkdir($TEMP);
	$f="$TEMP/.temp-$f." . time;
	return $f;
}
