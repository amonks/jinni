class Numeric
  def to_binary
    to_s(2)
  end

  def bits
    to_binary.length()
  end
end


