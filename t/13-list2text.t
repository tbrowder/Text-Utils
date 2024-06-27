use Test;

use Text::Utils :ALL;

plan 9;

# inputs
my @s1 = <a b c d e>;
my @s2 = <1 2 3 4 5>;
my @s3 = 11, 'boo', 33, 'hoo', 'five';
my $optional-comma = 0;

# expected outputs
my $s1a = 'a, b, c, d, and e';
my $s1b = 'a, b, c, d and e';
my $s2a = '1, 2, 3, 4, and 5';
my $s2b = '1, 2, 3, 4 and 5';
my $s3a = '11, boo, 33, hoo, and five';
my $s3b = '11, boo, 33, hoo and five';

# test normal usage without the special environment 'TEXT_UTILS_NO_OPTIONAL_COMMA'
my $s1a-res = list2text @s1;
my $s1b-res = list2text @s1, :$optional-comma;
my $s2a-res = list2text @s2;
my $s2b-res = list2text @s2, :$optional-comma;
my $s3a-res = list2text @s3;
my $s3b-res = list2text @s3, :$optional-comma;

is $s1a-res, $s1a;
is $s1b-res, $s1b;
is $s2a-res, $s2a;
is $s2b-res, $s2b;
is $s3a-res, $s3a;
is $s3b-res, $s3b;

# test usage WITH the special environment 'TEXT_UTILS_NO_OPTIONAL_COMMA'
{
    %*ENV<TEXT_UTILS_NO_OPTIONAL_COMMA> = 1;
    my $s1c-res = list2text @s1;
    my $s2c-res = list2text @s2;
    my $s3c-res = list2text @s3;

    is $s1c-res, $s1b;
    is $s2c-res, $s2b;
    is $s3c-res, $s3b;
}
