use Test;

use Text::Utils :ALL;
use Text::Utils::Subs;

# plan 8;

my ($s1, $s2, $s3, $left, $right, $splitter, $m, $string);

$s1 = 'sub foo($song, $tool, @long-array, :$good) is export { say pwd }';


($left, $right) = split-line( $s1, '(' );
is $left, 'sub foo(', "default split-line";
is $right, '$song, $tool, @long-array, :$good) is export { say pwd }',
           "default split-line";

$s2  = "Free Sans";
$splitter = "Free";

# default behavior: char stays with first part, no cleaning
$s3 = " key : some  text "; 
$splitter = ':';
($left, $right) = split-line $s3, $splitter;
is $left, " key :", "default behavior, split char says with first";
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

done-testing;
=finish
#=================================
# reverse search with splitter as key:
#             1     3    1
$string = " Free : Sans "; # 13 chars


done-testing;
=finish
# TODO fix following bad tests

# using a word as key
$s2  = " Free  Sans ";
$splitter = 'Free ';
($left, $right) = split-line $s2, $splitter;
is $left, " ", "split ' Free Sans ' at 'Free ', pre: '$left'";
is $right, " Sans ", "split 'Free Sans' at 'Free', post: '$right'";
