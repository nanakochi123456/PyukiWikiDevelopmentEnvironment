######################################################################
# @@HEADERPLUGIN_NANAMI@@
######################################################################
# xrea.com�ѹ���Хʡ����ϥץ饰����
#
# ������ˡ
#
# index.cgi �� index.xcg �� ��ĥ�� xcg ���ѹ����ޤ���
# (.cgi�ξ��ϡ�����ư�����ˤʤ�ޤ�)
# 
# �ȼ��ɥᥤ������ꤷ�Ƥ��ʤ����
# &xrea([left][center][right]);
# xrea.com�Υ����С��Ǥ���С���ưŪ�˽��Ϥ��ޤ���
# 
# �ȼ��ɥᥤ������ꤷ�Ƥ�����
# ��xrea�������̤ǡ�����HTML���ǧ���ơ����󥵥֥ɥᥤ����ǧ���ޤ���
# ��&xrea([left][center][right],username.s??.xrea.com);
#  xrea.com�Υ����С��Ǥ���С���ưŪ�˽��Ϥ��ޤ���
#
# ���
# ������֤ϡ�ɬ����1280x1024�ԥ�����β��̤Ǹ��ƥ������뤹��ɬ��
# �ʤ����֡פ�ɽ������褦�ˤ��Ʋ�������
# http://sb.xrea.com/showthread.php?t=10009
#
# ":Header" �ڡ��������������ɤ��Ǥ��礦��
#
# xrea+����ͭ�������С��ξ��ϡ�������Ϥ����פǤ���
#
# �ռ���''ư������å��Τ��������''̵���ǥ��ڡ������ߤ���ĺ��
# �ޤ��� xrea.com�ͤ˴����פ��ޤ���
######################################################################

$PLUGIN="xrea";
$VERSION="1.1";

use strict;
package xrea;

sub plugin_block {
	return &plugin_inline;
}

sub plugin_inline {
	my $body;
	my $hostname;
	my @args = split(/,/, shift);
	my $div=$args[0];
	if($args[1] ne '') {
		$hostname=$args[1];
		if($hostname!~/xrea\.com$/) {
			return qq(<strong>xrea.pl error!</strong> '$hostname' not allowed<br />);
		}
		if($ENV{SERVER_ADMIN}!~/xrea\.com$/ || $ENV{SCRIPT_FILENAME}!~/\.xcg$/) {
			return ' ';
		}
	} else {
		$hostname=$ENV{HTTP_HOST};
		if($ENV{SERVER_NAME}!~/xrea\.com$/ || $ENV{SCRIPT_FILENAME}!~/\.xcg$/) {
			return ' ';
		}
	}
	$body=<<EOM;
@{[$div eq '' ? '' : qq(<div align="$div">)]}
<script type="text/javascript" src="http://imgj.xrea.com/xa.j?site=$hostname"></script>
<noscript><iframe height="60" width="468" frameborder="0" marginheight="0" marginwidth="0" scrolling="no" allowtransparency="true" src="http://img.xrea.com/ad_iframe.fcg?site=$hostname"><a href="http://img.xrea.com/ad_click.fcg?site=$hostname" target="_blank"><img src="http://img.xrea.com/ad_img.fcg?site=$hostname" border="0" alt="xreaad"></a></iframe></noscript>
@{[$div eq '' ? '' : qq(</div>)]}
EOM
	return $body;
}

sub plugin_usage {
	return {
		name => 'xrea',
		version => '1.0',
		author => 'Nanami <http://www.daiba.cx/>',
		syntax => '&xrea(your hostname);',
		description => 'xrea.com AD plugin.',
		example => '&xrea(your hostname);',
	};
}

1;
__END__

=head1 NAME

xrea.pl - PyukiWiki / YukiWiki Plugin

=head1 WARNING

=over 4

=item CANNOT UNDERSTAND JAPANESE, MUST NOT USE THIS PLUGIN!!

From xrea.com

 The minimum qualification conditions...
 He lives in Japan, and understands Japanese, and it can respond.

=item Visit to xrea.com (Japanese)

L<http://xrea.com/>

=back

=head1 SYNOPSIS

 &xrea;
 #xrea
 &xrea(align, xrea's your subdomain);

=head1 DESCRIPTION

In the free rental server of xrea.com, an advertising banner is displayed on arbitrary positions.

=head1 USAGE

Please look at the upper part of the page of a plugin file or japanese pod file.

=head1 SEE ALSO

=over 4

=item PyukiWiki/Plugin/Nanami/xrea

L<@@BASEURL@@/PyukiWiki/Plugin/Nanami/xrea/>

=item PyukiWiki CVS

L<@@CVSURL@@/PyukiWiki-Devel/plugin/xrea.pl>

=back

=head1 AUTHOR

=over 4

@@AUTHOR_NANAMI@@

@@AUTHOR_PYUKI@@

=back

=head1 LICENSE

@@LICENSE_NANAMI@@

=cut
