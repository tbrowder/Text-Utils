#!/usr/bin/env raku

sub do-it {...}

if not @*ARGS {
    print qq:to/HERE/; 
    Usage: {$*PROGRAM.basename} go

    Analyzes various arg values and types.

    HERE
    exit;
}

my $delimiter = ":";
my $line = " boys : in : the : hood ";

# limit undefined
my @w = do-it $line, :limit;
my $res = @w.join("|");
say $res;

# limit not used
my @w2 = do-it $line;
my $res2 = @w.join("|");
say $res2;

my @limits = 0..^4; # $line.chars;
for @limits -> $limit {
    my @w = do-it $line, :$limit;
    my $res = @w.join("|");
    say "limit=$limit, result: '$res'";
}

sub do-it(
    Str:D $line,
    :$limit is copy,
    --> List
    ) is export {
    constant $min-limit = 2;
    if $limit.defined {
        if $limit ~~ Int {
            $limit = $limit >= $min-limit ?? $limit !! $min-limit
        }
        else {
            $limit = $min-limit;
        }
    }
    else {
        # undef
        $limit = Inf;
    }
    my @list = split $delimiter, $line, $limit, :v;
}
