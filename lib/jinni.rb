require "jinni/version"
require 'pry'

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
        length = range.bits
        difference = length - value.bits
        difference.times { output << "0" }
        output << value.to_binary
        output
      }.join(" ")
    end

    private

    # used internally by ::new_random, a la #initialize
    def initialize_randomly(*args, &block)
      @@genes.each_pair do |gene, range|
        value = self.class.send("#{gene}_min") + rand(range)
        instance_variable_set( "@#{gene}", value )
      end
    end

    # used internally by ::new_from_binary, a la #initialize
    def initialize_from_binary(binary)
      number = binary.to_i(2)
      ranges = @@genes.keys.map{ |gene| self.class.send("#{gene}_range") }
      binding.pry
    end

    # genetic eigenclass methods
    class << self

      # use after calling all attr_genetics
      def set_schema
        total = @@genes.values.reduce( :+ )
        @@schema_total = total
      end

      # to be used like `Klass.new()`
      def random_new(*args, &block)
        obj = allocate
        obj.send(:initialize_randomly, *args, &block)
        obj
      end

      # to be used by `cross`, `Klass.new_from_binary(binary_string)`
      def new_from_binary(*args, &block)
        obj = allocate
        obj.send(:initialize_from_binary, *args, &block)
        obj
      end


      # use like attr_accessor
      def attr_genetic( gene, min, max )
        range = max - min

        @@genes[gene] = max

        # getter
        define_method(gene) do
          instance_variable_get("@"+gene.to_s)
        end

        # setter
        define_method("#{gene}=") do |value|
          raise "trying to set #{gene} outside of range" unless (min..max).cover? value
          instance_variable_set("@"+gene.to_s, value)
        end


        # Eigenclass methods for getting class genes

        # range class variable, getter
        self.class_variable_set("@@#{gene.to_s}_range", range)
        define_singleton_method("#{gene.to_s}_range") do
          self.class_variable_get("@@#{gene.to_s}_range")
        end

        # min class variable, getter
        self.class_variable_set("@@#{gene.to_s}_min", min)
        define_singleton_method("#{gene.to_s}_min") do
          self.class_variable_get("@@#{gene.to_s}_min")
        end

        # max class variable, getter
        self.class_variable_set("@@#{gene.to_s}_max", max)
        define_singleton_method("#{gene.to_s}_max") do
          self.class_variable_get("@@#{gene.to_s}_max")
        end
      end

      private

    end

  end
end


class Numeric
  def to_binary
    to_s(2)
  end

  def bits
    to_binary.length()
  end
end



class Fish < Jinni::Creature
  attr_genetic :speed, -10, 10
  attr_genetic :size, 90, 100

  set_schema
end

bill = Fish.random_new()
ted = Fish.random_new()

child = bill.cross(ted)

(child == Fish.new_from_binary(child.to_binary) )

binding.pry
