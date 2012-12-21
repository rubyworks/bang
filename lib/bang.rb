module Bang

  # Bang has brass balls.
  require 'brass'

  #
  # If constant is missing check for value in project metadata.
  # e.g. `Bang::VERSION`.
  #
  def self.const_missing(const_name)
    index[const_name.to_s.downcase] || super(const_name)
  end

  #
  # Access project metadata.
  #
  def self.index
    @index ||= (
      require 'yaml'
      YAML.load_file(File.dirname(__FILE__) + '/bang.yml')
    )
  end

  # Bang's assertion class. Follows standard set by BRASS project,
  # defining `#assertion?` method which return `true`.
  #
  class Assertion < ::Exception

    #
    # Piece together an Assetion error give the message used to 
    # cause the assertion failure.
    #
    # @return [Assertion] Assertion instance.
    #
    def self.piece(s, a, b, t)
      e = new(message(s, *a, &b))
      e.set_backtrace(t)
      e
    end

    #
    # Put together an error message representive of the assertion made.
    #
    # @todo Imporve this to better handle operators.
    #
    # @return [String] Failed assertion message.
    #
    def self.message(s, *a, &b)
      "#{s}(%s)" % a.map{ |e| e.inspect }.join(',')
    end

    #
    # Bang::Assertion is alwasy an assertion.
    #
    # @return [true] Always true.
    #
    def assertion?
      true
    end
  end

  # Mixin of Object class, will take any undefined bang method, e.g. `foo!`
  # and if there is a corresponding query method, e.g. `foo?`, then it will
  # utilize the query method to make an assertion.
  #
  module MethodMissing

    #
    # If missing method is a bang method, see if there is a corresponding query
    # method and use that to make an assertion. Will also recognize the same
    # prefixed by `not_`, e.g. `not_equal_to?`.
    #
    def method_missing(s, *a, &b)
      return super(s, *a, &b) unless s.to_s.end_with?('!')

      neg  = false
      name = s.to_s.chomp('!')

      if name.start_with?('not_')
        neg  = true
        name = name[4..-1]
      end

      meth = method("#{name}?") rescue nil

      return super(s, *a, &b) unless meth

      result = meth.call(*a, &b)

      if neg
        refute(result, Bang::Assertion.piece(s, a, b, caller))
      else
        assert(result, Bang::Assertion.piece(s, a, b, caller))
      end
    end

  end

  # Mixin for Object class that adds some very useful query methods.
  #
  module ObjectMixin

    #
    # Is `self` identical with `other`? In other words, do two variables
    # reference the one and the same object.
    #
    # @return [true,false] Whether `self` is identical to `other`.
    #
    def identical?(other)
      other.object_id == object_id
    end

    #
    # Query method for `#==`. We have to use the `_to` suffix becuase Ruby
    # already defines the prepositionless term as a synonym for `#identical?`.
    # (Hopefully that will change one day.)
    #
    # @return [true,false] Whether `self` is equal to `other`.
    #
    def equal_to?(other)
      other == self
    end

    #
    # Until we can use `#equal?`, lets make the best of it and offer
    # the plural form as well.
    #
    alias :equals? :equal_to?

    #
    # Test whether `self` is like `other`. Like is broad equality
    # measure testing `identical?`, `eql?`, `==` and `===`.
    #
    # @todo Should `like?` this include `=~` also?
    #
    # @return [true,false] Whether `self` is like `other`.
    #
    def like?(other)
      other.identical?(self) ||
      other.eql?(self)       ||
      other.==(self)         ||
      other.===(self)
    end

    #
    # Test whether `other` is a case of `self` via `#===` method.
    #
    # @return [true,false] Whether `other` is a case of `self`.
    #
    def case?(other)
      other === self
    end

    #
    # Test whether `self` matches `other` via `#=~` method.
    #
    # @return [true,false] Whether `self` matches `other`.
    #
    def match?(other)
      other =~ self
    end

    #
    # Test whether `self` is the `true` instance.
    #
    # @return [true,false] Whether `self` is `true`.
    #
    def true?
      TrueClass === self
    end

    #
    # Test whether `self` is the `false` instance.
    #
    # @return [true,false] Whether `self` is `false`.
    #
    def false?
      FalseClass === self
    end

    #
    # Yield the given block and return `true` if the `self` is throw,
    # otherwise `false`.
    #
    # @return [true,false] Whether `self` was thrown.
    #
    def thrown?(&block)
      pass = true
      catch(self) do
        begin
          yield
        rescue ArgumentError => err     # 1.9 exception
          #msg += ", not #{err.message.split(/ /).last}"
        rescue NameError => err         # 1.8 exception
          #msg += ", not #{err.name.inspect}"
        end
        pass = false
      end
      pass
    end

    #
    # Yield block and return true if it runs without exception and does not
    # return `nil` or `false`.
    #
    # @return [true,false] True if block succeeds, otherwise false.
    #
    def satisfy?(&block)
      begin
        block.call(self)
      rescue
        false
      end
    end

  end

  # Mixin for Numeric class that adds `#within?` and `#close?`.
  #
  module NumericMixin

    #
    # Is this value within a given absolute `delta` of another?
    #
    # @return [true,false] True if within absolute delta, otherwise false.
    #
    def within?(other, delta)
      a, b, d = self.to_f, other.to_f, delta.to_f

      (b - d) <= a && (b + d) >= a   
    end

    #
    # Is this value within a given relative `epsilon` of another?
    #
    # @return [true,false] True if within relative epsilon, otherwise false.
    #
    def close?(other, epsilon)
      a, b, e = self.to_f, other.to_f, epsilon.to_f

      d = b * e

      (b - d) <= a && (b + d) >= a
    end

  end

  # Mixin for Proc class that adds `#raises?`, `#rescues?` and `#throws?`.
  #
  module ProcMixin

    #
    # Execute this procedure and return `true` if the specific given `exception`
    # is raised, otherwise `false`.
    #
    # @return [true,false] Whether exception was raised.
    #
    def raises?(exception)
      begin
        call
        false
      rescue exception => err
        exception == err.class
      rescue Exception => err
        false
      end
    end

    #
    # Execute this procedure and return `true` if the given `exception`,
    # or subclass there-of is raised, otherwise `false`.
    #
    # @return [true,false] Whether exception was rescued.
    #
    def rescues?(exception)
      begin
        call
        false
      rescue exception => err
        true
      rescue Exception => err
        false
      end
    end

    #
    # Execute this procedure and return `true` if the given `object`,
    # is thrown, otherwise `false`.
    #
    # @return [true,false] Whether object was thrown.
    #
    def throws?(object)
      pass = true
      catch(object) do
        begin
          call
        rescue ArgumentError => err     # 1.9 exception
          #msg += ", not #{err.message.split(/ /).last}"
        rescue NameError => err         # 1.8 exception
          #msg += ", not #{err.name.inspect}"
        end
        pass = false
      end
      pass
    end

  end

  # Class-level extension for Exception class that adds `#raised?` and `#rescued?`.
  #
  module ExceptionMixin

    #
    # Yield a given block and return `true` if this exception specifically
    # is raised, otherwise `false`.
    #
    # @return [true,false] Whether exception is raised.
    #
    def raised? #:yield:
      begin
        yield
        false
      rescue self => err
        self == err.class
      rescue Exception
        false
      end
    end

    #
    # Yield a given block and return `true` if this exception, or a sub-class
    # there-of is raised, otherwise `false`.
    #
    # @return [true,false] Whether exception is rescued.
    #
    def rescued? #:yield:
      begin
        yield
        false
      rescue self
        true
      rescue Exception
        false
      end
    end

  end

end

class Object
  include Bang::MethodMissing
  include Bang::ObjectMixin
end

class Proc
  include Bang::ProcMixin
end

class Numeric
  include Bang::NumericMixin
end

class Exception
  extend Bang::ExceptionMixin
end

