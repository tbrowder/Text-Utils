#!/usr/bin/env raku

sub do-it {...}
sub do-it2 {...}

my @opts = 
   Nil,   # 0
   "",    # 1
   True,  # 2
   False, # 3
   "hi",  # 4
   0,     # 5
   1,     # 6
   2,     # 7
#  Any,   # 8
;

if not @*ARGS {
    print qq:to/HERE/; 
    Usage: {$*PROGRAM.basename} go

    Analyzes various arg values and types.

    HERE
    exit;
}

my $debug = 1;
my $line = "b";
for @opts.kv -> $i, $opt {
    do-it $line, :$i, :$opt, :$debug;
}

sub do-it2(
    Str:D $line,
    :$max-limit,
    ) is export {
    if $max-limit.defined {
        given $max-limit {
            when Bool {
            }
            when UInt {
            }
            default {
            }
        }
    }
    else {
        # undef
    }

}

=finish

   
sub do-it(
    Str:D $line,
    :$i,
    :$opt,
    :$debug,
    ) is export {
    
    # test type of param $opt
    # which can be:
    #   undefined
    #   Bool
    #   UInt >= 2
    #
    # should we specify a return
    #   value?

    unless $line {
        die "FATAL: \$line is empty";
    }

    given $opt {
        my $typ = $_.^name;

        when Bool  { 
            say "DEBUG: $i \$opt type $typ is: '$_'" if $debug; }
        when UInt  { 
            say "$i \$opt type $typ is: '$_'" if $debug; }
        when Int  { 
            say "$i \$opt type $typ is: '$_'" if $debug; }
        when Numeric  { 
            say "$i \$opt type $typ is: '$_'" if $debug; }
        when Str   {
            say "$i \$opt type $typ is: '$_'" if $debug; }

        default {
            say "$i \$opt default type $typ is: '$_'" if $debug;
        }
    }
}
 
