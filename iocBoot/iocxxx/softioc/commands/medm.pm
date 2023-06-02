package commands::medm;

use Env;

sub _local
{
	system("$(TOP)/start_MEDM_$IOC_NAME", @_);
}

sub _usage
{
	print("medm [adl_file adl_macros]\n");
}


1;
