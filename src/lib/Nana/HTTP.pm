######################################################################
# @@HEADER3_NANAMI@@
######################################################################

package	Nana::HTTP;
use 5.005;
use strict;
#use integer;
use Socket 1.3;
use Fcntl;
use Errno qw(EAGAIN);
use HTTP::Lite;

use vars qw($VERSION);
$VERSION = '0.910';

# 0:付属エンジン(HTTP::Lite) 1:LWPが存在すればLWP、なければ付属エンジン
$Nana::HTTP::useLWP=0;

# ユーザーエージェント
$Nana::HTTP::UserAgent="$::package/$::version \@\@";

# タイムアウト
$Nana::HTTP::timeout=2;

######################################################################

my $timeoutflag=0;

sub new {
	my ($class, %hash) = @_;
	my $self = {
		plugin => $hash{plugin},
		module => $hash{module},
		ua => $hash{ua},
		header => $hash{header},
		user => $hash{user},
		pass => $hash{pass},
		timeout => $hash{timeout},
	};
	$$self{lwp_ok}=0;
	if($Nana::HTTP::useLWP eq 1) {
		if(&load_module("LWP::UserAgent") && &load_module("HTTP::Headers")) {
			$$self{lwp_ua}=LWP::UserAgent->new;
			$$self{_ua} = &makeua($$self{lwp_ua}->_agent,%hash),
			$$self{_header} = "User-Agent: " . $$self{_ua} . $$self{header};
			$$self{lwp_ua}->agent($$self{_ua});
			$$self{lwp_ua}->timeout($hash{timeout} eq "" ? $Nana::HTTP::timeout : $hash{timeout});
			if($::proxy_host ne '') {
				foreach("http", "https", "ftp") {
					$$self{lwp_ua}->proxy($_,"http://$::proxy_host:$::proxy_port/")
				}
			}
			$$self{lwp_ok}=1;
		}
	}
	if($$self{lwp_ok} ne 1) {
		$$self{lwp_ok}=0;
		$$self{_ua} = &makeua("",%hash),
		$$self{_header} = "User-Agent: " . $$self{_ua} . $$self{header};
	}
	return bless $self, $class;
}

sub load_module {
	my $funcp = $::functions{"load_module"};
	return &$funcp(@_);
}

sub head {
	my($self, $uri)=@_;
	if($$self{lwp_ok} eq 1) {
		my $req;
		my $header=HTTP::Headers->new;
		if($$self{user} . $$self{pass} ne '') {
			$header->authorization_basic($$self{user},$$self{pass});
		}
		$header->header("User-Agent", $$self{_ua});
		$req=HTTP::Request->new("HEAD", $uri, $header);
		my $res=$$self{lwp_ua}->request($req);
		if($res->is_success) {
			return(0,$res->content);
		} else {
			return(1,$res->status_line);
		}
	}
	return &httpcl($$self{timeout}, $uri,"HEAD", $$self{_header});
}

sub get {
	my($self, $uri)=@_;
	if($$self{lwp_ok} eq 1) {
		my $req;
		my $header=HTTP::Headers->new;
		if($$self{user} . $$self{pass} ne '') {
			$header->authorization_basic($$self{user},$$self{pass});
		}
		$header->header("User-Agent", $$self{_ua});
		$req=HTTP::Request->new("GET", $uri, $header);
		my $res=$$self{lwp_ua}->request($req);
		if($res->is_success) {
			return(0,$res->content);
		} else {
			return(1,$res->status_line);
		}
	}
	return &httpcl($$self{timeout}, $uri,"GET", $$self{_header});
}

