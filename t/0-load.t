use Test;

my @modules = <
    Text::Utils
    Text::Utils::Classes
    Text::Utils::Subs
    Text::Utils::Vars
    Text::Utils::Str2IntList
>;

plan @modules.elems;

for @modules -> $m {
    use-ok $m, "Module '$m' used okay";
}
