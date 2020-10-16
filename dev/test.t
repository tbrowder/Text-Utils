my $DEBUG = 1;
my $optional-comma = @*ARGS.elems ?? 0 !! 1;
my @list = <1 2 3 4 5>;

my $s = @list[0..*-2].join(', ');
say $s if $DEBUG;
$s ~= ',' if $optional-comma;
$s ~= ' and ' ~ @list[*-1];
say $s if $DEBUG;
