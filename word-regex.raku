#!/usr/bin/env raku

sub word-matches($w, :$string) is export {
    my @matchesatches = $string.match(:global,
        / << $w >> /).map({
            { word => ~$_, start => $_.from, end => $_.to }
    });

    my $nm = @matchesatches.elems;
    if $nm {
        say "Found text '$w' $nm times:";
        for @matchesatches.kv -> $i is copy, $w {
            ++$i;
            say " $i. Position {$w<start>}";
        }
    }
    else {
        say "Word '$w' not found";
    }
}

# sub word-matches($w, :$string --> List) is export {
my $string = " Foo : Bar ";
my $w = "Foo ";

word-matches $w, :$string;

# see last deepseek chat

# want: one match forward
# want: one matching from the end

# more subs from deepseek
sub find-all-text-chunks (
    Str $haystack, # the string to search 
    Str $needle,   # the text chunk of interest
    --> List       # list of hashes of match data
    ) is export {
    my @matches; 
    my $pos = 0;
    while $haystack.index($needle, $pos) -> $found-at {
       @matches.push: {
           chunk => $needle,
           start => $found-at,
           end   => $found-at + $needle.chars - 1,
        };
        $pos = $found-at + 1; # start point for next search
    }
    @matches;
} # end of sub find-all-text-chunks

