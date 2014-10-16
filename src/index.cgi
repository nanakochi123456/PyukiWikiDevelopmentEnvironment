#!/usr/bin/perl
#!/usr/local/bin/perl --
#!c:/perl/bin/perl.exe
#!c:\perl\bin\perl.exe
#!c:\perl64\bin\perl.exe
######################################################################
# @@HEADER1@@
######################################################################

# If don't work, please comment on this.
use Time::HiRes;

# You MUST modify following initial file.
BEGIN {

	$::ini_file = "pyukiwiki.ini.cgi";

######################################################################
	eval {
		$::_conv_start_hires = [Time::HiRes::gettimeofday];
	};

	$::_conv_start = (times)[0];
	$::setup_file="";
	$::ini_file = "pyukiwiki.ini.cgi" if($::ini_file eq "");
	require "$::ini_file";
	require "$::$setup_file" if(-r "$::setup_file");

	# don't delete for XS module
	push @INC, "$sysxs_dir";
	push @INC, "$sysxs_dir/lib";
	push @INC, "$sysxs_dir/arch";
	push @INC, "$sysxs_dir/arch/auto";
	push @INC, "$sys_dir";
	push @INC, "$sys_dir/CGI";
}

######################################################################
# If Windows NT Server, use sample it
#BEGIN {
#	chdir("C:/inetpub/cgi-bin/pyuki");
#	push @INC, "C:/inetpub/cgi-bin/pyuki/lib/";
#	push @INC, "C:/inetpub/cgi-bin/pyuki/lib/CGI";
#	push @INC, "C:/inetpub/cgi-bin/pyuki/";
#	$::_conv_start = (times)[0];
#}

require "$::sys_dir/wiki.cgi";

__END__

=head1 NAME

index.cgi - This is PyukiWiki Wrapper

=head1 DESCRIPTION

This file is a wrapper program for starting wiki.

=head1 AUTHOR

=over 4

@@AUTHOR_NEKYO@@

@@AUTHOR_PYUKI@@

=back

=head1 LICENSE

@@LICENSE_NEKYO@@

=cut

=cut
