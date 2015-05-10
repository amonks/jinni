module Jinni
  class Creature

    def self.inherited(subclass)
      subclass.class_variable_set("@@genes", Hash.new)
      # create a class variable called @@genes in subclass
      # create getter and setter methods for @@genes
    end

    # creature class methods
    class << self
      # # use after calling all attr_genetics
      # def set_schema
      #   total = @@genes.values.reduce( :+ )
      #   @@schema_total = total
      # end

      # random_new initializes an object with attributes randomly
      # assigned from within your declared range.
      def new_randomly(*args, &block)
        obj = allocate
        obj.send(:initialize_randomly, *args, &block)
        obj
      end
      alias :random_new :new_randomly

      # use this method to initialize an object from an arbitrary binary string.
      # it's used internally by the cross method.
      def new_from_binary(*args, &block)
        obj = allocate
        obj.send(:initialize_from_binary, *args, &block)
        obj
      end

      # genes class variable getter
      def genes
        class_variable_get "@@genes"
      end

      # genes class variable setter
      def genes= genes
        class_variable_set "@@genes", genes
      end

      # returns required length of a binary string to generate a creature of this class
      def genetic_bits
        genes.values.map {|range| range.bits}.reduce(:+)
      end


      # use this method in your class to declare your genetic attributes.
      # use it how you would attr_accessor
      def attr_genetic( gene, min, max )
        range = max - min + 1

        # update @@genes within (Fish)
        self.genes[gene] = range

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
