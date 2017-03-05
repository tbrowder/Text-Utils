# Text::More

[![Build Status](https://travis-ci.org/tbrowder/Text-More-Perl6.svg?branch=master)]
  (https://travis-ci.org/tbrowder/Text-More-Perl6)

Being a lazy programmer, I refactor chunks of code I find useful into
a module; whence comes this collection of Perl 6 subroutines I have
written during my coding adventures using Perl 5's new little sister.
I hope they will be useful to others.

The routines are described in detail in
[ALL-SUBS](https://github.com/tbrowder/Text-More-Perl6/blob/master/docs/ALL-SUBS.md)
which shows a short description of each exported routine along along
with its complete signature.

This module also includes a utility program in the bin directory.

## Status

This version is 0.1.0 which is considered usable, but the APIs are
subject to change in which case the version major number will be
updated. Note that newly added subroutines or application programs are
not considered a change in API.

## Debugging

For debugging, use one the following methods:

- set the module's $DEBUG variable:

```Perl6
:$Text::More::DEBUG = True;
```

- set the environment variable:

```Perl6
TEXT_MORE_DEBUG=1
```

## Subroutines Exported by the `:ALL` Tag

See
[ALL-SUBS](https://github.com/tbrowder/Text-More-Perl6/blob/master/docs/ALL-SUBS.md)
for a list of export(:ALL) subroutines, each with a short description
along with its complete signature.  Note that individual subroutines
may also be exported:

```Perl6
use Text::More :ALL;
```

```Perl6
use Text::More :strip-comment;
```

## Utility Program

See the *bin* directory for a utility program (```create-md.p6```) to create a README.md file for modules.
