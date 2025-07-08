use Test;

use Text::Utils :ALL;
use Text::Utils::Subs;

# plan 8;

my ($s1, $s2, $s3, $pre, $post, $line1, $line2);

$s1 = 'sub foo($song, $tool, @long-array, :$good) is export { say pwd }';


($line1, $line2) = split-line( $s1, '(' );
is $line1, 'sub foo(', "default split-line";
is $line2, '$song, $tool, @long-array, :$good) is export { say pwd }',
           "default split-line";

$s2  = "Free Sans";
my $brk = "Free";

# default behavior: char stays with first part, no cleaning
$s3 = " key : some  text "; 
$brk = ':';
($pre, $post) = split-line $s3, $brk;
is $pre, " key :", "default behavior, split char says with first";
is $post, " some  text ", "default behavior";

# behavior with :clean option: split char removed, first part cleaned
#   last part untouched
$s3 = " key : some  text ";
$brk = ':';
($pre, $post) = split-line $s3, $brk, :clean;
is $pre, "key", "use new :clean option";
is $post, " some  text ", "use new :clean option";

#=================================
# forward search with chunk as key:
#             1     3    1
my $string = " Free   Sans "; # 13 chars
#      first: 6 chars
#      last:  7 chars
#                 1
my $chunk  = "Free "; # 5 chars
my $m = find-text-forward :$string, :$chunk;
isa-ok $m, Hash, "\$m is a Hash";
for $m.kv -> $k, $v {
    say "key: '$k' => '$v'";
}

done-testing;
=finish
#=================================
# reverse search with chunk as key:
#             1     3    1
my $string = " Free : Sans "; # 13 chars


done-testing;
=finish
# TODO fix following bad tests

# using a word as key
$s2  = " Free  Sans ";
$brk = 'Free ';
($pre, $post) = split-line $s2, $brk;
is $pre, " ", "split ' Free Sans ' at 'Free ', pre: '$pre'";
is $post, " Sans ", "split 'Free Sans' at 'Free', post: '$post'";
