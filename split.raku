#!/usr/bin/env raku

# test nuances
my ($level, $de, $s2, @p2, @np, @nv);
$de = ";";
$s2 = "a ; b";

#==== with :v (keep deleveler)
@p2 = split $de, $s2, 1, :v;
say "\nSplit with :v, level = 1 (notice no split, one part):";
for @p2.kv -> $i, $s { say "  i=$i |$s|"; };

@p2 = split $de, $s2, 2, :v;
say "\nSplit with :v, level = 2 (notice three parts):";
for @p2.kv -> $i, $s { say "  i=$i |$s|"; };

say q:to/HERE/;
#=====================
#=====================
HERE

#==== with NO :v (toss deleveler)
@p2 = split $de, $s2, 1, :!v;
say "\nSplit with :!v, level = 1 (notice no split, one part):";
for @p2.kv -> $i, $s { say "  i=$i |$s|"; };

@p2 = split $de, $s2, 2, :!v;
say "\nSplit with :!v, level = 2 (notice no split, NO parts):";
say "\nThus any explicit 'level' very much effects results";


$de = "==";
my @str = [
    " x == 3 ";
    " x = 3 ";
    " x   3 ";
    " x == 3 = ";
    " x == 3 == 4";
];

$level = 2;
@np=[];@nv=[];
print qq:to/HERE/;
#==============================================
Params: :level({$level}) and always use option :v;
#==============================================
HERE

for @str -> $s is copy {
    $s .= trim;
    say "=== string: '$s', delim: '{$de.trim}'";
    my @res = split $de, $s, $level, :v;
    my $np = @res.elems;
    @np.push: $np;
    say "  number of parts returned: $np";
    say "  \$i => value";
    for @res.kv -> $i, $s { 
        say "  i=$i |$s|"; 
    }
    @nv.push(@nv.elems);
}
print q:to/HERE/;
Results: 
    parts  matches
HERE
my ($np, $nv) = @np.elems, @nv.elems;
unless $np == $nv { say "ERROR: np ($np) != nv ($nv) " };
for @np.kv -> $i, $np {
    my $nv = @nv[$i];
    say "      {$np}      {$nv}";
}

$level = 3;
@np=[];@nv=[];
print qq:to/HERE/;
#==============================================
Params: :level({$level}) and always use option :v;
#==============================================
HERE

for @str -> $s is copy {
    $s .= trim;
    say "=== string: '$s', delim: '{$de.trim}'";
    my @res = split $de, $s, $level, :v;
    my $nr = @res.elems;
    say "  number of parts returned: $nr";
    say "  \$i => value";
    for @res.kv -> $i, $s { 
        say "  i=$i |$s|"; 
    }
}
print q:to/HERE/;
Results: 
    parts  matchs
      1      0
      3      1
HERE 
