package commands::status;

use Env;
use lib "$IOC_COMMAND_DIR";
use _info;

sub _local
{	
	if (_info::has_remote())
	{
		my $IP   = _info::procserv("COMMAND", "IP");
		my $PORT = _info::procserv("COMMAND", "PORT");
		
		if (_info::is_local()) { print("Command console running locally on port $PORT\n"); }
		else                   { print("Command console running remotely at $IP:$PORT\n"); }
	}

	if (_info::ioc_up())
	{		
		if (_info::is_local())    { print("$IOC_NAME is running locally "); }
		else                      { print("$IOC_NAME is running remotely "); }
	
		if (_info::has_remote())
		{
			my $IP   = _info::procserv("CONSOLE", "IP");
			my $PORT = _info::procserv("CONSOLE", "PORT");
			my $PID  = _info::procserv("CONSOLE", "PID");
			
			print("in a procserv session at $IP:$PORT (pid=$PID)\n");
		}
		else
		{
			my $PID=_info::get_local_pid();
			print("in a screen session (pid=$PID)\n");
		}
	}
	else
	{
		print("$IOC_NAME is not running\n");
	}
}


1;
