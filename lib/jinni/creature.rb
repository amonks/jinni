module Jinni
  # creature instacce methods

  class Creature
    attr_reader :genes

    # you should override this function with something sensible for your class.
    # It returns `0.0` by default, but any float will do.
    def fitness
      0.0
    end

    # genes is a getter method that returns a hash with the genetic attributes
    # available to your instance as keys, and the size of their range of values
    # as values
    def genes
      @@genes
    end

    # mutate returns a slightly mutated object. Each bit in the original dna has
    # a `rate` chance of flipping.
    def mutate(rate = 0.01)
      binary = self.to_binary
      newBinaryArray = binary.chars.map do |bit|
        if rand < rate
          bit = (bit == "0" ? "1" : "0")
        end
        bit
      end
      newBinary = newBinaryArray.join
      return self.class.new_from_binary newBinary
    end

    # << is the basic method used to cross two objects. It splits the dna strands
    # of the input objects into random chunks, and then they randomly swap.
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

      self.class.new_from_binary(binary)
    end
    alias :<< :cross

    # to_binary returns the binary dna strand that represents the given object.
    def to_binary
      self.class.genes.collect {|gene, range|
        output = String.new
        value = self.send(gene) - self.class.send("#{gene}_min")
        difference = range.bits - value.bits
        difference.times { output << "0" }
        output << value.to_binary
      }.join("")
    end

    private

    # generic initialize from hash, called by the other initializers
    def initialize(hash)
      hash.each_pair do |gene, value|
        instance_variable_set( "@#{gene}", value )
      end
    end

    # used internally by ::new_random, a la #initialize
    def initialize_randomly(*args, &block)
      params = Hash.new
      self.class.genes.each_pair do |gene, range|
        value = self.class.send("#{gene}_min") + rand(range)
        params[gene] = value
      end
      initialize(params)
    end

    # used internally by ::new_from_binary, a la #initialize
    def initialize_from_binary(binary)
      # correct for broken method somewhere that sends array instead of string
      binary = binary.join if binary.class == Array

      raise "no binary string!!" unless binary.to_i(2) > 0
      until binary.length >= self.class.genetic_bits
        binary << binary
      end

      hash = hash_from_binary(binary)
      initialize(hash)
    end

    # method to return a creature attributes hash from a given binary string
    def hash_from_binary(binary)
      params = Hash.new
      start = 0
      self.class.genes.each_pair do |gene, range|
        binary_chunk = binary[start..(start = start + range.bits - 1)]
        break if binary_chunk.class != String
        offset = binary_chunk.to_i(2)
        value = self.class.send("#{gene}_min") + offset
        start += 1
        params[gene] = value
      end
      params
    end

  end
end

