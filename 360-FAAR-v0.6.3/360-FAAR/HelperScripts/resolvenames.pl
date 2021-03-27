#!/usr/bin/perl -w

# run this command to create the file report.txt
# touch report.txt
# run the script:
# ./resolvenames.pl od_format_csv_output_from_res_mode.csv
# the script will find all Log_Net_ /27 blocks and resolve
# the names from the block, else it resolves the whois.
# The code for this scrpit is mostly cut and pasted from here:
# http://stackoverflow.com/questions/85487/reverse-dns-lookup-in-perl

use strict;
use warnings;

use Net::Netmask;
use Net::DNS;
use Net::Whois::IP qw(whoisip_query);

STDOUT->autoflush(1);

my $filename = 'report.txt';

my %ipstocheck;
my %ipsnottocheck;


while (<>) {
	my $line = $_;
	if ($line =~ /^Log_Net_/) {
		my ($lognet) = split(',', $line);
		$lognet =~ s/^Log_Net_//;
		my ($ip, $nm) = split ('-', $lognet);
		$ipstocheck{$ip}++;
		#system("dig -x $ip") ;
	}
}

my $numoflognets = scalar keys %ipstocheck;
print "\nRead $numoflognets Log Networks to resolve\n\n";


# NOTE: read previously lookedup names from existing output file 
 
open(my $infh, '<', $filename) or die "Could not open file '$filename' $!";

foreach my $prevline (<$infh>) {
	my ($ip, $name) = split (',', $prevline);

	$ipsnottocheck{$ip}++;
}

close $infh;


# NOTE: close initial read of file and open in append so as to avoid clobbering the file

open(my $fh, '>>', $filename) or die "Could not open file '$filename' $!";

# set to write responses to file without buffering.
$fh->autoflush(1);

# NOTE: cycle through IP that we should reverse name lookup and lookup each IP from subnet

foreach my $ip (keys %ipstocheck) {

# NOTE: cycle through the IP's from 'any' rules

	print "\nLooking up IP block $ip\/27 ============================================\n";

	if (exists $ipsnottocheck{"$ip\/27"}) {
		print "Already written $ip\/27 to file $filename\n";
		next;
	}

	my $block = Net::Netmask->new("$ip\/27");

	my $res = Net::DNS::Resolver->new;

	my %sockets;
	my %namesreplies;
	my %whoisreplies;
	my $count = 0;


	my $wipresp = whoisip_query($block->nth(1)); 

	if (defined($wipresp) && exists $wipresp->{'NetName'}) {
		$whoisreplies{$wipresp->{'NetName'}}++; 
	}

	#foreach (sort keys(%{$response}) ) { 
	#	    print "$_ $response->{$_} \n"; 
	#}

	my $i = 0;
	for my $i (1 .. $block->size - 1) {
	    $count++;
	    my $ip = $block->nth($i);

	    my $reverse_ip = join ".", reverse split m/\./, $ip;
	    $reverse_ip .= ".in-addr.arpa";

	    my $bgsock = $res->bgsend($reverse_ip, 'PTR');
	    $sockets{$ip} = $bgsock;

	    print ".";
	    sleep 2 unless $i % 9;
	    #sleep 1;
	}

	print " $count requests sent\n";

	$i = 0;
	for my $i (1 .. $block->size - 1) {

	    my $ip = $block->nth($i);

	    my $socket = $sockets{$ip};
	    my $wait   = 0;

	    until ($res->bgisready($socket)) {
		print "waiting for $ip\n" if $wait > 0;
		sleep 1 + $wait;
		$wait++;
	    }

	    my $packet = $res->bgread($socket);
	    my @rr ;

	    if (defined($packet)) {
	    	    @rr     = $packet->answer;
	    } else {
	    	    print "No reply for $ip\n";
	    	    next;
	    }

	    #printf "%-15s %s\n", $ip, $res->errorstring
	    #  unless @rr;

	    for my $rr (@rr) {
		#printf "%-15s %s\n", $ip, $rr->string;
		my $name = $rr->string;
		$name =~ s/\r|\n//g;
		$name =~ s/\(|\)//g;
		my @repstring = split (/\s+/, $name);
		my $revnameout = $repstring[4];
		$revnameout =~ s/\.$//;
		$namesreplies{ $revnameout }++;
	    }
	}

	my $namecount = scalar keys %namesreplies;

	if (($namecount == 0) && (scalar keys %whoisreplies > 0)) {

		print "\nFound Whois Name for IP block $ip\/27:\n";
		my @wname = sort keys %whoisreplies;
		my $wname = "@wname"; 
		print "$ip\/27,none,$wname\n";
		print $fh "$ip\/27,none,$wname\n";

	} else {

		print "\nFound $namecount Names for IP block $ip\/27:\n";
		foreach my $name (sort keys %namesreplies) {
			my @wname = sort keys %whoisreplies;
			my $wname = "@wname"; 
			print     "$ip\/27,	$name, $wname\n";
			print $fh "$ip\/27,$name,$wname\n";
		}
	}
}


