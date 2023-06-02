package commands::usage;

use Env;
use lib "$IOC_COMMAND_DIR";
use _commands;

use FindBin;

sub _local
{
	my @parms = @_;
	
	if ($#parms == -1)
	{
		print("Usage: $FindBin::Script {");
		_commands::listAll("_local");
		print("}\n");
	}
	else
	{
		my $SELECTION = $parms[0];
		
		print("$FindBin::Script ");
		
		_commands::call("_usage", $SELECTION);
	}
}

sub _remote
{
	my @parms = @_;
	
	if ($#parms == -1)
	{
		print("Usage: $FindBin::Script {");
		_commands::listAll("_remote");
		print("}\n");
	}
	else
	{
		my $SELECTION = $parms[0];
		
		_commands::call("_usage", $SELECTION);
	}
}


1;
