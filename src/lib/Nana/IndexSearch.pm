######################################################################
# @@HEADER3_NANAMI@@
######################################################################

package Nana::Kana;
use strict;
use integer;
use Exporter;
use vars qw($VERSION);
$VERSION="0.1";

# http://chalow.net/2006-02-25-4.html			# comment
# http://chalow.net/2006-09-24-3.html			# comment

$Kana::EUCPRE = qr{@@exec="./build/search_eucpre.regex"@@};
$Kana::EUCPOST = qr{@@exec="./build/search_eucpost.regex"@@};

# euc			# comment
my %kana_table=(
@@include="./build/list_hiragana_euc.txt"@@
);

sub new {
	my($class,%hash)=@_;
	my $ret;
	my $method;
	my $obj;
	if(&load_module("MeCab")) {
		$method="MeCab";
		$obj=new MeCab::Tagger ("");
	} elsif(&load_module("Text::MeCab")) {
		$method="Text::MeCab";
		$obj=Text::MeCab->new();
	}
	my $code=lc $hash{code}=~/utf8/ || $hash{code}=~/utf-8/ ? "utf8"
		   : lc $hash{code}=~/euc/ ? "euc"
		   : lc $hash{code}=~/sjis/ ? "sjis"
		   : "euc";

	return bless {
		method=>$method,
		obj=>$obj,
		code=>$code
	}, $class;
}

sub parse {
	my ($self, $text)=@_;

	# $::defaultcode -> $self->{code}		# comment
	if($::defaultcode ne $self->{code}) {
		$text=&code_convert(\$text, $self->{code}, $::defaultcode);
	}
	if($self->{method} eq "MeCab") {
		return $self->{obj}->parseToNode($text);
	} elsif($self->{method} eq "Text::MeCab") {
		return $self->{obj}->parse($text);
	}
}

sub yomi1{
	my ($self, $text)=@_;
	my $buf;

	if($self->{method} eq "MeCab") {
	# $self->{code} -> euc			# comment
		my $array=$self->parse($text);
		while ($array = $array->{next}) {
			my $now=$array->{feature};
			$now=&code_convert(\$now, "euc", $self->{code});
			my ($r1, $r2, $r3, $r4, $r5, $r6, $word, $yomi1, $yomi2)
				=split(/,/,$now);
			my $w=$array->{surface};
			my $r;
			foreach(keys %kana_table) {
				$w=~s/$Kana::EUCPRE($kana_table{$_})$Kana::EUCPOST/$_/g;
				$r.="$_|";
			}

			$r=~s/\|$//g;
			my $chr;
			if($w=~/^([A-Z])*$/) {
				$chr=$w;
			} elsif($word ne "*") {
				$chr= $yomi1;
			} else {
				$chr= $yomi1;
			}
			if($chr eq "") {
				$chr=$w;
			}
			$buf.=$chr;
		}
	} else {
		# $self->{code} -> euc			# comment
		for ( my $array = $self->parse($text); $array; $array = $array->next ) {
			my $now=$array->feature;
			$now=&code_convert(\$now, "euc", $self->{code});
			my ($r1, $r2, $r3, $r4, $r5, $r6, $word, $yomi1, $yomi2)
				=split(/,/,$now);
			my $w=$array->surface;
			my $r;
			foreach(keys %kana_table) {
				$w=~s/$Kana::EUCPRE($kana_table{$_})$Kana::EUCPOST/$_/g;
				$r.="$_|";
			}

			$r=~s/\|$//g;
			my $chr;
			if($w=~/^([A-Z])*$/) {
				$chr=$w;
			} elsif($word ne "*") {
				$chr= $yomi1;
			} else {
				$chr= $yomi1;
			}
			if($chr eq "") {
				$chr=$w;
			}
			$buf.=$chr;
		}
	}
	#  euc -> $::defaultcode			# comment
	$buf=&code_convert(\$buf, $::defaultcode, "euc");
	$buf;
}

sub idx {
	my ($self, $text)=@_;
	# $::defaultcode -> euc				# comment
	$text=&code_convert(\$text, "euc", $::defaultcode);

	foreach(keys %kana_table) {
		$text=~s/$Kana::EUCPRE($kana_table{$_})$Kana::EUCPOST/$_/g;
	}
	foreach(keys %kana_table) {
		if(substr($text, 0, length($_)) eq $_) {
			if(/^[A-Z]$/) {
				return $_;
			}
			my $chr=(split(/\|/,$kana_table{$_}))[0];
			#   euc -> $::defaultcode	# comment
			my $txt=&code_convert(\$chr, $::defaultcode, "euc");
			return $txt;
		}
	}
	return "";
}

sub load_module {
	my $funcp = $::functions{"load_module"};
	return &$funcp(@_);
}

sub code_convert {
	my $funcp = $::functions{"code_convert"};
	return &$funcp(@_);
}

1;
__END__

=head1 NAME

Nana::Kana - Kanji Kana convert module

=head1 SEE ALSO

=over 4

=item PyukiWiki CVS

L<@@CVSURL@@/PyukiWiki-Devel/lib/Nana/Kana.pm>

=back

=head1 AUTHOR

=over 4

@@AUTHOR_NANAMI@@

@@AUTHOR_PYUKI@@

=back

=head1 LICENSE

@@LICENSE_NANAMI@@

=cut
