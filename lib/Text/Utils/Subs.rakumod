unit module Text::Utils::Subs;

use Test;

#my ($level, $de, $s2, @p2, @np, @nv, $np, $nv);

# Helper routines for special needs by primary routines.
sub find-all-text-splitters (
    Str $haystack, # the string to search
    Str $needle,   # the text splitter of interest
    --> List       # list of hashes of match data
    ) is export {
    my @matches;
    my @remains;
    my $pos = 0;
    while $haystack.index($needle, $pos) -> $found-at {
       @matches.push: {
           splitter => $needle,
           start => $found-at,
           end   => $found-at + $needle.chars - 1,
        };
        $pos = $found-at + 1; # start point for next search
        # get the remaining piece of the original string
    }
    @matches;
} # end of sub

sub find-text-reverse (
    Str :$splitter,   # the text splitter of interest for the split
    Str :$string,  # the string to search
    ) is export {
    my $first;     # text before the splitter plus the splitter
    my $last;      # text after the splitter
    my $pos = 0;   # beginning of the search string

    with $string.rindex($splitter) -> $pos {
        my %m = %(
           start => $pos,
           end   => $pos + $splitter.chars - 1,
        );
        my $first = $string.comb[0..%m<end>].join;
        my $spos  = %m<end> + 1; # start point for next search
        # get the remaining piece of the original string
        $last = $string.comb[$spos..*].join;
        if 1 {
            say "string: '$string'";
            say "splitter:  '$splitter'";
            say "first:  '$first'";
            say "last:   '$last'";
        }
        return %m;
    }
    { status => "not found" }
}

sub find-text-forward (
    Str :$splitter,   # the text splitter of interest for the split
    Str :$string,  # the string to search
    --> Hash       # hash of match data
    ) is export {
    my $first;     # text before the splitter plus the splitter
    my $last;      # text after the splitter
    my $pos = 0;   # beginning of the search string

    with $string.index($splitter) -> $pos {
        my %m = %(
           start => $pos,
           end   => $pos + $splitter.chars - 1,
        );
        my $first = $string.comb[0..%m<end>].join;
        my $spos  = %m<end> + 1; # start point for next search
        # get the remaining piece of the original string
        $last = $string.comb[$spos..*].join;
        if 1 {
            say "string: '$string'";
            say "splitter:  '$splitter'";
            say "first:  '$first'";
            say "last:   '$last'";
        }
        return %m;
    }
    { status => "not found" }
} # end of sub find-text-forward

subset SplitOp of Str  is export where * eq ":v";
subset LevelOp of UInt is export where * >= 1; 
sub test-and-show-string-list(
    @str,                 #= strings to test
    Str :$delim!,         #= delimiter
    LevelOp :$level = 1 , #= min number of matches
    SplitOp :$opt,        #= 'split' option used, if any
) is export {
    my @np=[]; my @nv=[];
    my ($np, $nv);

    my $opt-used = $opt.defined ?? $opt !! "(none)";
    print qq:to/HERE/;
    #=================================================
    Params: :level({$level}), using option '{$opt-used}'
    #=================================================
    HERE

    for @str -> $string {
        my $s = $string;
        $s .= trim;

        say "=== string: '$s', delim: '{$delim.trim}'";
        my @res = split $delim, $s, $level, {$opt.raku};
        # note the docs say the results depend on 
        #   level and any Raku core 'split' named option
        #   the only named option this package recognizes for a
        #     core 'split' option is ':v'

        # @res 
        $np = @res.elems;
        @np.push: $np;
        say "  number of parts returned: $np";
        say "  \$part => \$value";
        for @res.kv -> $i, $v {
            say "  part=$i |$v| value=$v";
        }
        @nv.push(@res.keys);
    }
    print q:to/HERE/;
    Results:
    parts  matches
    HERE
    ($np, $nv) = @np.elems, @nv.elems;
    unless $np == $nv { say "ERROR: np ($np) != nv ($nv) " };
    for @np.kv -> $i, $np {
        my $nv = @nv[$i];
        say "      {$np}      {$nv}";
    }
} # end of sub test-and-show-string-list
