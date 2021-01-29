[![Actions Status](https://github.com/tbrowder/Text-Utils/workflows/test/badge.svg)](https://github.com/tbrowder/Text-Utils/actions)

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
# OUTPUT:
any kind of text, including code;
my $s = 'foo';
```

DESCRIPTION
===========

The module contains several routines to make text handling easier for module and program authors. Following is a short synopsis and signature for each of the routines.

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

### sub wrap-text

This routine is used a in creating PostScript PDF or other output formats where blocks (e.g., paragraphs) need to be wrapped to a specific maximum width based on the font face and font size to be used. Note it has all the options of the **wrap-paragraph** routine except the `:width` is expressed in PostScript points (72 per inch) as is the `:font-size`. The default `:width` is 468 points, the length of a line on a Letter paper, portrait orientation, with one-inch margins on all sides.

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

Turn a list into a text string for use in a document

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

Count instances of a substring in a string

The signature:

```Raku
sub count-substrs(
    Str:D $string, 
    Str:D $substr 
    --> UInt
    ) is export(:count-substrs)
{...}
```

### sub strip-comments

Strip comments from an input text line, save comment if requested, normalize returned text if requested

The routine returns a string of text with any comment stripped off. Note the designated char will trigger the strip even though it is escaped or included in quotes. Also returns the comment if requested. All returned text is normalized if requested.

The signature:

```Raku
sub strip-comment(
    $line is copy,       # string of text with possible comment
    :$mark = '#',        # desired comment char indicator
    :$save-comment,      # if true, return the comment
    :$normalize,         # if true, normalize returned strings
    :$last,              # if true, use the last instead of first comment char
    ) is export(:strip-comment)
{...}
```

### sub commify

This routine is ported from the Perl version in the *The Perl Cookbook, 2e*.

This routine adds commas to a number to separate multiples of a thousand. For example, given an input of `1234.56`, the routine returns `1,234.56`.

The signature:

```Raku
sub commify($num) is export(:commify)
{...}
```

### sub normalize-string

This routine trims a string and collapses multiple whitespace characters.

The signature:

```Raku
sub normalize-string(
    Str:D $str is copy 
    --> Str) is export(:normalize-string)
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

### sub write-paragraph

**THIS ROUTINE IS DEPRECATED - USE `wrap-paragraph` FOR NEW AND OLD CODE**

This routine wraps a list of words into a paragraph with a maximum line width (default: 78) and updates the input list with the results.

The signature:

```Raku
sub write-paragraph(
    @text,
    UInt :$max-line-length   = 78,
    UInt :$para-indent       = 0,
    UInt :$first-line-indent = 0,
    Str  :$pre-text          = ''
    --> List) is export(:write-paragraph)
{...}
```

AUTHOR
======

Tom Browder <tbrowder@cpan.org>

COPYRIGHT AND LICENSE
=====================

Copyright &#x00A9; 2019-2021 Tom Browder

This library is free software; you can redistribute it or modify it under the Artistic License 2.0.

