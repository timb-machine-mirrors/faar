#!/usr/bin/perl -w

while (<>) {
	if (/Drop|Encrypt/) {
		unless (/disabled_sec_rule/) {
			print $_;
		}
	}
}

