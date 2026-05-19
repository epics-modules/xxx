package commands::phoebus;

use Env;

sub _local
{
	my @parms = @_;
	
	my $ui_file = $parms[0] // $ENV{IOC_DEFAULT_BOB};
	my $macros  = $parms[1] // $ENV{IOC_DEFAULT_MACROS};
	
	# Discover the BOB screen directory
	my ($bob_dir) = glob("$TOP/*App/op/bob/autoconvert");
	$bob_dir //= "$TOP/xxxApp/op/bob/autoconvert";
	
	# Fork so the ioc.pl process returns to the prompt
	my $pid = fork();
	
	if ($pid == 0)
	{
		exec("/APSshare/bin/phoebus",
		    "-layout", "$EPICS_APP/phoebus.layout",
		    "-resource", "file:${bob_dir}/${ui_file}?${macros}&target=window");
	}
}

sub _usage
{
	print("phoebus [bob_file macros]");
}

1;
