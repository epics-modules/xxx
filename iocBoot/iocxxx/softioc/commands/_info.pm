package _info;

use Env;
use Cwd;
use Socket;
use IO::Socket;
use Sys::Hostname;

use strict;


my %procserv_info;

$procserv_info{"COMMAND"} = { "PREFIX" => "ioc${IOC_NAME}-command",
                              "PORT" => -1,
                              "PID" => -1,
                              "IP" => -1,
                              "SAME_HOST" => 0};

$procserv_info{"CONSOLE"} = { "PREFIX" => "ioc${IOC_NAME}-console",
                              "PORT" => -1,
                              "PID" => -1,
                              "IP" => -1,
                              "SAME_HOST" => 0};

my %stale_info;    # Tracks stale procServ info files detected during parse()

sub my_ip
{
	return inet_ntoa(inet_aton(hostname));
}
							
sub parse 
{
	my @parms = @_;
	
	my $PS_PROC = $parms[0];
	
	my %output = %{$procserv_info{$PS_PROC}};
	
	my $CHECK_FILE = "$FindBin::RealBin/$output{PREFIX}.txt";
	
	if (-e $CHECK_FILE && -f $CHECK_FILE)
	{	
		open(my $filehandle, "<", "$CHECK_FILE");
		
		my $line1 = <$filehandle>;
		my $line2 = <$filehandle>;
		
		close($filehandle);
		
		$line1 =~ s/\R//g;
		$line2 =~ s/\R//g;
		
		my @pidline = split(/:/, $line1);
		my @tcpline = split(/:/, $line2);
		
		$output{"PID"}  = $pidline[1];
		$output{"IP"}   = $tcpline[1];
		$output{"PORT"} = $tcpline[2];

		
		my $ip_addr = my_ip();
		
		if ($ip_addr eq $tcpline[1])
		{
			$output{"SAME_HOST"} = 1;
		}
		
		# Validate that the process is actually running
		my $is_valid = 0;
		
		if ($output{"SAME_HOST"})
		{
			# Same host: check if PID is alive
			$is_valid = kill(0, $output{"PID"});
		}
		else
		{
			# Different host: try TCP connect to procServ port
			my $socket = new IO::Socket::INET (
				PeerHost => $output{"IP"},
				PeerPort => $output{"PORT"},
				Proto    => 'tcp',
				Timeout  => 5,
			);
			
			if ($socket)
			{
				$is_valid = 1;
				$socket->close();
			}
		}
		
		if (! $is_valid)
		{
			# Record the stale info for later prompting
			$stale_info{$PS_PROC} = {
				"FILE" => $CHECK_FILE,
				"IP"   => $output{"IP"},
				"PORT" => $output{"PORT"},
				"PID"  => $output{"PID"},
			};
			
			# Return defaults so callers see "no remote instance"
			return \%{$procserv_info{$PS_PROC}};
		}
	}
	
	return \%output;
}

sub procserv 
{
	my @parms = @_;
	
	my $PS_PROC = $parms[0];
	my $PS_INFO = $parms[1];
	
	my $output = parse($PS_PROC);
	return $output->{$PS_INFO};
}

sub update 
{	
	if (procserv("COMMAND", "PID") != -1 && ! can_ping("COMMAND"))
	{
		print("ProcServ file open for command server, but cannot access IP/Port\n");
	}
	
	if (procserv("CONSOLE", "PID") != -1 && ! can_ping("CONSOLE"))
	{
		print("ProcServ file open for console server, but cannot access IP/Port\n");
	}
}


sub get_local_pid 
{
	my $UID=$<;
	
	my $ptable = `ps -u $UID x`;
	
	foreach (split(/\n/, $ptable))
	{
		#Remove leading spaces
		$_ =~ s/^\s+//;
		
		#Split proc info, but don't break up command
		my @splitline = split(/\s+/, $_, 5);
		
		#[0] is PID, [4] is Command
		if (index($splitline[4], ${IOC_CMD}) == 0)
		{
			return $splitline[0];
		}
	}
	
	return 0;
}

