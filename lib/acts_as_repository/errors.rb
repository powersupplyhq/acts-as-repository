module ActsAsRepository
  class ResourceNotFoundError < StandardError; end
  class PersistenceFailedError < StandardError; end
end
