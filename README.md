# Jinni

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'jinni'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install jinni

## Usage

### have some objects

    class Fish < Jinni::Creature
        attr_genetic :hunger 0 10
        attr_genetic :speed 0 10

        def initialize
            @hunger = random(10)
            @speed = random(10)
        end

        def fitness
            @hunger + @speed / 2.0
        end
    end

    fishes = []
    10.times { fishes.push(Fish.new) }

### set up a genepool

    genepool = Jinni.new(fishes)

### Start a new generation

    baby = genepool.generate(fishes)
    fishes.push(baby)


## Development


## Contributing

1. Fork it ( https://github.com/amonks/jinni/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
