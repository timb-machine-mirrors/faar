#!/usr/bin/perl 

open SERVICES, "$ARGV[0]" or die "Can't open $ARGV[0]: $!\n";
open DEFAULTS, "$ARGV[1]" or die "Can't open $ARGV[1]: $!\n";

while (<SERVICES>) {
	next if /^#/;
	next if /^\s+/;
	@line = split (/\s+/, $_ );
	($port, $proto) = split (/\//, $line[1]) ;
	$name = $line[0];
	#$line[0] =~ s/\-|\_//g;
	#$line[0] =~ s/\-|\_//g;
	#$line[0] =~ tr/A-Z/a-z/;
	#print "$line[0]\n";
	$srvcs{$line[0]}{'pro'} = $proto;
	$srvcs{$line[0]}{'prt'} = $port;
	$srvcs2{$line[0]}{$proto}{$port}++;
}

print "# NOTE: OSX /etc/services ports\n\n";

foreach my $srvc (keys %srvcs2) {
	foreach my $proto (keys %{$srvcs2{$srvc}}) {
		foreach my $port (keys %{$srvcs2{$srvc}{$proto}}) {
			print "	\$srvcobjects_ref->{'$srvc'}{'type'} = '$proto'	\; \n";
			#print "	\$srvcobjects_ref->{'$srvc'}{'default'} = 'OSX'	\; \n";
			print "	\$srvcobjects_ref->{'$srvc'}{'port'}{'$proto'} = '$port'	\; \n";
			print "	\$srvcobjects_ref->{'$srvc'}{'ports'}{'$proto'}{'$port'}++	\; \n";
			print "	\$ports_ref->{'$proto'}{'$port'}{'name'} = '$srvc'		\; \n";
		}
	}
}

#print "###########################################################################################################\n";
#print "\n# NOTE: Checkpoint Default TCP ports\n\n";
#print "\n# NOTE: Checkpoint Default UDP ports with non numeric port addresses\n\n";

while (<DEFAULTS>) {
	@line = split (/\s+/, $_ );
	$name = $line[1];
	$line[0] =~ s/\-|\_//g;
	$line[0] =~ s/\-|\_//g;
	$line[0] =~ tr/A-Z/a-z/;
	if (exists $srvcs{$line[0]}) {
		#$proto = $srvcs{$line[1]}{'pro'};
		#$port = $srvcs{$line[1]}{'prt'} ;
		$proto = 'udp';
		$port = $name;
		#print "	\$srvcobjects_ref->{'$name'}{'type'} = '$proto'	\; \n";
		#print "	\$srvcobjects_ref->{'$name'}{'default'} = 'yes'	\; \n";
		#print "	\$srvcobjects_ref->{'$name'}{'port'}{'$proto'} = '$port'	\; \n";
		#print "	\$srvcobjects_ref->{'$name'}{'ports'}{'$proto'}{'$port'}++	\; \n";
		#print "	\$ports_ref->{'$proto'}{'$port'}{'name'} = '$name'		\; \n";
	} else {
#		$proto = 'dce-rpc';
#		$port = $name;
#		print "	\$srvcobjects_ref->{'$name'}{'type'} = '$proto'	\; \n";
#		print "	\$srvcobjects_ref->{'$name'}{'port'}{'$proto'} = '$port'	\; \n";
#		print "	\$srvcobjects_ref->{'$name'}{'ports'}{'$proto'}{'$port'}++	\; \n";
#		print "	\$ports_ref->{'$proto'}{'$port'}{'name'} = '$name'		\; \n";
	}
}
