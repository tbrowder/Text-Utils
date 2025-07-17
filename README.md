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

WARNING: This is a major update with several improvements. Unused or untested options were removed. See [Changes](Changes) for details.

Users needing those must file an issue if this is a breaking change for them.

DESCRIPTION
===========

The module contains several routines to make text handling easier for module and program authors. The routines are described below in alphabetical order below (as well in the code).

<table class="pod-table">
<thead><tr>
<th>Name</th> <th>Notes</th>
</tr></thead>
<tbody>
<tr> <td>commify</td> <td></td> </tr> <tr> <td>count-substrs</td> <td></td> </tr> <tr> <td>list2text</td> <td></td> </tr> <tr> <td>normalize-string</td> <td>alias &#39;normalize-text&#39;</td> </tr> <tr> <td>sort-list</td> <td></td> </tr> <tr> <td>split-line</td> <td>aliases &#39;splitstr&#39;, &#39;split-str&#39;</td> </tr> <tr> <td>strip-comment</td> <td>alias &#39;strip&#39;</td> </tr> <tr> <td>wrap-paragraph</td> <td>&#39;width&#39; is in PS points</td> </tr> <tr> <td>wrap-text</td> <td>&#39;width&#39; is in number of chars</td> </tr>
</tbody>
</table>

Following is a link to each sub's description section:

  * [commify](#commify)

  * [count-substrs](#count-substrs)

  * [list2text](#list2text)

  * [normalize-string](#normalize-string)

  * [sort-list](#sort-list)

  * [split-line](#split-line)

  * [strip-comment](#strip-comment) 

  * [wrap-paragraph](#wrap-paragraph) 

  * [wrap-text](#wrap-text)

Following is a short synopsis and signature for each of the routines.

### commify

This routine was originally ported from the Perl version in the *The Perl Cookbook, 2e*.

The routine adds commas to a number to separate multiples of a thousand. For example, given an input of `1234.56`, the routine returns `1,234.56`.

As an improvement, if real numbers are input, the routine returns the number stringified with two decimal places. The user may specify the desired number with the new `:$decimals` named argument.

The signature:

```Raku
sub commify($num, :$decimals --> Str) is export(:commify)
{...}
```

[List of subs](#Following)

### count-substrs

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

### list2text

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

### normalize-text

Alias for 'normalize-string'.

### normalize-string

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

Notice that in the normalization routines, spaces (' ') are always normalized, even when tabs and newlines are normalized separately.

Also notice all strings are normally trimmed of leading and trailing whitespace regardless of the option used. However, option `:no-trim` protects the input string from any such trimming. Consider the first example from above:

    my $s = " 1   \t\t\n\n 2 \n\t  3  ";

Using the 'no-trim' option:

    say normalize-string($s, :no-trim) # OUTPUT: « 1 2 3  ␤»

### sort-list

    #  StrLength, LengthStr, Str, Length, Number
    enum Sort-type is export(:sort-list) < SL LS SS LL N >;
    sub sort-list(@list, :$type = SL, :$reverse --> List) is export(:sort-list)
    {...}

By default, this routine sorts all lists by word length, then by Str order. The order by length is by the shortest abbreviation first unless the `:$reverse` option is used.

The routine's output can be modified for other uses by entering the `:$type` parameter to choose another of the `enum Sort-type`s.

### split-line

Splits a string into a list of pieces at a user-defined delimiter (or 'splitter').

There are two multi subs with several common options, but only two options are different.

The only required arguments are (1) the `$string` to be split and (2) the `$delimiter` which *must be a string*. (Notice the first two inputs are reversed from their equivalent options' order in the Raku core 'split' routine.)

The output will be a list of pieces of the input string split by any matches of the delimiter. If there were no matches, the list should contain two elements, with the first element being an empty string and the other element the original string.

The result of the default behavior, with a semicolon as the split character, is shown here:

    " Sally ; Jones " # OUTPUT: " Sally ", " Jones "

An additional option, `:$clean`, causes the first part to be normalized. The following parts remain unchanged.

The same input as before, but using the `:clean` option, yields:

    " Sally ; Jones " # OUTPUT: "Sally", " Jones "

An additional option, `:$clean-all`, causes all parts to be normalized.

The same input as before, but using the `:clean-all` option, yields:

    " Sally ; Jones " # OUTPUT: "Sally", "Jones"

Note the `split-line` routine encapsulates the Raku core routine `split` and uses default values as well as new names for options in an attempt to make it easier to use for novices as well as those, like the author, who find that routine a bit confusing with its awkward option names and purposes. 

For example, the core routine has a third unnamed parameter, `$limit`, whose default value is `Inf`, which ensures all splits are captured into the resulting `Sequence`. The `$limit` parameter is described this way:

*The optional LIMIT indicates in how many segments the string should be split, if possible.*

The `split-line` routine in this package makes that parameter into an optional *named* parameter, `:$limit`.

The core `split` routine also has an optional named parameter, `:$v`, which keeps the delimiter string between any matches found. The default for `split-line` is to *always* define that option to ensure consistent, easy-to-parse results.

In summary: This routine attempts to ease splitting strings for many common use cases. Use the core `split` routine if you have special needs or want to use regexes as delimiters.

The multi signatures:

#### First multi sub

```Raku
sub split-line(
    Str:D $line is copy,
    Str:D :d($delimiter)!,     #= the splitting delimiter
    # Common options follow... 
    --> List) is export(:split-line)
{...}
```

#### Second multi sub

    sub split-line(
        Str:D $line is copy,
        Str:D $delimiter,           #= the splitting delimiter
        # Common options follow... 
        --> List) is export(:split-line)
    {...}

#### Common options

              :$limit,             #= if defined and an int, use it;
                                   #    otherwise, equate it to 2;
                                   #    equate to $line.chars if absent
        Bool  :$clean     = False, #= if True, the first part is 
                                   #= normalized
        Bool  :$clean-all = False, #= if True, all parts are normalized

### strip-comment

Strip the comment from an input text line, save comment if requested, normalize returned text by default.

The routine returns a string of text with any comment stripped off. Note the designated comment character (default '#') character will trigger the strip even though it is escaped or included in quotes. Also returns the comment, including the comment character, if requested. It is very useful in argument handling, and the author uses it constantly:

All returned text is normalized by default unless you add the `!normalize` option. Any returned comment will also be normalized if the `normalize-all` option is used in place of `normalize`.

For example, this is the default behavior:

    my $s = " my  dog Gus # a Shit Tzu";
    $s = strip-comment $s; # OUTPUT: "my dog Gus"

For other needs, the comment can be stripped and the argument returned returned in its original form including any trailing spaces. Given the previous example and using the `!normalize` option yields this result:

    my $s = " my  dog Gus # a Shit Tzu";
    $s = strip-comment $s, !normalize; # OUTPUT: " my  dog Gus "

Notice the returned text is identical to its original form.

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
    :$first,                      #= if true, the comment char must be the
                                  #=   first non-whitespace character on
                                  #=   the line; otherwise, the line is
                                  #=   returned as is
    ) is export(:strip-comment)
{...}
```

Note the default return is the returned string without any comment. However, if you use the `save-comment` option, a two-element list is returned: `($string, $comment)` (either element may be "" depending upon the input text line).

### wrap-paragraph

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

### wrap-text

This routine is used in creating PostScript PDF or other output formats where blocks (e.g., paragraphs) need to be wrapped to a specific maximum width based on the font face and font size to be used. Note it has all the options of the **wrap-paragraph** routine except the `:width` is expressed in PostScript points (72 per inch) as is the `:font-size`. The default `:width` is 468 points, the length of a line on a Letter paper, portrait orientation, with one-inch margins on all sides.

The fonts currently handled are the the 14 PostScript and PDF *Core Fonts*:

<table class="pod-table">
<tbody>
<tr> <td>Courier</td> </tr> <tr> <td>Courier-Bold</td> </tr> <tr> <td>Courier-Oblique</td> </tr> <tr> <td>Courier-BoldOblique</td> </tr> <tr> <td>Helvetica</td> </tr> <tr> <td>Helvatica-Bold</td> </tr> <tr> <td>Helvetica-Oblique</td> </tr> <tr> <td>Helvatica-BoldOblique</td> </tr> <tr> <td>Times-Roman</td> </tr> <tr> <td>Times-Bold</td> </tr> <tr> <td>Times-Italic</td> </tr> <tr> <td>Times-BoldItalic</td> </tr> <tr> <td>Symbol</td> </tr> <tr> <td>Zaphdingbats</td> </tr>
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

AUTHOR
======

Tom Browder <tbrowder@cpan.org>

COPYRIGHT AND LICENSE
=====================

Copyright &#x00A9; 2019-2025 Tom Browder

This library is free software; you may redistribute it or modify it under the Artistic License 2.0.

