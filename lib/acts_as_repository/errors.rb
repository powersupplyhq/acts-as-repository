module ActsAsRepository
  class ResourceNotFoundError < StandardError; end
  class PersistenceFailedError < StandardError; end
  class RepositoryAlreadyRegisteredError < StandardError; end
end
