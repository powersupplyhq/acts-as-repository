module ActsAsRepository
  class TypeCaster
    def initialize(value)
      @value = value
    end

    def value_to_primitive_type(type)
      case type.to_s
      when "String"
        if @value.respond_to?(:to_s)
          @value.to_s
        else
          raise ActsAsRepository::TypeCastError.new("cant cast an instance of #{@value.class} to #{type}")
        end
      when "Integer"
        @value.to_i
      when "BigDecimal"
        to_big_decimal
      when "Boolean"
        to_boolean
      else
        raise ActsAsRepository::UnknownTypeError.new("don't know primitive type: #{type}")
      end
    end

    def to_big_decimal
      return @value if @value.is_a?(BigDecimal)

      if @value.is_a?(String)
        BigDecimal.new(@value.gsub(/[^\d,\.]/, ''))
      else
        raise ActsAsRepository::TypeCastError.new("can't cast #{@value} to a BigDecimal")
      end
    end

    def to_boolean
      return @value if @value.is_a?(TrueClass) || @value.is_a?(FalseClass)

      if [true, 1, "1", "true"].include?(@value)
        true
      elsif [false, 0, "0", "false"].include?(@value)
        false
      else
        raise ActsAsRepository::TypeCastError.new("can't cast #{@value} to a Boolean")
      end
    end
  end
end