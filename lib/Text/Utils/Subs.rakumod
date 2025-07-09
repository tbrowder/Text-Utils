unit module Text::Utils::Subs;

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
