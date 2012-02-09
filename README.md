# Bang! Bang!

[Website](http://rubyworks.github.com/bang) /
[Report Issue](http://github.com/rubyworks/bang/issues) /
[Mailing List](http://groups.google.com/groups/rubyworks-mailinglist) /
[Source Code](http://github.com/rubyworks/bang) /
IRC #rubyworks

[![Build Status](https://secure.travis-ci.org/rubyworks/bang.png)](http://travis-ci.org/rubyworks/bang)


## Description

Bang! Bang! is an assertions framework with a very clever design that translates
any bang call, e.g. `#foo!` into an assertion based on the corresponding query
call, `#foo?` (if it exists). In practice the framework is similar to MiniTest's
spec expectation methods, e.g. `#must_equal`, but the dynamic nature of Bang!
Bang! makes it much more flexible, as it is not limited to a finite set of 
assertion methods.

It's also pretty interesting idea that bang methods are asseriton methods.
In usual Ruby code, bang methods ususually aren't particularly necessary and 
could just as well be handled by non-bang methods, e.g. `#update` vs `#merge!`.


## Instruction

Usage is pretty straight forward.

    require 'bang'

    "This string".equals!("That string")  #=> raises Bang::Assertion

To use Bang! Bang! most effectively with common test frameworks, you may need
to load an adapter to ensure the framework recognizes the assertions as
such rather than as ordinary errors.

For MiniTest use:

    require 'bang/minitest'`

For TestUnit use:

    require 'bang/testunit'

An RSpec adapter is in the works.

Cucumber does not require an adapter as it does not differntiate errors
from assertions.

Note, these adapters simply require the `brass/adapters/minitest` and
`brass/adapters/testunit` respecitvely along with `bang`. So that's another
way to do it too.


## Copyrights

Bang Bang is Copyright (c) 2012 Rubyworks

You can redistribute it in accordance to the *BSD-2-Clause* license.

Please see the included COPYING.md file for license details.

