use Test;

use Text::Utils::Subs;

my (@nums, $res, $got, $exp);

my $ntests = 10;
plan $ntests;

@nums = 0..^$ntests;
for @nums -> $num {
    $got = is-odd $num;

    my $res = $num % 2;
    if $res {
        $exp = True;
    }
    else {
        $exp = False;
    }
    is $got, $exp, "is-odd: $num, got $got, exp $exp";
}

=finish

$num = 0;
$res = is-odd $num;
is $res, False, "$num is even"

