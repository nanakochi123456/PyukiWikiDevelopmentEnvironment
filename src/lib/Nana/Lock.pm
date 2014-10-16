######################################################################
# @@HEADER3_NANAMI@@
######################################################################
#
# ��莁��rename�t�@�C�����b�N�ɑ΂��āA�ȉ��̉��Ǔ_������܂��B
# �E�f�B���N�g�����g��Ȃ�
#   �S�̃��b�N�ł͂Ȃ��A�e�t�@�C���Ń��b�N
#
# YukiWikiDB����A�ȉ��̉��Ǔ_������܂��B
# �Elock�֌W�����ʉ��ł���悤�ɁA�t�@�C���ǂݏ��������̃t�@�C����
#
# from http://www.din.or.jp/~ohzaki/perl.htm#File_Lock
#
######################################################################

package	Nana::Lock;
use 5.005;
use strict;
use integer;
use Exporter;
use vars qw($VERSION);
$VERSION = '0.2';

$Nana::Lock::DEBUG=0;						# debug
# ���P�ɂ���ƃ��b�N�֌W�̃��b�Z�[�W���ł܂�# debug
# error										# debug
sub die {									# debug
	$::debug.="Nana::Lock:Error:$_[0]\n";	# debug
	return undef;							# debug
}											# debug
# message									# debug
sub msg {									# debug
	$::debug.="Nana:Lock:$_[0]\n"			# debug
		if($Nana::Lock::DEBUG eq 1);		# debug
}											# debug

$Nana::Lock::LOCK_SH=1;
$Nana::Lock::LOCK_EX=2;
$Nana::Lock::LOCK_NB=4;
$Nana::Lock::LOCK_DELETE=128;

# rename lock idea
# http://www.din.or.jp/~ohzaki/perl.htm#File_Lock
# ���b�N�t�@�C���̌`��															# debug
# (���t�@�C�����ŕs�v����������������).(method).(pid).(time).lk					# debug
#       0 : ���b�N���Ȃ��B�ȗ����̃f�t�H���g									# debug
#       1 : (LOCK_SH) ���L���b�N�C���g���C����									# debug
#       2 : (LOCK_EX) �r�����b�N�C���g���C����									# debug
#       5 : (LOCK_SH|LOCK_NB) ���L���b�N�C���g���C�Ȃ�							# debug
#       6 : (LOCK_EX|LOCK_NB) �r�����b�N�C���g���C�Ȃ�							# debug
#       8 : (LOCK_UN) �g��Ȃ����ƁB											# debug
#     128 : (LOCK_DELETE) ���b�N�t�@�C���̍폜									# debug

