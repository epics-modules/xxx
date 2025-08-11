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
		
		print("Usage: $FindBin::Script ");
		
		my $mod = "commands::${SELECTION}";
		
		if ($mod->can("_usage"))
		{
			_commands::call("_usage", $SELECTION);
		}
		else
		{
			print($SELECTION);
		}
		
		print("\n");
	}
}

sub _remote
{
	print("Usage: $FindBin::Script {");
	_commands::listAll("_remote");
	print("}\n");
}


1;
