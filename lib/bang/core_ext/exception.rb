class Exception

  #
  def raised? #:yield:
    begin
      yield
      false
    rescue self
      true
    end
  end

  def raised!
    RaiseAssay.assert(
    begin
      yield
      raise RaiseAssay, RaiseAssay.message(self)
    rescue self
    end
  end

end
