require 'pry'

require_relative 'jinni/version'
require_relative 'jinni/creature'
require_relative 'jinni/eigenclass'
require_relative 'jinni/numeric'
require_relative 'jinni/genepool'

class Fish < Jinni::Creature
  # attr_genetic name, min, max
  attr_genetic :pointiness, 0, 2
  attr_genetic :mass_in_kilos, 10, 100
  attr_genetic :speed_in_knots, 8, 12

  # must return a fixnum
  def fitness
     @pointiness.to_f * (@speed_in_knots.to_f / @mass_in_kilos.to_f )
  end
end

fishes = Genepool.new
100.times { fishes << Fish.random_new } # `random_new` respects min and max

newGen = fishes.generate(1000)

binding.pry

puts 'end'


