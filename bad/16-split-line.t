use Test;

use Text::Utils :ALL;
use Text::Utils::Subs;

# plan 11;

my ($s1, $s2, $s3, $s4, $left, $right, $splitter, $m, $string);
my (@str1, @str2, @str3, @str4);

$s1 = 'sub foo($song, $tool, @long-array, :$good) is export { say pwd }';

($left, $right) = split-line $s1, '(';
is $left, 'sub foo', "default split-line";
is $right, '$song, $tool, @long-array, :$good) is export { say pwd }',
           "default split-line";

$s2  = "Free Sans";
$splitter = "Free";
($left, $right) = split-line $s2, $splitter;
is $left, "", "default behavior";
is $right, " Sans", "default behavior";

# default behavior: no split text saved, 0 or 2 parts, no cleaning
$s3 = " key : some  text "; 
$splitter = ':';
($left, $right) = split-line $s3, $splitter;
is $left, " key ", "default behavior";
is $right, " some  text ", "default behavior";

# behavior with :clean option: split char removed, first part cleaned
#   last part untouched
$s3 = " key : some  text ";
$splitter = ':';
($left, $right) = split-line $s3, $splitter, :clean;
is $left, "key", "use new :clean option";
is $right, " some  text ", "use new :clean option";

#=================================
# forward search with splitter as key:
#             1     3    1
$string = " Free   Sans "; # 13 chars
#      first: 6 chars
#      last:  7 chars
#                 1
$splitter  = "Free "; # 5 chars
$m = find-text-forward :$string, :$splitter;
isa-ok $m, Hash, "\$m is a Hash";
for $m.kv -> $k, $v {
    say "key: '$k' => '$v'";
}

# using a word as key
$s2  = " Free  Sans ";
$splitter = 'Free ';
($left, $right) = split-line $s2, $splitter;
is $left, " ", "split ' Free Sans ' at 'Free ', pre: '$left'";
is $right, " Sans ", "split 'Free Sans' at 'Free', post: '$right'";

# more default use cases

$splitter = ":";         # expected
$s1 = "foo : bar";       # | | |
$s2 = "foo : bar : baz"; # | | |
$s3 = "foo   bar   baz"; # | | |
$s4 = ": bar";           # | | |

@str1 = split-line $s1, $splitter;
is @str1.elems, 2, "default: 2 pieces";
is @str1.head, "foo ", "default";
is @str1.tail, " bar", "default";

@str2 = split-line $s2, $splitter;
is @str2.elems, 2, "default: 2 pieces";
is @str2.head, "foo ", "default";
is @str2.tail, " bar : baz", "default";

@str3 = split-line $s3, $splitter;
is @str3.elems, 2, "default: 2 pieces";
is @str3.head, "", "default";
is @str3.tail, "foo   bar   baz", "default";

@str4 = split-line $s4, $splitter;
is @str4.elems, 2, "default: 2 pieces";
is @str4.head, "", "default";
is @str4.tail, " bar", "default";

done-testing;
=finish

