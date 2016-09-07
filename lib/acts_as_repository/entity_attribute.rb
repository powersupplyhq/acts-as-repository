module ActsAsRepository
  class EntityAttribute
    attr_accessor :name
    attr_accessor :type

    def initialize(name:, type:)
      @name = name
      @type = type
    end

    def set_value(value)
      @value = ActsAsRepository.type_cast_entity(value: value, to: @type)
    end

    def value
      @value
    end
  end
end
