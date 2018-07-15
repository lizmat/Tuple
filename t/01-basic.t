use v6.c;
use Test;

use Tuple;

plan 14;

my @a is Tuple = ^10;

my @b is Tuple = ^10;
is @b.WHICH, @a.WHICH, 'are @b and @a the same value type';

my $c = tuple(^10);
is $c.WHICH, @a.WHICH, 'are $c and @a the same value type';

my $d = Tuple.new(^10);
is $d.WHICH, @a.WHICH, 'are $d and @a the same value type';

dies-ok { @a = 4,5,6 },  'can we not re-assign to a tuple';
dies-ok { @a[0] = 42 },  'can we not assign to a tuple element';
dies-ok { @a[0] := 42 }, 'can we not bind to a tuple element';

for <
  ASSIGN-POS BIND-POS push append pop shift unshift prepend
> -> $method {
    dies-ok { @a."$method"() }, "does calling .$method die";
}

# vim: ft=perl6 expandtab sw=4
