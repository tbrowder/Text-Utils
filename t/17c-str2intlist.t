use Test;

use Text::Utils :ALL; 

my $set5s = set(1..69);
my $setpb = set(1..26);

isa-ok $set5s, Set, "isa-ok Set";
isa-ok $setpb, Set, "isa-ok Set";

# with a set of 5 numbers, ensure:
# valid sets
my @valid = [
    "69 4 3 2 1",
    "68 4 67 2 66",
    "1 3 4 68 69",
];

for @valid -> $s {
    my $set = set str2intlist $s;
    isa-ok $set, Set, "isa-ok Set";
}

done-testing;
=finish

# invalid sets
my @invalid = [
    "69 4  3 2  4", # dup numbers
    "70 4 67 2 66", # number too large
    "69 4  3 0  4", # number too small
];

done-testing;
