######################################################################
# @@HEADER4_NANAMI@@
######################################################################
# XSPKG : NanaXS::func 0.1

use 5.008100;

require "../xsmake/pyukiwikixs.pl";

&writemakefile(
	Module=>"NanaXS::func",
	File=>"func.pm",
	Author=>'\@\@AUTHOR_NANAMI\@\@',
	Libs=>['-L../xslib -lxslib'],
);
