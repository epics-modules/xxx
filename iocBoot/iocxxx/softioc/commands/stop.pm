package commands::stop;

use Env;
use lib "$IOC_COMMAND_DIR";
use _info;

sub _local
{
	if    (! _info::ioc_up())      { print("$IOC_NAME is not running\n"); }
	elsif ( _info::has_remote())   { _info::send_cmd("COMMAND", "stop"); }
	else
	{		
		my $PID = _info::get_local_pid();
		
		print("Stopping $IOC_NAME (pid=$PID)\n");
		kill( "SIGKILL", $PID);
	}
}

sub _remote
{
	my $PID = _info::procserv("CONSOLE", "PID");
	
	if ($PID != -1)    { _info::send_cmd("CONSOLE", "exit"); }
	
	$WAIT=1;
	
	while (_info::procserv("CONSOLE", "PID") != -1)
	{
		sleep(1);
		
		$WAIT += 1;
		
		if ($WAIT == 5)    { kill("SIGKILL", $PID); last; }
	}
}


1;
