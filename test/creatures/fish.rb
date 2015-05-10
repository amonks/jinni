class Fish < Jinni::Creature
  attr_genetic :scales, 10, 100
  attr_genetic :fins, 1, 3
  attr_genetic :weight, 1, 20

  def fitness
    @weight + @fins
  end
end
