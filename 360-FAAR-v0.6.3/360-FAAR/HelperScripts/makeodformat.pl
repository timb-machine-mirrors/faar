#!/usr/bin/perl -w

while (<>) {
	if (/^security_rule/) {
		$_ =~ s/\, /\,/g;
		$_ =~ s/ /\;/g;
		print $_;
	} else {
		$_ =~ s/\, /\,/g;
		print $_;
	}
}