sub post {
	my($self, $uri, $postdata, $posthash)=@_;

	if($$self{lwp_ok} eq 1) {
		my $req;
		my $header=HTTP::Headers->new;
		if($$self{user} . $$self{pass} ne '') {
			$header->authorization_basic($$self{user},$$self{pass});
		}
		$header->header("User-Agent", $$self{_ua});
		$req=HTTP::Request->new("POST", $uri, $header);
		$req->content_type('application/x-www-form-urlencoded');
		$req->content($postdata);

		my $res=$$self{lwp_ua}->request($req);
		if($res->is_success) {
			return(0,$res->content);
		} else {
			return(1,$res->status_line);
		}
	}
	return &httpcl($$self{timeout}, $uri,"POST", $$self{_header}, $postdata, $posthash);
}

sub makeua {
	my($add,%self)=@_;
	my $ua;
	my $mods;
	if($self{ua} eq '') {
		$ua=$Nana::HTTP::UserAgent;
		if($self{plugin} ne '') {
			$mods=" Plugin $self{plugin};";
		} elsif($self{module} ne '') {
			$mods=" Module $self{module};";
		}
		$ua=~s/\@\@/$mods@{[$add ne '' ? " $add" : '']}/g;
	} else {
		$ua=$self{ua};
	}
	return "$::package/$::version ($::basehref $ua)";

}

sub httpcl {
	my($timeout, $url,$method,$header,$postdata, $posthash)=@_;
	my $stat;
	my $body;
	$timeout=$timeout eq "" ? $Nana::HTTP::timeout : $timeout;
	eval {
		local $SIG{ALRM}=sub { die "timeout" };
		alarm($timeout);
		my $http=new HTTP::Lite;
		$method="GET" if($method eq '');
		$http->method($method);
		$http->http11_mode(1);
		foreach(split(/\n/,$header)) {
			my($hn,$hv)=split(/:\s/,$_);
			$http->add_req_header($hn,$hv) if($_=~/:/);
		}
		if($::proxy_host ne '' && $::proxy_port > 0) {
			$http->proxy("http://$::proxy_host:$::proxy_port");

		}
		if($postdata ne '') {
			$http->{content}=$postdata;
		} elsif($posthash ne '') {
			$http->prepare_post($posthash);
		}
		my $req;
		if($postdata ne '') {
			$req=$http->request_sub($url);
		} else {
			$req=$http->request($url);
		}
		if($req eq 200) {
			$stat=0;
			$body=$http->body();
		} else {
			$stat=1;
			$body="Error $req";
		}
		alarm 0;
	};
	alarm 0;
	if($@) {
		if($@=~/timeout/) {
			return(1,"Timeout $url");
		}
	}
	return($stat,$body);
}

package HTTP::Lite;

my $CRLF = "\r\n";

