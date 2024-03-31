use v6;
use Test;

use Text::Utils :ALL;

plan 17;

# normalize these strings
my $str1 = "1 2  3   4 \n   5 \t    6      7       8        9         0";
my $str2 = ' 1 2  3   4    5     6      7       8        9         0';
my $str3 = '1 2  3   4    5     6      7       8        9         0 ';
my $str4 = ' 1 2  3   4    5     6      7       8        9         0 ';
# all should normalize to:
constant $n = '1 2 3 4 5 6 7 8 9 0';

is normalize-string($str1), $n;
is normalize-string($str2), $n;
is normalize-string($str3), $n;
is normalize-string($str4), $n;

# normalize the strings in place
$str1 .= &normalize-string;
$str2 .= &normalize-string;
$str3 .= &normalize-string;
$str4 .= &normalize-string;
is $str1, $n;
is $str2, $n;
is $str3, $n;
is $str4, $n;

# aliases
is normalize-text($str1), $n;
is normalize-text($str2), $n;
is normalize-text($str3), $n;
is normalize-text($str4), $n;

# normalize the strings in place
$str1 .= &normalize-string;
$str2 .= &normalize-string;
$str3 .= &normalize-string;
$str4 .= &normalize-string;
is $str1, $n;
is $str2, $n;
is $str3, $n;
is $str4, $n;

#=== THIS MUST BE THE LAST TEST IN THE FILE ===
# check for failing on a non-string
$str1 = 3;
dies-ok { $str1 = normalize-string $str1 }, 'Fails on a non-string';
