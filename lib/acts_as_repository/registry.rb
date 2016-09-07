module ActsAsRepository
  class Registry
    def initialize
      @repositories = {}
    end

    def repositories
      @repositories
    end

    def add(entity_name, repository)
      if repositories[entity_name]
        raise ActsAsRepository::RepositoryAlreadyRegisteredError.new(%q{
          The #{repositories[entity_name]} is already defined for #{entity_name}
        })
      end

      repositories[entity_name] = repository
    end

    def remove_for(entity_name)
      if repositories[entity_name]
        repositories.delete(entity_name)
      end
    end
  end
end
