unit module Text::Utils;

use Font::AFM;

class AFM-font is export {
    has $.name is required;
    has Real $.size is required;

    has Real $.sf; # font size scale factor
    has Font::AFM $.afm;
    has Bool $.kern = True;
    has Real $.UnderlinePosition; # one source says this is the TOP of the stroke
    has Real $.UnderlineThickness;
    # convenience
    has Real $.upos; # underline position (PS points)
    has Real $.uwid; # underline thickness (PS points)
    has Real $.llx;
    has Real $.lly;
    has Real $.urx;
    has Real $.ury;

    submethod TWEAK {
        $!afm = Font::AFM.new: :name($!name);
        $!sf = $!size/1000;
        $!upos = $!afm.UnderlinePosition * $!sf;
        $!uwid = $!afm.UnderlineThickness * $!sf;

        $!UnderlinePosition  = $!upos;
        $!UnderlineThickness = $!uwid;

        ($!llx, $!lly, $!urx, $!ury) = $!afm.FontBBox;
        $!llx *= $!sf;
        $!lly *= $!sf;
        $!urx *= $!sf;
        $!ury *= $!sf;
    }
    method stringwidth($string) {
        $!afm.stringwidth: $string, $!size, :kern($!kern);
    }
    method kern-on {
        $!kern = True;
    }
    method kern-off {
        $!kern = False;
    }
}

constant \SPACE is export = ' ';
constant \EMPTY is export = '';
constant &ask is export(:DEFAULT)   = &prompt;

#| Export a debug var for users
our $DEBUG is export(:DEBUG) = False;
BEGIN {
    if %*ENV<TEXT_UTILS_DEBUG> {
	$DEBUG = True;
    }
    else {
	$DEBUG = False;
    }
}

#-----------------------------------------------------------------------
#| Purpose : Turn a list into a text string for use in a document
#| Params  : List, Bool
#| Returns : String from a special join operajtion
sub list2text(@list, :$optional-comma is copy = True) is export(:list2text) {
    $optional-comma = False if %*ENV<TEXT_UTILS_NO_OPTIONAL_COMMA>:exists;
    my $s = @list[0..*-2].join(', ');
    say $s if $DEBUG;
    $s ~= ',' if $optional-comma;
    $s ~= ' and ' ~ @list[*-1];
    say $s if $DEBUG;
    return $s;
} # list2test

#-----------------------------------------------------------------------
#| Purpose : Count instances of a substring in a string
#| Params  : String, Substring
#| Returns : Number of substrings found
sub count-substrs(Str:D $ip, Str:D $substr --> UInt) is export(:count-substrs) {
    my $nsubstrs = 0;
    my $idx = index $ip, $substr;
    while $idx.defined {
	++$nsubstrs;
	$idx = index $ip, $substr, $idx+1;
    }

    return $nsubstrs;

} # count-substrs

#-----------------------------------------------------------------------
#| Purpose : Strip comments from an input text line, save comment if
#|             requested, normalize returned text if requested
#| Params  : String of text, comment char ('#' is default),
#|             option to return the comment, option to normalize
#|             the returned strings, option to use the last comment char
#|             instead of the first
#| Returns : String of text with any comment stripped off. Note that the
#|             designated char will trigger the strip even though it is
#|             escaped or included in quotes.
#|             Also returns the comment if requested.
#|             All returned text is normalized if requested.
sub strip-comment($line is copy,       #= string of text with possible comment
                    :$mark = '#',        #= desired comment char indicator
                    :$save-comment,      #= if true, return the comment
                    :$normalize,         #= if true, normalize returned strings
                    :$last,              #= if true, use the last instead of first comment char
                   ) is export(:strip-comment) {
    my $comment = '';
    my $clen    = $mark.chars;
    my $idx     = $last ?? rindex $line, $mark
                        !! index  $line, $mark;
    if $idx.defined {
        $comment = substr $line, $idx+$clen; #= don't want the comment char
	$line = substr $line, 0, $idx;
    }
    if $normalize {
        $line    = normalize-string $line;
        $comment = normalize-string $comment;
    }
    if $save-comment {
        return $line, $comment;
    }
    $line;
}

