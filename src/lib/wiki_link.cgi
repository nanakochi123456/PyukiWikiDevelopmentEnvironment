######################################################################
# @@HEADER1@@
######################################################################

=head1 NAME

wiki_link.cgi - This is PyukiWiki, yet another Wiki clone.

=head1 SEE ALSO

=over 4

=item PyukiWiki/Dev/Specification/wiki_link.cgi

L<@@BASEURL@@/PyukiWiki/Dev/Specification/wiki_link.cgi/>

=item PyukiWiki CVS

L<@@CVSURL@@/PyukiWiki-Devel/lib/wiki_link.cgi>

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

=head2 make_link

=over 4

=item ������

&make_link(��Ф��줿�����);

=item ����

����󥯤����Ѵ����줿HTML

=item �����С��饤��

��

=item ����

��󥯤��������롣

=back

=cut

sub _make_link {
	my ($chunk)=@_;
	my $res;
	my $orgchunk=$chunk;
	my $target = qq( target="_blank");

	# add v0.2.1 follow control #comment
	my $follow;#nocompact
	my $followtag;#compact
	my $followtag=$::followtag_pub;#nocompact
#nocompact
	if($chunk=~/$::isurl/) {#nocompact
		$followtag=qq( rel="nofollow");#nocompact
	} else {#nocompact
		$followtag=qq( rel="follow");#nocompact
	}#nocompact
#nocompact
	if($chunk=~/\s([FfNn])\]\]$/) {#nocompact
		$follow=$1;#nocompact
		$chunk=~s/\s([FfNn])\]\]$/\]\]/g;#nocompact
	}#nocompact
	if(lc $follow eq "f") {#nocompact
		$followtag=qq( rel="follow");#nocompact
	} elsif(lc $follow eq "n") {#nocompact
		$followtag=qq( rel="nofollow");#nocompact
	}#nocompact

