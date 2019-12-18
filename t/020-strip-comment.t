use v6;
use Test;

use Text::Utils :ALL;

plan 32;

my (@s, @stripped);
# comment char is default '#'
@s = (
'some text',
'text # coment...',
' #comment',
'more text'
);

@stripped = (
'some text',
'text ',
' ',
'more text'
);

# return the stripped strings
for 0..^+@s -> $i {
    my $line = strip-comment(@s[$i]);
    is $line, @stripped[$i];
}

# # strip in place
# strip-comment-rw($str);
# is $line, $stripped;

# comment char is ';'
@s = (
'some text',
'text ; coment...',
' ;comment',
'more text'
);

# return the stripped strings
for 0..^+@s -> $i {
    my $line = strip-comment(@s[$i], ';');
    is $line, @stripped[$i];
}

# # embedded '#'
# my $se   = 'test \# more # comment';
# my $se-s = 'test \# more ';
# my $line = strip-comment($se);
# is $line, $se-s;

# test return of the comment
my $tstr = 'some  text # some  comment';
my ($text, $comm) = strip-comment $tstr, :save-comment;
is $text, 'some  text ';
is $comm, ' some  comment';

($text, $comm) = strip-comment $tstr, :save-comment, :normalize;
is $text, 'some text';
is $comm, 'some comment';

# test empty comment
$tstr = ' some  text ';
($text, $comm) = strip-comment $tstr, :save-comment;
is $text, ' some  text ';
is $comm, '';

($text, $comm) = strip-comment $tstr, :save-comment, :normalize;
is $text, 'some text';
is $comm, '';

# default is to take the first comment char found
# note multi-char comment char is allowed
$tstr = ' some  text %%  text %% some  comment ';
($text, $comm) = strip-comment $tstr, '%%', :save-comment;
is $text, ' some  text ';
is $comm, '  text %% some  comment ';

#===== ORIGINAL SIGNATURE IS DEPRECATED =====
# testing the original signature which is now deprecated
# and will be removed in version 3.0.0
($text, $comm) = strip-comment $tstr, '%%', :save-comment, :normalize;
is $text, 'some text';
is $comm, 'text %% some comment';

$text = strip-comment $tstr, '%%', :last;
is $text, ' some  text %%  text ';

($text, $comm) = strip-comment $tstr, '%%', :last, :save-comment;
is $text, ' some  text %%  text ';
is $comm, ' some  comment ';

($text, $comm) = strip-comment $tstr, '%%', :last, :save-comment, :normalize;
is $text, 'some text %% text';
is $comm, 'some comment';

# bad input by user
dies-ok { $text = strip-comment '#'; }, 'dies when line is same as comment char';

#===== END OF ORIGINAL SIGNATURE IS DEPRECATED =====

# test the new signature

# bad input by user
dies-ok { $text = strip-comment '%', :mark<%>; }, 'dies when line is same as comment (:mark) char';

($text, $comm) = strip-comment $tstr, :mark<%%>, :last, :save-comment, :normalize;
is $text, 'some text %% text';
is $comm, 'some comment';

# watch out for embedded newlines
my $s = q:to/HERE/;
text 1 # comment 1
text 2 # comment 2
HERE
$s = strip-comment $s;
is $s, 'text 1 ';

# how about tabs?
$tstr = " some\t text # some  comment ";
$text = strip-comment $tstr;
is $text, " some\t text ";

$text = strip-comment $tstr, :normalize;
is $text, 'some text', 'normalize a string with tabs';
