#!/usr/bin/perl -w
use strict;

open OUTFILE, ">", "errors.inc" or die "Couldn't open errors.inc for writing!\n";;
open INFILE, "<", "mysqld_error.txt" or die "Couldn't open mysqld_error.txt for reading!\n";

print OUTFILE "(* Auto-generated on ", scalar gmtime, " from MySQL headers. *)\n";
print OUTFILE "type error_code = ";

my @types;
my @codes;
while (<INFILE>) {
  chomp;
  if (/^#define ER_(\w+)\s+(\d+)/o) {
      my $err = lc $1;
      my $code = $2;
      push @codes, $code;
      push @types, ucfirst $err;
  }
}

close INFILE;
open INFILE, "<", "errmsg.h" or die "Couldn't open errmsg.h for reading!\n";
while (<INFILE>) {
  chomp;
  if (/^#define CR_(\w+)\s+(\d+)/o) {
      my $err = lc $1;
      my $code = $2;
      next if $err eq "max_error" or $err eq "min_error";
      push @codes, $code;
      push @types, ucfirst $err;
  }
}
close INFILE;

my %unique_types = map { $_ => 0 } @types;
my @unique_types = keys %unique_types;
@unique_types = sort @unique_types;

print OUTFILE join(" | ", @unique_types), "\n\n";

my $i = 0;
print OUTFILE "let error_of_int code = match code with\n";
foreach my $type (@types) {
  print OUTFILE "| $codes[$i] -> $type\n";
  $i++;
}

print OUTFILE "| _ -> Unknown_error\n";

close OUTFILE;
