module ActsAsRepository
  module Adapter
    class ActiveRecord < Base
      def convert_to_entity(model)
        enforce_valid_model!(model)
        entity_attribute_names = @entity_class.attribute_set.keys
        model_attributes = model.attributes.keys.map(&:to_sym)
        entity = @entity_class.new

        entity_attribute_names.each do |method_name|
          next if !model.respond_to?("#{method_name}") || !model.respond_to?(method_name)
          model_value = model.send(method_name)
          entity.send("#{method_name}=", model_value)
        end

        entity
      end

      def convert_to_model(entity)
        enforce_valid_entity!(entity)
        return @model_class.find(entity.id) if entity.id

        model_attribute_names = @model_class.new.attributes.keys.map(&:to_sym)
        model = @model_class.new

        model_attribute_names.each do |method_name|
          next if !model.respond_to?("#{method_name}=") || !entity.respond_to?(method_name)
          entity_value = entity.send(method_name)
          model.send("#{method_name}=", entity_value)
        end

        model
      end

      def query(&block)
        results = @model_class.send(:class_eval, &block)

        if results.respond_to?(:count)
          results.map{ |model| convert_to_entity(model) }
        else
          convert_to_entity(results)
        end
      end

      def find(id)
        raise ArgumentError.new("id is required") if id.blank?
        convert_to_entity(base_find(id))
      end

      def create(entity)
        enforce_valid_entity!(entity)
        model = convert_to_model(entity)

        begin
          model.save!
        rescue StandardError => e
          raise ActsAsRepository::PersistenceFailedError.new("the record failed to save")
        end

        convert_to_entity(model)
      end

      def update(entity)
        enforce_valid_entity!(entity)
        model = base_find(entity.id)

        begin
          model.update(entity.attributes)
        rescue StandardError => e
          raise ActsAsRepository::PersistenceFailedError.new("the record failed to save")
        end

        convert_to_entity(model)
      end

      def delete(entity)
        enforce_valid_entity!(entity)
        model = base_find(entity.id)
        model.destroy
        entity
      end

      def first
        convert_to_entity(@model_class.first)
      end

      def last
        convert_to_entity(@model_class.last)
      end

      def all
        @model_class.all.map{ |model| convert_to_entity(model) }
      end

      def count
        @model_class.count
      end

      private

      def enforce_valid_model!(model)
        return if model.is_a?(@model_class)
        raise ArgumentError.new("model must be an instance of #{@model_class}")
      end

      def enforce_valid_entity!(entity)
        return if entity.is_a?(@entity_class)
        raise ArgumentError.new("entity must be a UserEntity")
      end

      def base_find(id)
        begin
          @model_class.find(id)
        rescue ::ActiveRecord::RecordNotFound => e
          raise ActsAsRepository::ResourceNotFoundError.new("
            Could not find an instance of #{@model_class} with id:#{id}.
          ")
        end
      end
    end
  end
end
