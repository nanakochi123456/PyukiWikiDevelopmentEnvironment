######################################################################
# @@HEADERPLUGIN_SYNTAXHIGHLIGHTER_NANAMI@@
######################################################################
# based syntaxhighlighter_3.0.83
# http://alexgorbatchev.com/SyntaxHighlighter/
#
# SyntaxHighlighter is donationware. If you are using it, please donate.
#
# http://alexgorbatchev.com/SyntaxHighlighter/donate.html
######################################################################

$PLUGIN="syntaxhighlighter";
$VERSION="0.2";

@sh::supports=(
	"AppleScript",
	"AS3|actionscript3",
	"Bash|shell",
	"ColdFusion|cf",
	"Cpp|c",
	"CSharp|c#",
	"Css|css",
	"Delphi|pascal",
	"Diff|patch|pas",
	"Erlang|erl",
	"Groovy|groovy",
	"Java|java",
	"JavaFX|jfx",
	"JScript|js|javascript",
	"Perl|pl",
	"Php|php",
	"Plain|text",
	"PowerShell",
	"Python|py",
	"Ruby|rails|ror|rb",
	"Sass|scss",
	"Scala",
	"Sql",
	"Vb|vbnet",
	"Xml|xhtml|xslt|html",
);

@sh::css=(
	"Default",
	"Django",
	"Eclipse",
	"Emacs",
	"FadeToGrey",
	"MDUltra",
	"Midnight",
	"RDark",
);

$sh::load=0;
$sh::brush;
$sh::basedir="$::skin_dir/syntaxhighlighter";
$sh::jsprefix="$sh::basedir/shBrush";
$sh::cssprefix="$sh::basedir/shTheme";

# Options
# Demo URL
# http://alexgorbatchev.com/SyntaxHighlighter/manual/configuration/

# bloggerMode (false)
# Blogger integration.If you are hosting on blogger.com, you must turn this on.
$sh::config{"bloggerMode"}=false;

# strings
# Allows you to change default messages, see here for more details.


# stripBrs (false)
# If your software adds <br /> tags at the end of each line, this option
#  allows you to ignore those.
$sh::config{"stripBrs"}=false;

# tagName ("pre")
# Facilitates using a different tag.
$sh::config{"tagName"}="pre";

# auto-links (true)
# Allows you to turn detection of links in the highlighted element on and off.
# If the option is turned off, URLs wonÅft be clickable.
#$sh::defaults{"auto-links"}=false;

# class-name ('')
# Allows you to add a custom class (or multiple classes) to every highlighter
#  element that will be created on the page.

# collapse (false)
# Allows you to force highlighted elements on the page to be collapsed
#  by default.
#$sh::defaults{"collapse"}=false;

# first-line (1)
# Allows you to change the first (starting) line number.
$sh::defaults{"first-line"}=1;

# gutter (true)
# Allows you to turn gutter with line numbers on and off.
#$sh::defaults{"gutter"}=false;

# highlight (null)
# Allows you to highlight one or more lines to focus userÅfs attention.
# When specifying as a parameter, you have to pass an array looking value,
# like [1, 2, 3] or just an number for a single line. If you are changing
# SyntaxHighlighter.defaults['highlight'], you can pass a number or an
# array of numbers.

# html-script (false)
# Allows you to highlight a mixture of HTML/XML code and a script which is
# very common in web development. Setting this value to true requires that
# you have shBrushXml.js loaded and that the brush you are using supports
# this feature.
$sh::defaults{"html-script"}=true;

# smart-tabs (true)
# Allows you to turn smart tabs feature on and off.
$sh::defaults{"smart-tabs"}=true;

# tab-size (4)
# Allows you to adjust tab size.
$sh::defaults{"tab-size"}=4;

# toolbar (true)
# Toggles toolbar on/off. Click here for a demo.
$sh::defaults{"toolbar"}=false;

