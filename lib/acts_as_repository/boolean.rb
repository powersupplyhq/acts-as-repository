class Boolean
  # @param [true|false|Integer] value
  # @return [TrueClass|FalseClass] "1", 1, true will return true
  def initialize(value)
    case value
    when String
      value == '1' || value == 'true'
    when Integer
      value == 1
    else
      value
    end
  end
end
