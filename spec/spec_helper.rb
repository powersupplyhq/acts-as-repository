$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require "acts_as_repository"
require "active_support"
require "active_record"
require "pry"

RSpec.configure do |config|
  config.after(:each) do
    RepoUser.delete_all
  end
end

# Used to test interactions between DJ and an ORM
ActiveRecord::Base.establish_connection(adapter: "sqlite3", database: ":memory:")
ActiveRecord::Migration.verbose = false

ActiveRecord::Schema.define do
  create_table :repo_users, primary_key: :id, force: true do |table|
    table.string :first_name
    table.string :last_name
  end
end

class RepoUser < ActiveRecord::Base
  self.primary_key = "id"
end

class UserEntity
  include ActsAsRepository::IsEntity

  attribute :id, Integer
  attribute :first_name, String
  attribute :last_name, String
  attribute :active, Boolean
end

class UserRepository
  include ActsAsRepository::IsRepository

  acts_as_repository model_class: RepoUser, entity_class: UserEntity, db_adapter: :active_record

  def self.find_by_first_name(first_name)
    query do
      where(first_name: first_name)
    end
  end
end

RepoUser.delete_all
