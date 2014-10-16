######################################################################
# @@HEADER2_NANAMI@@
######################################################################
# This is extented plugin.
# To use this plugin, rename to 'google_analytics.inc.cgi'
######################################################################
#
# google-analytics.com �����ӥ��ˤ�롢�����ȥȥ�å��󥰥����ƥ�
#
# http://google-analytics.com/
#
# �Ȥ�����
#   ��google_analytics.inc.pl��google_analytics.inc.cgi�˥�͡���
#   ��info/setup.cgi ����Ͽ������������� (UA- �ǻϤޤ���) ��
#     $GOOGLEANALTYCS::ACCOUNT �ѿ��˥��åȤ��롣
#   �� ʣ���Υ��֥ɥᥤ�󤬤�����ϡ�
#     $GOOGLEANALTYCS::MULTISUB �� ��.example.com�פη����ǵ��ܤ��롣
#   ��ʣ���Υȥåץ�٥�ɥᥤ�󤬤����硢
#     $GOOGLEANALTYCS::MULTITOP=1 �򥻥åȤ��롣
#
# ��ա�
#   ����פǣ�����500���ӥ塼��Ķ����Ȳݶ⤬ȯ�����ޤ���
#
######################################################################

# UA- �ǻϤޤ륢������Ȥ����ꤹ�롣
$GOOGLEANALTYCS::ACCOUNT=""
	if($GOOGLEANALTYCS::ACCOUNT eq '');
#
# ʣ���Υ��֥ɥᥤ�󤬤��� ���ĤΥɥᥤ�󤬤����礽�Υɥᥤ�����ꤹ�롣
# example : [.example.com]
$GOOGLEANALTYCS::MULTISUB=""
	if($GOOGLEANALTYCS::MULTISUB eq "");
#
# ʣ���Υȥåץ�٥�ɥᥤ�󤬤����磱
$GOOGLEANALTYCS::MULTITOP=0
	if($GOOGLEANALTYCS::MULTITOP ne 0);
######################################################################
# Initlize											# comment

sub plugin_google_analytics_init {
	if($::form{cmd} eq "" || $::form{cmd} eq "read") {
		if($GOOGLEANALTYCS::ACCOUNT ne '') {
			my $header=<<EOM;
<script type="text/javascript"><!--
  var _gaq = _gaq || [];
  _gaq.push(['_setAccount', '$GOOGLEANALTYCS::ACCOUNT']);@{[$GOOGLEANALTYCS::MULTISUB ne '' ? "  _gaq.push(['_setDomainName', '$GOOGLEANALTYCS::MULTISUB']);\n" : ""]}@{[$GOOGLEANALTYCS::MULTITOP ne 0 ? "  _gaq.push(['_setDomainName', 'none']);\n  _gaq.push(['_setAllowLinker', true]);\n" : ""]}
  _gaq.push(['_trackPageview']);

  (function() {
    var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
    ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
    var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
  })();
//--></script>
EOM
			return ('init'=>1, 'header'=>$header);
		}
	}
	return ('init'=>0);
}

1;
__DATA__
sub plugin_google_analytics_setup {
	return(
		ja=>'�����ȥȥ�å��󥰥����ƥ� for google-analytics.com',
		en=>'Site Tracking System for google-analytics.com',
		url=>'@@BASEURL@@/PyukiWiki/Plugin/ExPlugin/google_analytics/'
	);
}
__END__

=head1 NAME

google_analytics.inc.pl - PyukiWiki Plugin

=head1 SYNOPSIS

Site Tracking System for google-analytics.com

=head1 DESCRIPTION

Site Tracking

=head1 USAGE

rename to google_analytics.inc.cgi

write info/setup.cgi to this value

$GOOGLEANALTYCS::ACCOUNT Account Name

if use multi subdomain, write domain of syntax [.example.com]

$GOOGLEANALTYCS::MULTISUB

if use multi top domain, set this value

$GOOGLEANALTYCS::MULTITOP=1;


=head1 OVERRIDE

none

=head1 SEE ALSO

=over 4

=item PyukiWiki/Plugin/ExPlugin/google_analytics

L<@@BASEURL@@/PyukiWiki/Plugin/ExPlugin/google_analytics/>

=item PyukiWiki CVS

L<@@CVSURL@@/PyukiWiki-Devel/lib/google_analytics.inc.pl>

=item Use This Service

L<http://google_analytics.com/>

=back

=head1 AUTHOR

=over 4

@@AUTHOR_NANAMI@@


@@AUTHOR_PYUKI@@

=back

=head1 LICENSE

@@LICENSE_NANAMI@@

=cut
