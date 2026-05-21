#!/usr/bin/perl

use strict;
use Config;
use FindBin;
use Cwd 'abs_path';
use File::Basename;

###################################################################
# Set Environment Variables to be used by the rest of the scripts #
###################################################################

BEGIN
{
	# Top level of the IOC folder
	$ENV{TOP} = "$FindBin::RealBin/../../..";	
	
	# IOC prefix name, used to find the correct iocBoot directory and executable
	$ENV{IOC_NAME} = substr(basename(abs_path("$FindBin::RealBin/../")),3);
	#! $ENV{IOC_NAME}="xxx";
		
	
	#########################
	# IOC Executable Config #
	#########################
	
	# Name of the IOC executable file
	$ENV{IOC_BINARY}="xxx";
	#! $ENV{IOC_BINARY}="$ENV{IOC_NAME}";
	
	# Top-level bin directory for the IOC
	$ENV{IOC_BIN_DIR}="$ENV{TOP}/bin";
	#! $ENV{IOC_BIN_DIR}="/home/username/epics/synApps/support/xxx/bin";
	#! $ENV{IOC_BIN_DIR}="/home/username/epics/synApps/support/module/iocs/exampleIOC/bin";
	
	# Architecture the IOC is built under
	$ENV{EPICS_HOST_ARCH} //= "linux-x86_64";
	#! $ENV{EPICS_HOST_ARCH}="linux-x86_64-debug";
	
	# Full path to the IOC executable
	$ENV{IOC_BIN_PATH}="$ENV{IOC_BIN_DIR}/$ENV{EPICS_HOST_ARCH}/$ENV{IOC_BINARY}";
	
	
	
	###########################
	# IOC Startup File Config #
	###########################
	
	# Startup Script for the IOC to run
	$ENV{IOC_STARTUP_FILE}="st.cmd.Linux";
	#! $ENV{IOC_STARTUP_FILE}="st.cmd.Cygwin";
	#! $ENV{IOC_STARTUP_FILE}="st.cmd.Win32";
	#! $ENV{IOC_STARTUP_FILE}="st.cmd.Win64";
	
	
	# Directory that contains the startup script
	$ENV{IOC_STARTUP_DIR}="$ENV{TOP}/iocBoot/ioc$ENV{IOC_NAME}";
	#! $ENV{IOC_STARTUP_DIR}="/home/username/epics/ioc/synApps/xxx/iocBoot/iocxxx";
	
	# Full path to the startup file
	$ENV{IOC_STARTUP_FILE_PATH}="$ENV{IOC_STARTUP_DIR}/$ENV{IOC_STARTUP_FILE}";
	

	############################
	# Display Manager Config   #
	############################
	
	# Default UI files for display managers (searched via display path)
	$ENV{IOC_DEFAULT_ADL}="$ENV{IOC_NAME}.adl";
	#! $ENV{IOC_DEFAULT_ADL}="xxx.adl";
	
	$ENV{IOC_DEFAULT_UI}="$ENV{IOC_NAME}.ui";
	#! $ENV{IOC_DEFAULT_UI}="xxx.ui";
	
	$ENV{IOC_DEFAULT_BOB}="$ENV{IOC_NAME}.bob";
	#! $ENV{IOC_DEFAULT_BOB}="ioc_motors.bob";
	
	# Default macros for display managers
	$ENV{IOC_DEFAULT_MACROS}="P=$ENV{IOC_NAME}:";
	#! $ENV{IOC_DEFAULT_MACROS}="P=xxx:";
	
	
	##########################
	# Config For This Script #
	##########################
	
	# Directory that contains all the command modules to be loaded
	$ENV{IOC_COMMAND_DIR}="$ENV{IOC_STARTUP_DIR}/softioc/commands";
	#! $ENV{IOC_COMMAND_DIR}="/home/username/epics/ioc/synApps/xxx/iocBoot/iocxxx/softioc/commands";
	
	$ENV{IOC_CMD}="$ENV{IOC_BIN_PATH} $ENV{IOC_STARTUP_FILE_PATH}";
	
	# Switch between screen/procserv for local sessions (procServ should be set in all lowercase)
	$ENV{IOC_DEFAULT_SESSION}="screen";
	#! $ENV{IOC_DEFAULT_SESSION}="procserv";


	########################
	#  IOC Logging Config  #
	########################

	# Remove EPICS 7.0.8 history
	$ENV{EPICS_IOCSH_HISTFILE}="";
	
	# Set maximum number of remote manager and iocConsole log files to keep
	$ENV{IOC_LOGFILE_MAX}=10;
	
	# Or set each type individually, Command is for remote command console logs, Console is iocConsole logs
	$ENV{IOC_COMMAND_FILE_MAX}=$ENV{IOC_LOGFILE_MAX};
	$ENV{IOC_CONSOLE_FILE_MAX}=$ENV{IOC_LOGFILE_MAX};
	
	# Set maximum size (in bytes) for an active console log file.
	# When exceeded, the file is truncated to keep the most recent content.
	# Default: 1073741824 (1 GB).  Set to 0 to disable size limiting.
	$ENV{IOC_LOGFILE_MAX_SIZE}=1073741824;

	# Set number of seconds betewen size checks of logfile
	$ENV{IOC_LOGFILE_POLLING}=60;

	# Set percentage amount of IOC file to keep when truncating
	$ENV{IOC_LOGFILE_KEEP_AMT}=0.75;


	###########################
	#  Require Command Paths  #
	###########################

	$ENV{SCREEN}="screen";
	$ENV{TELNET}="telnet";
	$ENV{PERL}="$Config{perlpath}";
	$ENV{PROCSERV}="/APSshare/bin/procServ";
	
}


use Env;
use File::Spec;
use Module::Loaded;
use List::Util;

use lib "$IOC_COMMAND_DIR";
use _info;
use _commands;


#####################################################################

my $GET_SCREEN_PID=1;

#####################################################################

if (! -d $ENV{IOC_COMMAND_DIR})
{
	print("Error: IOC command directory ($ENV{IOC_COMMAND_DIR}) doesn't exist.\n");
	print("IOC_COMMAND_DIR in $FindBin::RealScript needs to be corrected.\n");
	die;
}

#####################
#    Parse Input    #
#####################

_commands::call("_local", @ARGV);

