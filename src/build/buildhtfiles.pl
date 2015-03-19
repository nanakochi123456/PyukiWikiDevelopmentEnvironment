#!#!/usr/bin/perl
# release file perl script for pyukiwiki
# $Id$

@dirtable=(
	"./attach:noref",
	"./backup:noaccess",
	"./build:noaccess",
	"./cache:noaccess",
	"./counter:noaccess",
	"./diff:noaccess",
	"./image:noref",
	"./info:noaccess",
	"./lib:noaccess",
	"./logs:noaccess",
	"./plugin:noaccess",
	"./resource:noaccess",
	"./sample:noaccess",
	"./session:noaccess",
	"./skin:noref",
	"./src:noaccess",
	"./trackback:noaccess",
	"./user:noaccess",
	"./wiki:noaccess",
	".:root",
);

$file{"index.html"}{"noref"}=<<EOM;
<!-- \$Id\$ -->
\$dir files are placed here.
EOM

$file{"index.html"}{"noaccess"}=<<EOM;
<!-- \$Id\$ -->
\$dir files are placed here.
EOM

$file{".htaccess"}{"noref"}=<<EOM;
######################################################################
# Apache \$dir/\$file for PyukiWiki
# $Id$
# \@\@PYUKIWIKIVERSION\@\@
######################################################################

Order allow,deny
Allow from all

<FilesMatch ".(html)" >
	Order allow,deny
	Deny from all
</FilesMatch>

######################################################################
## Options can use, it is good to add the following setup.
#Options -Indexes

######################################################################
## sample prevention of direct link from other site
#SetEnvIf Referer "^\@\@PYUKI_URL\@\@" ref01
#Order deny,allow
#Deny from all
#Allow from env=ref01
EOM

$file{".htaccess"}{"noaccess"}=<<EOM;
######################################################################
# Apache \$dir/\$file for PyukiWiki
# \$Id\$
# \@\@PYUKIWIKIVERSION\@\@
######################################################################

Order deny,allow
Deny from all
EOM

$file{".htaccess"}{"root"}=<<EOM;
######################################################################
# Apache .htaccess for PyukiWiki
# \$Id\$
# \@\@PYUKIWIKIVERSION\@\@
######################################################################

######################################################################
## DirectoryIndex

DirectoryIndex nph-index.cgi index.cgi wiki.cgi pyukiwiki.cgi index.php index.html index.htm

######################################################################
## Permit files

<FilesMatch "\.(ini\.cgi|pl|txt)$">
	Order allow,deny
	Deny from all
</FilesMatch>

<FilesMatch "^robots\.txt$">
	Order deny,allow
	Allow from all
</FilesMatch>

<FilesMatch "^\.ht">
	Order allow,deny
	Deny from all
</FilesMatch>

######################################################################
## If using non extension cgi script, please comment out.
## example: using urlhack.inc.cgi + $use_path_info=1
#<FilesMatch "^wiki$">
#	ForceType application/x-httpd-cgi
#</FilesMatch>

######################################################################
## Authentication to this directory with basic-auth
## needs 'AllowOverride AuthConfig' at httpd.conf
#AuthType Basic
#AuthName      "Authentication required"
#AuthUserFile  /fullpath/.htpasswwd
#AuthGroupFile /dev/null
#Require       valid-user

######################################################################
## If using POST method authing with basic-auth (for SPAM attack measures)
## needs 'AllowOverride AuthConfig' at httpd.conf
## Please write it in that opportunity FrontPage.
## (password is blank)
#<Limit POST>
#	AuthType		Basic
#	AuthName		"Please Input Username: user"
#	AuthUserFile	/fullpath/.htpasswd
#	AuthGroupFile	/dev/null
#	Require			valid-user
#	require valid-user
#</Limit>

