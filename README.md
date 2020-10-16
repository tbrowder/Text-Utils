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

