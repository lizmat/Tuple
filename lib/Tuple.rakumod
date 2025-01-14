use ValueList:ver<0.0.4+>:auth<zef:lizmat>;

class Tuple is repr('VMArray') is ValueList {
    multi method gist(Tuple:D:) { 'Tuple.new' ~ callsame }
}

proto sub tuple(|) is export is nodal {*}
multi sub tuple( @args) { Tuple.CREATE.STORE(@args,:INITIALIZE) }
multi sub tuple(+@args) { Tuple.CREATE.STORE(@args,:INITIALIZE) }

# vim: expandtab shiftwidth=4
