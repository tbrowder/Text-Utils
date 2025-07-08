use Test;

my @modules = <
    Text::Utils
    Text::Utils::Subs
>;

plan @modules.elems;

for @modules -> $m {
    use-ok $m, "Module '$m' used okay";
}