#-----------------------------------------------------------------------
#| Purpose : Add commas to a number to separate multiples of a thousand
#| Params  : An integer or number with a decimal fraction
#| Returns : The input number with commas added, e.g.,
#|             1234.56 => 1,234.56
#|             1234.60 => 1,234.60
sub commify($Num, UInt :$decimals --> Str) is export(:commify) {
    # translated from Perl Cookbook, 2e, Recipe 2.16
    # with improvement by this author
    my $num = $Num;
    if $Num ~~ Int {
        $num = $Num.Str;
    }
    elsif $Num ~~ Real {
        my $nd = $decimals.defined ?? $decimals !! 2;
        $num = sprintf "%0.*f", $nd, $Num;
    }

    say "DEBUG: input '$num'" if $DEBUG;
    my $text = $num.flip;
    say "DEBUG: input flipped '$text'" if $DEBUG;
    #$text =~ s:g/ (\d\d\d)(?=\d)(?!\d*\.)/$0,/; # Perl
    # in Raku:
    $text ~~ s:g/ (\d\d\d) <?before \d> <!before \d*\.> /$0,/;

    # don't forget to flip back to the original
    $text .= flip;
    say "DEBUG: commified output '$text'" if $DEBUG;

    return $text;

} # commify

#-----------------------------------------------------------------------
#| Purpose : Wrap a list of words into a paragraph with a maximum line
#|             width (default: 78) and update the input list with the
#|           results
#| Params  : List of words, max line length, paragraph indent, first
#|             line indent, pre-text
#| Returns : List of formatted paragraph lines
=begin comment

Rules:

+ para-indent          => number of leading spaces applied to ALL lines
+ first-line-indent    => number of leading spaces applied to the first line only
+ line-indent          => number of leading spaces applied to all lines AFTER the first

+ para-pre-text        => text added to the beginning of ALL lines
+ first-line-pre-text  => text added to the beginning of the first line only
+ line-pre-text        => text added to the beginning all lines AFTER the first

How are they all applied? Examples follow;

For each line:
For the first line:
para-indent spaces + first-line-indent spaces + para-pre-text + first-line-pretext + text

For the following lines:
para-indent spaces + line-indent spaces + para-pre-text + line-pre-text + text

=end comment

multi sub wrap-paragraph($text, |c
                   --> List) is export(:wrap-paragraph) {
    return wrap-paragraph($text.words, |c);
}

