######################################################################
# @@HEADER1@@
######################################################################

=head1 NAME

wiki_http.cgi - This is PyukiWiki, yet another Wiki clone.

=head1 SEE ALSO

=over 4

=item PyukiWiki/Dev/Specification/wiki_http.cgi

L<@@BASEURL@@/PyukiWiki/Dev/Specification/wiki_http.cgi/>

=item PyukiWiki CVS

L<@@CVSURL@@/PyukiWiki-Devel/lib/wiki_http.cgi>

=back

=head1 AUTHOR

=over 4

@@AUTHOR_NEKYO@@

@@AUTHOR_NANAMI@@

@@AUTHOR_PYUKI@@

=back

=head1 LICENSE

@@LICENSE_NEKYO@@

=cut

=lang ja

=head2 content_output

=over 4

=item 入力値

&content_output(http_header, body of HTML);

=item 出力

標準出力

=item オーバーライド

可

=item 概要

CGIからのすべての出力をする。

=back

=cut

sub _content_output {
	my ($http_header,$body)=@_;
	$http_header=~s/\n\n/\n/g;
	$http_header=~s/\r\n\r\n/\r\n/g;
	print "$http_header\n";

	&load_module("Nana::HTMLOpt");
	if($::is_xhtml) {
		$body=Nana::HTMLOpt::xhtml($body);
	} else {
		$body=Nana::HTMLOpt::html($body);
	}

	&compress_output($body . &exec_explugin_last);
}

=lang ja

=head2 compress_output

=over 4

=item 入力値

&compress_output(HTML or XML etc...);

=item 出力

標準出力

=item オーバーライド

可

=item 概要

圧縮出力が有効な時は、圧縮出力をする。

=back

=cut

sub _compress_output {
	my($data)=shift;
	if($::gzip_exec eq 1) {
		&load_module("Nana::HTTPCompress");
		Nana::HTTPCompress::output($data);
	} else {
		print $data;
	}
}

=lang ja

=head2 http_header

=over 4

=item 入力値

出力するhttpヘッダ（配列）

=item 出力

httpヘッダ文字列

=item オーバーライド

可

=item 概要

httpヘッダの初期化をする。

=back

=cut

sub _http_header {
	my $http_header;
	my $nph_http_header;
	my $nph_http_header_first;

	foreach(@_) {
		$http_header.="$_\n";
	}
	$http_header=~s/\r//g;
	while($http_header=~/\n\n/) {
		$http_header=~s/\n\n/"\n"/ge;
	}
	$http_header=~s/\n$//g;
	$http_header.="\n";

	# nphスクリプトの場合、ヘッダを再構築する			# comment

	if($ENV{SCRIPT_NAME}=~/nph\-/) {
		my $cachecontrol=1;
		$ENV{SERVER_PROTOCOL}="HTTP/1.1" if($ENV{SERVER_PROTOCOL} eq '');
		$nph_http_header_first="$ENV{SERVER_PROTOCOL} 200 OK";
		foreach(split(/\n/,$http_header)) {
			if(/^Status/) {
				s/Status:\s*//g;
				$nph_http_header_first="$ENV{SERVER_PROTOCOL} $_";
				if($_ eq 401) {
					$nph_http_header_first=~s/\n//g;
					$nph_http_header_first.=" Authorization Required\n";
				}
			} elsif(/^Last-Modified|^Cache|^Expire/) {
				$cachecontrol=0;
				$nph_http_header.="$_\n";
			} else {
				$nph_http_header.="$_\n";
			}
		}
		$http_header=$nph_http_header_first . "\n" . $nph_http_header;
		if($cachecontrol eq 1) {
#		#	$http_header.="Cache-Control: max-age=0\n";
			# changed 0.2.0-p4								# comment
			$http_header.=sprintf("Expires: %s\n", &http_date);
			$http_header.=sprintf("Date: %s\n", &http_date);
		}
		$http_header=~s/\n\n/\n/g;
	}

	# 改行コードを CRLFにする					# comment
	$http_header=~s/\x0D\x0A|\x0D|\x0A/\x0D\x0A/g;
	return "$http_header\x0D\x0A";
}
1;
