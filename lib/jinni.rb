require "jinni/version"
require 'pry'

module Jinni
  class Creature
    attr_reader :genes

    @@genes = []

    def to_binary
      binary = String.new
      genes.each do |gene|
        binary += instance_variable_get("@#{gene.to_s}").to_i.to_s(2)
      end
      binary
    end

    def genes
      @@genes
    end

    class << self
      def attr_genetic( name, min, max )
        @@genes.push name

        define_method(name) do
          instance_variable_get("@"+name.to_s)
        end

        define_method("#{name}=") do |value|
          raise "trying to set #{name} outside of range" unless (min..max).cover? value
          instance_variable_set("@"+name.to_s, value)
        end

        define_method("#{name}_min") do
          min
        end

        define_method("#{name}_max") do
          max
        end
      end
    end

    def cross(object)
      self.to_binary + object.to_binary
    end

  end
end


class Fish < Jinni::Creature
  attr_genetic :speed, 0, 10
end

bill = Fish.new
