#!/bin/sh
#--------------------------------------------------------------
# PyukiWiki Installer CGI Maker
# $Id$
#--------------------------------------------------------------
ZIPCMD=$1
P7ZCMD=$2
ORGFILE=$3
TOFILE=$4.cgi
PROJ=$4
ZIPFILE=$4.zip
P7ZFILE=$4.exe
GZIP_7Z="7za a -tgzip -mx9 -mpass=10 -mfb=256"
BZIP2_7Z="7za a -tbzip2 -mx9 -mpass=10 -md=100m"
P7ZSFXFILE=./build/7zSD.sfx
P7ZCONFIGFILE=/tmp/config.txt
VERSION=$5
PREFIX=$6
ARCMETHOD=$7
TXTMETHOD=$8
CODE=$9
TEMPDIR="./temp"
TEMP1="$TEMPDIR/tmp1"
TEMP2="$TEMPDIR/tmp2"
TEMP3="$TEMPDIR/tmp3"
TEMP4="$TEMPDIR/tmp4"

if [ "$CODE" == "euc" ]; then
	CODE="EUC"
else
	CODE="UTF-8"
fi

arc() {
	if [ "$ARCMETHOD" = "gz" ]; then
#		ARCCMD="GZIP="gzip -9"
		ARCCMD="7za a -tgzip -mx9"
		EXTCMD="gunzip"
	fi
	if [ "$ARCMETHOD" = "bz2" ]; then
#		ARCCMD="bzip2 -9"
		ARCCMD="7za a -tbzip2 -mx9"
		EXTCMD="bunzip2"
	fi
	if [ "$ARCMETHOD" = "xz" ]; then
#		ARCCMD="xz -9"
		ARCCMD="7za a -txz -mx9"
		EXTCMD="unxz"
	fi

	cat <<EOM>temp/installer.mk
FILES=$TEMPDIR/license_art_en.htm $TEMPDIR/license_art_ja.htm $TEMPDIR/license_gpl_en.htm $TEMPDIR/license_gpl_ja.htm $TEMPDIR/installer.sh $TEMPDIR/installer2.sh $TEMPDIR/installer_sub.sh

all:\${FILES}

$TEMPDIR/license_art_en.htm: ./build/license_art_en.html
	perl build/compressfile.pl html $TEMPDIR/license_art_en.1 build/license_art_en.html
	perl build/build.pl cp "$TEMPDIR" "0644" "$TEMPDIR/license_art_en.1" "$TEMPDIR/license_art_en.htm" "release" "lf" "euc" "" >/dev/null
	rm -f $TEMPDIR/license_art_en.1

$TEMPDIR/license_art_ja.htm: ./build/license_art_ja.html
	perl build/compressfile.pl html $TEMPDIR/license_art_ja.1 build/license_art_ja.html
	perl build/build.pl cp "$TEMPDIR" "0644" "$TEMPDIR/license_art_ja.1" "$TEMPDIR/license_art_ja.htm" "release" "lf" "euc" "" >/dev/null
	rm -f $TEMPDIR/license_art_ja.1

$TEMPDIR/license_gpl_en.htm: ./build/license_gpl_en.html
	perl build/compressfile.pl html $TEMPDIR/license_gpl_en.1 build/license_gpl_en.html
	perl build/build.pl cp "$TEMPDIR" "0644" "$TEMPDIR/license_gpl_en.1" "$TEMPDIR/license_gpl_en.htm" "release" "lf" "euc" "" >/dev/null
	rm -f $TEMPDIR/license_gpl_en.1

$TEMPDIR/license_gpl_ja.htm: ./build/license_gpl_ja.html
	perl build/compressfile.pl html $TEMPDIR/license_gpl_ja.1 build/license_gpl_ja.html
	perl build/build.pl cp "$TEMPDIR" "0644" "$TEMPDIR/license_gpl_ja.1" "$TEMPDIR/license_gpl_ja.htm" "release" "lf" "euc" "" >/dev/null
	rm -f $TEMPDIR/license_gpl_ja.1

$TEMPDIR/installer.sh: ./build/installer.sh
	perl build/build.pl cp "$TEMPDIR" "0644" "build/installer.sh" "$TEMPDIR/installer.sh" "release" "lf" "euc" "" >/dev/null

$TEMPDIR/installer2.sh: ./build/installer2.sh
	perl build/build.pl cp "$TEMPDIR" "0644" "build/installer2.sh" "$TEMPDIR/installer2.sh" "release" "lf" "euc" "" >/dev/null

$TEMPDIR/installer_sub.sh: ./build/installer_sub.sh
	perl build/build.pl cp "$TEMPDIR" "0644" "build/installer_sub.sh" "$TEMPDIR/installer_sub.sh" "release" "lf" "euc" "" >/dev/null
EOM

	echo $0:Make selfextracter
	gmake -f temp/installer.mk

	echo $0:Compress selfextracter
	perl build/arc.pl a $TEMP1 temp/installer_sub.sh temp/*.htm >/dev/null 2>/dev/null

	$ARCCMD $TEMP1.$ARCMETHOD $TEMP1 >/dev/null 2>/dev/null

	if [ "$TXTMETHOD" = "b64" ]; then
		TXTENCCMD="b64encode"
		TXTCMD="b64decode"
	fi
	if [ "$TXTMETHOD" = "uu" ]; then
		TXTENCCMD="uuencode"
		TXTCMD="uudecode"
	fi
	if [ "$TXTMETHOD" = "shar" ]; then
		TXTENCCMD=""
		TXTCMD=""
	fi

	if [ "$TXTMETHOD" = "shar" ]; then
		perl ./build/base64.pl b64encode < $TEMP1.$ARCMETHOD > $TEMP2
	else
		$TXTENCCMD -o $TEMP2 $TEMP1.$ARCMETHOD a >/dev/null 2>/dev/null
	fi
}

txt() {
	if [ "$TXTMETHOD" = "b64" ]; then
		TXTENCCMD="b64encode"
		TXTCMD="b64decode"
	fi
	if [ "$TXTMETHOD" = "uu" ]; then
		TXTENCCMD="uuencode"
		TXTCMD="uudecode"
	fi
	if [ "$TXTMETHOD" = "shar" ]; then
		TXTENCCMD=""
		TXTCMD=""
	fi
	if [ "$TXTMETHOD" = "shar" ]; then
		echo $0:Extract archive file
		mkdir -p ./temp/makeinstaller
		tar xvfz $ORGFILE -C ./temp/makeinstaller >/dev/null 2>/dev/null
		cd temp/makeinstaller
		PROJ=`echo $PROJ|sed -e 's/.*\///g'|sed -e 's/\_installer//g'`
		echo $0:Taping archive file to $TOFILE.ar
		perl ../../build/arc.pl adv ../../$TOFILE.ar `find $PROJ` >/dev/null 2>/dev/null
		echo $0:Compress archive file to $TOFILE.gz
		$GZIP_7Z ../../$TOFILE.ar.gz ../../$TOFILE.ar >/dev/null 2>/dev/null
#		$BZIP2_7Z ../../$TOFILE.ar.bz2 ../../$TOFILE.ar >/dev/null 2>/dev/null

		cd ../..
		rm -rf temp/makeinstaller
		echo $0:Encode archive file to $TOFILE
		perl ./build/base64.pl b64encode < $TOFILE.ar.gz > $TEMP3
#		perl ./build/base64.pl b64encode < $ORGFILE > $TEMP3
	else
		$TXTENCCMD -o $TEMP3 $ORGFILE a >/dev/null 2>/dev/null
	fi
}
arc
txt

cat $TEMPDIR/installer.sh \
	| sed -e "s/__ARCCMD__/$EXTCMD/g" \
	| sed -e "s/__TXTCMD__/$TXTCMD/g" \
	| sed -e "s/__ARCEXT__/$ARCMETHOD/g" \
	| sed -e "s/__TXTEXT__/$TXTMETHOD/g" \
	| sed -e "s/__PYUKIWIKIVERSION__/$VERSION/g" \
	| sed -e "s/__BUILD__/$PREFIX/g" \
	| sed -e "s/__CODE__/$CODE/g" \
	| perl -pe 's/\n\n/\n/g' \
	| perl -pe 's/^\t+//g' > $TOFILE

if [ "$TXTMETHOD" = "shar" ]; then
	echo cat\>\$S\<\<\'aaaaaa\'>>$TOFILE
	cat $TEMP2>>$TOFILE
	echo aaaaaa>>$TOFILE
else
 	echo cat\>\$S\<\<\'aaaaaa\'>>$TOFILE

	cat>$TEMPDIR/tmp.pl<<EOF
open(R,"$TEMP2");
foreach(<R>){
print "\$_";
}
close(R);
EOF
	perl $TEMPDIR/tmp.pl>>$TOFILE

	echo aaaaaa>>$TOFILE
fi

if [ "$TXTMETHOD" = "shar" ]; then
	echo cat\>\$I\<\<\'bbbbbb\'>>$TOFILE
	cat $TEMP3>>$TOFILE
#	echo aaaaaa>>$TOFILE
	echo bbbbbb>>$TOFILE
else
	echo cat\>\$I\<\<\'bbbbbb\'>>$TOFILE
	cat>$TEMPDIR/tmp.pl<<EOF
open(R,"$TEMP3");
foreach(<R>){
print "\$_";
}
close(R);
EOF
	perl $TEMPDIR/tmp.pl>>$TOFILE
	echo bbbbbb>>$TOFILE
fi

#rm $TEMP1.$ARCMETHOD
#rm $TEMP2
#rm $TEMP3

#cat $TEMP2 >> $TOFILE
#cat $TEMP3 >> $TOFILE
#rm -f $TEMPDIR/tmp.pl

#cd ..


echo "cat <<EOF|perl -e 'while(<STDIN>){\$z.=\$_;}foreach my \$i(0..255){\$x{sprintf(\"%02X\",\$i)}=chr(\$i);}\$z=~s/([0-9A-F][0-9A-F])/\$x{\$1}/g;print \$z;'>\$TP">$TEMPDIR/hexinstaller.sh
perl -pe 's/(.)/uc unpack("H2", $1)/eg;' ./build/b64decode.pl >> $TEMPDIR/hexinstaller.sh
echo "" >> $TEMPDIR/hexinstaller.sh
echo "EOF" >> $TEMPDIR/hexinstaller.sh
echo "cat <<EOF|perl -e 'while(<STDIN>){\$z.=\$_;}foreach my \$i(0..255){\$x{sprintf(\"%02X\",\$i)}=chr(\$i);}\$z=~s/([0-9A-F][0-9A-F])/\$x{\$1}/g;print \$z;'>\$AE">>$TEMPDIR/hexinstaller.sh
perl -pe 's/(.)/uc unpack("H2", $1)/eg;' ./build/ext_small.pl >> $TEMPDIR/hexinstaller.sh
echo "" >> $TEMPDIR/hexinstaller.sh
echo "EOF" >> $TEMPDIR/hexinstaller.sh


cat $TEMPDIR/hexinstaller.sh $TEMPDIR/installer2.sh \
	| sed -e "s/__ARCCMD__/$EXTCMD/g" \
	| sed -e "s/__TXTCMD__/$TXTCMD/g" \
	| sed -e "s/__ARCEXT__/$ARCMETHOD/g" \
	| sed -e "s/__TXTEXT__/$TXTMETHOD/g" \
	| sed -e "s/__PYUKIWIKIVERSION__/$VERSION/g" \
	| sed -e "s/__BUILD__/$PREFIX/g" \
	| sed -e "s/__CODE__/$CODE/g">> $TOFILE


# convert crlf document
perl -pe 's/\n/\r\n/' ./build/CGI_INSTALLER.ja.txt > $TEMPDIR/CGI_INSTALLER.ja.txt
perl -pe 's/\n/\r\n/' ./README.ja.txt > $TEMPDIR/README.ja.txt
perl -pe 's/\n/\r\n/' ./COPYRIGHT.txt > $TEMPDIR/COPYRIGHT.txt
perl -pe 's/\n/\r\n/' ./COPYRIGHT.ja.txt > $TEMPDIR/COPYRIGHT.ja.txt

# make zip file
echo $0:Make zip file to $ZIPFILE
$ZIPCMD $ZIPFILE $TOFILE $TEMPDIR/CGI_INSTALLER.*.txt $TEMPDIR/README.ja.xtxt $TEMPDIR/COPYRIGHT.*.txt $TEMPDIR/COPYRIGHT.txt >/dev/null 2>/dev/null
#rm -rf $TEMPDIR/*

# remove installer
#rm $TOFILE

exit 0