multi sub wrap-paragraph(
    @text,
    UInt :$max-line-length     = 78,
    #------------------------------#
    UInt :$para-indent         = 0,
    UInt :$first-line-indent   = 0,
    UInt :$line-indent         = 0,
    #------------------------------#
    Str  :$para-pre-text       = '',
    Str  :$first-line-pre-text = '',
    Str  :$line-pre-text       = '',
    #------------------------------#
    :$debug,
    --> List) is export(:wrap-paragraph) {

    my $mll = $max-line-length;

    if $debug {
        note qq:to/HERE/;
        DEBUG: sub wrap inputs:
            $para-pre-text
            $first-line-pre-text
            $line-pre-text
        HERE
    }

    # Calculate the various effective indents and any pre-text effects
    # and get the effective first-line and following lines indent
    # First line
    my $findent  = $para-indent + $first-line-indent;
    # Get the info for the remaining lines
    my $lindent  = $para-indent + $line-indent;

    my $findent-spaces = SPACE x $findent;
    my $lindent-spaces = SPACE x $lindent;

    # ready to take care of the first line
    # we do not add additional spaces between or following these items:
    my $line = EMPTY;
    $line ~= $findent-spaces if $findent-spaces;
    $line ~= $para-pre-text if $para-pre-text;
    $line ~= $first-line-pre-text if $first-line-pre-text;
    # do an initial length check on $line length
    line-length-ok :$line, :initial-first;

    # get all the words
    my @words = (join ' ', @text).words;
    note "DEBUG: starting with {@words.elems} words" if $debug;
    my @para = ();
    my $first-word = True;

    # some flags for error checking
    my $begin-first-line      = True;
    my $begin-following-line  = False;
    my $checked-following     = False;
    my $wnum = 0;

    while @words {
        my $word = @words.head;
        my $wc = $word.chars;
        if $wc > $max-line-length {
            die "FATAL: Word '$word' has $wc chars, too long for max line length of $mll chars";
        }

        my $next = $first-word ?? $word !! SPACE ~ $word;
        note "DEBUG: word: '$word'" if $debug;
        note "DEBUG: next: '$next'" if $debug;

        if $debug and $begin-first-line {
            note "DEBUG begin-first line: '$line'";
        }
        if $debug and $begin-following-line {
            note "DEBUG begin following line: '$line'";
        }

        # do length checks
        my $tmp-line = $line ~ $next;
        my $tc = $tmp-line.chars;
        note "DEBUG: tmp-line: '$tmp-line'" if $debug;
        if $begin-first-line {
            # check mll with first word
            if $tc > $max-line-length {
                die "FATAL: First line, first Word '$tmp-line' has $tc chars, too long for max line length of $mll chars";
            }
            $begin-first-line = False;
        }
        if $begin-following-line {
            # check mll with first word
            if $tc > $max-line-length {
                die "FATAL: First line, first Word '$tmp-line' has $tc chars, too long for max line length of $mll chars";
            }
            $begin-following-line = False;
        }

        if line-length-ok(:line($tmp-line))  {
            # enough space to add this
            $line ~= $next;
            note "DEBUG: good line: '$line'" if $debug;
            @words.shift; # remove the used word
            $first-word = False;
            note "DEBUG: good line with {@words.elems} words" if $debug;
            next;
        }

        # else we're done with this line
        @para.push: $line if $line;
        $line = EMPTY;
        last if not @words.elems;

        $first-word = True;
        $begin-following-line = True;
        $line ~= $lindent-spaces if $lindent-spaces;
        $line ~= $para-pre-text if $para-pre-text;
        $line ~= $line-pre-text if $line-pre-text;
        if not $checked-following {
            # do an initial length check on $line length
            line-length-ok :$line, :initial-following;
            $checked-following = True;
        }
    }

    # may have a line left
    @para.push: $line if $line;
    $line = EMPTY;

    # should not have any  words left
    if @words.elems {
        die "FATAL: Unexpected non-empty \@words: '{join(SPACE, @words)}'";
    }

    my sub line-length-ok(:$line, :$initial-first, :$initial-following) {
        my $mll = $max-line-length;
        my $nc  = $line.chars;
        if $initial-first and $nc > $mll {
            die "FATAL: first line pre too long: $nc chars is too long for max length $mll";
        }
        elsif $initial-following and $nc > $mll {
            die "FATAL: following lines pre too long: $nc chars is too long for max length $mll";
        }
        return $nc <= $mll;
    }

    return @para;

} # wrap-paragraph

#-----------------------------------------------------------------------
#| Purpose : Trim a string and collapse multiple whitespace characters
#|             to single ones
#| Params  : The string to be normalized
#| Returns : The normalized string
# define  "aliases" for convenience
our &normalize-text is export(:normalize-text, :normalize-string) = &normalize-string;
sub normalize-string(Str:D $str is copy --> Str) is export(:normalize-string, :normalize-text) {
    $str .= trim;
    $str ~~ s:g/ \s ** 2..*/ /;
    return $str;
} # normalize-string

