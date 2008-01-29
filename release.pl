# FILENAME...	release.pl
#
# USAGE... This PERL script is used in conjunction with a start_epics_xxx
#           csh script to setup environment variables for medm.
#
# ORIGINAL AUTHOR: Ron Sluiter
# 
# SYNOPSIS...	release.pl(<ioctop> directory)
#
#
# MODIFICATION LOG...
# 03/25/04 rls Support for GATEWAY environment variable.
# 04/08/04 rls Bug fix for spaces between macro and '=' sign; e.g. MPF = /home/mpf.
# 01/25/08 rls Support "include" entries without a macro; e.g. "include /home/ioc/configure/MASTER_RELEASE"
# 01/29/08 rls Bug fix; "($macro) =" line is wrong.

#
#Version:	$Revision: 1.7 $
#Modified By:	$Author: sluiter $
#Last Modified:	$Date: 2008-01-29 21:18:55 $

use Env;

if ($ENV{GATEWAY} ne "")
{
    # Add GATEWAY to macro list.
    $applications{GATEWAY} = $ENV{GATEWAY};
}

$top = $ARGV[0];

$applications{TOP} = $top;

@files =();
push(@files,"$top/configure/RELEASE");

foreach $file (@files)
{
    if (-r "$file")
    {
	open(IN, "$file") or die "Cannot open $file\n";
	while ($line = <IN>)
	{
	    next if ( $line =~ /\s*#/ );
	    chomp($line);
	    $_ = $line;
	    #test for "include" command
	    ($prefix,$post) = /(.*)\s* (.*)/;
	    if ($prefix eq "include")
	    {
		($prefix,$macro,$post) = /(.*)\s* \s*\$\((.*)\)(.*)/;
		if ($macro eq "")
		{
		    #true if no macro is present
		    #the following looks for
		    #prefix = post
		    ($prefix,$post) = /(.*)\s* \s*(.*)/;
		}
		else
		{
		    $base = $applications{$macro};
		    if ($base eq "")
		    {
			#print "error: $macro was not previously defined\n";
		    }
		    else
		    {
			$post = $base . $post;
		    }
		}
		push(@files,"$post")
	    }
	    else
	    {
		#the following looks for
		#prefix = $(macro)post
		($prefix,$macro,$post) = /(.*)\s*=\s*\$\((.*)\)(.*)/;
		if ($macro eq "")
		{
		    #true ifno macro is present
		    #the following looks for
		    #prefix = post
		    ($prefix,$post) = /(.*)\s*=\s*(.*)/;
		}
		else
		{
		    $base = $applications{$macro};
		    if ($base eq "")
		    {
			#print "error: $macro was not previously defined\n";
		    }
		    else
		    {
			$post = $base . $post;
		    }
		}

		$prefix =~ s/^\s+|\s+$//g; # strip leading and trailing whitespace.

		$applications{$prefix} = $post;
		if ( -d "$post")
		{
		    print "set $prefix = $post\n";
		}
	    }
	}
	close IN;
    }
}

