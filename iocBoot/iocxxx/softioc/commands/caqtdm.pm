package commands::caqtdm;

use Env;
use lib "$IOC_COMMAND_DIR";
use _release;

sub _local
{
	my @parms = @_;
	
	my $ui_file = $parms[0] // $ENV{IOC_DEFAULT_UI};
	my $macros  = $parms[1] // $ENV{IOC_DEFAULT_MACROS};
	
	# Build display search path
	my $display_path = _release::display_path($TOP, "caqtdm");
	
	$ENV{CAQTDM_DISPLAY_PATH} = defined $ENV{CAQTDM_DISPLAY_PATH} && $ENV{CAQTDM_DISPLAY_PATH} ne ""
	    ? "$display_path:$ENV{CAQTDM_DISPLAY_PATH}"
	    : $display_path;
	
	# For drag-and-drop workaround at APS, need /APSshare/bin/xclip
	$ENV{CAQTDM_EXEC_LIST} = 'Probe;probe &P &:UI File;echo &A:PV Name(s);echo &P:Copy PV name; echo -n &P| xclip -i -sel clip:Paste PV name;caput &P `xclip -o -sel clip`';
	
	# Qt/caQtDM library path setup
	if (-d "/APSshare/caqtdm")
	{
		$ENV{PATH} = "$ENV{PATH}:/APSshare/bin";
		$ENV{QT_PLUGIN_PATH}  = "/APSshare/caqtdm/plugins";
		$ENV{LD_LIBRARY_PATH} = "/APSshare/caqtdm/lib";
		$ENV{LD_LIBRARY_PATH} .= ":" . ($ENV{EPICS_BASE} // "") . "/lib/linux-x86_64";
	}
	else
	{
		$ENV{QT_PLUGIN_PATH} = "/usr/local/epics/extensions/lib/linux-x86_64";
	}
	
	# Fork so the ioc.pl process returns to the prompt
	my $pid = fork();
	
	if ($pid == 0)
	{
		exec("/APSshare/bin/caQtDM", "-style", "plastique", "-noMsg", "-macro", $macros, $ui_file);
	}
}

sub _usage
{
	print("caqtdm [ui_file macros]");
}

1;