#-----------------------------------------------------------------------
#| Purpose : Split a string into two pieces
#| Params  : String to be split, the split character, maximum length, a
#|             starting position for the search, search direction
#| Returns : The two parts of the split string; the second part will be
#|             empty string if the input string is not too long
sub split-line(Str:D $line is copy, Str:D $brk, UInt :$max-line-length = 0,
               UInt :$start-pos = 0, Bool :$rindex = False --> List) is export(:split-line) {
    my $line2 = '';
    return ($line, $line2) if $max-line-length && $line.chars <= $max-line-length;

    my $idx;
    if $rindex {
        my $spos = max $start-pos, $max-line-length;
        $idx = $spos ?? rindex $line, $brk, $spos !! rindex $line, $brk;
    }
    else {
        $idx = $start-pos ?? index $line, $brk, $start-pos !! index $line, $brk;
    }
    if $idx.defined {
        $line2 = substr $line, $idx+1;
        $line  = substr $line, 0, $idx+1;

        #$line  .= trim-trailing;
        #$line2 .= trim;
    }
    return ($line, $line2);

} # split-line

#-----------------------------------------------------------------------
#| Purpose : Split a string into two pieces
#| Params  : String to be split, the split character, maximum length, a
#|             starting position for the search, search direction
#| Returns : The part of the input string past the break character, or
#|             an empty string (the input string is modified in-place if
#|             it is too long)
sub split-line-rw(Str:D $line is rw, Str:D $brk, UInt :$max-line-length = 0,
                  UInt :$start-pos = 0, Bool :$rindex = False --> Str) is export(:split-line-rw) {
    my $line2 = '';
    return $line2 if $max-line-length && $line.chars <= $max-line-length;

    my $idx;
    if $rindex {
        my $spos = max $start-pos, $max-line-length;
        $idx = $spos ?? rindex $line, $brk, $spos !! rindex $line, $brk;
    }
    else {
        $idx = $start-pos ?? index $line, $brk, $start-pos !! index $line, $brk;
    }
    if $idx.defined {
        $line2 = substr $line, $idx+1;
        $line  = substr $line, 0, $idx+1;

        #$line  .= trim-trailing;
        #$line2 .= trim;
    }
    return $line2;

} # split-line-rw


# DEPRECATED SUBROUTINE
multi sub write-paragraph(@text,
	                  UInt :$max-line-length = 78,
                          UInt :$para-indent = 0,
		          UInt :$first-line-indent = 0,
                          Str  :$pre-text = '',
                          --> List) is export(:wrap-paragraph-deprecated) {

    # Calculate the various effective indents and any pre-text effects
    # and get the effective first-line indent
    my $findent = $first-line-indent ?? $first-line-indent !! $para-indent;
    # Get the effective paragraph indent
    my $pindent = $pre-text.chars + $para-indent;

    my $findent-spaces = ' ' x $findent;
    # ready to take care of the first line
    my $first-line = $pre-text ~ $findent-spaces;
    my $line = $first-line;

    # now do a length check
    {
        my $nc = $line.chars;
        if $nc > $max-line-length {
            say "FATAL:  Line length too long ($nc), must be <= \$max-line-length ($max-line-length)";
            say "line:   '$line'";
            die "length: $nc";
        }
    }

    # get all the words
    my @words = (join ' ', @text).words;

    my @para = ();
    my $first-word = True;

    loop {
        if !@words.elems {
            @para.push: $line if $line;
            last;
        }

        my $next = @words[0];
        $next = ' ' ~ $next if !$first-word;
        $first-word = False;

        # do a length check
	{
            my $nc = $next.chars;
            if $nc > $max-line-length {
                say "FATAL:  Line length too long ($nc), must be <= \$max-line-length ($max-line-length)";
                say "line:   '$next'";
                die "length: $nc";
            }
        }

        if $next.chars + $line.chars <= $max-line-length {
            $line ~= $next;
            shift @words;
            next;
        }

        # we're done with this line
        @para.push: $line if $line;
        #@para.push: $line;
        last;
    }

    # and remaining lines
    my $pindent-spaces = ' ' x $pindent;
    $line = $pindent-spaces;
    $first-word = True;
    loop {
        if !@words.elems {
            @para.push: $line if $line;
            last;
        }

        my $next = @words[0];
        $next = ' ' ~ $next if !$first-word;
        $first-word = False;

        # do a length check
	{
            my $nc = $next.chars;
            if $nc > $max-line-length {
                say "FATAL:  Line length too long ($nc), must be <= \$max-line-length ($max-line-length)";
                say "line:   '$next'";
                die "length: $nc";
            }
        }

        if $next.chars + $line.chars <= $max-line-length {
            $line ~= $next;
            shift @words;
            next;
        }

        # we're done with this line
        @para.push: $line if $line;

        last if !@words.elems;

        # replenish the line
        $line = $pindent-spaces;
        $first-word = True;
    }

    return @para;
} # write-paragraph

