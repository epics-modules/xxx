#!/usr/bin/env perl

use Env;
use strict;
use warnings;

use Cwd qw(cwd);
use Getopt::Std;
$Getopt::Std::STANDARD_HELP_VERSION = 1;

use EPICS::Path;
use EPICS::Release;

our ($arch, $top, $iocroot, $root);
our ($opt_a, $opt_t, $opt_T);

getopts('a:t:T:') or HELP_MESSAGE();

my $cwd = UnixPath(cwd());

if ($opt_a) {
    $arch = $opt_a;
} else {                # Look for O.<arch> in current path
    $cwd =~ m{ / O. ([\w-]+) $}x;
    $arch = $1;
}

if ($opt_T) {
    $top = $opt_T;
} else {                # Find $top from current path
    # This approach only works inside iocBoot/* and configure/*
    $top = $cwd;
    $top =~ s{ / iocBoot .* $}{}x;
    $top =~ s{ / configure .* $}{}x;
}

# The IOC may need a different path to get to $top
if ($opt_t) {
    $iocroot = $opt_t;
    $root = $top;
    if ($iocroot eq $root) {
        # Identical paths, -t not needed
        undef $opt_t;
    } else {
        while (substr($iocroot, -1, 1) eq substr($root, -1, 1)) {
            chop $iocroot;
            chop $root;
        }
    }
}

# HELP_MESSAGE() unless @ARGV == 1;

my $outfile = $ARGV[0];

# TOP refers to this application
my %macros = (TOP => LocalPath($top));
my @apps   = ('TOP');   # Records the order of definitions in RELEASE file

# Read the RELEASE file(s)
my $relfile = "$top/configure/RELEASE";
die "Can't find $relfile" unless (-f $relfile);
readReleaseFiles($relfile, \%macros, \@apps, $arch);
expandRelease(\%macros);


# This is a perl switch statement:
for ($outfile) {
    do { genconfig();  last; };
}

sub genconfig {
	my @includes = grep !m/^ (RULES | TEMPLATE_TOP) $/x, @apps;

    unlink($outfile);
    open(OUT,">$outfile") or die "$! creating $outfile";

    my $ioc = $cwd;
    $ioc =~ s/^.*\///;  # iocname is last component of directory name
	
	print OUT "local MODULES = {\n";
	
	foreach my $app (@includes) {
        my $iocpath = my $path = $macros{$app};
        $iocpath =~ s/^$root/$iocroot/o if ($opt_t);
        $iocpath =~ s/([\\"])/\\$1/g; # escape back-slashes and double-quotes
        print OUT "\t[\"$app\"] = \"$iocpath\",\n" if (-d $path);
    }

	print OUT "}\n";
	print OUT "return MODULES";
	
    #print OUT "MODULES{(\"IOC\",\"$ioc\")\n";
    
    close OUT;
}

