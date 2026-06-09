package commands::putrecorder;

use Env;
use lib "$IOC_COMMAND_DIR";
use _release;


sub _local
{
	my @parms = @_;
	my $prefix = $parms[0] // $ENV{IOC_DEFAULT_MACROS};
	
	# Extract just the prefix value (e.g., "xxx:" from "P=xxx:")
	($prefix) = $prefix =~ /(?:P=)?(.+)/;
	
	# Find the caputRecorder module path from RELEASE
	my %apps;
	$apps{"TOP"} = $TOP;
	_release::parse("$TOP/configure/RELEASE", \%apps);
	
	my $caputrecorder = $apps{"CAPUTRECORDER"};
	
	if (!$caputrecorder || ! -d $caputrecorder)
	{
		print("Error: CAPUTRECORDER module not found in RELEASE\n");
		return;
	}
	
	my $caputrecorder_py = "$caputrecorder/caputRecorderApp/op/python/caputRecorder.py";
	
	if (! -f $caputrecorder_py)
	{
		print("Error: caputRecorder.py not found at $caputrecorder_py\n");
		return;
	}
	
	# Find the IOC's python macros directory and file
	my ($python_dir) = glob("$TOP/*App/op/python");
	
	if (!$python_dir || ! -d $python_dir)
	{
		print("Error: No *App/op/python directory found\n");
		return;
	}
	
	my $name_prefix = $prefix;
	$name_prefix =~ s/:$//;
	my $macros_py = "$python_dir/macros_${name_prefix}.py";
	
	# Set PYTHONPATH
	$ENV{PYTHONPATH} = defined $ENV{PYTHONPATH}
	    ? "$python_dir:$ENV{PYTHONPATH}"
	    : $python_dir;
	
	# Fork and launch caputRecorder.py
	my $pid = fork();
	
	if ($pid == 0)
	{
		exec("python", $caputrecorder_py, $prefix, $macros_py);
	}
}

sub _usage
{
	print("putrecorder [prefix]");
}

1;
