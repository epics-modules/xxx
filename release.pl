$top = $ARGV[0];

unlink("tmp");
open(OUT,">tmp") or die "$! opening tmp";

@files =();
push(@files,"$top/config/RELEASE");

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
			print "error: $macro was not previously defined\n";
		    }
		    else
		    {
			$post = $base . $post;
		    }
		}
		$applications{$prefix} = $post;
		$app = lc($prefix);
		if ( -d "$post")
		{
		    #check that directory exists
		    print OUT "setenv $app $post\n";
		}
	    }
	}
	close IN;
    }
}
close OUT;

