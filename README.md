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

This module replaces the obsolete module 'Text::More' and it should be an easy drop-in replacement.

The module contains several routines to make text handling easier for module and program authors. Following is a short synopsis and signature for each of the routines.

list2text
---------

Turn a list into a text string for use in a document

For example, this list `1 2 3` becomes either this `"1, 2, and 3"` (the default result) or this `"1, 2 and 3"` (if the `$optional-comma` named variable is set to false). The default result uses the so-called *Oxford Comma* which is not popular among some writers, but those authors may change the default behavior by permanently by defining the environment variable `TEXT_UTILS_NO_OPTIONAL_COMMA`.

The signature:

```Raku
sub list2text(@list, :$optional-comma is copy = True) is export(:list2text) 
{...}
```

AUTHOR
======

Tom Browder <tom.browder@gmail.com>

COPYRIGHT AND LICENSE
=====================

Copyright &#x00A9; 2019-2020 Tom Browder

This library is free software; you can redistribute it or modify it under the Artistic License 2.0.

### sub list2text

```perl6
sub list2text(
    @list,
    :$optional-comma is copy = Bool::True
) returns Mu
```

Purpose : Turn a list into a text string for use in a document Params : List, Bool Returns : String from a special join operajtion

### sub count-substrs

```perl6
sub count-substrs(
    Str:D $ip,
    Str:D $substr
) returns UInt
```

Purpose : Count instances of a substring in a string Params : String, Substring Returns : Number of substrings found

### multi sub strip-comment

```perl6
multi sub strip-comment(
    $line is copy,
    :$mark = "#",
    :$save-comment,
    :$normalize,
    :$last
) returns Mu
```

Purpose : Strip comments from an input text line, save comment if requested, normalize returned text if requested Params : String of text, comment char ('#' is default), option to return the comment, option to normalize the returned strings, option to use the last comment char instead of the first Returns : String of text with any comment stripped off. Note that the designated char will trigger the strip even though it is escaped or included in quotes. Also returns the comment if requested. All returned text is normalized if requested.
string of text with possible comment

class Mu $
----------

desired comment char indicator

class Mu $
----------

if true, return the comment

class Mu $
----------

if true, normalize returned strings

class Mu $
----------

if true, use the last instead of first comment char

### multi sub strip-comment

```perl6
multi sub strip-comment(
    $line is copy,
    $comment-char = "#",
    :$save-comment,
    :$normalize,
    :$last
) returns Mu
```

NOTE THE FOLLOWING SIGNATURE IS DEPRECATED
string of text with possible comment

class Mu $
----------

desired comment char indicator

class Mu $
----------

if true, return the comment

class Mu $
----------

if true, normalize returned strings

class Mu $
----------

if true, use the last instead of first comment char

### sub commify

```perl6
sub commify(
    $num
) returns Mu
```

Purpose : Add commas to a number to separate multiples of a thousand Params : An integer or number with a decimal fraction Returns : The input number with commas added, e.g., 1234.56 => 1,234.56

### multi sub write-paragraph

```perl6
multi sub write-paragraph(
    @text,
    Int :$max-line-length where { ... } = 78,
    Int :$para-indent where { ... } = 0,
    Int :$first-line-indent where { ... } = 0,
    Str :$pre-text = ""
) returns List
```

Purpose : Wrap a list of words into a paragraph with a maximum line width (default: 78) and update the input list with the results Params : List of words, max line length, paragraph indent, first line indent, pre-text Returns : List of formatted paragraph lines

### multi sub write-paragraph

```perl6
multi sub write-paragraph(
    $fh,
    @text,
    Int :$max-line-length where { ... } = 78,
    Int :$para-indent where { ... } = 0,
    Int :$first-line-indent where { ... } = 0,
    Str :$pre-text = ""
) returns Mu
```

Purpose : Wrap a list of words into a paragraph with a maximum line width (default: 78) and print it to the input file handle Params : Output file handle, list of words, max line length, paragraph indent, first line indent, pre-text Returns : Nothing

### sub normalize-string

```perl6
sub normalize-string(
    Str:D $str is copy
) returns Str
```

Purpose : Trim a string and collapse multiple whitespace characters to single ones Params : The string to be normalized Returns : The normalized string

### sub split-line

```perl6
sub split-line(
    Str:D $line is copy,
    Str:D $brk,
    Int :$max-line-length where { ... } = 0,
    Int :$start-pos where { ... } = 0,
    Bool :$rindex = Bool::False
) returns List
```

Purpose : Split a string into two pieces Params : String to be split, the split character, maximum length, a starting position for the search, search direction Returns : The two parts of the split string; the second part will be empty string if the input string is not too long

### sub split-line-rw

```perl6
sub split-line-rw(
    Str:D $line is rw,
    Str:D $brk,
    Int :$max-line-length where { ... } = 0,
    Int :$start-pos where { ... } = 0,
    Bool :$rindex = Bool::False
) returns Str
```

Purpose : Split a string into two pieces Params : String to be split, the split character, maximum length, a starting position for the search, search direction Returns : The part of the input string past the break character, or an empty string (the input string is modified in-place if it is too long)

