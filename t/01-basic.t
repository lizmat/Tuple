use v6.c;
use Test;

use Tuple;

plan 19;

my @a is Tuple = ^10;

my @b is Tuple = ^10;
is @b.WHICH, @a.WHICH, 'are @b and @a the same value type';

my $c = tuple(^10);
is $c.WHICH, @a.WHICH, 'are $c and @a the same value type';

my $d = Tuple.new(^10);
is $d.WHICH, @a.WHICH, 'are $d and @a the same value type';

my $e = Tuple.new(@a);
is $e.WHICH, @a.WHICH, 'are $e and @a the same value type';

my $f = tuple(@a);
is $f.WHICH, @a.WHICH, 'are $f and @a the same value type';

dies-ok { @a = 4,5,6 },  'can we not re-assign to a tuple';
dies-ok { @a[0] = 42 },  'can we not assign to a tuple element';
dies-ok { @a[0] := 42 }, 'can we not bind to a tuple element';

for <
  ASSIGN-POS BIND-POS push append pop shift unshift prepend
> -> $method {
    dies-ok { @a."$method"() }, "does calling .$method die";
}

dies-ok { $_ = 42 for @a },
  'are iterated values also immutable';
dies-ok { .value = 42 for @a.pairs },
  'are iterated pairs also immutable';
dies-ok { for @a.kv -> \k, \v { v = 42 } },
  'are iterated kv also immutable';

# vim: ft=perl6 expandtab sw=4
