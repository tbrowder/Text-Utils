#!/usr/bin/env raku

sub has-all-args {...}
sub has-c-arg    {...}

if not @*ARGS {
    print qq:to/HERE/;
    Usage: {$*PROGRAM.basename} go

    Demonstrates using '|c' to pass arguments to another
    routine which decodes and uses them.

    HERE
    exit;
}

sub has-all-args (
    UInt $a = 1,
    Str  $b = "a",
    Str  :$c = "d",
    Hash :%d,
    List :@e,
    ) is export {
    @e = <f g h>;
    %d = 5 => "i";
} # sub Caller

sub has-c-arg($a, |c) is export {
    # expect c = $b, :$c, :%d, :@e
    my $b = c.b;
    my $c = c.c;
    my %d = c.d;
    my @e = c.e;
} # sub Called


