use v6.c;

# Since this module is intended to be part of the Rakudo core in the
# foreseeable future, it is implemented how a core module would be
# implemented, namely freely using nqp:: ops when they seem to be
# necessary for optimal performance (as of 2016.07).
use nqp;

class Tuple:ver<0.0.4>:auth<cpan:ELIZABETH>
  is IterationBuffer   # get some low level functionality for free
  does Positional      # so we can bind into arrays
  does Iterable        # so it iterates automagically
  is repr('VMArray')   # needed to get nqp:: ops to work on self
{

    method WHICH(Tuple:) {
        nqp::box_s(
          nqp::concat(
            nqp::if(
              nqp::eqaddr(self.WHAT,Tuple),
              'Tuple|',
              nqp::concat(self.^name,'|')
            ),
            nqp::sha1(
              nqp::join(
                '|',
                nqp::stmts(  # cannot use native str arrays early in setting
                  (my $strings  := nqp::list_s),
                  (my int $i     = -1),
                  (my int $elems = nqp::elems(self)),
                  nqp::while(
                    nqp::islt_i(($i = nqp::add_i($i,1)),$elems),
                    nqp::push_s($strings,nqp::atpos(self,$i).Str)
                  ),
                  $strings
                )
              )
            )
          ),
          ValueObjAt
        )
    }

    proto method new(|) {*}
    multi method new(Tuple: @args) {
        nqp::create(self)!SET-SELF: @args.iterator
    }
    multi method new(Tuple: +@args) {
        nqp::create(self)!SET-SELF: @args.iterator
    }
    method STORE(Tuple: \to_store, :$initialize) {
        nqp::if(
          $initialize,
          self!SET-SELF(to_store.iterator),
          X::Assignment::RO.new(value => self).throw
        )
    }

    method !SET-SELF(\iterator) {
        nqp::stmts(
          nqp::until(
            nqp::eqaddr((my $pulled := iterator.pull-one),IterationEnd),
            nqp::push(self, nqp::decont($pulled))
          ),
          self
        )
    }

    class Iterate does Iterator {
        has Tuple $!tuple;
        has int $!i;
        has int $!elems;

        method !SET-SELF(\tuple) {
            $!tuple := tuple;
            $!i      = -1;
            $!elems  = nqp::elems(tuple);
            self
        }
        method new(\tuple) { nqp::create(self)!SET-SELF(tuple) }

        method pull-one() is raw {
            nqp::if(
              nqp::islt_i(($!i = nqp::add_i($!i,1)),$!elems),
              nqp::atpos($!tuple,$!i),
              IterationEnd
            )
        }
    }
    method iterator(Tuple:D:) { Iterate.new(self) }

    multi method perl(Tuple:D:) {
        'tuple'
          ~ nqp::p6bindattrinvres(nqp::create(List),List,'$!reified',self).perl
    }

    # methods that are not allowed on immutable things
    BEGIN for <
      ASSIGN-POS BIND-POS push append pop shift unshift prepend
    > -> $method {
        Tuple.^add_method: $method, method (Tuple:D: |) {
            X::Immutable.new(:$method, typename => self.^name).throw
        }
    }
}

proto sub tuple(|) is export is nodal {*}
multi sub tuple( @args) { nqp::create(Tuple).STORE(@args,:initialize) }
multi sub tuple(+@args) { nqp::create(Tuple).STORE(@args,:initialize) }

=begin pod

=head1 NAME

Tuple - provide an immutable List value type

=head1 SYNOPSIS

    use Tuple;
 
    my @a is Tuple = ^10;  # initialization follows single-argument semantics
    my @b is Tuple = ^10;

    set( @a, @b );  # elems == 1

    my $t = tuple(^10);  # also exports a "tuple" sub

=head1 DESCRIPTION

Perl 6 provides a semi-immutable Positional datatype: List.  A C<List> can
not have any elements added or removed from it.  However, since a list B<can>
contain containers of which the value can be changed, it is not a value type.
So you cannot use Lists in data structures such as C<Set>s, because each List
is considered to be different from any other List, because they are not value
types.

Since Lists are used very heavily internally with the current semantics, it
is a daunting task to make them truly immutable value types.  Hence the
introduction of the C<Tuple> data type.

=head1 AUTHOR

Elizabeth Mattijsen <liz@wenzperl.nl>

Source can be located at: https://github.com/lizmat/Tuple .
Comments and Pull Requests are welcome.

=head1 COPYRIGHT AND LICENSE

Copyright 2018 Elizabeth Mattijsen

This library is free software; you can redistribute it and/or modify it under the Artistic License 2.0.

=end pod

# vim: ft=perl6 expandtab sw=4
