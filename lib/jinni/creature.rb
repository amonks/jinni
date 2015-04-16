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
      binary_one = self.to_binary
      binary_two = object.to_binary

      raise "uh oh" if binary_one.length != binary_two.length

      crossover_point = rand(binary_one.length)

      output_one = binary_one[0..crossover_point - 1] << binary_two[crossover_point..-1]
      output_two = binary_two[0..crossover_point - 1] << binary_one[crossover_point..-1]

      binary = rand(1) == 1 ? output_one : output_two

      Fish.new_from_binary(binary)
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

    # generic initialize from hash, called by the others
    def initialize(hash)
      puts hash
      hash.each_pair do |gene, value|
        instance_variable_set( "@#{gene}", value )
      end
    end

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

