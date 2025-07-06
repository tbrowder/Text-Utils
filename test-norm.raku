#!/usr/bin/env raku

my $norm;


{
    if not $norm.defined {
        say "\$norm is NOT defined";
    }
}

{
    $norm = True;
    if $norm.defined {
        say "\$norm is defined";
    }
}
{
    $norm = True;
    if $norm {
        say "\$norm is True";
    }
}

{
    $norm = !$norm;
    if not $norm {
        say "\$norm is False";
    }
}

{
    $norm = False;
    if not $norm {
        say "\$norm is False";
    }
}



