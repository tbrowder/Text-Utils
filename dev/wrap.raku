#!/usr/bin/env raku

use lib <./lib ../lib>;
use Text::Utils :wrap-paragraph;

my $str = qq:to/HERE/;
The framistan is cooked twice. Once rare for those who like it that
way, and the second time well-done for those who are not foodies.
HERE

my @para = wrap-paragraph $str.lines, :line-pre-text<#|>, :first-line-indent(4), :para-indent(4);
.say for @para;
