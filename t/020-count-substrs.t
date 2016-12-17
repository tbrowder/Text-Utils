use v6;
use Test;

use Misc::Utils :ALL;

plan 3;

is count-substrs('23:::', '::'), 2;
is count-substrs('d:efa33:23:::', ':'), 5;
is count-substrs('d-:efa33:23:-::', '-:'), 2;
