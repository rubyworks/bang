# Bangers

    require 'bang'

## true!

    true.true!

    expect Bang::Assertion do
      false.true!
    end

    false.not_true!

## false!

    false.false!

    expect Bang::Assertion do
      true.false!
    end

    true.not_false!

## nil!

    nil.nil!

    expect Bang::Assertion do
      true.nil!
    end

    true.not_nil!

## equal!

    1.equal!(1)

    expect Bang::Assertion do
      1.equal!(2)
    end

    1.not_equal!(2)

## eql!

    1.eql!(1)

    expect Bang::Assertion do
      1.eql!(1.0)
    end

    1.not_eql!(1.0)

## identical!

Ruby's built-in query method for this is `#equal?`, but obviously that conflicts
with our use of `#equal!` to test quality using `###`. So instead we use `#identical!`
which makes more sense really.

    :a.identical!(:a)

    expect Bang::Assertion do
      "a".identical!("a")
    end

    :a.not_identical!('a')

## instance_of!

    1.instance_of!(Fixnum)

    expect Bang::Assertion do
      1.instance_of!(String)
    end

    1.not_instance_of!(String)

## kind_of!

    1.kind_of!(Integer)

    expect Bang::Assertion do
      1.kind_of!(String)
    end

    1.not_kind_of!(String)

## within!

    1.within!(2, 1.5)

    expect Bang::Assertion do
      1.within!(2, 0.5)
    end

    1.not_within!(2, 0.5)

## close!

    1.close!(2, 1.5)

    expect Bang::Assertion do
      1.close!(1.2, 0.5)
    end

    1.not_close!(5, 0.5)

## match!

    "abc".match!(/a/)

    expect Bang::Assertion do
      "abc".match!(/x/)
    end

    "abc".not_match!(/g/)

## respond_to!

    "string".respond_to!(:upcase)

    expect Bang::Assertion do
      "string".respond_to!(:not_a_method)
    end

    "string".not_respond_to!(:not_a_method)

## satisfy!

    5.satisfy!{ |x| x > 3 }

    expect Bang::Assertion do
      5.satisfy!{ |x| x < 3 }
    end

    5.not_satisfy!{ |x| x < 3 }

## raises!

    ::ArgumentError.raised!{ raise ::ArgumentError }

An extension to Proc class can also be used.

    procedure = lambda{ raise ::ArgumentError }

    procedure.raises!(::ArgumentError)

    expect Bang::Assertion do
      procedure.raises!(::TypeError)
    end

## rescues!

    ::TypeError.rescued!{ raise ::TypeError }

An extension to Proc class can also be used.

    procedure = lambda{ raise ::TypeError }

    procedure.rescues!(::StandardError)

    expect Bang::Assertion do
      procedure.rescues!(::IOError)
    end

## throws!

    :foo.thrown!{ throw :foo }

An extension to Proc class can also be used.

    procedure = lambda{ throw :foo }

    procedure.throws!(:foo)

    expect Bang::Assertion do
      procedure.throws!(:bar)
    end

