package commands::console;

use Env;
use lib "$IOC_COMMAND_DIR";
use _info;


sub _local
{
	if    (! _info::ioc_up)    { print("${IOC_NAME} is not running\n"); }
	elsif ( _info::has_remote) 
	{
		system("${TELNET}", _info::procserv("CONSOLE", "IP"), _info::procserv("CONSOLE", "PORT"));
	}
	else
	{
		print("Connecting to ${IOC_NAME}'s screen session\n");
		
		# The -r flag will only connect if no one is attached to the session
		#!${SCREEN} -r ${IOC_NAME}
		# The -x flag will connect even if someone is attached to the session
		system("${SCREEN} -x ${IOC_NAME}");
	}
}


1;
