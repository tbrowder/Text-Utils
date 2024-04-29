[![Actions Status](https://github.com/tbrowder/Text-Utils/actions/workflows/linux.yml/badge.svg)](https://github.com/tbrowder/Text-Utils/actions) [![Actions Status](https://github.com/tbrowder/Text-Utils/actions/workflows/macos.yml/badge.svg)](https://github.com/tbrowder/Text-Utils/actions) [![Actions Status](https://github.com/tbrowder/Text-Utils/actions/workflows/windows.yml/badge.svg)](https://github.com/tbrowder/Text-Utils/actions)

NAME
====

Text::Utils - Miscellaneous text utilities

SYNOPSIS
========

```Raku
# Export individual routines or :ALL
use Text::Utils :strip-comment;
my $text = q:to/HERE/;
    any kind of text, including code"; # some comment
    my $s = 'foo'; # another comment
    HERE

for $text.lines -> $line is copy {
    $line = strip-comment $line;
    say $line;
}
# OUTPUT with comments removed:
any kind of text, including code;
my $s = 'foo';
```

DESCRIPTION
===========

The module contains several routines to make text handling easier for module and program authors. Following is a short synopsis and signature for each of the routines.

### `sub sort-list`

    #  StrLength, LengthStr, Str, Length, Number
    enum Sort-type is export(:sort-list) < SL LS SS LL N >;
    sub sort-list(@list, :$type = SL, :$reverse --> List) is export(:sort-list)
    {...}

By default, this routine sorts all lists by word length, then by Str order. The order by length is by the shortest abbreviation first unless the `:$reverse` option is used. 

The routine's output can be modified for other uses by entering the `:$type` parameter to choose another of the `enum Sort-type`s.

### sub strip-comment

Strip the comment from an input text line, save comment if requested, normalize returned text if requested.

The routine returns a string of text with any comment stripped off. Note the designated character will trigger the strip even though it is escaped or included in quotes. Also returns the comment, including the comment character, if requested. All returned text is normalized if requested. Any returned comment will also be normalized if the `normalize-all` option is used in place of `normalize`.

The signature:

```Raku
sub strip-comment(
    $line is copy,                # string of text with possible comment
    :mark(:$comment-char) = '#',  # desired comment character indicator
                                  #   (with alias :$comment-char)
    :$save-comment,               # if true, return the comment
    :$normalize,                  # if true, normalize returned string
    :$normalize-all,              # if true, normalize returned string
                                  #   and also normalize any saved comment
    :$last,                       # if true, use the last instead of first 
                                  #   comment character
    :$first,
    ) is export(:strip-comment)
{...}
```

Note the default return is the returned string without any comment. However, if you use the `save-comment` option, a two-element list is returned: `($string, $comment)` (either element may be "" depending upon the input text line).

### sub normalize-string (or its alias 'normalize-text')

This routine trims a string and collapses multiple whitespace characters (including tabs and newlines) into one.

The signature:

```Raku
subset Kn of Any where { $_ ~~ /^ :i [0|k|n]   /}; #= keep or normalize
subset Sn of Any where { $_ ~~ /^ :i [0|n|s|t] /}; #= collapse all contiguous ws 
sub normalize-string(
    Str:D $str is copy
    Kn :t(:$tabs)=0,           #= keep or normalize
    Kn :n(:$newlines)=0,       #= keep or normalize
    Sn :c(:$collapse-ws-to)=0, #= collapse all contiguous ws 
                               #=   to one char
    --> Str) is export(:normalize-string)
{...}
```

'Normalization' is the process of converting a contiguous sequence of space characters into a single character. The three space characters recognized are " " (0x20, 'space'), "\t" (0x09, tab), and "\n" (0x0A, 'newline'). The default algorithm to do that for a string `$s` is `$s = s:g/ \s ** 2 / /`.

This routine gives several options to control how the target string is 'normalized'. First, the user may choose one or more of the space character types to be normalized individually. Second, the user may choose to 'collapse' all space characters to one of the three types.

Given a string with spaces, tabs, and newlines:

    my $s = " 1   \t\t\n\n 2 \n\t  3  ";

The default:

    say normalize-string($s) # OUTPUT: «1 2 3␤»

Normalize each tab:

    say normalize-string($s, :t<n>) # OUTPUT: «1 \t\n\n 2 \n\t 3␤»

Normalize each newline:

    say normalize-string($s, :n<n>) # OUTPUT: «1 \t\t\n 2 \n\t 3␤»

Normalize each tab and newline:

    say normalize-string($s, :t<n>, :n<n>) # OUTPUT: «1 \t\n 2 \n\t 3␤»

Collapse to a space:

    say normalize-string($s, :c<s>) # OUTPUT: «1 2 3␤»

Collapse to a tab:

    say normalize-string($s, :c<t>) # OUTPUT: «1\t2\t3␤»

Collapse to a newline:

    say normalize-string($s, :c<n>) # OUTPUT: «1\n2\n3␤»

### sub wrap-text

This routine is used in creating PostScript PDF or other output formats where blocks (e.g., paragraphs) need to be wrapped to a specific maximum width based on the font face and font size to be used. Note it has all the options of the **wrap-paragraph** routine except the `:width` is expressed in PostScript points (72 per inch) as is the `:font-size`. The default `:width` is 468 points, the length of a line on a Letter paper, portrait orientation, with one-inch margins on all sides.

The fonts currently handled are the the 14 PostScript and PDF *Core Fonts*:

<table class="pod-table">
<tbody>
<tr> <td>Courier Courier-Bold Courier-Oblique Courier-BoldOblique</td> </tr> <tr> <td>Helvetica Helvatica-Bold Helvetica-Oblique Helvatica-BoldOblique</td> </tr> <tr> <td>Times-Roman Times-Bold Times-Italic Times-BoldItalic</td> </tr> <tr> <td>Symbol</td> </tr> <tr> <td>Zaphdingbats</td> </tr>
</tbody>
</table>

```Raku
multi sub wrap-text(
    @text,
    Real :$width               = 468, #= PS points for 6.5 inches
         :$font-name           = 'Times-Roman',
    Real :$font-size           = 12,
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
    --> List) is export(:wrap-text)
{...}
multi sub wrap-text(
    $text,
    # ... other args same as the other multi
    --> List) is export(:wrap-text)
{...}
```

### sub list2text

Turn a list into a text string for use in a document.

For example, this list `1 2 3` becomes either this `"1, 2, and 3"` (the default result) or this `"1, 2 and 3"` (if the `$optional-comma` named variable is set to false). The default result uses the so-called *Oxford Comma* which is not popular among some writers, but those authors may change the default behavior by permanently by defining the environment variable `TEXT_UTILS_NO_OPTIONAL_COMMA`.

The signature:

```Raku
sub list2text(
    @list,
    :$optional-comma is copy = True
    ) is export(:list2text)
{...}
```

### sub count-substrs

Count instances of a substring in a string.

The signature:

```Raku
sub count-substrs(
    Str:D $string,
    Str:D $substr
    --> UInt
    ) is export(:count-substrs)
{...}
```

### sub commify

This routine was originally ported from the Perl version in the *The Perl Cookbook, 2e*.

The routine adds commas to a number to separate multiples of a thousand. For example, given an input of `1234.56`, the routine returns `1,234.56`.

As an improvement, if real numbers are input, the routine returns the number stringified with two decimal places. The user may specify the desired number with the new `:$decimals` named argument.

The signature:

```Raku
sub commify($num, :$decimals --> Str) is export(:commify)
{...}
```

### sub split-line

This routine splits a string into two pieces.

Inputs are the string to be split, the split character, maximum length, a starting position for the search, and the search direction.

It returns the two parts of the split string; the second part will be an empty string if the input string is not too long.

The signature:

```Raku
sub split-line(
    Str:D $line is copy,
    Str:D $brk,
    UInt  :$max-line-length = 0,
    UInt  :$start-pos       = 0,
    Bool  :$rindex          = False
    --> List) is export(:split-line)
{...}
```

### sub split-line-rw

Splits a string into two pieces.

Inputs are the string to be split, the split character, maximum length, a starting position for the search, and search direction.

It returns the part of the input string past the break character, or an empty string (the input string is modified in-place if it is too long).

The signature:

```Raku
sub split-line-rw(
    Str:D $line is rw,
    Str:D $brk,
    UInt  :$max-line-length = 0,
    UInt  :$start-pos       = 0,
    Bool  :$rindex          = False
    --> Str) is export(:split-line-rw)
{...}
```

### sub wrap-paragraph

This routine wraps a list of words into a paragraph with a maximum line width in characters (default: 78), and returns a list of the new paragraph's lines formatted as desired. An option, `:$para-pre-text`, used in conjunction with `:$para-indent`, is very useful for use in auto-generation of code. For example, given this chunk of text describing a following PDF method `MoveTo(x, y)`:

    my $str = q:to/HERE/;
    Begin a new sub-path by moving the current point to coordinates (x,
    y), omitting any connecting line segment. If the previous path
    construction operator in the current path was also m, the new m
    overrides it.
    HERE

Run that string through the sub to see the results:

```raku
my @para = wrap-paragraph $str.lines, :para-pre-text('#| '), :para-indent(4);
.say for @para;
```

yields:

        #| Begin a new sub-path by moving the current point to coordinates (x, y),
        #| omitting any connecting line segment. If the previous path construction
        #| operator in the current path was also m, the new m overrides it.

The signature:

```Raku
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
    --> List) is export(:wrap-paragraph)
{...}
multi sub wrap-paragraph(
    $text,
    # ... other args same as the other multi
    --> List) is export(:wrap-paragraph)
{...}
```

AUTHOR
======

Tom Browder <tbrowder@cpan.org>

COPYRIGHT AND LICENSE
=====================

Copyright &#x00A9; 2019-2024 Tom Browder

This library is free software; you may redistribute it or modify it under the Artistic License 2.0.

