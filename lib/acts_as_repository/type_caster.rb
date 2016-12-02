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
          raise ActsAsRepository::TypeCastError.new("cant cast an instance of #{@value.class} to String")
        end
      when "Symbol"
        if @value.respond_to?(:to_sym)
          @value.to_sym
        else
          raise ActsAsRepository::TypeCastError.new("cant cast an instance of #{@value.class} to Symbol")
        end
      when "Time"
        if @value.respond_to?(:to_time)
          @value.to_time
        else
          raise ActsAsRepository::TypeCastError.new("cant cast an instance of #{@value.class} to Time")
        end
      when "Date"
        if @value.respond_to?(:to_date)
          @value.to_date
        else
          raise ActsAsRepository::TypeCastError.new("cant cast an instance of #{@value.class} to Date")
        end
      when "DateTime"
        if @value.respond_to?(:to_datetime)
          @value.to_datetime
        else
          raise ActsAsRepository::TypeCastError.new("cant cast an instance of #{@value.class} to DateTime")
        end
      when "JSON"
        if @value.respond_to?(:to_json)
          @value.to_json
        else
          raise ActsAsRepository::TypeCastError.new("cant cast an instance of #{@value.class} to JSON")
        end
      when "Integer"
        if @value.respond_to?(:to_i)
          @value.to_i
        else
          raise ActsAsRepository::TypeCastError.new("cant cast an instance of #{@value.class} to Integer")
        end
      when "BigDecimal"
        to_big_decimal
      when "Boolean"
        to_boolean
      else
        raise ActsAsRepository::UnknownTypeError.new("don't know primitive type: #{type}")
      end
    end

    private

    def to_big_decimal
      return @value if @value.is_a?(BigDecimal)

      if @value.is_a?(String)
        BigDecimal.new(@value.gsub(/[^\d,\.]/, ''))
      elsif @value.is_a?(Integer)
        BigDecimal.new(@value.to_s)
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