######################################################################
## sample of rewrite engine !!if use urlhack.cgi this comment out please
#RewriteEngine on
#RewriteBase /
#
#RewriteCond %{REQUEST_URI} !^/(attach|cache|image|skin)
#RewriteRule ^\?(.*)$ ./index.cgi?$1 [L]
#RewriteCond %{REQUEST_URI} !^/(attach|cache|image|skin)
#RewriteRule ^$ ./index.cgi [L]
#RewriteCond %{REQUEST_URI} !^/(attach|cache|image|skin)
#RewriteRule ^/$ ./index.cgi [L]
#RewriteCond %{REQUEST_URI} !^/(attach|cache|image|skin)
#RewriteRule ^(.+)/$ ./index.cgi/$1 [L]
#
# or...
#
#RewriteCond %{REQUEST_URI} !^/(attach|cache|image|skin)
#RewriteRule ^\?(.*)$ /cgi-bin/w?$1 [L]
#RewriteCond %{REQUEST_URI} !^/(attach|cache|image|skin)
#RewriteRule ^(.+)/$ /cgi-bin/w/$1 [L]
#RewriteCond %{REQUEST_URI} !^/(attach|cache|image|skin)
#RewriteRule ^$ /cgi-bin/w [L]

######################################################################
## use servererror.inc.pl, comment delete it.
## what ? replace ./nph-index.cgi -> ./index.cgi ?
#ErrorDocument 400 ./nph-index.cgi?cmd=servererror
#ErrorDocument 401 ./nph-index.cgi?cmd=servererror
#ErrorDocument 402 ./nph-index.cgi?cmd=servererror
#ErrorDocument 403 ./nph-index.cgi?cmd=servererror
#ErrorDocument 404 ./nph-index.cgi?cmd=servererror
#ErrorDocument 405 ./nph-index.cgi?cmd=servererror
#ErrorDocument 406 ./nph-index.cgi?cmd=servererror
#ErrorDocument 407 ./nph-index.cgi?cmd=servererror
#ErrorDocument 408 ./nph-index.cgi?cmd=servererror
#ErrorDocument 409 ./nph-index.cgi?cmd=servererror
#ErrorDocument 410 ./nph-index.cgi?cmd=servererror
#ErrorDocument 411 ./nph-index.cgi?cmd=servererror
#ErrorDocument 412 ./nph-index.cgi?cmd=servererror
#ErrorDocument 413 ./nph-index.cgi?cmd=servererror
#ErrorDocument 414 ./nph-index.cgi?cmd=servererror
#ErrorDocument 415 ./nph-index.cgi?cmd=servererror
#ErrorDocument 416 ./nph-index.cgi?cmd=servererror
#ErrorDocument 417 ./nph-index.cgi?cmd=servererror
#ErrorDocument 500 ./nph-index.cgi?cmd=servererror
#ErrorDocument 501 ./nph-index.cgi?cmd=servererror
#ErrorDocument 502 ./nph-index.cgi?cmd=servererror
#ErrorDocument 503 ./nph-index.cgi?cmd=servererror
#ErrorDocument 504 ./nph-index.cgi?cmd=servererror
#ErrorDocument 505 ./nph-index.cgi?cmd=servererror
#ErrorDocument 506 ./nph-index.cgi?cmd=servererror
#ErrorDocument 507 ./nph-index.cgi?cmd=servererror
#ErrorDocument 508 ./nph-index.cgi?cmd=servererror
#ErrorDocument 510 ./nph-index.cgi?cmd=servererror
EOM

$file{".htpasswd"}{"root"}=<<EOM;
user:
EOM

$f="./" . $ARGV[0];
@fname=split("/",$f);
$file=pop(@fname);
$dir=join("/",@fname);

if($file eq "") {
	print STDERR "Usage : $0 filename\n";
	exit;
}

&main($dir, $file);


sub main {
	my($dir, $file)=@_;

	foreach(@dirtable) {
		my($l,$r)=split(/:/,$_);
		if($dir eq $l && $file{$file}{$r} ne "") {
			$text=$file{$file}{$r};
			$d=$dir;
			$d=~s/^\.\///g;
			$text=~s/\$dir/$d/g;
			$text=~s/\$file/$file/g;
			print "Write $dir/$file\n";
			open(W, ">$dir/$file")||die("$dir/$file can't create\n");
			print W $text;
			close(W);
			exit;
		}
	}
}