sub lock {
	my $timeout=5;
	my $trytime=2;

	my($fname,$method)=@_;
	# �f�B���N�g���A�t�@�C�����A�g���q�𕪗�									# debug
	my($d,$f,$e)=$fname=~/(.*)\/(.+)\.(.+)$/;
	# �t�@�C��������L���炵�����̂�����(�Z�����邽��)							# debug
	$f=~s/[.%()[]:*,_]//g;
	# �����n���h���̍쐬														# debug
	my %lfh=(
		dir=>$d,
		basename=>$f,
		timeout=>$timeout,
		trytime=>($method & $Nana::Lock::LOCK_NB ? 0 : $trytime),
		fname=>$fname,
		method=>$method & 3,
		path=>"$d/$f.lk"
	);
	# ���b�N�t�@�C���̍폜									# debug
	if($method eq $Nana::Lock::LOCK_DELETE) {
		return &lock_del(%lfh);
	}
	# method�����������ꍇreturn							# debug
	if($lfh{method} eq 0) {									# debug
		&msg("lock error:$fname $lfh{method} - $method");	# debug
		return;												# debug
	}														# debug
	return if($lfh{method} eq 0);

	for(my $i=0; $i < $lfh{trytime}*10; $i++) {
		# ���b�N���\�b�h�A�v���Z�XID�A���ݎ�������										# debug
		$lfh{current}=sprintf("%s/%s.%x.%x.%x.%d.lk"
			,$lfh{dir},$lfh{basename},$lfh{method},$$,time);
		# ���b�N�A�������͐���I��															# debug
		if(rename($lfh{path},$lfh{current})) {												# debug
			&msg(sprintf("%s:%s->%s"														# debug
				,($lfh{method} eq 1 ? 'LOCK_SH' : 'LOCK_EX'), $lfh{path},$lfh{current}));	# debug
			return \%lfh;																	# debug
		}																					# debug
		return \%lfh if(rename($lfh{path},$lfh{current}));

		# �ߋ��̃��b�N�t�@�C��������														# debug
		my @filelist=&lock_getdir(%lfh);
		my @locklist=();
		my $fcount=0;
		my $excount=0;
		my $shcount=0;
		foreach (@filelist) {
			if (/^$lfh{basename}\.(\d)\.(.+)\.(.+)\.lk$/) {
				push(@locklist,"$1\t$2\t$3");
				$fcount++;
				$shcount++ if($1 eq 1);
				$excount++ if($1 eq 2);
				&msg(sprintf("Found:%s.%s.%s.%s.lk(method=%d,all=%d,ex=%d,sh=%d)"			# debug
					,$lfh{basename},$1,$2,$3,$lfh{method},$fcount,$excount,$shcount));		# debug
			}
		}
		# ���b�N�t�@�C�������݂��Ȃ���ΐV�K�쐬											# debug
		if($fcount eq 0) {
			&msg("Create $lfh{path}");														# debug
			open(LFHF,">$lfh{path}");# or return undef;
			close(LFHF);
			next;
		# ���L���b�N�̏ꍇ																	# debug
		} elsif($lfh{method} eq 1) {
			# �r�������݂��Ȃ��ꍇ															# debug
			&msg("SH Lock Check $lfh{basename}");											# debug
			if($shcount > 0 && $excount eq 0) {
				# �P�`���C�X���āA���l�[������											# debug
				foreach(@locklist) {
					my($method,$pid,$time)=split(/\t/,$_);
					my $orgf=sprintf("%s/%s.%x.%s.%s.lk"
						,$lfh{dir},$lfh{basename},$method,$pid,$time);
					&msg("new fn=$orgf");													# debug
					# �ă��b�N																# debug
					if(rename($orgf,$lfh{current})) {										# debug
						&msg(sprintf("%s:%s->%s"											# debug
							,"LOCK_SH",$orgf,$lfh{current}));								# debug
						return \%lfh;														# debug
					}																		# debug
					return \%lfh if(rename($orgf,$lfh{current}));
				}
			}
		}
		# �r���ł���or�ُ펞																# debug
		# 0.1�b��sleep�A�g���Ȃ����1�b														# debug
		eval("select undef, undef, undef, 0.1;");
		if($@) {
			sleep 1;
			$i+=9;
			&msg("waiting 1sec count $i");													# debug
		} else {																			# debug
			&msg("waiting 0.1sec count $i");												# debug
		}
	}
	# �Ď��s�I��																			# debug
	# �ߋ��̃��b�N�t�@�C��������															# debug
	my @filelist=&lock_getdir(%lfh);
	foreach (@filelist) {
		if (/^$lfh{basename}\.(\d)\.(.+)\.(.+)\.lk$/) {
			# �^�C���A�E�g���Ă���̂����݂�����											# debug
			if (time - hex($3) > $lfh{timeout}) {
				my $orgf=sprintf("%s/%s.%s.%s.%s.lk"
					,$lfh{dir},$lfh{basename},$1,$2,$3);
				if(rename($orgf,$lfh{current})) {											# debug
					&msg(sprintf("%s:%s->%s"												# debug
						,"FORCE_LOCK",$orgf,$lfh{current}));								# debug
					return \%lfh;															# debug
				}																			# debug
				return \%lfh if(rename($orgf,$lfh{current}));
			}
		}
	}
	&msg("lock:can't lock");																# debug
	return undef;
}

sub unlock {
	if(rename($_[0]->{current}, $_[0]->{path})) {											# debug
		&msg("LOCK_UN" . $_[0]->{current} . "->" . $_[0]->{path});							# debug
	}																						# debug
	rename($_[0]->{current}, $_[0]->{path});
}

sub lock_del {
	my(%lfh)=@_;
	unlink($lfh{path});
	&msg("LOCK_DELETE: $lfh{path}");							# debug
	my @filelist=&lock_getdir(%lfh);
	foreach (@filelist) {
		if (/^$lfh{basename}\.(\d)\.(.+)\.(.+)\.lk$/) {
			unlink($_);
			&msg("LOCK_DELETE: $_");							# debug
		}
	}
}

sub lock_getdir {
	my(%lfh)=@_;
	opendir(LOCKDIR, $lfh{dir});
	my @filelist = readdir(LOCKDIR);
	closedir(LOCKDIR);
	return @filelist;
}

1;
__END__

=head1 NAME

Nana::Lock - Rename file lock module

=head1 SEE ALSO

=over 4

=item PyukiWiki CVS

L<@@CVSURL@@/PyukiWiki-Devel/lib/Nana/Lock.pm>

=item perl file lock how to

L<http://www.din.or.jp/~ohzaki/perl.htm#File_Lock>

=back

=head1 AUTHOR

=over 4

@@AUTHOR_NANAMI@@

@@AUTHOR_PYUKI@@

=back

=head1 LICENSE

@@LICENSE_NANAMI@@

=cut
