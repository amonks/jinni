require_relative 'minitest_helper'

class TestJinni < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Jinni::VERSION
  end

  def test_it_can_be_loaded_into_a_class
    require_relative 'creatures/fish'
    require_relative 'creatures/building'
  end

  def test_it_creates_random_members_of_a_class_with_attributes_which_are_in_range
    require_relative 'creatures/fish'
    jane = Fish.random_new
    Fish.genes.each_key do |gene|
      range = ( Fish.send("#{gene}_min") .. Fish.send("#{gene}_max") )
      assert range === jane.send(gene)
    end
  end

  def test_it_creates_random_members_of_a_class_correctly
    require_relative 'creatures/fish'
    bill = Fish.random_new
    ted = Fish.random_new
    assert bill != ted
    assert bill.class == Fish
    assert ted.class == Fish
  end

  def test_it_creates_a_random_member_of_a_class_with_negative_attribute_minima
    require_relative 'creatures/building'
    house = Building.random_new
  end

  def test_it_crosses_two_random_members_of_a_class_correctly
    require_relative 'creatures/fish'
    bill = Fish.random_new
    ted = Fish.random_new
    assert (bill << ted).class == Fish
  end

  def test_it_can_generate_new_generations_from_a_genepool_correctly
    genepool = create_and_fill_genepool(:building, 100)
    generation = genepool.generate(100)

    assert generation.class == Jinni::Genepool
    generation.each do |creature|
      assert creature.class == Building
    end
  end

  def test_it_can_find_the_average_fitness_of_a_genepool
    genepool = create_and_fill_genepool(:building, 100)
    assert genepool.average(:x_coord)
    assert genepool.average
  end

  def test_fitness_usually_improves_between_generations
    genepool_fitness = 0
    evolved_fitness = 0
    10.times do
      genepool = create_and_fill_genepool(:building, 100)
      evolved = genepool.generate(100)


      genepool_fitness += genepool.average
      evolved_fitness += evolved.average
    end
    assert evolved_fitness > genepool_fitness
  end

  def test_it_can_create_a_creature_from_any_random_binary_string
    require_relative "creatures/fish"
    require_relative "creatures/building"

    100.times do |t|
      string = "1"
      t.times do |l|
        string << rand.to_s
      end
      newFish = Fish.new_from_binary string
      newBuilding = Building.new_from_binary string
      assert newFish.class == Fish
      assert newBuilding.class == Building
      assert newFish.fitness, "the new fish should have a fitness"
      assert newBuilding.fitness, "the new building should have a fitness"
    end
  end

  def test_it_can_mutate_a_creature_correctly
    require_relative 'creatures/fish'

    bill = Fish.random_new
    ted = bill.mutate(1)
    assert ted.class == Fish
    assert ted != bill
    assert ted.scales != bill.scales
    assert ted.fins != bill.fins
    assert ted.weight != bill.weight
  end


  private

  def create_and_fill_genepool(creature, number)
    require_relative "creatures/#{creature.to_s}"
    genepool = Jinni::Genepool.new
    number.times do
      klass = Kernel.const_get creature.to_s.capitalize
      genepool << klass.random_new
    end
    genepool
  end
end
