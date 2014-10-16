cp $S $S.shar>/dev/null 2>/dev/null
rm -f $S
perl $TP<$S.shar>$S.ar.gz
rm -f $S.ar
gunzip $S.ar.gz>/dev/null 2>/dev/null
cd $T
perl ../$AE ../$S.ar>/dev/null 2>/dev/null
cd ..
if [ "$SE" != "" ]; then
$SH $X $SE $0
fi
rm -rf $X $S $S.$TET $S.$AET $I $I.$TET $I.$AET $TP $T
