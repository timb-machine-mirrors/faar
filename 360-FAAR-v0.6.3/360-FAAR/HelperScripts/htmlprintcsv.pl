#!/usr/bin/perl -w

# NOTE: this script is lifted almost wholesale from stackoverflow, from here: http://stackoverflow.com/questions/200140/how-do-i-convert-csv-into-an-html-table-using-perl.
#	It seems to work just fine, thanks to tsee.

use strict;
use warnings;
use CGI qw();
use Text::CSV;

my $file;
if (defined (@ARGV)) {
	$file = $ARGV[0];
} else {
	print "\nThis \"helper script\" converts 360-FAAR 'print' mode output CSV's to HTML tables\n";
	print "You can, if you want, delete uninteresting columns from the CSV before converting to HTML\n";
	print "column headers and table headers are found dynamicaly\n\n";
	print "USAGE EXAMPLE:\n";
	print "  ./htmlprintcsv.pl printout.csv > testface.html\n\n";
	exit
}

my $cgi = CGI->new();
print $cgi->header();

my $headercount = 0;

# should really use a templating module from CPAN,
# but let's take it step by step.
# Any of the following would fit nicely:
# - Template.pm (Template Toolkit)
# - HTML::Template, etc.
my $startHtml = <<'HERE';
<html>
<head> <title>360-FAAR 'print' Mode Firewall Object Analysis Report</title> </head>
<body bgcolor="#BDBDBD">
<div align="left">
<table cellpadding="1" cellspacing="1" border="1" bordercolor="black" width="100%">
HERE
my $endHtml = <<'HERE';

</table>

</body>
<html>
HERE
my $endTable = <<'HERE';

</table>

HERE

my @columns ;

my $csv = Text::CSV->new();
open my $fh, '<', $file
  or die "Could not open file '$file': $!"; # should generate a HTML error here

while (defined(my $line = <$fh>)) {
  if ($line =~ /^## NAME/) {
	  if ($headercount > 0) {
  # NOTE: if this isnt the first table close the preceding table
		  print $endTable;
	  }
	  my @columnnames = split (/\,/, $line) ;
	  my $colcount = 0;
	  foreach my $colname (@columnnames) {
		  $columns[$colcount] = { name => "$colname", width => 40 };
		  $colcount++;
	  }
	# print header
	print $startHtml;
	print_table_header(\@columns);
	$headercount++;
	next;
  }


  $csv->parse($line);
  # watch out: This may be "tainted" data!
  my @fields = $csv->fields();
  @fields = @fields[0..$#columns] if @fields > @columns;
  print_table_line(\@fields);
}

close $fh;

print $endHtml;




sub print_table_header {
  my $columns = shift;
  print "<tr>\n";
  foreach my $column (@$columns) {
    my $widthStr = (defined($column->{width}) ? ' width="'.$column->{width}.'"' : '');
    my $colName = $column->{name};
    print qq{<td$widthStr bgcolor="#FFFF00"><font size="2">$colName</font></td>\n};
  }
  print "</tr>\n";
}

sub print_table_line {
  my $fields = shift;
  print "<tr>\n";
  foreach my $field (@$fields) {
    print qq{<td bgcolor=\"#CEF6F5\"><font size="2">$field</font></td>\n};
  }
  print "</tr>\n";
}

