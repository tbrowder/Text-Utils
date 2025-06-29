use Test;

use Text::Utils :ALL;

plan 6;

my $s1 = 'sub foo($song, $tool, @long-array, :$good) is export { say pwd }';

my ($line1, $line2) = split-line($s1, '(');
is $line1, 'sub foo(';
is $line2, '$song, $tool, @long-array, :$good) is export { say pwd }';

my $s2  = "Free Sans";
my $brk = "Free";

my ($pre, $post) = split-line $s2, $brk, :break-after;
is $pre, "Free", "split 'Free Sans' at 'Free', :breakafter, pre: '$pre'";
is $post, " Sans", "split 'Free Sans' at 'Free', :breakafter, post: '$post'";

my $s3 = " key : some   text";
$brk = ':';
($pre, $post) = split-line $s3, $brk, :clean;
is $pre, "key", "use new :clean";
is $post, "some text", "use new :clean";
