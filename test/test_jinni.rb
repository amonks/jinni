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

  def test_it_creates_random_members_of_a_class_which_are_different
    require_relative 'creatures/fish'
    bill = Fish.random_new
    ted = Fish.random_new
    assert bill != ted
  end

  def test_it_creates_a_random_member_of_a_class_with_negative_attribute_minima
    require_relative 'creatures/building'
    house = Building.random_new
  end

  def test_it_crosses_two_random_members_of_a_class_without_errors
    require_relative 'creatures/fish'
    bill = Fish.random_new
    ted = Fish.random_new
    bill << ted
  end

end
