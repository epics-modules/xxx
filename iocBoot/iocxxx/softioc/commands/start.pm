package commands::start;

use Env;
use Cwd;
use FindBin;
use POSIX;
use lib "$IOC_COMMAND_DIR";
use _info;


sub _local()
{
	_commands::call("_local", $ENV{IOC_DEFAULT_SESSION}, "start");
}

sub _remote()
{
	_commands::call("_local", "procserv", "start");
}


1;
