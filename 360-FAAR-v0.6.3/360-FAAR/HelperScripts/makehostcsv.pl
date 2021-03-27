#!/usr/bin/perl -w

# run the resolvenames.pl script first to create the report.txt file
# run this command to output names in 'od' style CSV:
# ./makehostcsv.csv > output_file_for_od_format_names.csv
# the script will output the names found with resolvenames.pl in 'od'
# format, the last name listed for a subnet will be used for the translation.
# the outputfile can be read by 360-faar.pl and used to translate ip block
# names with 'rr' and 'bldobj' mode.  Load the output rulebase (from 'res')
# mode as well as the newly created 'od' csv objects.  Select the 'od' csv
# objects as the destination firewall in either mode and objects will be 
# translated in the output.

use strict;
use warnings;

use Net::Netmask;
use Net::DNS;

STDOUT->autoflush(1);

my $filename = 'report.txt';

# NOTE: read previously lookedup names from existing output file 
 
open(my $infh, '<', $filename) or die "Could not open file '$filename' $!";

foreach my $prevline (<$infh>) {
	chomp ($prevline);

	my ($ip, $name, $wname) = split (',', $prevline);
	$ip   =~ s/\/27$//;
	$name =~ s/\.$//;

	if (($name eq 'none') && defined($wname) && ($wname !~ /^\s*$/)) {

		print "$wname\-$ip\-27,net,$ip,255.255.255.224,,,,\n";

	} elsif (defined($wname) && ($wname !~ /^\s*$/)) {

		print "$wname\-$ip\-27\-$name,net,$ip,255.255.255.224,,,,\n";

	} elsif ($name ne 'none') {

		print "$ip\-27\-$name,net,$ip,255.255.255.224,,,,\n";

	} else {
		print "ERROR:$wname\-$ip\-27\-$name,net,$ip,255.255.255.224,,,,\n";
	}
}

close $infh;


