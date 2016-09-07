require "active_support"
require "acts_as_repository/errors"
require "acts_as_repository/boolean"
require "acts_as_repository/type_caster"
require "acts_as_repository/entity_attribute"
require "acts_as_repository/is_entity"
require "acts_as_repository/is_repository"
require "acts_as_repository/adapter"
require "acts_as_repository/adapter/base"
require "acts_as_repository/adapter/active_record"

module ActsAsRepository
  class TypeCastError < StandardError; end
  class UnknownTypeError < StandardError; end

  def self.lookup_db_adapter(adapter_name)
    case adapter_name
    when :active_record
      ActsAsRepository::Adapter::ActiveRecord
    end
  end

  def self.type_cast_entity(value:, to:)
    return value if value.nil? || to.nil?
    caster = ActsAsRepository::TypeCaster.new(value)
    caster.value_to_primitive_type(to)
  end
end
