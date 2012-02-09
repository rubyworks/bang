module Kernel

  def identical?(other)
    other.object_id == object_id
  end

  #
  def identical!(other)
    raise IdentityAssay.exception(self, other) unless identical?(other)
  end

  #
  def equal!(other)
    raise IdentityAssay.exception(self, other) unless equal?(other)
  end

  #
  def eql!(other)
    raise SameAssay.exception(self, other) unless eql?(other)
  end

  #
  #def == ?
  #end

  #
  def like?(other)
    # TODO
  end

  #
  def like!(other)
    raise LikeAssay.exception(self, type) unless like?(other)
  end

  #
  def case?(other)
    other === self
  end

  #
  def case!(other)
    raise CaseAssay.exception(self, other) unless case?(other)
  end

  #
  def match?(other)
    other =~ self
  end

  #
  def match!(other)
    raise MatchAssay.exception(self, other) unless match?(other)
  end

  #
  def instance_of!(type)
    raise InstanceAssay.exception(self, type) unless instance_of?(type)
  end

  #
  def kind_of!(type)
    raise KindAssay.exception(self, type) unless kind_of?(type)
  end

  #
  def true?
    TrueClass === self
  end

  #
  def true!
    raise TrueAssay.exception(self) unless true?
  end

  #
  def false?
    FalseClass === self
  end

  #
  def false!
    raise FalseAssay.exception(self) unless true?
  end

  #
  def nil?
    NilClass === self
  end

  #
  def nil!
    raise NilAssay.exception(self) unless true?
  end

end
