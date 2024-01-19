package commands::remote;

use Env;
use FindBin;
use POSIX;
use lib "$IOC_COMMAND_DIR";
use _info;
use _commands;


sub _local
{
	my @parms = @_;
	
	my $ONOFF = $parms[0];
	
	if ( $ONOFF eq "enable" )
	{
		if (_info::has_remote())
		{
			_commands::call("_local", "status");
			return;
		}

		my $ip_addr = _info::my_ip();
		
		my $port = _info::get_port();
		
		my $prefix = _info::procserv("COMMAND", "PREFIX");
		my $curr_time = strftime("%y%m%d-%H%M%S", localtime());
		my $LOG_FILE="$IOC_STARTUP_DIR/softioc/logs/remote/${prefix}.log_${curr_time}";
		
		# Start Command Port
		system("cd $FindBin::RealBin; $PROCSERV --allow --quiet --oneshot -L $LOG_FILE -i ^C --logoutcmd=^D -I $prefix.txt $ip_addr:$port $FindBin::RealBin/$FindBin::RealScript remote commandline");
	}
	elsif ( $ONOFF eq "disable" )
	{
		if (! _info::has_remote() || ! _info::is_local())
		{
			print("Command console not running on this computer\n");
			return;
		}
		
		my $PID=_info::procserv("COMMAND", "PID");
		
		_info::send_cmd("COMMAND", "exit");
		_commands::call("_remote", "stop");
	}
	elsif ( $ONOFF eq "commandline" )
	{
		print("> ");
	
		 while (<STDIN>)
		 {
			chomp($_);
			
			my @input = split(/\s+/,$_);
			
			if ($#input == 0 && $input[0] eq "exit")    { last; }
			
			_commands::call("_remote", $_);
			
			print("> ");
		 }
	}
	else
	{
		_commands::call("_local", "usage", "remote");
	}
}


sub _usage
{
	print("remote enable/disable\n");
}


1;
