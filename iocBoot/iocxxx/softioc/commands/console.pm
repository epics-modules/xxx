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
		my $SESSION = _info::get_local_session();
		
		if ($SESSION eq "screen")
		{
			print("Connecting to ${IOC_NAME}'s screen session\n");
			
			# The -r flag will only connect if no one is attached to the session
			#!${SCREEN} -r ${IOC_NAME}
			# The -x flag will connect even if someone is attached to the session
			system("${SCREEN} -x ${IOC_NAME}");
		}
		elsif ($SESSION eq "procServ")
		{			
			print("Connecting to ${IOC_NAME}'s procServ session\n");
			
			system("${TELNET}", _info::procserv("CONSOLE", "IP"), _info::procserv("CONSOLE", "PORT"));
		}
	}
}


1;
