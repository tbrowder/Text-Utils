use Test;

use Text::Utils;
use Text::Utils::Subs;

plan 26;

my ($s1, $s2, $s3, $s4, $left, $right, $splitter, $m, $string);
my (@str1, @str2, @str3, @str4);

$s1 = 'sub foo($song, $tool, @long-array, :$good) is export { say pwd }';

@str1 = core-split-wmods $s1, '(', :v;
is @str1.head, 'sub foo', "default core-split-wmods";
is @str1.tail, '$song, $tool, @long-array, :$good) is export { say pwd }', "default core-split-wmods";

$s2  = "Free Sans";
$splitter = "Free";
@str2 = core-split-wmods $s2, $splitter;
is @str2.head, "", "default behavior";
is @str2.tail, " Sans", "default behavior";

# default behavior: no split text saved, 0 or 2 parts, no cleaning
$s3 = " key : some  text ";
$splitter = ':';
@str3 = core-split-wmods $s3, $splitter;
is @str3.head, " key ", "default behavior";
is @str3.tail, " some  text ", "default behavior";

# behavior with :clean option: split char removed, first part cleaned
#   last part untouched
$s3 = " key : some  text ";
$splitter = ':';
@str3 = core-split-wmods $s3, $splitter; #, :clean;
is @str3.head, " key ", "use new :clean option";
is @str3.tail, " some  text ", "use new :clean option";

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
subtest {
    for $m.kv -> $k, $v {
        say "key: '$k' => '$v'";
    }
}

# using a word as key
$s2  = " Free  Sans ";
$splitter = 'Free ';
@str2 = core-split-wmods $s2, $splitter;
is @str2.head, " ";
is @str2.tail, " Sans ", "split 'Free Sans' at 'Free '";

# more default use cases
$splitter = ":";         # expected
$s1 = "foo : bar";
$s2 = "foo : bar : baz";
$s3 = "foo   bar   baz";
$s4 = ": bar";

$splitter = ":";         # expected
@str1 = core-split-wmods $s1, $splitter;
is @str1.elems, 2, "default: 2 parts (max) for core split";
is @str1.head, "foo ", "default";
is @str1.tail, " bar", "default";

$splitter = ":";         # expected
$s2 = "foo : bar : baz";
@str2 = core-split-wmods $s2, $splitter;
is @str2.elems, 3, "default: 3 parts (max) for core split";
is @str2.head, "foo ", "default";
is @str2[1], " bar ", "default";
is @str2.tail, " baz", "default";

# STRANGE DEFAULT RESULTS for tests below
# discuss on #raku

$splitter = ":";         # expected
$s3 = "foo   bar   baz";
@str3 = core-split-wmods $s3, $splitter;
say "==================================";
say "core split with NO delimiter match";
say "  delimiter: '$splitter'";
say "  input    : '$s3'";
say "  output   :";
subtest {
    for @str3 -> $s {
        say "    '$s'";
    }
}
is @str3.elems, 1, "strange default: 1 part (max) for core split";
is @str3.head, "foo   bar   baz", "1st part: '{@str3.head}'";
say "==================================";

$splitter = ":";         # expected
$s4 = ": bar";
@str4 = core-split-wmods $s4, $splitter;
say "==================================================";
say "core split with NO text BEFORE the delimiter";
say "  delimiter: '$splitter'";
say "  input    : '$s4'";
say "  output   :";
subtest {
    for @str4 -> $s {
        say "    '$s'";
    }
}

is @str4.elems, 2, "strange default: 2 parts (max) for core split";
is @str4.head, "", "1st part: '{@str4.head}'";
is @str4.tail, " bar", "2nd part: '{@str4.tail}'";
say "==================================================";
