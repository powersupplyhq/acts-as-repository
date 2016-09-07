require "spec_helper"

RSpec.describe ActsAsRepository::IsRepository do
  let!(:user){ RepoUser.create!(first_name: "Steve", last_name: "Rogers") }

  describe "#all" do
    it "returns all of the created users as entities" do
      result = UserRepository.all
      expect(result.count).to eq(1)
      expect(result.first).to be_an_instance_of(UserEntity)
    end
  end

  describe "#count" do
    it "returns the count of all of the created users" do
      expect(UserRepository.count).to eq(1)
    end
  end

  describe "#create" do
    it "persists an entity" do
      new_entity = UserEntity.new(first_name: "steve", last_name: "rogers")
      result = UserRepository.create(new_entity)
      expect(RepoUser.where(first_name: "steve", last_name: "rogers").count).to eq(1)
    end
  end

  describe "#update" do
    it "persists an entity" do
      new_entity = UserEntity.new(id: user.id, first_name: "new")
      UserRepository.update(new_entity)
      expect(RepoUser.last.first_name).to eq("new")
    end
  end

  describe "#delete" do
    it "destroys an entity" do
      adapter = ActsAsRepository::Adapter::ActiveRecord.new(
        model_class: RepoUser,
        entity_class: UserEntity
      )

      entity = adapter.convert_to_entity(RepoUser.last)
      UserRepository.delete(entity)
      expect(RepoUser.count).to eq(0)
    end
  end

  describe "#first" do
    before{ @new_user = RepoUser.create(first_name: "Barry", last_name: "Allen") }

    it "returns the first entity created" do
      entity = UserRepository.first

      expect(entity.id).to eq(user.id)
      expect(entity.first_name).to eq(user.first_name)
      expect(entity.last_name).to eq(user.last_name)
    end
  end

  describe "#last" do
    before{ @last_user = RepoUser.create(first_name: "Bruce", last_name: "Banner") }

    it "returns the last entity created" do
      entity = UserRepository.last

      expect(entity.id).to eq(@last_user.id)
      expect(entity.first_name).to eq(@last_user.first_name)
      expect(entity.last_name).to eq(@last_user.last_name)
    end
  end

  describe "#find" do
    context "when the resource exists" do
      it "returns the entity" do
        result = UserRepository.find(user.id)
        expect(result).to be_an_instance_of(UserEntity)
        expect(result.id).to eq(user.id)
      end
    end

    context "when the resource does not exist" do
      it "raises an exception" do
        expect{ UserRepository.find("foobar") }.to raise_error(ActsAsRepository::ResourceNotFoundError)
      end
    end
  end

  describe "#query" do
    it "runs the query against the adatper" do
      result = UserRepository.find_by_first_name(user.first_name)
      expect(result.count).to eq(1)
      expect(result.first).to be_an_instance_of(UserEntity)
    end
  end
end
