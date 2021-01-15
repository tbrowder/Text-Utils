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

### sub list2text

Turn a list into a text string for use in a document

For example, this list `1 2 3` becomes either this `"1, 2, and 3"` (the default result) or this `"1, 2 and 3"` (if the `$optional-comma` named variable is set to false). The default result uses the so-called *Oxford Comma* which is not popular among some writers, but those authors may change the default behavior by permanently by defining the environment variable `TEXT_UTILS_NO_OPTIONAL_COMMA`.

The signature:

```Raku
sub list2text(@list, :$optional-comma is copy = True) is export(:list2text) 
{...}
```

### sub count-substrs

Count instances of a substring in a string

The signature:

```Raku
sub count-substrs(Str:D $string, Str:D $substr --> UInt) is export(:count-substrs) 
{...}
```

### multi strip-comments

Strip comments from an input text line, save comment if requested, normalize returned text if requested

The routine returns a string of text with any comment stripped off. Note the designated char will trigger the strip even though it is escaped or included in quotes. Also returns the comment if requested. All returned text is normalized if requested.

The signature:

```Raku
multi strip-comment($line is copy,       # string of text with possible comment
                    :$mark = '#',        # desired comment char indicator
                    :$save-comment,      # if true, return the comment
                    :$normalize,         # if true, normalize returned strings
                    :$last,              # if true, use the last instead of first comment char
                   ) is export(:strip-comment) 
{...}
```

### sub commify

This routine is ported from the Perl version in the *The Perl Cookbook, 3e*.

This routine adds commas to a number to separate multiples of a thousand. For example, given an input of `1234.56`, the routine returns `1,234.56`.

The signature:

```Raku
sub commify($num) is export(:commify) 
{...}
```

### multi write-paragraph

This routine wraps a list of words into a paragraph with a maximum line width (default: 78) and updates the input list with the results.

The signature:

```Raku
multi write-paragraph(@text,
		      UInt :$max-line-length   = 78,
                      UInt :$para-indent       = 0,
		      UInt :$first-line-indent = 0,
                      Str  :$pre-text          = '' 
                      --> List) is export(:write-paragraph)
{...}
```

### multi write-paragraph

This routine wraps a list of words into a paragraph with a maximum line width (default: 78) and writes it to the input file handle.

The signature:

```Raku
multi write-paragraph($fh, @text,
                      UInt :$max-line-length   = 78,
                      UInt :$para-indent       = 0,
                      UInt :$first-line-indent = 0,
                      Str  :$pre-text          = '') is export(:write-paragraph2)
{...}
```

### sub normalize-string

This routine trims a string and collapses multiple whitespace characters.

The signature:

```Raku
sub normalize-string(Str:D $str is copy --> Str) is export(:normalize-string) 
{...}
```

### sub split-line

This routine splits a string into two pieces.

Inputs are the string to be split, the split character, maximum length, a starting position for the search, and the search direction.

It returns the two parts of the split string; the second part will be an empty string if the input string is not too long.

The signature:

```Raku
sub split-line(Str:D $line is copy, 
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
sub split-line-rw(Str:D $line is rw, 
                  Str:D $brk, 
                  UInt  :$max-line-length = 0,
                  UInt  :$start-pos       = 0, 
                  Bool  :$rindex          = False 
                  --> Str) is export(:split-line-rw) 
{...}
```

AUTHOR
======

Tom Browder <tom.browder@gmail.com>

COPYRIGHT AND LICENSE
=====================

Copyright &#x00A9; 2019-2020 Tom Browder

This library is free software; you can redistribute it or modify it under the Artistic License 2.0.

