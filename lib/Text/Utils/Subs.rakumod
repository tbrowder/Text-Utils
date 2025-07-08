unit module Text::Utils::Subs;

# Helper routines for special needs by primary routines.
sub find-all-text-chunks (
    Str $haystack, # the string to search 
    Str $needle,   # the text chunk of interest
    --> List       # list of hashes of match data
    ) is export {
    my @matches; 
    my @remains;
    my $pos = 0;
    while $haystack.index($needle, $pos) -> $found-at {
       @matches.push: {
           chunk => $needle,
           start => $found-at,
           end   => $found-at + $needle.chars - 1,
        };
        $pos = $found-at + 1; # start point for next search
        # get the remaining piece of the original string
    }
    @matches;
} # end of sub

sub find-text-reverse (
    Str :$chunk,   # the text chunk of interest for the split
    Str :$string,  # the string to search
    ) is export {
    my $first;     # text before the chunk plus the chunk
    my $last;      # text after the chunk
    my $pos = 0;   # beginning of the search string

    with $string.rindex($chunk) -> $pos {
        my %m = %(
           start => $pos,
           end   => $pos + $chunk.chars - 1,
        );
        my $first = $string.comb[0..%m<end>].join;
        my $spos  = %m<end> + 1; # start point for next search
        # get the remaining piece of the original string
        $last = $string.comb[$spos..*].join;
        if 1 {
            say "string: '$string'";
            say "chunk:  '$chunk'";
            say "first:  '$first'";
            say "last:   '$last'";
        }
        return %m;
    }
    { status => "not found" }
}

sub find-text-forward (
    Str :$chunk,   # the text chunk of interest for the split
    Str :$string,  # the string to search
    --> Hash       # hash of match data
    ) is export {
    my $first;     # text before the chunk plus the chunk
    my $last;      # text after the chunk
    my $pos = 0;   # beginning of the search string

    with $string.index($chunk) -> $pos {
        my %m = %(
           start => $pos,
           end   => $pos + $chunk.chars - 1,
        );
        my $first = $string.comb[0..%m<end>].join;
        my $spos  = %m<end> + 1; # start point for next search
        # get the remaining piece of the original string
        $last = $string.comb[$spos..*].join;
        if 1 {
            say "string: '$string'";
            say "chunk:  '$chunk'";
            say "first:  '$first'";
            say "last:   '$last'";
        }
        return %m;
    }
    { status => "not found" }
} # end of sub find-text-forward
