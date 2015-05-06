# Jinni [![Gem](https://img.shields.io/gem/v/jinni.svg?style=plastic)](https://rubygems.org/gems/jinni)

unconventional genetics, aggressively metaprogrammed. Pronounced like `genie`.

## Installation

Add this line to your application's Gemfile:

    gem 'jinni'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install jinni


## Quick-Start

### Make a class

    class Fish < Jinni::Creature
        # attr_genetic name, min, max
        attr_genetic :pointiness, 0, 1
        attr_genetic :mass_in_kilos, 10, 100
        attr_genetic :speed_in_knots, 8, 12

        # must return a fixnum
        def fitness
             @pointiness + (@speed_in_knots / @mass_in_kilos )
        end
    end

### Have an offspring

    bill = Fish.random_new
    ted = Fish.random_new

    child = bill << ted

### Put some creatures in a genepool

    fishes = Genepool.new
    10.times { fishes.push(Fish.random_new) } # `random_new` respects min and max

### have some more offspring

    bill = fishes[0]
    ted = fishes[1]

    child = bill << ted

### Start a whole new generation

    generation = fishes.generate(10)
    fishes << generation

### todo: something mutations something, also make it faster

## API

### creatures : instance

Jinni adds the following public instance methods to your creatures:

#### fitness()
you should override this function with something sensible for your class. It returns `0.0` by default, but any float will do.
#### genes()
genes is a getter method that returns the genetic attributes available to your instance.
#### mutate(rate = 0.01)
mutate returns a slightly mutated object. Each bit in the original dna has a `rate` chance of flipping.
#### <<(object) / cross(object)
<< is the basic method used to cross two objects. It splits the dna strands of the input objects into random chunks, and then they randomly swap.
#### to_binary()
to_binary returns the binary dna strand that represents the object.

### creatures : class

Jinni adds the following public class methods to your creature class:

#### attr_genetic(:name, min, max)
use this method in your class to declare your genetic attributes.
#### random_new()
random_new initializes an object with attributes randomly assigned from within your declared range.
#### new_from_binary()
use this method to initialize an object from an arbitrary binary string.

### numeric

Jinni also monkeypatches the following methods into Numeric:

#### to_binary()
utility method to convert a numeric into a binary string.
#### bits()
utility method to return the number of bits that the binary representation of the number requires

### genepool

Jinni creates a class, Genepool which inherits from Array. Genepool has the following instance methods:

#### generate(n, mutationRate = 0.01, quality = :fitness)
use this method to create a new generation of `n` creatures based on a genepool. it uses weighted roulette wheel selection to simulate the effects of genetic fitness, then crosses the selected objects together.
#### roulette(n, quality = :fitness)
this utility method uses weighted roulette wheel selection to choose `n` objects from your gene pool influenced by fitness. It does not cross them.
#### average(quality = :fitness)
this method returns the mean of one quality through a collection of objects. It's very useful for watching your generations increase in fitness.

## Contributing

1. Fork it ( https://github.com/amonks/jinni/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
