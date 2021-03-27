#!/usr/bin/perl  

open FILE, "$ARGV[0]" ;

while (<FILE>) {
	@line = split(/\s+/, $_) ;
	#print "$line[3], $line[4]\n";
	if ($line[3] =~ /192.168.73.222/) {
		$nm = 32;
		($ip, $nm) = split (/\//, $line[1]);
		#($ip, $nm) = split (/\//, $line[0]);
		#print "EX $ip $nm\n";
		print "IN $ip $nm\n";
		#print "WAN $ip $nm\n";
	}
}
#print "TRANSIT 0.0.0.0 0\n";

