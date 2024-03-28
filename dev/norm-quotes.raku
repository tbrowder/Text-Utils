#!/usr/bin/env raku

my $xfil = "quoted.txt";
my $ifil;

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
for $ifil.IO.lines.kv -> $i, $line {
    say "Checking line $i";
    for $line.comb.kv -> $j, $c {
        my $u = $c.uniname;
        say "  char $j: $c ($u)";
    }
}

# proper quote pairs:
=begin table
Left quote | Right quote
-----------+------------
U+0022  (E<0x0022>)  | U+0022  (E<0x0022>)
U+0027  (E<0x0027>)  | U+0027  (E<0x0027>)
U+0018  (E<0x0018>)  | U+0019  (E<0x0019>)
U+201C  (E<0x201C>)  | U+201D  (E<0x201D>)
=end table

