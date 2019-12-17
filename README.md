# Text::More

[![Build Status](https://travis-ci.org/tbrowder/Text-Utils-Raku.svg?branch=master)](https://travis-ci.org/tbrowder/Text-Utils-Raku)

This model provides some miscellaneous text processing routines not
provided by core Raku. (Note it replaces the now-deprecated `Text::More` module.)

## Synopsis

```Raku
use Text::More :ALL;
```
Note that individual subroutines
may also be exported:

```Raku
use Text::More :strip-comment;
```

## Installation

``` Raku
zef install Text::Utils
```

## Documentation

``` Raku
zef install p6doc
p6doc Text::Utils
```

## See also

- `Text::Abbrev`
- `Text::BorderedBlock`
- `Text::Diff::Sift4`
- `Text::Emotion`
- `Text::Levenshtein::Damerau`
- `Text::MiscUtils`
- `Text::More (deprecated)`
- `Text::Table::List`
- `Text::Table::Simple`
- `Text::Tabs`
- `Text::Wrap`

## Acknowledgements

The `commify` subroutine is based on the subroutine of the same
name found in the *Perl Cookbook*.

## LICENSE

Artistic 2.0. See [LICENSE](https://github.com/tbrowder/Text-Utils-Raku/blob/master/LICENSE).

## COPYRIGHT

Copyright (C) 2019 Thomas M. Browder, Jr. <<tom.browder@gmail.com>>
