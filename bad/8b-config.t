use Test;

use File::Temp;

use Text::Utils;

my $debug = 1; # output files are place in local dir "tmp"

# test saving in a temp dir
my $tdir = $debug ?? "tmp" !! tempdir;
mkdir $tdir;

# this is the way to most easily create an array of strings
#my @x = qqww{ "\n"  ; || , "\t" | \# };

#                        |<== default
my @line-endings = qqww{ "\n"  ;  ||    };
my @sepchar      = qqww{  ,    ; "\t" | };
my @mark         = qqww{ \#    ;        };

# the test csv contents
# by line without a defined line ending
my @hdr  = [" name ", " age ", " notes " ];
my @row1 = [" Sally x Jean ", " 22 ", "" ]; # replace 'x' with either '\n' or ' '
my @row2 = [" Tom ", " 30 ", " rakuun "];
my $ncols = 3;
# the test files
my $prefix = "csv";
my $idx = 0;
L: for @line-endings -> $le {
    note "DEBUG: line ending is \<$le\>";
    if $le ~~ /\n+/ {
        note "DEBUG: line ending is a newline";
    }
    M: for @mark -> $mk {
        next M if $mk ~~ /$le/;

        S: for @sepchar -> $sc {
            next S if $sc ~~ /$mk/;
            next S if $sc ~~ /$le/;

            my $LE = $le;
            my $SC = $sc;
            $LE = "nl"  if $LE ~~ /\n/;
            $SC = "tab" if $SC ~~ /\t/;
            my $comment = "Using mark ($mk), sepchars ($SC), line endings ($LE)";

            my $num = ++$idx;
            my $fnam = $prefix ~ sprintf "%02d", $num;
            $fnam = "$tdir/$fnam";
            my $fh = open $fnam, :w, :nl-in($le);
            #===========
            $fh.say: "$mk $comment";
            for @hdr.kv -> $i, $v is copy {
                $fh.print: $v;
                $fh.print($sc) if $i < $ncols - 1;
            }
            $fh.say();

            for @row1.kv -> $i, $v is copy  {
                # special col 0
                if $i == 0 and $v.contains('x') {
                    note "DEBUG: \$v contains x";
                    if $le ~~ /\n/ {
                        note "DEBUG: x with newline ending";
                        $v ~~ s/x/ /;
                    }
                    else {
                        note "DEBUG: x with NO newline ending";
                        $v ~~ s/x/\n/;
                    }
                }

                $fh.print: $v;
                $fh.print($sc) if $i < $ncols - 1;
            }
            $fh.say();

            for @row2.kv -> $i, $v is copy {
                $fh.print: $v;
                $fh.print($sc) if $i < $ncols - 1;
            }
            $fh.say();

            #===========
            $fh.close;
        }
    }
}
say "Wrote $idx test files";

exit;
=finish

my $f = "$tdir/conf-test.csv";
# write the test file
my $fh = open $f, :w, :nl-out("||");
for @csv {
    $fh.say: $_;
}
$fh.close;

#my ($of1, $of2, $f3, $f4, $f5, $f6);
#$of1 = "$tdir/config-csv-table.yml";
#$of2 = "$tdir/config-csv-table.json";

my $cy = "t/data/conf-rev.yml";
my $cj = "t/data/conf-rev.json";

my $t;

$t = CSV::Table.new: :csv($f), :config($cy);
is $t.has-header, True, "has header";
is $t.separator, '\t', "sep char is a tab";
is $t.comment-char, ";", "comment-char semicolon";
is $t.line-ending, '||', "line-ending '||'";
is $t.normalize, False, "normalize False";

# check values
is $t.rows, 2, "2 rows";
is $t.fields, 3, "3 fields";
is $t.field[0], "name", "field 0 is name";

is $tdir.IO.d, True, "making dir '$tdir'";
my $tstem = "$tdir/test-out";
my $tcsv = $tstem ~ ".csv";
my $traw = $tstem ~ $t.raw-ending ~ ".csv";
lives-ok { $t.save: $tstem, :force; }, "save and rename";

is $tcsv.IO.r, True, "commented written";
is $traw.IO.r, True, "commented -clean written";

done-testing;
=finish


$t = CSV::Table.new: :csv($f1), :config($cj);

# test the self-selected file names
lives-ok { CSV::Table.write-config: $f4, :force; }, "valid file name";
lives-ok { CSV::Table.write-config: $f5, :force; }, "valid file name";

# test all the combos
lives-ok { CSV::Table.write-config: :force, :type(yam); }, "valid input type";
lives-ok { CSV::Table.write-config: :force, :type(ya); }, "valid input type";
lives-ok { CSV::Table.write-config: :force, :type(y); }, "valid input type";
lives-ok { CSV::Table.write-config: :force, :type(yml); }, "valid input type";
lives-ok { CSV::Table.write-config: :force, :type(ym); }, "valid input type";
lives-ok { CSV::Table.write-config: :force, :type(jso); }, "valid input type";
lives-ok { CSV::Table.write-config: :force, :type(js); }, "valid input type";
lives-ok { CSV::Table.write-config: :force, :type(j); }, "valid input type";

done-testing;

