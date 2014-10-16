#!/usr/bin/perl
# release file perl script for pyukiwiki
# $Id$

@dirs=(
	"attach:attachallow,noindex,noref",
	"backup:hidden",
	"build:hidden",
	"cache:hidden",
	"counter:hidden",
	"diff:hidden",
	"image:imageallow,noindex,noref",
	"info:hidden",
	"lib:hidden",
	"plugin:hidden",
	"resource:hidden",
	"sample:hidden",
	"session:hidden",
	"skin:skinallow,noindex,noref,compress",
	"src:hidden",
	"user:hidden",
	"logs:hidden",
	"trackback:hidden",
	"wiki:hidden",
);

	$text{head}=<<EOM;
######################################################################
# Apache \$dir/.htaccess for PyukiWiki
# \$Id\$
# \@\@PYUKIWIKIVERSION\@\@
######################################################################

EOM

	$text{attachallow}=<<EOM;
Order allow,deny
Allow from all

<FilesMatch "\.(html)$">
	Order allow,deny
	Deny from all
</FilesMatch>
EOM

	$text{skinallow}=<<EOM;
Order allow,deny
Deny from all

<FilesMatch "\\.(cgi|php|css|js|gz|swf|gif|jpg|jpeg|png)\$">
	Order allow,deny
	Allow from all
</FilesMatch>
EOM

	$text{imageallow}=<<EOM;
Order allow,deny
Deny from all

<FilesMatch "\\.(gif|jpg|jpeg|png|gz)\$">
	Order allow,deny
	Allow from all
</FilesMatch>
EOM

	$text{hidden}=<<EOM;
Order deny,allow
Deny from all
EOM

	$text{noindex}=<<EOM;
######################################################################
## Options can use, it is good to add the following setup.
#Options -Indexes
EOM

	$text{noref}=<<EOM;
######################################################################
## sample prevention of direct link from other site
#SetEnvIf Referer "^http://pyukiwiki.sourceforge.jp/" ref01
#Order deny,allow
#Deny from all
#Allow from env=ref01
EOM

	$text{compress}=<<EOM;
######################################################################
# If using compressed skin, delete comment

#RewriteEngine on
#RewriteCond %{HTTP:Accept-Encoding} gzip
#RewriteCond %{REQUEST_FILENAME}\\.gz -s
#RewriteRule .+ %{REQUEST_URI}.gz
#
#<FilesMatch "\\.css\\.gz\$">
#	ForceType   text/css
#	AddEncoding x-gzip .gz
#</FilesMatch>
#
#<FilesMatch "\\.js\\.gz\$">
#	ForceType   application/x-javascript
#	AddEncoding x-gzip .gz
#</FilesMatch>
EOM

foreach (@dirs) {
	($dir, $modes)=split(/:/,$_);
#	print "$dir\n";
	$text=$text{head};
	foreach $mode(split(/,/,$modes)) {
		$text.="$text{$mode}\n";
	}
	$text=~s/\$dir/$dir/g;

	mkdir($dir);
	open(W, ">$dir/.htaccess")||die;
	print W $text;
	close(W);

	open(W, ">$dir/index.html")||die;
	print W <<EOM;
<!-- \$Id\$ -->
$dir files are placed here.
EOM
	close(W);
}
