
module Jinni
  class Creature
    attr_reader :genes

    @@genes = Hash.new

    # redefine this method in your class
    def fitness
      0.0
    end

    # getter for list of genes
    def genes
      @@genes
    end

    # this is Where It Happens
    # usage:
    # child = bill << ted
    def cross(object)
      object # should be a cross of `self` with `object`
    end
    alias :<< :cross

    # serialize object into binary, according to schema laid out in eigenclass
    def to_binary
      @@genes.collect {|gene, range|
        output = String.new
        value = self.send(gene) - self.class.send("#{gene}_min")
        difference = range.bits - value.bits
        difference.times { output << "0" }
        output << value.to_binary
      }.join("")
    end

    private

    # used internally by ::new_random, a la #initialize
    def initialize_randomly(*args, &block)
      params = Hash.new
      @@genes.each_pair do |gene, range|
        value = self.class.send("#{gene}_min") + rand(range)
        params[gene] = value
      end
      initialize(params)
    end

    # used internally by ::new_from_binary, a la #initialize
    def initialize_from_binary(binary)
      hash = hash_from_binary(binary)
      initialize(hash)
    end

    def initialize(hash)
      puts hash
      hash.each_pair do |gene, value|
        instance_variable_set( "@#{gene}", value )
      end
    end

    def hash_from_binary(binary)
      params = Hash.new
      start = 0
      @@genes.each_pair do |gene, range|
        binary_chunk = binary[start..(start = start + range.bits - 1)]
        offset = binary_chunk.to_i(2)
        value = self.class.send("#{gene}_min") + offset
        start += 1
        params[gene] = value
      end
      puts params
      params
    end

  end
end

