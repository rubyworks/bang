module Enumerable

  #
  def include!(member)
    raise IncludeAssay.exception(self, member) unless include?(member)
  end

end

