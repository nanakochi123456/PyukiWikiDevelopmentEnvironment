#!/usr/bin/perl
#!/usr/local/bin/perl --
#!c:/perl/bin/perl.exe
#!c:\perl\bin\perl.exe
#!c:\perl64\bin\perl.exe
######################################################################
# @@HEADERPLUGIN_NANAMI@@
######################################################################
# 2012/02/18 change: WMV���ʤ��Ƥ�MP4������а��ư���褦�ˤ�����
#                    ���ΰ١����åץ��ɻ��� MP4::Info��ɬ�פˤʤ�ޤ���
#                    IE�ǤΥݥåץ��åפ򳫤��Τ��٤��Τ���������
# 2012/02/14 change: �̥�����ɥ��򳫤��ʤ��Ƥ�Ф�⡼�ɤ����֤������ʦ��ǡ�
# 2012/02/13 change: JavaScript�ݥåץ��åפǥ�����ɥ����������ѹ�����褦��
#                    ������
#                    video.js��2.0.2����3.0.7�˥С�����󥢥åפ�����
# 2011/10/07 change: ʣ���Υ����Ȥ�ư�褬ʬ�����Ƥ��Ƥ��б��Ǥ���褦�ˤ�����
#                    ��������wmv������PyukiWiki��Ʊ�������Ȥ����֤��ʤ����
#                    �����ޤ��󤬡�mp4��flv���̥����Ȥ����֤��뤳�Ȥ�
#                    �Ǥ���褦�ˤʤä���
#                    ���ΥС������ˤ���ˤϡ�deletecache �򤹤�ɬ�פ����ꡢ
#                    ���ġ�FLV��MP4�ե������õ����硢�⤦���� deletecache
#                    �򤹤�ɬ�פ�����ޤ���
#                    ̵����zip�ʳ��ˤ⡢����WMV�ե�������������ɤǤ���
#                    �褦�ˤ������ʥǥե���Ȥ�̵����zip��
# 2011/10/05 change: HEAD�ꥯ�����Ȥ��Ѥ��ơ�WMV�ʳ��γ�ĥ�Ҥ�ư���
#                    PyukiWiki�����֤��Ƥ��륵���С��ʳ�������Ǥ���褦��
#                    �������ޤ���IE 9 �ˤ����ơ�video.js��̵����������
# 2011/10/02 change: HTML5�ץ쥤�䡼���б������ΰ١�HTML5�֥饦�����Ǥʤ�
#                    Flash�Ǻ���������ˡ�����MP4�ե����뤬ɬ�פˤʤ롣
#                    ���λ����Ѵ��ե����ޥåȤϡ�FlowPlayer��ǧ������褦��
#                    MPEG4 AVC/H.264�������Ѵ����ʤ���Фʤ�ʤ���
#                    �����Flash�Ǥκ����⥵�ݡ��Ȥ��Ƥ��ޤ�����IE10��
#                    �ǥ����ȥå��ǰʳ��ǥ��ݡ��Ȥ���ʤ��ʤ뤿�ᡢ�ߴ����ΰ٤�
#                    ���������Ϥ��Ƥ���ޤ���
#                    IE9���Զ��ǡ�IE9�ˤ����Ƥϡ�HTML5�ץ쥤�䡼�ϻ���
#                    �Ǥ��ʤ��褦�ˤʤäƤ��ޤ���
# 2011/09/11 change: �ǥե���ȤΥ�������ɤ߹����褦�ˤ�����
#                    FireFox�ǥ������ˤ��ư��Υ���ɤ���Τ��˻ߤ�����
#                    ���ꤷ�Ƥ�����������ɤǽ��ϤǤ���褦�ˤ�����
# 2011/06/12 change: flvư��ˤ��б���������������wmv��ɬ�פǤ���
# 2011/05/26 change: wmv�˥������դ����Ƥ����硢zip�ե�����Υ��������
#                    �ե�����̾�򤽤�̾���˻���Ǥ���褦�ˤ�����
# 2011/05/26 change: info/setup.cgi���б�����
# 2011/03/14 change: Content-disposition: attachment; filename="$file.wvx"
#                    ����Ϥ�������꤬�����ǽ�������뤿�ᡢ���Ϥ�
#                    ����������
# 2011/03/01 change: ��ĥ�Ҥ�wvx���ѹ�������
#                    Content-Type: video/x-ms-wvx ����Ϥ�����
#                    Content-disposition: attachment; filename="$file.wvx"
#                    ����Ϥ�����
# 2010/12/10 change: �˥��˥�ư����б�����
# 2010/11/13 change: ̵����zip�ǥ�������ɤǤ���褦�ˤ�����
#                    ���̤�ư�褬����Ȥ�����å��夫���������褦��
#                    ��������������ͭ�����¤ϣ����֤Ǥ���
# 2010/10/27 change: MSIE ��Opera�ʳ���Windwos Media�ץ쥤�䡼
#                    ��������_blank(�¼��̥��֡ˤˤʤ�褦�ˤ�����
#                    Safari�Ǥ�����������ˤʤ�ޤ���
# 2010/10/24 change: use sub make_link_target
######################################################################
# You MUST modify following initial file.
BEGIN {
	$::ini_file = "pyukiwiki.ini.cgi";
######################################################################
$PLUGIN="playvideo";
$VERSION="2.2a";

	$::_conv_start = (times)[0];

	$::ini_file = "pyukiwiki.ini.cgi" if($::ini_file eq "");
	require $::ini_file;
	require $::setup_file if (-r $::setup_file);

	push @INC, "$::sys_dir";
	push @INC, "$::sys_dir/CGI";
}

# If Windows NT Server, use sample it
#BEGIN {
#	chdir("C:/inetpub/cgi-bin/pyuki");
#	push @INC, "C:/inetpub/cgi-bin/pyuki/lib/";
#	push @INC, "C:/inetpub/cgi-bin/pyuki/lib/CGI";
#	push @INC, "C:/inetpub/cgi-bin/pyuki/";
#	$::_conv_start = (times)[0];
#}

$::defaultcode="utf8";#utf8
$::defaultcode="euc";#euc

require "$::plugin_dir/playvideo_v_cgi.pl";

__END__
=head1 NAME

v.cgi - PyukiWiki External Plugin of video player wrapper

=head1 SYNOPSIS

Playvideo Plugin

=head1 SEE ALSO

=over 4

=item PyukiWiki/Plugin/Nanami/playvideo/

L<@@BASEURL@@/PyukiWiki/Plugin/Nanami/playvideo/>

=item PyukiWiki CVS

L<@@CVSURL@@/PyukiWiki-Devel/v.cgi>

L<@@CVSURL@@/PyukiWiki-Devel/plugin/playvideo.inc.pl>

L<@@CVSURL@@/PyukiWiki-Devel/plugin/playvideo_v_cgi.pl>

=back

=head1 AUTHOR

=over 4

@@AUTHOR_NANAMI@@

@@AUTHOR_PYUKI@@

=back

=head1 LICENSE

@@LICENSE_NANAMI@@

=cut
