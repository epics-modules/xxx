package commands::procserv;

use Env;
use Cwd;
use FindBin;
use POSIX;
use lib "$IOC_COMMAND_DIR";
use _info;


sub _local()
{
	my @parms = @_;
	
	my $ONOFF = $parms[0];
	
	if ( $ONOFF eq "start" )
	{
		if    (_info::ioc_up())     { print("IOC is already running\n"); }
		elsif (_info::has_remote()) 
		{ 
			print("Starting procServ session on remote computer\n"); 
			_info::send_cmd("COMMAND", "start");
		}
		else
		{
			my $ip_addr = _info::my_ip();
			my $port = _info::get_port();
			
			my $prefix = _info::procserv("CONSOLE", "PREFIX");
			my $curr_time = strftime("%y%m%d-%H%M%S", localtime());
			my $LOG_FILE="-L $IOC_STARTUP_DIR/softioc/logs/iocConsole/${prefix}.log_${curr_time}";
			
			if ($#parms > -1)
			{
				if ($parms[0] eq "silent")
				{
					$LOG_FILE="";
				}
			}
			
			system("cd $FindBin::RealBin; $PROCSERV --allow --quiet --oneshot $LOG_FILE -c $IOC_STARTUP_DIR -i ^C --logoutcmd=^D -I $prefix.txt $ip_addr:$port $IOC_CMD");
			
			sleep 1;
			
			my @logfiles = glob("$IOC_STARTUP_DIR/softioc/logs/iocConsole/${prefix}.log_*");
			
			my $numkept=0;
			
			foreach(reverse @logfiles)
			{
				$numkept = $numkept+1;
				next if ($numkept <= $IOC_LOGFILE_MAX);
				unlink $_;
			}
		}
	}
	elsif ( $ONOFF eq "stop" )
	{
		my $PID = _info::procserv("CONSOLE", "PID");
		my $prefix = _info::procserv("CONSOLE", "PREFIX");
		
		print("Stopping $IOC_NAME (pid=$PID)\n");
		
		if ($PID != -1)    { _info::send_cmd("CONSOLE", "exit"); }
		
		$WAIT=1;
		
		while (_info::procserv("CONSOLE", "PID") != -1)
		{
			sleep(1);
			
			$WAIT += 1;
			
			if ($WAIT == 5)    { kill("SIGKILL", $PID); last; }
		}
		
		unlink "$FindBin::RealBin/$prefix.txt";
	}
	else
	{
		_commands::call("_local", "usage", "procserv");
	}
}

sub _usage
{
	print("procserv start/stop");
}

1;
