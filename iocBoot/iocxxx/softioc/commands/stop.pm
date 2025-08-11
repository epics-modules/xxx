package commands::stop;

use Env;
use lib "$IOC_COMMAND_DIR";
use _info;

sub _local
{
	my $SESSION = _info::get_local_session();
	
	_commands::call("_local", $SESSION, "stop");
}

sub _remote
{
	_commands::call("_local", "procserv", "stop");
}


1;