#	# bug fix 0.1.8											# comment
#	if ($chunk =~ /^(https?|ftp):/) {						# comment
# fix 0.2.0													# comment
	if ($chunk =~ /^$::isurl/ && $chunk =~ /\.$::image_extention$/o) {
		if (&exist_plugin('img') == 1) {
			$res = &plugin_img_convert("$chunk,module");
			return $res if ($res ne '');
		}
#		return qq(<a href="$chunk"$target>$chunk</a>);		# comment

# ���ס� v0.2.0												# comment
#	} elsif ($chunk =~ /^$interwiki_definition2$/) {		# comment
##	if ($chunk =~ /^$interwiki_definition2$/) {				# comment
#		my $value = <<EOM;									# comment
#<span class="InterWiki">@{[&make_link_target($1, $2, $target, "", "", $followtag)]}</span>	# comment
#EOM														# comment
#		return $value;										# comment

	# ����饤��ץ饰����									# comment
	} elsif ($chunk =~ /^$embedded_inline/o) {
		if($::usePukiWikiStyle eq 1) {
			return &embedded_inline($chunk,2);
		} else {
			return &embedded_inline($chunk);
		}
	}
	my $escapedchunk=&unarmor_name($chunk);
	$chunk=&unescape($escapedchunk);
	# url													# comment
	if ($chunk =~ /^$::isurl$/o) {
		my $tmp=&make_link_urlhref($chunk);
		if ($use_autoimg and $chunk =~ /\.$::image_extention$/o) {
			return &make_link_url("url",$tmp,$tmp,$tmp, "", "", $followtag);
		} else {
			return &make_link_url("url",$tmp,$tmp, "", "", "", $followtag);
		}
	}
	# [[intername:wiki#anchor]]								# comment
	if ($chunk!~/>/ && $chunk =~ /^$interwiki_name2$/o && $chunk!~/$::isurl|$ismail/o) {
		my $chunk1=&make_link_interwiki($1,$2,$3,$escapedchunk, $followtag);
		return $chunk1 if($chunk1 ne '');
	# [[intername:wiki]]									# comment
	} elsif ($chunk!~/>/ && $chunk =~ /^$interwiki_name1$/o && $chunk!~/$::isurl|$ismail/o) {
		$escapedchunk=&make_link_interwiki($1,$2,$escapedchunk, "", $followtag);
		return $chunk1 if($chunk1 ne '');
	}
 	if($chunk!~/>/ && $chunk=~/$ismail/o) {
		# mailto:mail@address								# comment
	 	if($chunk=~/([Mm][Aa][Ii][Ll][Tt][Oo]):$::ismail/o) {
			$chunk=~s/[Mm][Aa][Ii][Ll][Tt][Oo]://g;
			return &make_link_mail($chunk,$escapedchunk);
		}
		# [[mail@address]]									# comment
	 	if($chunk=~/^$::ismail$/o) {
			return &make_link_mail($chunk,$escapedchunk);
		}
	}
	# [[name>alias]]										# comment
	if($chunk=~/^([^>]+)>(.+)$/) {
		$escapedchunk=$1;
		my $chunk2=&htmlspecialchars($2);
		#[[http://some/image.(gif|png|jpe?g)>???]]			# comment
		if ($use_autoimg && $escapedchunk=~/$::isurl/o && $escapedchunk =~ /\.$::image_extention$/o) {
			my $chunkurl;
			my $alt;
			# v0.2.0 image alt plus							# comment
			if($chunk2=~/^(.+)\,(.+)$/) {
				$chunkurl=$1;
				$alt=$2;
				$escapedchunk=&make_link_image(&htmlspecialchars($escapedchunk),&htmlspecialchars($alt));
				$chank2=$chankurl;
			} else {
				$escapedchunk=&make_link_image(&htmlspecialchars($escapedchunk));
			}
			# v0.2.0 image alt plus							# comment
			if($alt ne '') {
				return &make_link_url("link",$chunkurl,$escapedchunk,'','',$alt, $followtag);
			}
		} else {
			$escapedchunk=&htmlspecialchars($escapedchunk);
		}
		# v0.1.7 http & mailto swap							# comment
		# [[name>http://url/]]								# comment
		if($chunk2=~/$::isurl/o) {
			return &make_link_url("link",$chunk2,$escapedchunk, "", "", "", $followtag);
		# [[name>mailto:mail@address]] or [[name>mail@address]]	# comment
		} elsif($chunk2=~/$ismail/o) {
		 	if($chunk2=~/([Mm][Aa][Ii][Ll][Tt][Oo]):$ismail/o) {
				$chunk2=~s/[Mm][Aa][Ii][Ll][Tt][Oo]://g;
			}
			return &make_link_mail($chunk2,$escapedchunk);
		# [[name>intername:wiki#anchor]]					# comment
		} elsif($chunk2=~/^$interwiki_name2$/o) {
			my $chunk1=&make_link_interwiki($1,$2,$3,$escapedchunk, $followtag);
			return $chunk1 if($escapedchunk ne '');
		# [[name>intername:wiki]]							# comment
		} elsif($chunk2=~/^$interwiki_name1$/o) {
			my $chunk1=&make_link_interwiki($1,$2,$escapedchunk, "", $followtag);
			return $chunk1 if($escapedchunk ne '');
		} elsif($chunk=~/^$::isurl/o) {
			if ($use_autoimg and $escapedchunk =~ /\.$::image_extention$/o) {
				return &make_link_url("image",$chunk,$chunk,$escapedchunk, "", "", $followtag);
			} else {
				return &make_link_url("url",$chunk,$chunk, "", "", "", $followtag);
			}
		}
	}
	# [[name:alias]]										# comment
	if($chunk=~/^(.+?):(.+)$/ && $chunk!~/^file/) {
		$escapedchunk=$1;
		my $chunk2=$2;
		if ($use_autoimg && $escapedchunk=~/$::isurl/o && $escapedchunk =~ /\.$::image_extention$/o) {
			my $chunkurl;
			my $alt;
			# v0.2.0 image alt plus, separater is [,]				# comment
			if($chunk2=~/^(.+)\,(.+)$/) {
				$chunkurl=$1;
				$alt=$2;
				$escapedchunk=&make_link_image(&htmlspecialchars($escapedchunk),&htmlspecialchars($alt));
				$chank2=$chankurl;
			} else {
				$escapedchunk=&make_link_image(&htmlspecialchars($escapedchunk));
			}
		# v0.2.0 image alt plus										# comment
			if($alt ne '') {
				return &make_link_url("link",$chunkurl,$escapedchunk,'','',$alt, $followtag);
			}
		} else {
			$escapedchunk=&htmlspecialchars($escapedchunk);
		}
		# [[name>mailto:mail@address]] or [[name>mail@address]]	# comment
		if($chunk2=~/$ismail/o) {
		 	if($chunk2=~/([Mm][Aa][Ii][Ll][Tt][Oo]):$ismail/o) {
				$chunk2=~s/[Mm][Aa][Ii][Ll][Tt][Oo]://g;
			}
			return &make_link_mail($chunk2,$escapedchunk);
		# [[name>http://url/]]								# comment
		} elsif($chunk2=~/$::isurl/o) {
			return &make_link_url("link",$chunk2,$escapedchunk, "", "", "", $followtag);
		# [[name>intername:wiki#anchor]]					# comment
		} elsif($chunk2=~/^$interwiki_name2$/o) {
			my $chunk1=&make_link_interwiki($1,$2,$3,$escapedchunk, $followtag);
			return $chunk1 if($escapedchunk ne '');
		# [[name>intername:wiki]]							# comment
		} elsif($chunk2=~/^$interwiki_name1$/o) {
			my $chunk1=&make_link_interwiki($1,$2,$escapedchunk, "", $followtag);
			return $chunk1 if($escapedchunk ne '');
		} elsif($chunk=~/^$::isurl/o) {
			if ($use_autoimg and $escapedchunk =~ /\.$::image_extention$/o) {
				return &make_link_url("image",$chunk,$chunk,$escapedchunk, "", "", $followtag);
			} else {
				return &make_link_url("url",$chunk,$chunk, "", "", "", $followtag);
			}
		}
	}

	# [[name>alias]] -> [[name:alias]]						# comment
	if($chunk=~/^(.+?)>(.+?)$/) {
		$chunk=$2;
		$escapedchunk = &htmlspecialchars($1);
	} elsif($chunk=~/^(.+?):(.+?)$/) {
		$chunk=$2;
		$escapedchunk = &htmlspecialchars($1);
	}

	# local wiki page										# comment
	return &make_link_wikipage(get_fullname($chunk, $::form{mypage}),$escapedchunk, $followtag);
}

