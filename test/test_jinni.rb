require 'minitest_helper'

class TestJinni < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Jinni::VERSION
  end

  def test_it_creates_a_new_genepool
    assert Jinni.new([ attr: :hunger, min: 0, max: 10 ])
  end

  def test_it_creates_a_new_generation
    assert Jinni.new([ attr: :hunger, min: 0, max: 10 ]).generate(objects)
  end
end
