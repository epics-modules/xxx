package commands::run;

use Env;
use lib "$IOC_COMMAND_DIR";
use _info;

use Cwd;

sub _local
{
	if    (_info::ioc_up())        { print("$IOC_NAME is already running\n"); }	
	elsif (_info::has_remote())    { print("IOC set up for remote commands\n"); }
	else
	{		
		_info::sanity_check();
		
		# Check for stale procServ info files
		if (_info::check_stale_and_prompt())    { return; }
		
		print("Starting $IOC_NAME\n");
		
		my $currdir = getcwd();
		chdir "$IOC_STARTUP_DIR";
		
		# Run IOC outside of a screen session, which is helpful for debugging
		system("${IOC_CMD}");
		
		chdir "$currdir";
	}
}

1;
