######################################################################
# @@HEADER2_NANAMI@@
######################################################################
# This is extented plugin sample
# To use this plugin, rename to 'stationary_explugin.inc.cgi'
######################################################################

use strict;

#
# init
#
sub plugin_stationary_init {
	my $http_header="X-PyukiWiki-Stationary:test";
	return(
		'init'=>1,
		'http_header'=>$http_header
		, 'func'=>'convtime', 'convtime'=>\&convtime
	);
}

sub convtime {
	if ($::enable_convtime != 0) {
		return sprintf("PyukiWiki $::version stationary_explugin<br />Powered by Perl $] HTML convert time to %.3f sec.%s",
			((times)[0] - $::_conv_start), $::gzip_header ne '' ? " Compressed" : "");
	}
}


1;
__END__
