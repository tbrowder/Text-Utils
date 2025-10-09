unit module PB-Lottery::Str2IntList;

# moved to its own module
sub str2intlist(
    # from ChatGPT
    Str $s,
    :$no-zeros       = True,
    :$no-negatives   = True,
    :$only-positives = True,
    :$debug,
   --> List
) is export {

    my @words = $s.words;
    # validate tokens
    for @words -> $tok {
        unless $tok ~~ /^ '-'? \d+ $/ {
            die "Non-numeric token found: |$tok|";
        }
    }

    # normalize to Ints
    my @ints = @words.map({ .Int });
    if $only-positives {
        @ints .= grep({ $_ != 0}) if $no-zeros;
    }
    else {
        @ints .= grep({ $_ != 0}) if $no-zeros;
        @ints .= grep({ $_ >= 0}) if $no-negatives;
    }

    # Ints unique and sorted
    @ints.unique.sort({ $^a <=> $^b }).List;
} # end of sub str2intlist
