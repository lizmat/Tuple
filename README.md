[![Actions Status](https://github.com/lizmat/Tuple/actions/workflows/linux.yml/badge.svg)](https://github.com/lizmat/Tuple/actions) [![Actions Status](https://github.com/lizmat/Tuple/actions/workflows/macos.yml/badge.svg)](https://github.com/lizmat/Tuple/actions) [![Actions Status](https://github.com/lizmat/Tuple/actions/workflows/windows.yml/badge.svg)](https://github.com/lizmat/Tuple/actions)

NAME
====

Tuple - provide an immutable List value type

SYNOPSIS
========

```raku
use Tuple;

my @a is Tuple = ^10;  # initialization follows single-argument semantics
my @b is Tuple = ^10;

set( @a, @b );  # elems == 1

my $t = tuple(^10);  # also exports a "tuple" sub
```

DESCRIPTION
===========

Raku provides a semi-immutable `Positional` datatype: List. A `List` can not have any elements added or removed from it. However, since a list **can** contain containers of which the value can be changed, it is not a value type. So you cannot use Lists in data structures such as `Set`s, because each List is considered to be different from any other List, because they are not value types.

Since Lists are used very heavily internally with the current semantics, it is a daunting task to make them truly immutable value types. Hence the introduction of the `Tuple` data type.

IMPLEMENTATION NOTES
====================

In newer versions of Raku and the `Tuple` class, this class is now simply a child of the `ValueList` class (either supplied by the core or by the `ValueList` module).

AUTHOR
======

Elizabeth Mattijsen <liz@raku.rocks>

Source can be located at: https://github.com/lizmat/Tuple . Comments and Pull Requests are welcome.

COPYRIGHT AND LICENSE
=====================

Copyright 2018, 2020, 2021, 2022, 2024, 2025 Elizabeth Mattijsen

This library is free software; you can redistribute it and/or modify it under the Artistic License 2.0.

