use Test;

my @modules = <
    Text::Utils
    Text::Utils::Classes
    Text::Utils::Subs
    Text::Utils::TaggedSubs
    Text::Utils::Vars
>;

plan @modules.elems;

for @modules -> $m {
    use-ok $m, "Module '$m' used okay";
}
