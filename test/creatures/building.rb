class Building < Jinni::Creature
  attr_genetic :floors, 1, 5
  attr_genetic :x_coord, -100, 100
  attr_genetic :y_coord, -100, 100
  attr_genetic :dealbreaker, 0, 3

  def distance(x, y)
    Math.sqrt( (@x_coord - x) ** 2 + (@y_coord - y) ** 2 )
  end

  def fitness
    @dealbreaker == 0 ? 0 : distance(0, 0)
  end

end

