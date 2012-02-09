module Bang

  class Assertion < Exception
    def self.piece(s, a, b, bt)
      e = new(message(s, *a, &b))
      e.set_backtrace(bt)
      e
    end

    def self.message(s, *a, &b)
      "#{s}(%s)" % a.map{ |e| e.inspect }.join(',')
    end
  end


  module Catcher

    #
    def method_missing(s, *a, &b)
      return super(s, *a, &b) unless s.to_s.end_with?('!')

      name = s.to_s.chomp('!')
      meth = method("#{name}?") rescue nil

      return super(s, *a, &b) unless meth

      if result = meth.call(*a, &b)
        result
      else
        raise Bang::Assertion.piece(s, a, b, caller)
      end
    end

  end

end

::Bang::Catcher.__send__(:append_features, Object)

