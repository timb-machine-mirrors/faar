#!/usr/bin/perl -w
use strict;
my %protos;
my %descriptions;

$protos{1}      = 'icmp'        ;
$protos{2}      = 'igmp'        ;
$protos{6}      = 'tcp'         ;
$protos{17}     = 'udp'         ;
$protos{47}     = 'gre'         ;
$protos{50}     = 'AH'          ;
$protos{51}     = 'ESP'         ;
$protos{112}    = 'vrrp'        ;
$protos{115}    = 'l2tp'        ;
$protos{'RPC'}  = 'rcp'		;

$descriptions{'APPLE-ICHAT'} 	= 'Apple iChat Services Group Pre-defined'	;
$descriptions{'MGCP'} 		= 'Media Gateway Control Protocol Pre-defined'	;
$descriptions{'MS-AD'} 		= 'Microsoft Active Directory Pre-defined'	;
$descriptions{'MS-EXCHANGE'}	= 'Microsoft Exchange Pre-defined'		;
$descriptions{'MS-IIS'} 	= 'Microsoft IIS Server Pre-defined'		;
$descriptions{'VOIP'} 		= 'VOIP Service Group Pre-defined'		;

print "\nsub set_cisco_defaults {\n";
print "	my (\$srvcobjects_ref)  = \@_;\n\n";
print "# NOTE: Cisco default services created with servicebuilder.pl by dan !! \n\n";

while (<>) {
	chomp($_);
	my ($service, $port) = split(/\,/, $_);
	my $description = 'Cisco_Default';
	my $default = 'Default';
#	next unless defined $default;
#	if (exists $protos{$proto}) {$proto = $protos{$proto};}
#	if ($port eq '-') { 
#		$port = $service; 
#		$port =~ tr/A-Z/a-z/; 
#		#$proto = $description;
#	}
#	if ($port =~ /^\d+\/\d+$/) { $port =~ tr'/'-'; }
	print "	\$srvcobjects_ref->{'$service'}{'type'}        	= 'tcp'	\; \n";
	print "	\$srvcobjects_ref->{'$service'}{'default'}    	= '$default'	\; \n";
#	print "	\$srvcobjects_ref->{'$service'}{'timeout'}    	= '$timeout'	\; \n";
	print "	\$srvcobjects_ref->{'$service'}{'description'}	= '$description'\; \n";
	print "	\$srvcobjects_ref->{'$service'}{'port'}{'tcp'}	= '$port'	\; \n";
	print "	\$srvcobjects_ref->{'$service'}{'port'}{'udp'}	= '$port'	\; \n";
	print "	\$ports_ref->{'tcp'}{'$service'}{'name'}        = '$service'    \; \n";
	print "	\$ports_ref->{'udp'}{'$service'}{'name'}        = '$service'    \; \n";
	print "	\$ports_ref->{'tcp'}{'$port'}{'name'}        	= '$service'    \; \n";
	print "	\$ports_ref->{'udp'}{'$port'}{'name'}        	= '$service'    \; \n";
	my $trsrvc = $service;
	$trsrvc =~ tr/a-z/A-Z/;
	print "	\$ports_ref->{'tcp'}{'$trsrvc'}{'name'}        = '$service'    \; \n";
	print "	\$ports_ref->{'udp'}{'$trsrvc'}{'name'}        = '$service'    \; \n";

#	my $trsrvc = $service;
#	$trsrvc =~ tr/a-z/A-Z/;
#	print "	\$srvcobjects_ref->{'$service'}{'ports'}{'$proto'}{'$service'}++ 	\; \n";
#	print "	\$srvcobjects_ref->{'$service'}{'ports'}{'$proto'}{'$trsrvc'}++ 	\; \n";
#	if ($description eq 'other') {
#		$description = $descriptions{$description};
#		#print "	\$srvcobjects_ref->{'$service'}{'ports'}{'other'}{'$port'}++	\; \n";
#		print "	\$srvcobjects_ref->{'$service'}{'ports'}{'other'}{'$service'}++	\; \n";
#		print "	\$srvcobjects_ref->{'$service'}{'ports'}{'other'}{'$trsrvc'}++	\; \n";
#	}
	#if ($port =~ /^\d+\-\d+$/) { 
	#	my ($start, $end) = split ('-', $port);
	#	for (my $i = $start; $i <= $end; $i++) {
	#		print "	\$ports_ref->{'$proto'}{'$'}{'name'}       	= '$service'	\; \n";
	#}
	#print "	\$ports_ref->{'$proto'}{'$port'}{'name'}       	= '$service'	\; \n";
}
print "}\n\n";

	