multi sub wrap-text($text, |c
                   --> List) is export(:wrap-text) {
    return wrap-text($text.words, |c);
}

class BBox is export {
    has Real $.llx;
    has Real $.lly;
    has Real $.urx;
    has Real $.ury;
    method width  { $!urx - $!llx }
    method height { $!ury - $!lly }
}

class Line is export {
    # The line's origin is the origin of its first character.
    has BBox $.bbox; #= PS points
    has Str  $.text;
}
class Para is export {
    # The para's origin is the origin of its first line.
    # Each additional line adds one leading distance to the vertical space.
    has Real $.width               = 468; #= PS points for 6.5 inches
    has      $.font-name           = 'Times-Roman';
    has Real $.font-size           = 12;
    has      $.kern                = True;
    has Real $.leading-ratio       = 1.3; #= PS points for 6.5 inches
    #------------------------------#
    has UInt $.para-indent         = 0;
    has UInt $.first-line-indent   = 0;
    has UInt $.line-indent         = 0;
    #-----.------------------------#
    has Str  $.para-pre-text       = '';
    has Str  $.first-line-pre-text = '';
    has Str  $.line-pre-text       = '';
    #------------------------------#
    has Line @.lines;
    has BBox $.bbox;
    method add-line(Line $line) {
        @!lines.push: $line;
        # adjust new bbox
    }
    method width  { $!bbox.urx - $!bbox.llx }
    method height { $!bbox.ury - $!bbox.lly }

}

