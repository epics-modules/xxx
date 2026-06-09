package _release;

# _release.pm
#
# Utility package for parsing EPICS configure/RELEASE files and
# discovering display screen directories within support modules.
#
# Usage:
#   use _release;
#
#   my %apps;
#   $apps{"TOP"} = $TOP;
#   _release::parse("$TOP/configure/RELEASE", \%apps);
#
#   my $path = _release::display_path($TOP, "caqtdm");

use strict;
use Cwd 'abs_path';

# Directories to skip during search -- build artifacts, VCS,
# test/example code, documentation, and iocBoot directories.
my %SKIP_DIRS = map { $_ => 1 } qw(
    .git .svn .hg
    bin lib include dbd db
    iocBoot documentation docs
    autoconvert
);

# Prefixes of directory names to skip (test apps, examples, etc.)
my @SKIP_PREFIXES = qw(test example);


###############################################################################
# Parse a RELEASE file and populate a hash of MODULE => PATH
#
#   $file         - Path to the RELEASE file
#   $applications - Hash ref to populate with module paths
###############################################################################

sub parse
{
    my ($file, $applications) = @_;

    if (-r "$file")
    {
        open(my $fh, "<", "$file") or return;

        while (my $line = <$fh>)
        {
            next if ($line =~ /^\s*#/);

            chomp($line);
            $line =~ s/\r//g;

            # Test for "include" / "-include" directives
            if ($line =~ /^(-?include)\s+(.*)/)
            {
                my $inc_path = $2;

                # Resolve $(MACRO) references in the include path
                if ($inc_path =~ /\$\((\w+)\)(.*)/)
                {
                    my $macro = $1;
                    my $rest  = $2;

                    if (exists $applications->{$macro} && $applications->{$macro} ne "")
                    {
                        $inc_path = $applications->{$macro} . $rest;
                    }
                    else
                    {
                        next;    # macro not yet defined, skip
                    }
                }

                parse($inc_path, $applications);
            }
            elsif ($line =~ /^(\w+)\s*=\s*(.*)/)
            {
                my $key = $1;
                my $val = $2;

                # Resolve $(MACRO) references in the value
                if ($val =~ /\$\((\w+)\)(.*)/)
                {
                    my $macro = $1;
                    my $rest  = $2;

                    if (exists $applications->{$macro} && $applications->{$macro} ne "")
                    {
                        $val = $applications->{$macro} . $rest;
                    }
                }

                $key =~ s/^\s+|\s+$//g;

                if ($key ne "")
                {
                    $applications->{$key} = $val;
                }
            }
        }

        close($fh);
    }
}


###############################################################################
# Depth-limited directory scanner.  Searches for directories containing
# files with the given extension.  When a matching directory is found,
# its /autoconvert subdirectory is also added (if it exists) but not
# searched further.  Skips build output, test, and documentation dirs.
###############################################################################

sub _search_depth
{
    my ($dir, $extension, $max_depth, $results) = @_;

    return if $max_depth < 0;

    # Check if this directory contains screen files
    my @files = glob("$dir/*.$extension");

    if (@files)
    {
        push @$results, $dir;

        # Also add /autoconvert if it exists (but don't search into it)
        if (-d "$dir/autoconvert")
        {
            push @$results, "$dir/autoconvert";
        }

        return;    # Don't recurse deeper once we've found screen files
    }

    # No screen files here, but check if autoconvert/ has them
    # (some modules only have auto-converted screens, not hand-crafted ones)
    if (-d "$dir/autoconvert")
    {
        my @ac_files = glob("$dir/autoconvert/*.$extension");

        if (@ac_files)
        {
            push @$results, "$dir/autoconvert";
            return;
        }
    }

    # Recurse into subdirectories
    return if $max_depth == 0;

    opendir(my $dh, $dir) or return;

    my @subdirs = grep {
        my $name = $_;

        $name ne '.' && $name ne '..'
        && !$SKIP_DIRS{$name}
        && $name !~ /^O\./
        && !grep { $name =~ /^${_}/i } @SKIP_PREFIXES;
    } readdir($dh);

    closedir($dh);

    for my $subdir (sort @subdirs)
    {
        my $full = "$dir/$subdir";
        next unless -d $full;
        _search_depth($full, $extension, $max_depth - 1, $results);
    }
}


###############################################################################
# Discover screen file directories for a given file extension within a
# module path.  Searches to a depth of 3 directories, which covers all
# standard synApps screen directory layouts.
#
# If the module contains a 'modules/' subdirectory (e.g., motor), each
# submodule is also searched to depth 3.
###############################################################################

sub screen_dirs
{
    my ($module_path, $extension) = @_;

    my @found;

    return @found unless (-d $module_path);

    # Search to depth 3 from the module root
    _search_depth($module_path, $extension, 3, \@found);

    # If a 'modules/' subdirectory exists, search each submodule within
    # it to depth 3 (covers motor-style layouts)
    if (-d "$module_path/modules")
    {
        opendir(my $dh, "$module_path/modules") or return sort @found;

        for my $submod (sort readdir($dh))
        {
            next if $submod eq '.' || $submod eq '..';
            my $submod_path = "$module_path/modules/$submod";
            next unless -d $submod_path;
            _search_depth($submod_path, $extension, 3, \@found);
        }

        closedir($dh);
    }

    return sort @found;
}


###############################################################################
# Build the complete display path for a given display manager.
#
#   $epics_app       - Top level IOC directory (TOP)
#   $display_manager - "medm", "caqtdm", or "pydm"
#
# Returns the colon-separated display path string.
###############################################################################

sub display_path
{
    my ($epics_app, $display_manager) = @_;

    # Determine file extension to search for
    my $extension;

    if    ($display_manager eq "medm")    { $extension = "adl"; }
    elsif ($display_manager eq "caqtdm")  { $extension = "ui"; }
    elsif ($display_manager eq "pydm")    { $extension = "ui"; }
    else                                  { return ""; }

    # Parse RELEASE to get all module paths
    my %applications;
    $applications{"TOP"} = $epics_app;

    if (defined $ENV{GATEWAY} && $ENV{GATEWAY} ne "")
    {
        $applications{"GATEWAY"} = $ENV{GATEWAY};
    }

    parse("$epics_app/configure/RELEASE", \%applications);

    # Remove non-module entries
    delete $applications{"TOP"};
    delete $applications{"SUPPORT"};
    delete $applications{"EPICS_BASE"};

    # Scan the local application directory first so its screens take priority
    my @path_components;

    if (-d $epics_app)
    {
        my @local_dirs = screen_dirs($epics_app, $extension);
        push @path_components, @local_dirs;
    }

    # Discover screen directories in each support module
    foreach my $mod (sort keys %applications)
    {
        my $mod_path = $applications{$mod};
        next unless (-d $mod_path);

        my @dirs = screen_dirs($mod_path, $extension);
        push @path_components, @dirs;
    }

    return join(":", @path_components);
}

1;
