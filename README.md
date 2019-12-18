[![Build Status](https://travis-ci.org/tbrowder/Text-Utils-Raku.svg?branch=master)](https://travis-ci.org/tbrowder/Text-Utils-Raku)

# Text::Utils

This model provides some miscellaneous text processing routines not
provided by core Raku. (Note it replaces the now-deprecated `Text::More` module.)

Note this is version `2.0.0` which introduces a new API 2 for
the `strip-comment` routine. See the examples below for its use.
The old signature is still usable, but it is deprecated
and will be removed in version `3.0.0`.

## Synopsis

```raku
use Text::More :ALL;
```
Note that individual subroutines
may also be exported:

```raku
use Text::More :strip-comment;
# the '#' is the default comment character
my $line = " some  text # a comment";
$line = strip-comment $line;
say $line; # OUTPUT: « some  text ␤»
```
If you want to be fancier, return the stripped line and its comment,
bit normalized (trimmed of leading and trailing spaces, contiguous
spaces collapsed to one):

```raku
# define your own comment character(s)
# save the comment and normalize the returned strings
my ($line, $comm) = strip-comment $line, :mark<%%>, :save-comment, :normalize;
say $line; # OUTPUT: «some text␤»
say $comm; # OUTPUT: «a comment␤»
```
The default behavior is to find the first comment character in the input
string, but you may choose to start the search from the end of the
input string:

```raku
my $line = "text 1 # text 2 # comment";
$line = strip-comment $line, :reverse;
say $line; # OUTPUT: «text 1 # text 2 ␤»
```
Note that the routine is line oriented, so embedded newlines
may give unexpected results:
```raku
my $line = q:to/HERE/;
text 1 # comment 1
text 2 # comment 2
HERE
$line = strip-comment $line
say $line; # OUTPUT: «text 1 ␤»
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
- `Text::More` (deprecated by `Text::Utils`)
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
