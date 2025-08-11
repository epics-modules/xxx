package commands::screen;

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
		if    (_info::ioc_up())        { print ("IOC is already running\n"); }
		elsif (_info::has_remote())    { _info::send_cmd("COMMAND", "start"); }
		else
		{
			_info::sanity_check();
			print ("Starting $IOC_NAME\n");
			
			my $prefix = _info::procserv("CONSOLE", "PREFIX");
			my $curr_time = strftime("%y%m%d-%H%M%S", localtime());
			my $LOG_FILE="-L -Logfile $IOC_STARTUP_DIR/softioc/logs/iocConsole/${prefix}.log_${curr_time}";
			
			if ($#parms > -1)
			{
				if ($parms[0] eq "silent")
				{
					$LOG_FILE="";
				}
			}
			
			my $currdir = getcwd();
			
			chdir "${IOC_STARTUP_DIR}";
			
			system("$SCREEN -dm -S $IOC_NAME -h 5000 $LOG_FILE $IOC_CMD");
			
			chdir "$currdir";
			
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
		my $PID = _info::get_local_pid();
		
		print("Stopping $IOC_NAME (pid=$PID)\n");
		kill( "SIGKILL", $PID);
	}
	else
	{
		_commands::call("_local", "usage", "screen");
	}
}

sub _usage
{
	print("screen start/stop");
}

1;