=lang ja

=head2 make_link_wikipage

=over 4

=item ������

&make_link_wikipage(�����, ɽ��ʸ���� [, �ե�������);

=item ����

HTML

=item �����С��饤��

��

=item ����

wiki�ڡ����ؤΥ�󥯤��������롣

=back

=cut

sub _make_link_wikipage {
	my($chunk1,$escapedchunk, $followtag)=@_;
	my($chunk,$anchor)=$chunk1=~/^([^#]+)#?(.*)/;
	my $cookedchunk  = &encode($chunk);
	my $cookedurl=&make_cookedurl($cookedchunk);

	if (&is_exist_page($chunk)) {
		if($anchor eq '') {
			return qq(<a title="$chunk" href="$cookedurl"$followtag>$escapedchunk</a>);
		} else {
			return qq(<a title="$chunk" href="$cookedurl#$anchor"$followtag>$escapedchunk</a>);
		}
	} elsif (&is_editable($chunk)) {
		# 2005.10.27 pochi: ��ư��󥯵�ǽ���ĥ			# comment
		if ($::editchar eq 'this') {
			return qq(<a title="$::resource{editthispage}" class="editlink" href="$::script?cmd=edit&amp;mypage=$cookedchunk" rel="nofollow">$escapedchunk</a>);
		} elsif ($::editchar) {
			# original
			return qq($escapedchunk<a title="$::resource{editthispage}" class="editlink" href="$::script?cmd=edit&amp;mypage=$cookedchunk" rel="nofollow">$::editchar</a>);
		}
	}
	return $escapedchunk;
}

=lang ja

=head2 make_link_interwiki

=over 4

=item ������

&make_link_interwiki($intername, $keyword, $anchor,$escapedchunk [, �ե�������]);

=item ����

���HTML

=item �����С��饤��

��

=item ����

InterWiki�Υ�󥯤��������롣

=back

=cut

sub _make_link_interwiki {
	my ($intername, $keyword, $anchor,$escapedchunk, $followtag) = @_;
	if($escapedchunk eq '') {
		$escapedchunk=$anchor;
		$anchor="";
	}
	$intername=~tr/A-Z/a-z/;
	if(exists $::interwiki2{$intername}) {
		my ($code, $url) = %{$::interwiki2{$intername}};
		if($url=~/\$1/) {
			$url =~ s/\$1/&interwiki_convert($code, $keyword)/e;
		} else {
			$url.=&interwiki_convert($code, $keyword);
		}
		$url = &htmlspecialchars($url.$anchor);
		return &make_link_url("interwiki",$url,$escapedchunk, "", "", "", $followtag);
	} else {
		my $remoteurl = $::interwiki{$intername};
		if ($remoteurl) {
			$remoteurl =~
			 s/\b(utf8|euc|sjis|ykwk|asis)\(\$1\)/&interwiki_convert($1, $localname)/e;
			return &make_link_url("interwiki",$remoteurl,$escapedchunk, "", "", "", $followtag);
		}
	}
}

=lang ja

=head2 make_cookedurl

=over 4

=item ������

&make_cookedurl(URL���������פ��줿�����);

=item ����

�����URL

=item �����С��饤��

��

=item ����

wiki�ڡ����ؤΥ�������Ϥ��롣

=back

=cut

sub _make_cookedurl {
	my($cookedchunk)=@_;
	return "$::script" . "?" . "$cookedchunk";
}

=lang ja

=head2 make_link_mail

=over 4

=item ������

&make_link_mail(�����, ɽ��ʸ����);

=item ����

���󥫡�̾(��ʸ����

=item �����С��饤��

��

=item ����

�᡼�륢�ɥ쥹�Υ�󥯤򤹤롣

=back

=cut

sub _make_link_mail {
	my($chunk,$escapedchunk)=@_;

	my $adr=$chunk;
	$adr=~s/^[Mm][Aa][Ii][Ll][Tt][Oo]://g;
	return qq(<a href="mailto:$adr" class="mail" rel="nofollow">$escapedchunk</a>);
}

=lang ja

=head2 make_link_url

=over 4

=item ������

&make_link_url(���饹, �����, ɽ��ʸ����, ����, �������å�, img����ɽ��ʸ���� [, �ե�������]);

=item ����

���HTML

=item �����С��饤��

��

=item ����

URL���󥯤��롣

=back

=cut

sub _make_link_url {
	my($class,$chunk,$escapedchunk,$img,$target,$alt, $followtag)=@_;
	my $chunk2=&make_link_urlhref($chunk);
	$target="_blank" if($target eq '');
	if($img ne '') {
		$class.=($class eq '' ? 'img' : '');
		return &make_link_target($chunk2,$class,$target,"", "", $followtag)
			. &make_link_image($img,$escapedchunk) . qq(</a>);
	}
	if($escapedchunk=~/^<img/) {
		return &make_link_target($chunk2,$class,$target,@{[$alt eq '' ? $chunk : $alt]}, "", $followtag)
			. qq($escapedchunk</a>);
	}
	return &make_link_target($chunk2,$class,$target,$escapedchunk, "", $followtag)
			. qq($escapedchunk</a>);
}

=lang ja

=head2 make_link_target

=over 4

=item ������

&make_link_target(�����, ���饹, �������å�, �����ȥ�ʸ���� [, �ݥåץ��åפ��뤫�ɤ����Υե饰] [, �ե�������]);

=item ����

���HTML

=item �����С��饤��

��

=item ����

�������åȤ����URL���󥯤��롣

=back

=cut

sub _make_link_target {
	my($url,$class,$target,$escapedchunk,$flag,$followtag)=@_;
	$flag=$::use_popup if($flag eq '');
	$class=&htmlspecialchars($class);
	$target=&htmlspecialchars($target);
	$escapedchunk=&htmlspecialchars($escapedchunk);
	my $popup_allow=$::setting_cookie{popup} ne '' ? $::setting_cookie{popup}
					: $flag+0 ? 1 : 0;
	my $target=$popup_allow != 0 ? $target : '';
	$target='' if($flag eq 2 && $url=~/ttp\:\/\/$ENV{HTTP_HOST}/);
	if($target ne '' && $flag eq 3) {
		my $tmp=$::basehref;
		$tmp=~s/\/.*//g;
		$target='' if($url=~/\Q$tmp/);
	}
	if($target eq '') {
		return qq(<a href="$url" @{[$class eq '' ? '' : qq(class="$class")]} title="$escapedchunk"$followtag>);
	} elsif($::is_xhtml) {
		return qq(<a href="$url" @{[$class eq '' ? '' : qq(class="$class")]} title="$escapedchunk"$followtag onclick="return ou(this.href, '@{[$target eq "_blank" ? "b" : $target]}');">);
	} else {
		return qq(<a href="$url" @{[$class eq '' ? '' : qq(class="$class")]} target="$target" title="$escapedchunk"$followtag>);
	}
}

=lang ja

=head2 make_link_urlhref

=over 4

=item ������

&make_link_urlhref(URL);

=item ����

URLʸ����

=item �����С��饤��

��

=item ����

URLʸ������������롣

=back

=cut

sub _make_link_urlhref {
	my($url)=@_;
	return &htmlspecialchars(
		&unescape(
			&unescape($url)
		)
	);
}

=lang ja

=head2 make_link_image

=over 4

=item ������

&make_link_image(������URL, ����);

=item ����

HTML

=item �����С��饤��

��

=item ����

������HTML����Ϥ��롣

=back

=cut

sub _make_link_image {
	my($img,$alt)=@_;
	$alt=&htmlspecialchars($alt);
	$img=&htmlspecialchars($img);
	$alt=$img if($alt eq '');
	return qq(<img src="@{[&make_link_urlhref($img)]}" alt="$alt" />);
}
1;
