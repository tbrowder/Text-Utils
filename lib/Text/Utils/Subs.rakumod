# Subs without export tags not intended to be selectively exported

unit module Text::Utils::Subs;

use Test;

use Text::Utils::Vars;
use Text::Utils::TaggedSubs;

sub calc-limit(
    Str :$line!,
        :$max-limit!,
    --> UInt
) is export { # (:calc-limit) {

    my $limit;
    if $max-limit.defined {
        if $max-limit ~~ Int {
            $limit = $max-limit; 
        }
        else {
            $limit = $line.chars;
        }
    }
    else {
        $limit = 2; # our default
    }
    $limit;
}

sub calc-parts(
    :$limit!,
    :$line!,
    :$delimiter!,
) is export { # (:calc-parts) {
    my @parts;
    # use a sub here to calc @parts...
    if $limit {
        @parts = split $delimiter, $line, $limit, :v;
    }
    else {
        @parts = split $delimiter, $line, :v;
    }
    @parts;
}

sub calc-pieces(
    :@parts!,
    --> List
) is export { # (:calc-pieces) {
    my @pieces;
    for @parts.kv -> $i, $v is copy {
        # skip the delimiters
        next if is-odd $i; # zero is "even"
        @pieces.push: $v;
    }
    @pieces;
}


sub is-odd(
    UInt $num
    --> Bool
    ) is export { # (:is-odd) {
    $num % 2 == 1 ?? True !! False
}

# Helper routines for special needs by primary routines.
sub find-all-text-splitters (
    Str $haystack, # the string to search
    Str $needle,   # the text splitter of interest
    --> List       # list of hashes of match data
    ) is export { # (:find-all-text-splitters) {
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
    ) is export { # (:find-text-reverse) {

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
    ) is export { # (:find-text-forward) {

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


# # define  "aliases" for convenience (with unique export keys)
# our &strip is export(:strip) = &strip-comment;

# put in separate sub for use by other routines?
#-----------------------------------------------------------------------
#| Purpose : Trim a string and collapse multiple whitespace characters
#|             to single ones
#| Params  : The string to be normalized
#| Returns : The normalized string
subset Kn of Any is export where { $_ ~~ /^ :i [0|k|n]   /}; #= keep or normalize
subset Sn of Any is export where { $_ ~~ /^ :i [0|n|s|t] /}; #= collapse all contiguous ws

our &normalize-text is export(:normalize-text) = &normalize-string; # per lizmat, 2024-04-26
sub normalize-string(
    Str:D $str is copy,
    Kn :t(:$tabs)=0,           #= keep or normalize
    Kn :n(:$newlines)=0,       #= keep or normalize
    Sn :c(:$collapse-ws-to)=0, #= collapse all contiguous ws
                               #=   to one char
    :$no-trim,                 #= do not trim the input string
    --> Str
    ) is export(:normalize-string) {
    # default is to always trim first, but to do so we must save the
    # original leading and trailing spaces
    my ($pre-ws, $post-ws);
    if $no-trim.defined {
        if $str ~~ /^ (\s+) / {
            $pre-ws = ~$0;
        }
        if $str ~~ / (\s+) $/ {
            $post-ws = ~$0;
        }
        $str .= trim;
    }
    else {
        $str .= trim;
    }

    # then normalize all space characters
    $str ~~ s:g/ $WS ** 2..* /$WS/;

    # then check for exceptions before normalizing all whitespace

    # convenience aliases
    my $t = $tabs;
    my $c = $collapse-ws-to;
    my $n = $newlines;

    if $collapse-ws-to {
        if $c ~~ /^ :i s / {
            # collapse all to a single space
            $str ~~ s:g/ $NL          /$WS/;
            $str ~~ s:g/ $TAB         /$WS/;
            $str ~~ s:g/ $WS  ** 2..* /$WS/;
        }
        elsif $c ~~ /^ :i t / {
            # collapse all to a single tab
            $str ~~ s:g/ $WS          /$TAB/;
            $str ~~ s:g/ $NL          /$TAB/;
            $str ~~ s:g/ $TAB ** 2..* /$TAB/;
        }
        elsif $c ~~ /^ :i n / {
            # collapse all to a single newline
            $str ~~ s:g/ $WS          /$NL/;
            $str ~~ s:g/ $TAB         /$NL/;
            $str ~~ s:g/ $NL  ** 2..* /$NL/;
        }
    }
    elsif $newlines and $tabs {
        if $t ~~ /^ :i k / {
            ; # ok, a no-op
        }
        elsif $t ~~ /^ :i n / {
            $str ~~ s:g/ $TAB ** 2..* /$TAB/;
        }
        if $n ~~ /^ :i k / {
            ; # ok, a no-op
        }
        elsif $n ~~ /^ :i n / {
            $str ~~ s:g/ $NL  ** 2..* /$NL/;
        }
    }
    elsif $tabs {
        if $t ~~ /^ :i k / {
            ; # ok, a no-op
        }
        elsif $t ~~ /^ :i n / {
            $str ~~ s:g/ $TAB ** 2..* /$TAB/;
        }
    }
    elsif $newlines {
        if $n ~~ /^ :i k / {
            ; # ok, a no-op
        }
        elsif $n ~~ /^ :i n / {
            $str ~~ s:g/ $NL  ** 2..* /$NL/;
        }
    }
    else {
        $str .= trim;
        $str ~~ s:g/ \s ** 2..* /$WS/;
    }

    =begin comment
    else {
        #$str .= trim;
        # this also takes care of tabs and newlines
        $str ~~ s:g/ \s ** 2..*/ /;
    }
    =end comment

    if $no-trim.defined {
        # add back any original leading or trailing spaces
        if $pre-ws {
            $str = $pre-ws ~ $str;
        }
        if $post-ws {
            $str = $str ~ $post-ws;
        }
    }
    $str;
} # end of sub normalize-string
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
=end comment
