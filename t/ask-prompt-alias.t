use v6;
use Test;
use Temp::Path;

use Text::Utils;

# Tests for constant &ask = &prompt

my @tests = () => "", 'a' => "a", 42 => "42", [<a b c>] => "a b c",
    [<a b>, (42, (3, 5))] => "a b 42 3 5",
    class { method Str { "pass" } }.new => "pass";

plan 3*@tests;

{
    for @tests -> (:key($ask), :value($out)) {
        subtest "default handle attributes" => {
            plan 2;

            my $file-in  = make-temp-path :content("foobar\nbarbar\nberbar");
            my $file-out = make-temp-path;

            temp $*OUT = $file-out.open: :w;
            temp $*IN  = $file-in.open;
            is-deeply ask($ask<>), 'foobar', 'return value';
            $*OUT.close; $*IN.close;
            is-deeply $file-out.slurp, $out, 'printed content';
        }

        subtest "changed handle attributes" => {
            plan 2;

            my $file-in  = make-temp-path :content("foobar\nbarbar\nberbar");
            my $file-out = make-temp-path;

            temp $*OUT = $file-out.open: :w, :nl-out<MEOW>;
            temp $*IN  = $file-in.open: :!chomp, :nl-in<oba>;
            is-deeply ask($ask<>), 'fooba', 'return value';
            $*OUT.close; $*IN.close;
            is-deeply $file-out.slurp, $out, 'printed content';
        }

        subtest "no-arg ask" => {
            plan 1;
            temp $*OUT = class :: is IO::Handle {
                method opened   { True }
                method print    { die "Method must not be called" }
                method print-nl { die "Method must not be called" }
                method say      { die "Method must not be called" }
                method put      { die "Method must not be called" }
                method printf   { die "Method must not be called" }
            }.new;

            my $file-in = make-temp-path :content("foobar\nbarbar\nberbar");

            temp $*IN   = $file-in.open: :nl-in<oba>;
            is-deeply ask(), 'fo', 'return value';
            $*IN.close;
        }
    }
}