sub request_sub
{
  my ($self, $url, $data_callback, $cbargs) = @_;

  my $method = $self->{method};
  if (defined($cbargs)) {
    $self->{CBARGS} = $cbargs;
  }

  my $callback_func = $self->{'callback_function'};
  my $callback_params = $self->{'callback_params'};

  # Parse URL
  my ($protocol,$host,$junk,$port,$object) =
    $url =~ m{^([^:/]+)://([^/:]*)(:(\d+))?(/.*)$};

  # Only HTTP is supported here
  if ($protocol ne "http")
  {
    warn "Only http is supported by HTTP::Lite";
    return undef;
  }

  # Setup the connection
  my $proto = getprotobyname('tcp');
  local *FH;
  socket(FH, PF_INET, SOCK_STREAM, $proto);
  $port = 80 if !$port;

  my $connecthost = $self->{'proxy'} || $host;
  $connecthost = $connecthost ? $connecthost : $host;
  my $connectport = $self->{'proxyport'} || $port;
  $connectport = $connectport ? $connectport : $port;
  my $addr = inet_aton($connecthost);
  if (!$addr) {
    close(FH);
    return undef;
  }
  if ($connecthost ne $host)
  {
    # if proxy active, use full URL as object to request
    $object = "$url";
  }

  # choose local port and address
  my $local_addr = INADDR_ANY;
  my $local_port = "0";
  if (defined($self->{'local_addr'})) {
    $local_addr = $self->{'local_addr'};
    if ($local_addr eq "0.0.0.0" || $local_addr eq "0") {
      $local_addr = INADDR_ANY;
    } else {
      $local_addr = inet_aton($local_addr);
    }
  }
  if (defined($self->{'local_port'})) {
    $local_port = $self->{'local_port'};
  }
  my $paddr = pack_sockaddr_in($local_port, $local_addr);
  bind(FH, $paddr) || return undef;  # Failing to bind is fatal.

  my $sin = sockaddr_in($connectport,$addr);
  connect(FH, $sin) || return undef;
  # Set nonblocking IO on the handle to allow timeouts
  if ( $^O ne "MSWin32" ) {
    fcntl(FH, F_SETFL, O_NONBLOCK);
  }

  if (defined($callback_func)) {
    &$callback_func($self, "connect", undef, @$callback_params);
  }

  if ($self->{header_at_once}) {
    $self->{holdback} = 1;    # http_write should buffer only, no sending yet
  }

  # Start the request (HTTP/1.1 mode)
  if ($self->{HTTP11}) {
    $self->http_write(*FH, "$method $object HTTP/1.1$CRLF");
  } else {
    $self->http_write(*FH, "$method $object HTTP/1.0$CRLF");
  }

  # Add some required headers
  # we only support a single transaction per request in this version.
  $self->add_req_header("Connection", "close");
  if ($port != 80) {
    $self->add_req_header("Host", "$host:$port");
  } else {
    $self->add_req_header("Host", $host);
  }
  if (!defined($self->get_req_header("Accept"))) {
    $self->add_req_header("Accept", "*/*");
  }

#  if ($method eq 'POST') {
#    $self->http_write(*FH, "Content-Type: application/x-www-form-urlencoded$CRLF");
#  }

  # Purge a couple others
  $self->delete_req_header("Content-Type");
  $self->delete_req_header("Content-Length");

  # Output headers
  foreach my $header ($self->enum_req_headers())
  {
    my $value = $self->get_req_header($header);
    $self->http_write(*FH, $self->{headermap}{$header}.": ".$value."$CRLF");
  }

  my $content_length;
  if (defined($self->{content}))
  {
    $content_length = length($self->{content});
  }
  if (defined($callback_func)) {
    my $ncontent_length = &$callback_func($self, "content-length", undef, @$callback_params);
    if (defined($ncontent_length)) {
      $content_length = $ncontent_length;
    }
  }

  if ($content_length) {
    $self->http_write(*FH, "Content-Length: $content_length$CRLF");
  }

  if (defined($callback_func)) {
    &$callback_func($self, "done-headers", undef, @$callback_params);
  }
  # End of headers
  $self->http_write(*FH, "$CRLF");

  if ($self->{header_at_once}) {
    $self->{holdback} = 0;
    $self->http_write(*FH, ""); # pseudocall to get http_write going
  }

  my $content_out = 0;
  if (defined($callback_func)) {
    while (my $content = &$callback_func($self, "content", undef, @$callback_params)) {
      $self->http_write(*FH, $content);
      $content_out++;
    }
  }

  # Output content, if any
  if (!$content_out && defined($self->{content}))
  {
    $self->http_write(*FH, $self->{content});
  }

  if (defined($callback_func)) {
    &$callback_func($self, "content-done", undef, @$callback_params);
  }


  # Read response from server
  my $headmode=1;
  my $chunkmode=0;
  my $chunksize=0;
  my $chunklength=0;
  my $chunk;
  my $line = 0;
  my $data;
  while ($data = $self->http_read(*FH,$headmode,$chunkmode,$chunksize))
  {
    $self->{DEBUG} && $self->DEBUG("reading: $chunkmode, $chunksize, $chunklength, $headmode, ".
        length($self->{'body'}));
    if ($self->{DEBUG}) {
      foreach my $var ("body", "request", "content", "status", "proxy",
        "proxyport", "resp-protocol", "error-message",
        "resp-headers", "CBARGS", "HTTPReadBuffer")
      {
        $self->DEBUG("state $var ".length($self->{$var}));
      }
    }
    $line++;
    if ($line == 1)
    {
      my ($proto,$status,$message) = split(' ', $$data, 3);
      $self->{DEBUG} && $self->DEBUG("header $$data");
      $self->{status}=$status;
      $self->{'resp-protocol'}=$proto;
      $self->{'error-message'}=$message;
      next;
    }
    if (($headmode || $chunkmode eq "entity-header") && $$data =~ /^[\r\n]*$/)
    {
      if ($chunkmode)
      {
        $chunkmode = 0;
      }
      $headmode = 0;

      # Check for Transfer-Encoding
      my $te = $self->get_header("Transfer-Encoding");
      if (defined($te)) {
        my $header = join(' ',@{$te});
        if ($header =~ /chunked/i)
        {
          $chunkmode = "chunksize";
        }
      }
      next;
    }
    if ($headmode || $chunkmode eq "entity-header")
    {
      my ($var,$datastr) = $$data =~ /^([^:]*):\s*(.*)$/;
      if (defined($var))
      {
        $datastr =~s/[\r\n]$//g;
        $var = lc($var);
        $var =~ s/^(.)/&upper($1)/ge;
        $var =~ s/(-.)/&upper($1)/ge;
        my $hr = ${$self->{'resp-headers'}}{$var};
        if (!ref($hr))
        {
          $hr = [ $datastr ];
        }
        else
        {
          push @{ $hr }, $datastr;
        }
        ${$self->{'resp-headers'}}{$var} = $hr;
      }
    } elsif ($chunkmode)
    {
      if ($chunkmode eq "chunksize")
      {
        $chunksize = $$data;
        $chunksize =~ s/^\s*|;.*$//g;
        $chunksize =~ s/\s*$//g;
        my $cshx = $chunksize;
        if (length($chunksize) > 0) {
          # read another line
          if ($chunksize !~ /^[a-f0-9]+$/i) {
            $self->{DEBUG} && $self->DEBUG("chunksize not a hex string");
          }
          $chunksize = hex($chunksize);
          $self->{DEBUG} && $self->DEBUG("chunksize was $chunksize (HEX was $cshx)");
          if ($chunksize == 0)
          {
            $chunkmode = "entity-header";
          } else {
            $chunkmode = "chunk";
            $chunklength = 0;
          }
        } else {
          $self->{DEBUG} && $self->DEBUG("chunksize empty string, checking next line!");
        }
      } elsif ($chunkmode eq "chunk")
      {
        $chunk .= $$data;
        $chunklength += length($$data);
        if ($chunklength >= $chunksize)
        {
          $chunkmode = "chunksize";
          if ($chunklength > $chunksize)
          {
            $chunk = substr($chunk,0,$chunksize);
          }
          elsif ($chunklength == $chunksize && $chunk !~ /$CRLF$/)
          {
            # chunk data is exactly chunksize -- need CRLF still
            $chunkmode = "ignorecrlf";
          }
          $self->add_to_body(\$chunk, $data_callback);
          $chunk="";
          $chunklength = 0;
          $chunksize = "";
        }
      } elsif ($chunkmode eq "ignorecrlf")
      {
        $chunkmode = "chunksize";
      }
    } else {
      $self->add_to_body($data, $data_callback);
    }
  }
  if (defined($callback_func)) {
    &$callback_func($self, "done", undef, @$callback_params);
  }
  close(FH);
  return $self->{status};
}

1;
__END__

=head1 NAME

Nana::HTTP - HTTP access module

=head1 SEE ALSO

=over 4

=item PyukiWiki CVS

L<@@CVSURL@@/PyukiWiki-Devel/lib/Nana/HTTP.pm>

=back

=head1 AUTHOR

=over 4

@@AUTHOR_NANAMI@@

@@AUTHOR_PYUKI@@

=back

=head1 LICENSE

@@LICENSE_NANAMI@@

=cut
