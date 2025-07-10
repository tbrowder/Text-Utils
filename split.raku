#!/usr/bin/env raku

=begin comment
sub test-and-show {...}
=end comment

use lib "lib";
use Text::Utils::Subs;

# test nuances
my ($opt, $level, $de, $s2, @p2, @np, @nv, $np, $nv);
$de = ";";
$s2 = "a ; b";

#==== with :v (keep delimiter values)
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

#==== with NO :v (toss delimiter values)
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
@np=[]; @nv=[];
$opt = 'v';
print qq:to/HERE/;
#=================================================
Params: :level({$level}), using option :{$opt}
#=================================================
HERE

for @str -> $s is copy {
    $s .= trim;
    say "=== string: '$s', delim: '{$de.trim}'";
    my @res = split $de, $s, $level, :v;
    $np = @res.elems;
    @np.push: $np;
    say "  number of parts returned: $np";
    say "  \$i => value";
    for @res.kv -> $i, $s {
        say "  i=$i |$s|";
    }
    @nv.push(@res.keys);
}
print q:to/HERE/;
Results:
    parts  matches
HERE
($np, $nv) = @np.elems, @nv.elems;
unless $np == $nv { say "ERROR: np ($np) != nv ($nv) " };
for @np.kv -> $i, $np {
    my $nv = @nv[$i];
    say "      {$np}      {$nv}";
}

=begin comment
subset SplitOp of Str where * ~~ /^ ':' (v|k|kv) $/;
subset LevelOp of Str where * >= 1;
sub test-and-show-string-list(
    @str,             #= strings to test
    Str :$delim!,     #= delimiter
    LevelOp :$level!, #= min number of matches
    SplitOp :$opt!,   #= option used
) {
    my @np=[]; my @nv=[];
    print qq:to/HERE/;
    #=================================================
    Params: :level({$level}), using option {$opt}
    #=================================================
    HERE

    for @str -> $s is copy {
        $s .= trim;
        say "=== string: '$s', delim: '{$delim.trim}'";
        my @res = split $delim, $s, $level, {$opt.raku};
        $np = @res.elems;
        @np.push: $np;
        say "  number of parts returned: $np";
        say "  \$part => \$value";
        for @res.kv -> $i, $s {
            say "  part=$i |$s| value=$v";
        }
        @nv.push(@res.keys);
    }
    print q:to/HERE/;
    Results:
    parts  matches
           HERE
           ($np, $nv) = @np.elems, @nv.elems;
    unless $np == $nv { say "ERROR: np ($np) != nv ($nv) " };
    for @np.kv -> $i, $np {
        my $nv = @nv[$i];
        say "      {$np}      {$nv}";
    }
}
=end comment

=finish

$level = 3;
@np=[]; @nv=[];
print qq:to/HERE/;
#================================================
Params: :level({$level}) and always use option :v
#================================================
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
