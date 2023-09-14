package commands::phoebus;

use Env;

sub _local
{
	system("$TOP/start_phoebus_$IOC_NAME", @_);
}

sub _usage
{
	print("phoebus [boy_file boy_macros]\n");
}

1;
