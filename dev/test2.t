use lib <../lib>;
use Text::Utils :list2text;

my $optional-comma = @*ARGS.elems ?? 0 !! 1;
my @list = <1 2 3 4 5>;

my $s = list2text @list, :$optional-comma;
say $s;
