module ActsAsRepository
  class Repository
    def self.register(type:, repository:)
      raise ArgumentError.new("type must be a symbol") unless type.is_a?(Symbol)
      raise ArgumentError.new("repository must be a Repository") unless repository.respond_to?(:acts_as_repository)
      registry.add(type, repository)
    end

    def self.clear!
      @registry = ActsAsRepository::Registry.new
    end

    def self.remove_for(type)
      registry.remove_for(type)
    end

    def self.repositories
      registry.repositories
    end

    def self.for(type)
      repositories[type]
    end

    private

    def self.registry
      @registry ||= ActsAsRepository::Registry.new
    end
  end
end
