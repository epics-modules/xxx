package _commands;

use Env;
use lib "$IOC_COMMAND_DIR/..";

my @loaded_cmds = ();

opendir my $dir, "$IOC_COMMAND_DIR";

while (readdir($dir)) 
{
	next if($_ =~ /^\.$/);
	next if($_ =~ /^\.\.$/);
	next if($_ =~ /^_/);
	
	if ($_ =~ /pm$/)
	{
		my $cmd_name = $_;
		$cmd_name =~ s/\.pm//g;
		
		eval "use commands::$cmd_name";
		
		if ($!)    { print ("$cmd_name: $!\n"); }

		push ( @loaded_cmds, "$cmd_name");
	}
}

closedir $dir;


sub call
{
	my @parms = @_;
	
	my ($FUNCTION, $SELECTION, @SEL_ARGS) = (@parms);
	
	if (! defined $SELECTION)    { $SELECTION = "usage"; }
	
	
	if (! List::Util::first { $_ eq $SELECTION; } @loaded_cmds)
	{
		print("couldn't find command: $SELECTION\n");
	}
	else
	{
		if (eval "commands::${SELECTION}->can($FUNCTION)")
		{
			eval "commands::${SELECTION}::$FUNCTION(@SEL_ARGS)";
		}
	}
}


sub listAll
{
	my @parms = @_;
	
	my $FILTER = @parms[0];
	
	my $first = 1;
	
	foreach (sort @loaded_cmds)
	{
		next if(! eval "commands::$_->can($FILTER)");
		
		if ($first)    { $first = 0; }
		else           { print("|"); }
			
		print($_);
	}
}

1;
