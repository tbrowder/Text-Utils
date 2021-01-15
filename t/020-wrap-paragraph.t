use v6;
use Test;

use Text::Utils :ALL;

#plan 10;

my $debug = 1;

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
    @para = wrap-paragraph(@text, :max-line-length(24));

    @p1 =
    "words words words words",
    "words words words words",
    "words words";

    is-deeply @para, @p1
        , "shorter max line length, plain para";
}

# test 3
{
    @para = wrap-paragraph(@text, :max-line-length(20));

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
    @para = wrap-paragraph(@text, :max-line-length(38), :first-line-pre-text('topic:  '));

    @p1 =
    "topic:  words words words words words",
    "words words words words words";

    is-deeply @para, @p1
        , "first-line-pre-text";
}

# test 5
{
    @para = wrap-paragraph(@text, :max-line-length(30), :first-line-indent(3));

    @p1 =
    "   words words words words",
    "words words words words words",
    "words";

    is-deeply @para, @p1 
        , "first-line-indent";
}

# test 6
{
    @para = wrap-paragraph(@text, :max-line-length(33), :first-line-indent(3),
		    :para-indent(5));

    @p1 =
    "        words words words words",
    "     words words words words",
    "     words words";

    is-deeply @para, @p1
        , "para-indent and first-line-indent";
}

# test 7
{
    @para = wrap-paragraph(@text, :max-line-length(33), :first-line-indent(5),
			    :para-indent(3));

    @p1 =
    "        words words words words",
    "   words words words words words",
    "   words";

    is-deeply @para, @p1
        , "para-indent and first-line-indent";
}

# test 8
{
    @para = wrap-paragraph(@text, :first-line-pre-text('text: '), :max-line-length(39),
			    :first-line-indent(5), :para-indent(3));

   #          1         2         3        4
   # 123456789012345678901234567890123467890
    @p1 =
    "        text:words words words words",
    "   words words words words words words";

    is-deeply @para, @p1
        , "para-indent, first-line-indent, first-line-pre-text";
}

# test 9
{
    @para = wrap-paragraph(@text30, :max-line-length(30));

    @p1 =
    "123456789012345678901234567890";

    is-deeply @para, @p1, "line at maxlength of 30";
}

# test 10
{
    @para = wrap-paragraph(@text, :para-pre-text<#| >, :max-line-length(30));

    @p1 =
    "#| words words words words",
    "#| words words words words",
    "#| words words";

    is-deeply @para, @p1, "line-pre-text with trailing space, max line length 30";
}

# test 11
{
    dies-ok { @para = wrap-paragraph(@text32, :max-line-length(30)) }, "line reported too long";
}

# THE FOLLOWING TEST MUST WORK FOR NEXT RELEASE
# test 12
{
    dies-ok { @para = wrap-paragraph(@text30, :max-line-length(30), :para-pre-text('def: ')) }, 
        "line exactly the max length but too long with pre-text";
}
