unit module Text::Utils::TaggedSubs;

use Text::Utils::Vars;

# normalize-text
# normalize-string

# put in separate sub for use by other routines?
#-----------------------------------------------------------------------
#| Purpose : Trim a string and collapse multiple whitespace characters
#|             to single ones
#| Params  : The string to be normalized
#| Returns : The normalized string

subset Kn of Any where { $_ ~~ /^ :i [0|k|n]   /}; #= keep or normalize
subset Sn of Any where { $_ ~~ /^ :i [0|n|s|t] /}; #= collapse all contiguous ws
#constant &normalize-text is export(:normalize-text) = &normalize-string; # per lizmat, 2024-04-26
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
} # normalize-string
