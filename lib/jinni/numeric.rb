class Numeric
  # utility method to convert a numeric into a binary string.
  def to_binary
    to_s(2)
  end

  # utility method to return the number of bits that the
  # binary representation of the number requires
  def bits
    to_binary.length()
  end
end


