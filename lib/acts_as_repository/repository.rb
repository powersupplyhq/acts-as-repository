module ActsAsRepository
  class Repository
    def self.register(type, repository)
      registry.add(type, repository)
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
