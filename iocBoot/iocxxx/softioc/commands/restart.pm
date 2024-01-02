package commands::restart;

use Env;
use lib "$IOC_COMMAND_DIR";
use _info;
use _commands;

sub _local 
{
	if    (! _info::ioc_up())      { print("IOC isn't running\n"); }
	elsif (_info::has_remote())    
 	{ 
  		_info::send_cmd("COMMAND", "stop");
    		sleep(1);
  		_info::send_cmd("COMMAND", "start"); 
    	}
	else
	{
		_commands::call("_local", "stop");
		sleep(1);
		_commands::call("_local", "start");
	}
}

sub _remote
{
	_commands::call("_remote", "stop");
	_commands::call("_remote", "start");
}


1;
