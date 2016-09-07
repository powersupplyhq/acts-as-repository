module ActsAsRepository
  module IsRepository
    extend ::ActiveSupport::Concern

    module ClassMethods
      def acts_as_repository(model_class:, entity_class:, db_adapter:)
        @repo_model_class = model_class
        @repo_entity_class = entity_class

        @repo_db_adapter = ActsAsRepository.lookup_db_adapter(db_adapter).new(
          model_class: repo_model_class,
          entity_class: repo_entity_class
        )
      end

      def create(entity)
        repo_db_adapter.create(entity)
      end

      def update(entity)
        repo_db_adapter.update(entity)
      end

      def delete(entity)
        repo_db_adapter.delete(entity)
      end

      def find(id)
        repo_db_adapter.find(id)
      end

      def first
        repo_db_adapter.first
      end

      def last
        repo_db_adapter.last
      end

      def all
        repo_db_adapter.all
      end

      def count
        repo_db_adapter.count
      end

      private

      def repo_db_adapter
        @repo_db_adapter
      end

      def repo_model_class
        @repo_model_class
      end

      def repo_entity_class
        @repo_entity_class
      end

      def query(&block)
        repo_db_adapter.query(&block)
      end

      def convert_to_entity(model)
        repo_db_adapter.convert_to_entity(model)
      end

      def convert_to_model(entity)
        repo_db_adapter.convert_to_model(entity)
      end
    end
  end
end
