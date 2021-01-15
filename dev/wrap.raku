#!/usr/bin/env raku

use lib <./lib ../lib>;
use Text::Utils :wrap-paragraph;

my $str = q:to/HERE/;
Begin a new sub-path by moving the current point to coordinates (x,
y), omitting any connecting line segment. If the previous path
construction operator in the current path was also m, the new m
overrides it.
HERE

my @para = wrap-paragraph $str.lines, :para-pre-text('#| '),
:para-indent(4);
.say for @para;
