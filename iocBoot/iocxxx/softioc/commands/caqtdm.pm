package commands::caqtdm;

use Env;

sub _local
{
	system("$TOP/start_caQtDM_$IOC_NAME", @_);
}

sub _usage
{
	print("caqtdm [ui_file ui_macros]\n");
}

1;
