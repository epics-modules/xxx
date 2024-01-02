#!/usr/bin/perl

use strict;
use FindBin;

###################################################################
# Set Environment Variables to be used by the rest of the scripts #
###################################################################

BEGIN
{
	# Top level of the IOC folder
	$ENV{TOP} = "$FindBin::RealBin/../../..";
	
	
	# IOC prefix name, used to find the correct iocBoot directory and executable
	$ENV{IOC_NAME}="xxx";
	
	
	
	#########################
	# IOC Executable Config #
	#########################
	
	# Name of the IOC executable file
	$ENV{IOC_BINARY}="$ENV{IOC_NAME}";
	#! $ENV{IOC_BINARY}="xxx";
	
	
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
	
	
	
	##########################
	# Config For This Script #
	##########################
	
	# Directory that contains all the command modules to be loaded
	$ENV{IOC_COMMAND_DIR}="$ENV{IOC_STARTUP_DIR}/softioc/commands";
	#! $ENV{IOC_COMMAND_DIR}="/home/username/epics/ioc/synApps/xxx/iocBoot/iocxxx/softioc/commands";
	
	
	$ENV{IOC_CMD}="$ENV{IOC_BIN_PATH} $ENV{IOC_STARTUP_FILE_PATH}";
	
	# Required shell commands
	$ENV{SCREEN}="screen";
	$ENV{TELNET}="telnet";
	$ENV{PROCSERV}="/APSshare/bin/procServ";
	$ENV{NETCAT}="nc";
	$ENV{ECHO}="echo";
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

