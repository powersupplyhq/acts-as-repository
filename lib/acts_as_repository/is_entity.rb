module ActsAsRepository
  module IsEntity
    extend ::ActiveSupport::Concern

    module ClassMethods
      def attribute(name, type, options = {})
        attribute_set[name] = ActsAsRepository::EntityAttribute.new(name: name, type: type)

        define_method(name) do
          instance_variable_get("@#{name}")
        end

        define_method("#{name}=") do |value|
          @attribute_set ||= {}
          @attribute_set[name] ||= self.class.attribute_set[name]
          v = @attribute_set[name].set_value(value)
          instance_variable_set("@#{name}", v)
          v
        end
      end

      def attribute_set
        @attribute_set ||= {}
      end
    end

    def initialize(attributes = {})
      attributes.each_pair do |key, value|
        self.send("#{key}=", value)
      end
    end

    def attributes
      h = {}

      attribute_set.each_pair do |key, attr|
        h[key] = attr.value
      end

      h
    end

    def attribute_set
      @attribute_set ||= self.class.attribute_set.dup
    end
  end
end
