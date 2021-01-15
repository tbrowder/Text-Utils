use v6;
use Test;

use Text::Utils :ALL;

plan 13;

my $debug = 0;

# input: 10 five-letter words in a string
constant \SPACE = ' ';
my @text;
@text.push: SPACE ~ 'words';
for 1..^10 -> $i {
    my $s = SPACE x $i;
    $s ~= 'words';
    @text.push: $s;
}
@text.push: SPACE;
# test some corner cases ==================================
#                         1         2         3
my Str @text30 = '123456789012345678901234567890';   # 30 chars
my Str @text32 = '12345678901234567890123456789012'; # 32 chars

#          1         2         3        4
# 123456789012345678901234567890123467890
# test against some strings
my (@para, @p1);

#============================================================================================
# the string output version

# test 1
{
    @para = wrap-paragraph @text, :max-line-length(30), :$debug;

    @p1 =
    "words words words words words",
    "words words words words words";

    is-deeply @para, @p1, "max line length, plain para";
}

# test 2
{
    @para = wrap-paragraph @text, :max-line-length(24), :$debug;

    @p1 =
    "words words words words",
    "words words words words",
    "words words";

    is-deeply @para, @p1
        , "shorter max line length, plain para";
}

# test 3
{
    @para = wrap-paragraph @text, :max-line-length(20), :$debug;

    @p1 =
    "words words words",
    "words words words",
    "words words words",
    "words";

    is-deeply @para, @p1
        , "even shorter max line length, plain para";
}

# test 4
{
    @para = wrap-paragraph @text, :max-line-length(38), :first-line-pre-text('topic:  '), :$debug;

    @p1 =
    "topic:  words words words words words",
    "words words words words words";

    is-deeply @para, @p1
        , "first-line-pre-text";
}

# test 5
{
    @para = wrap-paragraph @text, :max-line-length(30), :first-line-indent(3), :$debug;

    @p1 =
    "   words words words words",
    "words words words words words",
    "words";

    is-deeply @para, @p1 
        , "first-line-indent";
}

# test 6
{
    @para = wrap-paragraph @text, :max-line-length(33), :first-line-indent(3),
		    :para-indent(5), :$debug;

    @p1 =
    "        words words words words",
    "     words words words words",
    "     words words";

    is-deeply @para, @p1
        , "para-indent and first-line-indent";
}

# test 7
{
    @para = wrap-paragraph @text, :max-line-length(33), :first-line-indent(5),
			    :para-indent(3), :$debug;

    @p1 =
    "        words words words words",
    "   words words words words words",
    "   words";

    is-deeply @para, @p1
        , "para-indent and first-line-indent";
}

# test 8
{
    @para = wrap-paragraph @text, :first-line-pre-text('text: '), :max-line-length(39),
			    :first-line-indent(5), :para-indent(3), :$debug;

   #          1         2         3        4
   # 123456789012345678901234567890123467890
    @p1 =
    "        text: words words words words",
    "   words words words words words words";

    is-deeply @para, @p1
        , "para-indent, first-line-indent, first-line-pre-text with one trailing space";
}

# test 9
{
    @para = wrap-paragraph @text30, :max-line-length(30), :$debug;

    @p1 =
    "123456789012345678901234567890";

    is-deeply @para, @p1, "line at maxlength of 30";
}

# test 10
{
    @para = wrap-paragraph @text, :para-pre-text('#| '), :max-line-length(30), :$debug;

    @p1 =
    "#| words words words words",
    "#| words words words words",
    "#| words words";

    is-deeply @para, @p1, "para-pre-text with one trailing space, max line length 30";
}

# test 11
{
    dies-ok { @para = wrap-paragraph @text32, :max-line-length(30), :$debug; }, "line reported too long";
}

# test 12
{
    dies-ok { @para = wrap-paragraph @text30, :max-line-length(30), :para-pre-text('def: '), :$debug; }, 
        "line exactly the max length but too long with pre-text";
}

# test 13
{
    @para = wrap-paragraph @text, 
                            :max-line-length(39),
                            :para-indent(2), 
			    :line-indent(6), 
                            :first-line-pre-text('defn: '), 
                            :$debug;

   #          1         2         3        4
   # 123456789012345678901234567890123467890
    @p1 =
    "  defn: words words words words words",
    "        words words words words words";

    is-deeply @para, @p1
        , "para-indent, line-indent, first-line-pre-text with one trailing space";
}
