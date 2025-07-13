unit module Text::Utils::Subs;

use Test;

sub is-odd(
    UInt $num
    --> Bool
    ) is export {
    $num % 2 == 1 ?? True !! False
}

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
    LevelOp :$limit,      #= max number of matches
    SplitOp :$opt,        #= 'split' option used, if any
) is export {
    my @np=[]; my @nv=[];
    my ($np, $nv);

    my $opt-used = $opt.defined ?? $opt !! "(none)";
    print qq:to/HERE/;
    #=================================================
    Params: :limit({$limit}), using option '{$opt-used}'
    #=================================================
    HERE

    for @str -> $string {
        my $s = $string;
        $s .= trim;

        say "=== string: '$s', delim: '{$delim.trim}'";
        my @res;
        if $limit {
            @res = split $delim, $s, $limit, {$opt.raku};
        }
        else {
            @res = split $delim, $s, {$opt.raku};
        }

        # note the docs say the results depend on 
        #   limit and any Raku core 'split' named option
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

sub core-split-wmods(
    # reverse order of first two args
    $string,    
    $delimiter,
    # rest
    $limit = Inf,
    :$v, :$k, :$kv, :$p, :$skip-empty,
    :$debug,
    --> List
    ) is export {

    my @res = split $delimiter, $string, $limit, 
                         :$v, :$k, :$kv, :$p, :$skip-empty;

    # debug handling


    @res;
}

=finish

=begin comment
sub core-split(
    Str:D $delimiter,
    Str:D $input,
    $limit = Inf,
    :$v, :$k, :$kv, :$p,
    #:$debug,
    --> List
    ) is export {
    my @res = split $delimiter, $string, $limit, |c;

    =begin comment
    if 0 {
        my $np = @res.elems;
        my $lim = $limit.defined ?? $limit !! "*";
        print qq:to/HERE/;
        DEBUG: Raku core routine 'split'
               delimiter: |$delimiter|
               string   : |$string|
               limit    : |$lim|
               num parts: |$np|
        HERE
        if $np {
            for $np.kv -> $i, $v {
                say "         part $i:   |$v|";
            }
        }
    }
    =end comment

    @res;
} # end of sub core-split
