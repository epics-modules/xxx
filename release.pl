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
	    ($prefix,$macro,$post) = /(.*)\s* \s*\$\((.*)\)(.*)/;
	    if ($prefix eq "include")
	    {
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

