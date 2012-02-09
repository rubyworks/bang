require 'assay'

# This module provides assertion mettods as object extensions in the
# form of bang methods.
#
# Examples
#
#   "string".instance_of!(String)
#
#   "string".equal!("string")
#
#   "string".not_equal!("another")
#
module Bang

  BANG_NAMES = {
    :kind     => :kind_of,
    :instance => :instance_of,
    :executes => :satisfy        # mabybe change this in Assay
  }

  BANG_ALIAS = {
    #:equal => [:identical]
  }

  #
  # Meta-programming routine for creating all the subjective methods.
  #
  def self.bootstrap
    Assertion.subclasses.each do |const|
      name = const.assertive_name.to_sym
      name = BANG_NAMES[name] || name

      aliases = BANG_ALIAS[name]

      [name, *aliases].each do |name|
        define_method("#{name}!") do |*args, &blk|
          const.assert!(self, *args, :backtrace=>caller, &blk)
        end

        define_method("not_#{name}!") do |*args, &blk|
          const.refute!(self, *args, :backtrace=>caller, &blk)
        end
      end
    end
  end

  #
  # Do it!
  #
  bootstrap

  #
  def thrown!(&block)
    ThrowAssay.assert!(self, :backtrace=>caller, &block)
  end

  #
  def not_thrown!(&block)
    ThrowAssay.refute!(self, :backtrace=>caller, &block)
  end

  #
  #
  def throws!(object)
    ThrowAssay.assert!(object, :backtrace=>caller, &self)
  end

  #
  module ForProc
    #
    #
    def raises!(exception)
      RaiseAssay.assert!(exception, :backtrace=>caller, &self)
    end

    #
    # @todo Better name?
    def rescues!(exception)
      RescueAssay.assert!(exception, :backtrace=>caller, &self)
    end
  end

end

class Object
  include Bang
end

class Proc
  include Bang::ForProc
end