multi sub wrap-text(@text,
    Real :$width               = 468, #= PS points for 6.5 inches
         :$font-name           = 'Times-Roman',
    Real :$font-size           = 12,
         :$kern                = True,
    Real :$leading-ratio       = 1.3;
    #------------------------------#
    UInt :$para-indent         = 0,
    UInt :$first-line-indent   = 0,
    UInt :$line-indent         = 0,
    #------------------------------#
    Str  :$para-pre-text       = '',
    Str  :$first-line-pre-text = '',
    Str  :$line-pre-text       = '',
    #------------------------------#
         :$debug,
         --> List) is export(:wrap-text) {

    my $afm = Font::AFM.new: :name($font-name);
    my $sf = $font-size/1000;

    my $mll = $width; # the maximum line width (in PS points) of any line

    # Calculate the various effective indent effects
    # and get the effective first-line and following lines indent
    # First line
    my $findent  = $first-line-indent;
    # Get the info for the remaining lines
    my $lindent  = $line-indent;

    my $findent-spaces = SPACE x $findent;
    my $lindent-spaces = SPACE x $lindent;

    # ready to take care of the first line
    # we do not add additional spaces between or following these items:
    my $line = EMPTY;
    $line ~= $findent-spaces if $findent-spaces;
    $line ~= $para-pre-text if $para-pre-text;
    $line ~= $first-line-pre-text if $first-line-pre-text;
    # do an initial length check on $line length
    line-length-ok :$line, :initial-first;

    # get all the words
    my @words = (join ' ', @text).words;
    note "DEBUG: starting with {@words.elems} words" if $debug;
    my @para = ();
    my $p = Para.new;
    my $first-word = True;

    # some flags for error checking
    my $begin-first-line      = True;
    my $begin-following-line  = False;
    my $checked-following     = False;
    my $wnum = 0;

    while @words {
        my $word = @words.head;
        my $len = $afm.stringwidth: $word, $font-size, :$kern;

        if $len > $width {
            die "FATAL: Word '$word' has length $len, too long for max line length of $mll points";
        }

        my $next = $first-word ?? $word !! SPACE ~ $word;
        note "DEBUG: word: '$word'" if $debug;
        note "DEBUG: next: '$next'" if $debug;

        if $debug and $begin-first-line {
            note "DEBUG begin-first line: '$line'";
        }
        if $debug and $begin-following-line {
            note "DEBUG begin following line: '$line'";
        }

        # do length checks
        my $tmp-line = $line ~ $next;
        my $tl = $afm.stringwidth: $tmp-line, $font-size, :$kern;

        note "DEBUG: tmp-line: '$tmp-line'" if $debug;
        if $begin-first-line {
            # check mll with first word
            if $tl > $mll {
                die "FATAL: First line, first word '$tmp-line' is $tl points wide, too wide for max line length of $mll points";
            }
            $begin-first-line = False;
        }
        if $begin-following-line {
            # check mll with first word
            if $tl > $mll {
                die "FATAL: First line, first word '$tmp-line' is $tl points wide, too wide for max line length of $mll points";
            }
            $begin-following-line = False;
        }

        if line-length-ok(:line($tmp-line))  {
            # enough space to add this
            $line ~= $next;
            note "DEBUG: good line: '$line'" if $debug;
            @words.shift; # remove the used word
            $first-word = False;
            note "DEBUG: good line with {@words.elems} words" if $debug;
            next;
        }

        # else we're done with this line
        @para.push: $line if $line;
        $line = EMPTY;
        last if not @words.elems;

        $first-word = True;
        $begin-following-line = True;
        $line ~= $lindent-spaces if $lindent-spaces;
        $line ~= $para-pre-text if $para-pre-text;
        $line ~= $line-pre-text if $line-pre-text;
        if not $checked-following {
            # do an initial length check on $line length
            line-length-ok :$line, :initial-following;
            $checked-following = True;
        }
    }

    # may have a line left
    @para.push: $line if $line;
    $line = EMPTY;

    # should not have any  words left
    if @words.elems {
        die "FATAL: Unexpected non-empty \@words: '{join(SPACE, @words)}'";
    }

    my sub line-length-ok(:$line, :$initial-first, :$initial-following) {
        my $mll = $width;
        my $nl  = $afm.stringwidth: $line, $font-size, :$kern;
        if $initial-first and $nl > $mll {
            die "FATAL: first line pre too long: $nl points is too long for max length $mll";
        }
        elsif $initial-following and $nl > $mll {
            die "FATAL: following lines pre too long: $nl points is too long for max length $mll";
        }
        return $nl <= $mll;
    }

    # TODO turn the para into a para object with line objects as children
    return @para;
}