sub get_local_session
{
	my $UID=$<;
	
	my $ptable = `ps -u $UID x`;
	
	foreach (split(/\n/, $ptable))
	{
		#Remove leading spaces
		$_ =~ s/^\s+//;
		
		#Split proc info, but don't break up command
		my @splitline = split(/\s+/, $_, 5);
		
		#[0] is PID, [4] is Command
		if (index($splitline[4], ${IOC_CMD}) != -1)
		{
			if    (index($splitline[4], "procServ") != -1)    { return "procserv"; }
			elsif (index($splitline[4], "SCREEN")   != -1)    { return "screen"; }
		}
	}
	
	return 0;
}
							
sub can_ping 
{	
	my @parms = @_;
	
	my $PS_PROC = $parms[0];
	
	my $data = parse($PS_PROC);
	
	my $IP = $data->{"IP"};
	my $PORT = $data->{"PORT"};
		
	my $socket = new IO::Socket::INET (
		PeerHost => $IP,
		PeerPort => $PORT,
		Proto => 'tcp',
		Timeout => 5,
	);
	
	return 0 unless($socket);
	
	$socket->close();
	return 1
}

sub has_remote 
{
	return (procserv("COMMAND", "IP") != -1);
}

sub is_local 
{
	if (has_remote())    { return (procserv("COMMAND", "SAME_HOST") != 0); }
	
	return 1;
}

sub ioc_up 
{	
	if (has_remote())    { return can_ping("CONSOLE"); }
	else                 { return get_local_pid(); }
}


sub send_cmd
{
	my @parms = @_;
	
	my ($PS_PROC, @CMDS) = (@parms);
	
	my $data = parse($PS_PROC);
	
	my $IP   = $data->{"IP"};
	my $PORT = $data->{"PORT"};
	
	my $socket = new IO::Socket::INET (
		PeerHost => $IP,
		PeerPort => $PORT,
		Proto => 'tcp',
	);
	
	return 0 unless $socket;
	
	# Seem to need some sort of time to actually establish connection
	# Instead of arbitrary sleep, we'll just attempt a read
	my $buffer = "";
	$socket->recv($buffer, 1024);
	
	my $everything = join(" ", @CMDS);
	
	$socket->send("$everything\n");
	$socket->shutdown(SHUT_WR);
	
	$socket->recv($buffer, 1024);
	$socket->shutdown(SHUT_RD);
	$socket->close();
}


sub get_port() 
{
	my $ip = my_ip();
	my $port_to_use = 50000;
	
	while ($port_to_use <= 65535)
	{
		my $socket = new IO::Socket::INET (
			PeerHost => $ip,
			PeerPort => $port_to_use,
			Proto => 'tcp',
		);
		
		last unless($socket);
		
		$socket->close();
		$port_to_use += 1;
	}
	
	return $port_to_use;
}

sub sanity_check()
{
	#######################
	#    Sanity Checks    #
	#######################
	
	
	if (! -d $ENV{IOC_STARTUP_DIR})
	{
		print("Error: Starting directory ($ENV{IOC_STARTUP_DIR}) doesn't exist.\n");
		print("IOC_STARTUP_DIR in $FindBin::RealScript needs to be corrected.\n");
		die;
	}
	
	if (! -f $ENV{IOC_BIN_PATH})
	{
		print("Error: No IOC executable at $ENV{IOC_BIN_PATH}\n");
		print("IOC_BIN_PATH in $FindBin::RealScript needs to be corrected.\n");
		die;
	}
	
	if (! -f $ENV{IOC_STARTUP_FILE_PATH})
	{
		print("Error: No IOC startup script at $ENV{IOC_STARTUP_FILE_PATH}\n");
		print("IOC_STARTUP_FILE_PATH in $FindBin::RealScript needs to be corrected.\n");
		return;
	}
}


