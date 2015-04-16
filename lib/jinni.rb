require 'pry'

require 'jinni/version'
require 'jinni/creature'
require 'jinni/eigenclass'
require 'jinni/numeric'





class Fish < Jinni::Creature
  attr_genetic :hunger, -10, 10
  attr_genetic :speed, 1, 100
  attr_genetic :size, 90, 100
  attr_genetic :pointiness, 50, 100

  set_schema
end

bill = Fish.random_new()
ted = Fish.random_new()

child = bill.cross(ted)

binding.pry
