# Bang! Bang!

[Website](http://rubyworks.github.com/bang) /
[Report Issue][http://github.com/rubyworks/bang/issues) /
[Mailing List][http://groups.google.com/groups/rubyworks-mailinglist) /
[Source Code][http://github.com/rubyworks/bang) /
IRC #rubyworks


## Description

Bang Bang is an assertions nomenclature built on top of the Assay
assertion framework. It is similar to MiniTest's spec expectation
methods, e.g. `#must_equal`, but uses "bang" mathods instead, such
as `#equal!`.


## Instruction

Usage is pretty straight forward.

    require 'bang'

    "This string".equal!("That string")  #=> raise EqualAssay

To use Bang Bang most effectively with common test frameworks, you may need
to load an Assay adapter to ensure the framework recognizes the assertions as
such rather than as ordinary errors.

For MiniTest use:

    require 'bang/minitest'`

For TestUnit use:

    require 'bang/testunit'

An RSpec adapter is in the works.

Cucumber does not require an adapter as it does not differntiate errors
from assertions.


## Copyrights

Bang Bang is Copyright (c) 2012 Rubyworks

You can redistribute it in accordance to the *BSD-2-Clause* license.

Please see the included COPYING.md file for license details.

