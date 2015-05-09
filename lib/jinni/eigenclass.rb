module Jinni
  class Creature
    # creature class methods
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
        range = max - min + 1

        @@genes[gene] = range

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
