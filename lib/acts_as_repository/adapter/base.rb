module ActsAsRepository
  module Adapter
    class Base
      def initialize(model_class:, entity_class:)
        @model_class = model_class
        @entity_class = entity_class
      end

      def convert_to_entity(model)
        raise StandardError.new("NOT YET IMPLEMENTED.")
      end

      def convert_to_model(entity)
        raise StandardError.new("NOT YET IMPLEMENTED.")
      end
    end
  end
end
