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

    fishes = Jinni::Genepool.new
    10.times { fishes.push(Fish.random_new) } # `random_new` respects min and max

### have some more offspring

    bill = fishes[0]
    ted = fishes[1]

    child = bill << ted

### Start a whole new generation

    generation = fishes.generate(10)
    fishes << generation

## API

See the API documentation over on [rubydoc](http://www.rubydoc.info/gems/jinni/)

## Contributing

1. Fork it ( https://github.com/amonks/jinni/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
