package _info;

use Env;
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
							
sub my_ip
{
	return inet_ntoa((gethostbyname(hostname))[4]);
}
							
sub parse 
{
	my @parms = @_;
	
	my $PS_PROC = $parms[0];
	
	my %output = %{$procserv_info{$PS_PROC}};
	
	my $CHECK_FILE = "$output{PREFIX}.txt";
	
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
							
sub can_ping 
{	
	my @parms = @_;
	
	my $PS_PROC = $parms[0];
	
	my $data = parse($PS_PROC);
	
	my $IP = $data->{"IP"};
	my $PORT = $data->{"PORT"};
	
	if ($PORT != -1)
	{
		my $exit_code = system("$NETCAT -z $IP $PORT");
		
		return ($exit_code == 0);
	}
	
	return 0;
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
	
	my $everything = join(" ", @CMDS);
	
	my $throwaway =`$ECHO '$everything' | $NETCAT $IP $PORT`;
}


sub get_port() 
{
	my $ip = my_ip();
	my $port_to_use = 50000;
	
	while ($port_to_use <= 65535)
	{
		my $exit_code = system("$NETCAT -z $ip $port_to_use");
		
		if ($exit_code != 0)    { last; }
		
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

1;
