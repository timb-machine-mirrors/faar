#!/usr/bin/perl -w

$count = 0;
while (<>) {
	if (/^rulebase_header/) {
		$count = 0;
		print $_;
	#} elsif (/^security_rule|^section_header|^disabled_sec_rule/) {
	} elsif (/^security_rule|^disabled_sec_rule/) {
		$count++;
		$_ =~ s/\,/\, /g;
		$_ =~ s/\;/ /g;
		print "Rule: $count, $_";
	} else {
		print $_;
	}
}
