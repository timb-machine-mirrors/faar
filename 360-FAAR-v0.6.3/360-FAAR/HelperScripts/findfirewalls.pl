#!/usr/bin/perl 

use strict;
my %backend;
my %frontend;

while (<>) {
	my ($type, $src, $dst, $vpn, $service, $action, $log, $installon, $time, $comment) = split(/\,/, $_);
	my @installons = split(/\;/, $installon);
	foreach my $installfield (@installons) {
		if ($installfield =~ /STUFF/) {
			$backend{$_}++;
		} elsif ($installfield =~ /OTHERSTUFF/) {
			$frontend{$_}++;
		}
	}
}
print "\nBACKEND RULES TO BE ADDED:\n";
foreach my $belineout (keys %backend) {
	print $belineout;
}


print "\nFRONTEND RULES TO BE ADDED:\n";
foreach my $felineout (keys %frontend) {
	print $felineout;
}
	
