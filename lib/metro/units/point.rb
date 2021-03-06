module Metro
  module Units

    #
    # Represents and object that contains the x, y, and z position.
    #
    class Point < Struct.new(:x,:y,:z)
      include CalculationValidations

      #
      # Generate a point at 0,0,0.
      #
      def self.zero
        new 0.0, 0.0, 0.0
      end

      #
      # An alternate way of creating a point. Creation here converts
      # all inputs to floating point and assumes that the z-value is
      # zero (as this is a 2D universe).
      #
      def self.at(x=0.0,y=0.0,z=0.0)
        new x.to_f, y.to_f, z.to_f
      end

      #
      # Parse a string representation of a point object. The
      # supported formated is a comma-delimited string that contains
      # either "x,y" or "x,y,z".
      #
      def self.parse(string)
        at *string.to_s.split(",",3).map(&:to_f)
      end

      # As this is a 2D world, the Z is often refered to as a the z-ordering
      alias_method :z_order, :z
      alias_method :z_order=, :z=

      def to_s
        "#{x},#{y},#{z}"
      end

      #
      # Add this point to another another point-like structure. A point like structure
      # is anything has the methods x, y, and z.
      #
      # @return a new point which is the sum of the point and the provided value.
      #
      def +(value)
        self.class.at *calculate(value,:+)
      end

      #
      # Subtract the point-like structure from this point. A point like structure
      # is anything has the methods x, y, and z.
      #
      # @return a new point which is the difference of the point and the
      #   provided value.
      #
      def -(value)
        self.class.at *calculate(value,:-)
      end

      private

      def calculation_requirements
        [ :x, :y, :z ]
      end

    end
  end
end