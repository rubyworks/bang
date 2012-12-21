# Bang! Bang!

[Website](http://rubyworks.github.com/bang) /
[Report Issue](http://github.com/rubyworks/bang/issues) /
[Source Code](http://github.com/rubyworks/bang)
( [![Build Status](https://secure.travis-ci.org/rubyworks/bang.png)](http://travis-ci.org/rubyworks/bang) )

<br/>

Bang! Bang! is a [BRASS](http://rubyworks.github.com/brass) compliant assertions
framework with a very clever design that translates any bang call, e.g. `#foo!`
into an assertion based on the corresponding query call if it exists (e.g. `#foo?`).
In practice the framework is similar to MiniTest's spec methods,
e.g. `#must_equal`, but the dynamic nature of Bang! Bang! makes it much more 
flexible, as it is not limited to a finite set of assertion methods.

It's also pretty interesting idea that bang methods would be assertion methods.
In general practice bang methods are usually used for methods that change the
state of an object *in-place*. But this isn't particularly necessary and 
is just as well handled by non-bang methods, e.g. `#update` vs `#merge!`.


## Instructions

Usage is pretty straight forward.

```ruby
    require 'bang'

    "This string".equals!("That string")  #=> raises Bang::Assertion
```

To use Bang! Bang! most effectively with common test frameworks, you may need
to load an adapter to ensure the framework recognizes the assertions as
such rather than as ordinary errors.

For MiniTest use:

```ruby
    require 'bang/minitest'`
```

For TestUnit use:

```ruby
    require 'bang/testunit'
```

An RSpec adapter is in the works.

Cucumber does not require an adapter as it does not differentiate errors
from assertions.

Note, these adapters simply require the `brass/adapters/minitest` and
`brass/adapters/testunit` respectively along with `bang`. So that's another
way to do it too.


## On Robustness

Bang! Bang! works via a set of core extensions. There may be some concern
about this approach for a test framework. I can assure you that the fear
of the inaptly named "monkey patch" is very much overwrought.

Even though Bang! Bang! adds a `#method_missing` call to the Object class, it is
almost always okay to use because it does not get called if an object already has
a bang method defined for it's own use. And when it does get called it only applies
if a corresponding query (e.g. `foo?`) method exists.

The other core extensions it adds are simply convenience methods that make testing
easier. Because these are only additions and not overrides, it is perfectly safe to
use in all but the most esoteric cases (such a heavy meta-programming). In fact, if
a program doesn't work because of these core extensions, that's usually a good 
indication that something isn't being done right in the program itself.


## Copyrights

Bang Bang is copyrighted open source software.

    Copyright (c) 2012 Rubyworks

You can redistribute it in accordance to the [BSD-2-Clause](http://spdx.org/licenses/BSD-2-Clause) license.

See the included LICENSE.txt file for details.
