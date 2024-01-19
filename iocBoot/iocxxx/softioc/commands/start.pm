package commands::start;

use Env;
use Cwd;
use FindBin;
use POSIX;
use lib "$IOC_COMMAND_DIR";
use _info;


sub _local()
{
	if    (_info::ioc_up())        { print ("IOC is already running\n"); }
	elsif (_info::has_remote())    { _info::send_cmd("COMMAND", "start"); }
	else
	{
		_info::sanity_check();
		print ("Starting $IOC_NAME\n");
		
		my $prefix = _info::procserv("CONSOLE", "PREFIX");
		my $curr_time = strftime("%y%m%d-%H%M%S", localtime());
		my $LOG_FILE="$IOC_STARTUP_DIR/softioc/logs/iocConsole/${prefix}.log_${curr_time}";
		
		my $currdir = getcwd();
		
		chdir "${IOC_STARTUP_DIR}";
		
		system("$SCREEN -dm -S $IOC_NAME -h 5000 -L -Logfile $LOG_FILE $IOC_CMD");
		
		chdir "$currdir";
	}
}

sub _remote()
{
	if (_info::ioc_up())    { print("IOC is already running\n"); }
	else
	{
		my $ip_addr = _info::my_ip();
		my $port = _info::get_port();
		
		my $prefix = _info::procserv("CONSOLE", "PREFIX");
		my $curr_time = strftime("%y%m%d-%H%M%S", localtime());
		my $LOG_FILE="$IOC_STARTUP_DIR/softioc/logs/iocConsole/${prefix}.log_${curr_time}";
		
		system("cd $FindBin::RealBin; $PROCSERV --allow --quiet --oneshot -L $LOG_FILE -c $IOC_STARTUP_DIR -i ^C --logoutcmd=^D -I $prefix.txt $ip_addr:$port $IOC_CMD");
	}
}


1;
