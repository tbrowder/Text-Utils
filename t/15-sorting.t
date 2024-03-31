use Test;

use Text::Utils :sort-list;

my $debug = 0;

# non-numeric input test data
my @in = <Bc a B>;                    
# expected
my @outLS     = <B a Bc>;                    
my @outLS-rev = <Bc a B>;
my @outSL     = <B Bc a>;                    
my @outSL-rev = <a Bc B>;                    

is sort-list(@in), @outLS, "default, LS";
is sort-list(@in, :reverse), @outLS-rev, "default, LS, reversed";

is sort-list(@in, :type(LS)), @outLS, "type LS";
is sort-list(@in, :type(LS), :reverse), @outLS-rev, "type LS, reversed";

is sort-list(@in, :type(SL)), @outSL, "type SL";
is sort-list(@in, :type(SL), :reverse), @outSL-rev, "type SL, reversed";

# numeric sorting
@in = 1, 3, 2;
is sort-list(@in, :type(N)), (1,2,3), "numerical sort with numbers";
@in = 1, 'a', 2;
is sort-list(@in, :type(N)), (1,2,'a'), "numerical sort with non-numbers";

done-testing;