sub check_stale_and_prompt
{
	# Only care about stale CONSOLE files (indicates a previously-running IOC)
	return 0 if (! exists $stale_info{"CONSOLE"});
	
	my $info = $stale_info{"CONSOLE"};
	
	# Non-interactive: silently clean up and proceed
	if (! -t STDIN)
	{
		unlink $info->{"FILE"} if (-f $info->{"FILE"});
		delete $stale_info{"CONSOLE"};
		return 0;
	}
	
	print("\n");
	print("Warning: A procServ info file was found for $IOC_NAME, but the\n");
	print("process does not appear to be running.\n");
	print("\n");
	print("  File: $info->{FILE}\n");
	print("  IP:   $info->{IP}\n");
	print("  Port: $info->{PORT}\n");
	print("  PID:  $info->{PID}\n");
	print("\n");
	print("This may indicate the IOC previously crashed or is running on a\n");
	print("host that is currently unreachable.\n");
	print("\n");
	print("Do you want to continue starting the IOC? [y/N]: ");
	
	my $answer = <STDIN>;
	chomp($answer) if defined $answer;
	
	if (defined $answer && $answer =~ /^[yY]$/)
	{
		# User confirmed: clean up stale file and proceed
		unlink $info->{"FILE"} if (-f $info->{"FILE"});
		delete $stale_info{"CONSOLE"};
		return 0;
	}
	
	# User declined or hit enter
	return 1;
}

my $LOG_WATCHER_PID_FILE = "$FindBin::RealBin/.log_watcher.pid";

sub start_log_watcher
{
	my @parms = @_;
	my $logfile = $parms[0];
	
	my $max_size = $ENV{IOC_LOGFILE_MAX_SIZE} // 0;
	
	# Don't start if size limiting is disabled
	if ($max_size <= 0)    { return; }
	
	# Clean up any stale watcher
	stop_log_watcher();
	
	my $pid = fork();
	
	if (!defined $pid)
	{
		print("Warning: Could not fork log watcher: $!\n");
		return;
	}
	
	if ($pid != 0)
	{
		# Parent: record the child PID and return
		if (open(my $fh, ">", $LOG_WATCHER_PID_FILE))
		{
			print $fh "$pid\n";
			close($fh);
		}
		return;
	}
	
	# Child: detach from terminal and run the watch loop
	POSIX::setsid();
	
	# Close standard file descriptors so we don't hold the terminal
	open(STDIN,  "<", "/dev/null");
	open(STDOUT, ">", "/dev/null");
	open(STDERR, ">", "/dev/null");
	
	while (1)
	{
		sleep($IOC_LOGFILE_POLLING);
		
		# Exit if the log file no longer exists
		last if (! -f $logfile);
		
		# Exit if the IOC is no longer running
		last if (! ioc_up());
		
		my $size = (stat($logfile))[7];
		
		next if (!defined $size || $size <= $max_size);
		
		# Truncate: keep the tail portion of the file
		_truncate_logfile($logfile, $max_size);
	}
	
	# Clean up PID file on exit
	unlink $LOG_WATCHER_PID_FILE if (-f $LOG_WATCHER_PID_FILE);
	
	exit(0);
}

sub _truncate_logfile
{
	my ($logfile, $max_size) = @_;
	
	my $keep_bytes = int($max_size * $IOC_LOGFILE_KEEP_AMT);
	
	my $size = (stat($logfile))[7];
	return if (!defined $size || $size <= $max_size);
	
	my $skip = $size - $keep_bytes;
	
	# Read the tail we want to keep
	if (!open(my $rfh, "<", $logfile))    { return; }
	else
	{
		seek($rfh, $skip, 0);
		
		# Advance past any partial line so we start at a clean boundary
		my $partial = <$rfh>;
		
		# Read the remaining content
		local $/;
		my $tail = <$rfh>;
		close($rfh);
		
		# Only proceed if we actually have content to write back
		if (defined $tail && length($tail) > 0)
		{
			# Write the tail back, truncating the file
			if (open(my $wfh, ">", $logfile))
			{
				print $wfh $tail;
				close($wfh);
			}
		}
	}
}

sub stop_log_watcher
{
	if (-f $LOG_WATCHER_PID_FILE)
	{
		if (open(my $fh, "<", $LOG_WATCHER_PID_FILE))
		{
			my $pid = <$fh>;
			close($fh);
			
			chomp($pid) if defined $pid;
			
			if (defined $pid && $pid =~ /^\d+$/ && $pid > 0)
			{
				kill("SIGTERM", $pid);
			}
		}
		
		unlink $LOG_WATCHER_PID_FILE;
	}
}

1;
