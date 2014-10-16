######################################################################
# @@HEADERPLUGIN_NANAMI@@
######################################################################
# xrea.com用広告バナー出力プラグイン
#
# 使用方法
#
# index.cgi を index.xcg 等 拡張子 xcg に変更します。
# (.cgiの場合は、広告自動挿入になります)
# 
# 独自ドメインを設定していない場合
# &xrea([left][center][right]);
# xrea.comのサーバーであれば、自動的に出力します。
# 
# 独自ドメインを設定している場合
# ・xrea管理画面で、広告HTMLを確認して、契約サブドメインを確認します。
# ・&xrea([left][center][right],username.s??.xrea.com);
#  xrea.comのサーバーであれば、自動的に出力します。
#
# 注意
# 広告位置は、必ず「1280x1024ピクセルの画面で見てスクロールする必要
# ない位置」に表示するようにして下さい。
# http://sb.xrea.com/showthread.php?t=10009
#
# ":Header" ページ等に入れると良いでしょう。
#
# xrea+等、有料サーバーの場合は、広告出力が不要です。
#
# 謝辞：''動作チェックのためだけに''無料でスペースを貸して頂き
# ました xrea.com様に感謝致します。
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
