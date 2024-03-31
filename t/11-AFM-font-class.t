use v6;
use Test;

use Text::Utils :ALL;
use Font::AFM;

plan 13;

my $debug = 0;

my $f;

$f = AFM-font.new: :name<Times-Roman>, :size(12);

is $f.size, 12;
is $f.name, 'Times-Roman';
is $f.upos, -1.2;
is $f.uwid, 0.6;
is $f.UnderlinePosition, -1.2;
is $f.UnderlineThickness, 0.6;
is $f.kern, True;

$f.kern-off;
is $f.kern, False;
$f.kern-on;
is $f.kern, True;
is $f.llx, -2.016;
is $f.lly, -2.616;
is $f.urx, 12;
is $f.ury, 10.776;