sub plugin_sh_convert {
	my ($param)=@_;;
	my ($arg,$thm,$eom)=split(/,/,$param);

	my $flg=0;

	foreach my $sups(@sh::supports) {
		my $lang=$sups;
		$lang=~s/\|.*//g;
		my $brush=$sups;
		$brush=~s/.*\|//g;
		my @sups=split(/\|/,$sups);
		foreach (@sups) {
			if(lc $arg eq lc $_) {
				$flg=1;
				$sh::lang=$lang;
				$sh::brush=$brush;
				last;
			}
		}
	}
	if($flg eq 0) {
		return "SyntaxHighlighter: not support $arg";
	}
	if($thm eq '') {
		$thm="Default";
	}
	if($sh::load eq 0) {
		$::IN_HEAD.=<<EOM;
<script type="text/javascript" src="$sh::basedir/XRegExp.js"></script>
<script type="text/javascript" src="$sh::basedir/shCore.js"></script>
<script type="text/javascript" src="$sh::basedir/shAutoloader.js"></script>
<link rel="stylesheet" type="text/css" href="$sh::basedir/shCore.css" />
<link rel="stylesheet" type="text/css" href="$sh::cssprefix$thm.css" />
<script type="text/javascript"><!--
EOM

		foreach(keys %sh::config) {
			$::IN_HEAD.=<<EOM;
SyntaxHighlighter.config['$_'] = "$sh::config{$_}";
EOM
		}
		foreach(keys %sh::defaults) {
			$::IN_HEAD.=<<EOM;
SyntaxHighlighter.defaults['$_'] = "$sh::defaults{$_}";
EOM
		}
		$::IN_HEAD.=<<EOM;
SyntaxHighlighter.all();
//--></script>
EOM
	}
	$::IN_HEAD.=<<EOM;
<script type="text/javascript" src="$sh::jsprefix$sh::lang.js"></script>
EOM
	$::linedata="";
	$::linesave=1;
	$::eom_string=$eom;
	$::eom_string="#sh" if($eom eq '');
	$::exec_inlinefunc=\&plugin_sh_display;
	return ' '
}

sub plugin_sh_display {
	my($text)=@_;
	my $body=<<EOM;
<pre class="brush: $sh::brush;">
@{[&htmlspecialchars($text)]}
</pre>
EOM
	$sh::brush="";
	return $body;
}

1;
__END__
=head1 NAME

sh.inc.pl - PyukiWiki Plugin

=head1 SYNOPSIS

 #sh(language name)
 program code
 pgoramm code
 ...
 #sh

 #sh(language name, skin, EOM)
 program code
 pgoramm code
 ...
 EOM

=head1 DESCRIPTION

Display formatted program code.

=head1 USAGE

#sh(language name)
...
#sh (End code)

#sh(language name, skin, EOM)
...
EOM

=over 4

=item language name

Setting language name

list...

applescript,
actionscript3,as3,
bash,shell,
coldfusion,cf,
cpp,c,
c#,c-sharp,
css,
delphi,pascal,
diff,patch,pas,
erl,erlang,
groovy,
java,
jfx,javafx,
js,jscript,javascript,
perl,pl,
php,
text,plain,
py,python,
ruby,rails,ror,rb,
sass,scss,
scala,
sql,
vb,vbnet,
xml,xhtml,xslt,html

=item skin

Setting skin. Default is Default.

list...

Default,
Django,
Eclipse,
Emacs,
FadeToGrey,
MDUltra,
Midnight,
RDark

=back

=head1 SEE ALSO

=over 4

=item PyukiWiki/Plugin/Nanami/sh

L<@@BASEURL@@/PyukiWiki/Plugin/Nanami/sh/>

=item PyukiWiki CVS

L<@@CVSURL@@/PyukiWiki-Devel/plugin/sh.inc.pl>

=item SyntaxHighlighter

L<http://alexgorbatchev.com/SyntaxHighlighter/>

=back

=head1 AUTHOR

=over 4

@@AUTHOR_NANAMI@@

@@AUTHOR_PYUKI@@

=back

=head1 LICENSE

@@LICENSE_NANAMI@@

SyntaxHighlighter is donationware. If you are using it, please donate.

L<http://alexgorbatchev.com/SyntaxHighlighter/donate.html>

=cut
