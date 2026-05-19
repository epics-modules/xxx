package commands::medm;

use Env;

sub _local
{
	my @parms = @_;
	
	my $ui_file = $parms[0] // $ENV{IOC_DEFAULT_ADL};
	my $macros  = $parms[1] // $ENV{IOC_DEFAULT_MACROS};
	
	# Build display search path
	require "$TOP/setup_epics_common";
	my $display_path = build_display_path($TOP, "medm", $EPICS_APP_ADL_DIR);
	
	$ENV{EPICS_DISPLAY_PATH} = defined $ENV{EPICS_DISPLAY_PATH} && $ENV{EPICS_DISPLAY_PATH} ne ""
	    ? "$display_path:$ENV{EPICS_DISPLAY_PATH}"
	    : $display_path;
	
	$ENV{MEDM_EXEC_LIST} //= 'Probe;probe &P &';
	
	# Fork so the ioc.pl process returns to the prompt
	my $pid = fork();
	
	if ($pid == 0)
	{
		exec("medm", "-macro", $macros, "-x", $ui_file);
	}
}

sub _usage
{
	print("medm [adl_file macros]");
}


1;