# define  "aliases" for convenience
our &typeset-line is export(:typeset-line) = &typeset-text;
our &typeset-string is export(:typeset-string) = &typeset-text;
multi sub typeset-text(Str:D $text,
    Real :$x                   = 0; # x starting point (origin) of the text
    Real :$y                   = 0; # y starting point
    Real :$width               = 468, #= PS points for 6.5 inches
         :$font-name           = 'Times-Roman',
    Real :$font-size           = 12,
         :$kern                = True,
    Real :$leading-ratio       = 1.3;
    #------------------------------#
    UInt :$para-indent         = 0,
    UInt :$first-line-indent   = 0,
    UInt :$line-indent         = 0,
    #------------------------------#
    Str  :$para-pre-text       = '',
    Str  :$first-line-pre-text = '',
    Str  :$line-pre-text       = '',
    #------------------------------#
         :$debug,
         --> List
        ) is export(:typeset-text, :typeset-string, :typeset-line) {

    my $afm = Font::AFM.new: :name($font-name);
    my $sf = $font-size/1000;

    my $mll = $width; # the maximum line width (in PS points) of any line

    # Calculate the various effective indent effects
    # and get the effective first-line and following lines indent
    # First line
    my $findent  = $first-line-indent;
    # Get the info for the remaining lines
    my $lindent  = $line-indent;

    my $findent-spaces = SPACE x $findent;
    my $lindent-spaces = SPACE x $lindent;

    # ready to take care of the first line
    # we do not add additional spaces between or following these items:
    my $line = EMPTY;
    $line ~= $findent-spaces if $findent-spaces;
    $line ~= $para-pre-text if $para-pre-text;
    $line ~= $first-line-pre-text if $first-line-pre-text;
    # do an initial length check on $line length
    line-length-ok :$line, :initial-first;

    # get all the words
    my @words = $text.words;
    note "DEBUG: starting with {@words.elems} words" if $debug;
    my @para = ();
    my $p = Para.new;

    my $first-word = True;

    # some flags for error checking
    my $begin-first-line      = True;
    my $begin-following-line  = False;
    my $checked-following     = False;
    my $wnum = 0;

    while @words {
        my $word = @words.head;
        my $len = $afm.stringwidth: $word, $font-size, :$kern;

        if $len > $width {
            die "FATAL: Word '$word' has length $len, too long for max line length of $mll points";
        }

        my $next = $first-word ?? $word !! SPACE ~ $word;
        note "DEBUG: word: '$word'" if $debug;
        note "DEBUG: next: '$next'" if $debug;

        if $debug and $begin-first-line {
            note "DEBUG begin-first line: '$line'";
        }
        if $debug and $begin-following-line {
            note "DEBUG begin following line: '$line'";
        }

        # do length checks
        my $tmp-line = $line ~ $next;
        my $tl = $afm.stringwidth: $tmp-line, $font-size, :$kern;

        note "DEBUG: tmp-line: '$tmp-line'" if $debug;
        if $begin-first-line {
            # check mll with first word
            if $tl > $mll {
                die "FATAL: First line, first word '$tmp-line' is $tl points wide, too wide for max line length of $mll points";
            }
            $begin-first-line = False;
        }
        if $begin-following-line {
            # check mll with first word
            if $tl > $mll {
                die "FATAL: First line, first word '$tmp-line' is $tl points wide, too wide for max line length of $mll points";
            }
            $begin-following-line = False;
        }

        if line-length-ok(:line($tmp-line))  {
            # enough space to add this
            $line ~= $next;
            note "DEBUG: good line: '$line'" if $debug;
            @words.shift; # remove the used word
            $first-word = False;
            note "DEBUG: good line with {@words.elems} words" if $debug;
            next;
        }

        # else we're done with this line
        @para.push: $line if $line;
        $line = EMPTY;
        last if not @words.elems;

        $first-word = True;
        $begin-following-line = True;
        $line ~= $lindent-spaces if $lindent-spaces;
        $line ~= $para-pre-text if $para-pre-text;
        $line ~= $line-pre-text if $line-pre-text;
        if not $checked-following {
            # do an initial length check on $line length
            line-length-ok :$line, :initial-following;
            $checked-following = True;
        }
    }

    # may have a line left
    @para.push: $line if $line;
    $line = EMPTY;

    # should not have any  words left
    if @words.elems {
        die "FATAL: Unexpected non-empty \@words: '{join(SPACE, @words)}'";
    }

    my sub line-length-ok(:$line, :$initial-first, :$initial-following) {
        my $mll = $width;
        my $nl  = $afm.stringwidth: $line, $font-size, :$kern;
        if $initial-first and $nl > $mll {
            die "FATAL: first line pre too long: $nl points is too long for max length $mll";
        }
        elsif $initial-following and $nl > $mll {
            die "FATAL: following lines pre too long: $nl points is too long for max length $mll";
        }
        return $nl <= $mll;
    }

    # TODO turn the para into a para object with line objects as children
    return @para;
} # sub typeset-text
