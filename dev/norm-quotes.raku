#!/usr/bin/env raku

use Text::Utils :ALL;
use Number::More :dec2hex;

my $xfil = "quoted.txt";
my $ifil;

# hashes containing quote char hex codes
my %quote-left = %(
    # left => right
);
my %quote-right = %(
    # right => left
);
;
if not @*ARGS {
    print qq:to/HERE/;
    Usage: {$*PROGRAM.basename} <text file>

    Normalize one or more strings of text. Detects improperly
    quoted text;

    HERE
    exit;
}

my @args;
for @*ARGS {
    unless $_.IO.r {
        @args.push: $_; 
    }
    $ifil = $_;
}

for @*ARGS {
    when /^ :i g/ {
        $ifil = $xfil
    }
    default {
        say "FATAL: Unknown arg '$_'";
    }
}

say "Inspecting file: $ifil";
for $ifil.IO.lines.kv -> $i, $line is copy {
    $line = strip-comment $line;
    next if $line !~~ /\S/;

    say "Checking line $i";
    for $line.comb.kv -> $j, $c {
        my $u = $c.uniname;
        my $d = $c.ord; # decimal
        # convert to 4-char hex
        my $h = dec2hex $d, 4;
        say "  char $j: $c ($u, $h)";
    }
}

# proper quote pairs:
=begin table
Left quote | Right quote
-----------+------------
U+0022  (E<0x0022>)  | U+0022  (E<0x0022>)
U+0027  (E<0x0027>)  | U+0027  (E<0x0027>)
U+2018  (E<0x2018>)  | U+2019  (E<0x2019>)
U+201C  (E<0x201C>)  | U+201D  (E<0x201D>)
=end table

