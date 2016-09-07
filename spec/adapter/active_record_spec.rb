require "spec_helper"

RSpec.describe ActsAsRepository::Adapter::ActiveRecord do
  let(:adapter) do
    ActsAsRepository::Adapter::ActiveRecord.new(
      model_class: RepoUser,
      entity_class: UserEntity
    )
  end

  describe "#convert_to_entity" do
    context "when the model is of the expected class" do
      it "returns the expected entity with it's attributes set" do
        result = adapter.convert_to_entity(RepoUser.new(id: 1, first_name: "Bruce", last_name: "Wayne"))

        expect(result).to be_an_instance_of(UserEntity)
        expect(result.id).to eq(1)
        expect(result.first_name).to eq("Bruce")
        expect(result.last_name).to eq("Wayne")
      end
    end

    context "when the model is not of the expected class" do
      it "raises an argument error" do
        expect{ adapter.convert_to_entity(OpenStruct.new(foo: :bar)) }.to raise_error(ArgumentError)
      end
    end
  end

  describe "#convert_to_model" do
    context "when the entity is of the expected class" do
      it "returns the expected model with it's attributes set" do
        result = adapter.convert_to_model(UserEntity.new(first_name: "Bruce", last_name: "Wayne"))

        expect(result).to be_an_instance_of(RepoUser)
        expect(result.id).to eq(nil)
        expect(result.first_name).to eq("Bruce")
        expect(result.last_name).to eq("Wayne")
      end
    end

    context "when the entity is not of the expected class" do
      it "raises an argument error" do
        expect{ adapter.convert_to_model(OpenStruct.new(foo: :bar)) }.to raise_error(ArgumentError)
      end
    end
  end

  describe "#query" do
  end

  describe "#find" do
    context "id is nil" do
      it "it raises an error" do
        expect{ adapter.find("") }.to raise_error(ArgumentError)
      end
    end

    context "id is blank" do
      it "it raises an error" do
        expect{ adapter.find("") }.to raise_error(ArgumentError)
      end
    end

    context "the record cannot be found" do
      it "it raises an error" do
        expect{ adapter.find(1) }.to raise_error(ActsAsRepository::ResourceNotFoundError)
      end
    end

    context "the record can be found" do
      before{ RepoUser.create!(first_name: "Billy", last_name: "Batson") }

      it "returns an entity that represents the found model" do
        result = adapter.find(RepoUser.last.id)
        expect(result).to be_an_instance_of(UserEntity)
      end
    end
  end

  describe "#create" do
    context "with an invalid entity" do
      it "raises an error" do
        expect{ adapter.create(OpenStruct.new(foo: "bar")) }.to raise_error(ArgumentError)
      end
    end

    context "success" do
      let(:entity){ UserEntity.new(first_name: "Axel", last_name: "Asher") }

      it "returns an entity with an id" do
        new_entity = adapter.create(entity)
        expect(new_entity.id).to eq(RepoUser.last.id)
      end
    end

    context "persistence at the AR level fails" do
      before{ allow_any_instance_of(RepoUser).to receive(:save!).and_raise(ActiveRecord::RecordNotSaved) }
      let(:entity){ UserEntity.new(first_name: "Axel", last_name: "Asher") }

      it "raises an error" do
        expect{ adapter.create(entity) }.to raise_error(ActsAsRepository::PersistenceFailedError)
      end
    end
  end

  describe "#update" do
    context "with an invalid entity" do
      it "raises an error" do
        expect{ adapter.update(OpenStruct.new(foo: "bar")) }.to raise_error(ArgumentError)
      end
    end

    context "success" do
      before{ RepoUser.create!(first_name: "Axel", last_name: "Asher") }
      let(:model){ RepoUser.last }
      let(:entity) do
        e = adapter.convert_to_entity(model)
        e.first_name = "Barry"
        e.last_name = "Allen"
        e
      end

      it "returns the updated entity" do
        updated_entity = adapter.update(entity)
        expect(updated_entity.id).to eq(RepoUser.last.id)
        expect(updated_entity.first_name).to eq(RepoUser.last.first_name)
        expect(updated_entity.last_name).to eq(RepoUser.last.last_name)
      end
    end

    context "persistence at the AR level fails" do
      before do
        allow_any_instance_of(RepoUser).to receive(:update!).and_raise(ActiveRecord::RecordNotSaved)
        RepoUser.create!(first_name: "Axel", last_name: "Asher")
      end
      let(:model){ RepoUser.last }
      let(:entity) do
        e = adapter.convert_to_entity(model)
        e.first_name = "Barry"
        e.last_name = "Allen"
        e
      end

      it "raises an error" do
        expect{ adapter.update(entity) }.to raise_error(ActsAsRepository::PersistenceFailedError)
      end
    end
  end

  describe "#delete" do
    context "with an invalid entity" do
      it "raises an error" do
        expect{ adapter.delete(OpenStruct.new(foo: "bar")) }.to raise_error(ArgumentError)
      end
    end

    context "success" do
      before{ RepoUser.create!(first_name: "Axel", last_name: "Asher") }
      let(:model){ RepoUser.last }
      let(:entity){ adapter.convert_to_entity(model) }

      it "returns the destroyed entity without an id" do
        model = RepoUser.last
        updated_entity = adapter.delete(entity)
        expect(updated_entity.id).to eq(nil)
        expect(updated_entity.first_name).to eq(model.first_name)
        expect(updated_entity.last_name).to eq(model.last_name)
      end
    end

    context "persistence at the AR level fails" do
      before do
        allow_any_instance_of(RepoUser).to receive(:destroy).and_return(false)
        RepoUser.create!(first_name: "Axel", last_name: "Asher")
      end
      let(:model){ RepoUser.last }
      let(:entity){ adapter.convert_to_entity(model) }

      it "raises an error" do
        expect{ adapter.delete(entity) }.to raise_error(ActsAsRepository::PersistenceFailedError)
      end
    end
  end

  describe "#first" do
    context "no models exist" do
      it "returns nil" do
        expect(adapter.first).to eq(nil)
      end
    end

    context "models exist" do
      before{ RepoUser.create!(first_name: "Axel", last_name: "Asher") }

      it "returns an entity representing the first model" do
        result = adapter.first
        expect(result.id).to eq(RepoUser.first.id)
      end
    end
  end

  describe "#last" do
    context "no models exist" do
      it "returns nil" do
        expect(adapter.last).to eq(nil)
      end
    end

    context "models exist" do
      before{ 2.times{ RepoUser.create!(first_name: "Axel", last_name: "Asher") } }

      it "returns an entity representing the last model" do
        result = adapter.last
        expect(result.id).to eq(RepoUser.last.id)
      end
    end
  end

  describe "#all" do
    context "no models exist" do
      it "returns an empty array" do
        expect(adapter.all).to be_empty
      end
    end

    context "models exist" do
      before{ 2.times{ RepoUser.create!(first_name: "Axel", last_name: "Asher") } }

      it "returns a collection of entities for each model" do
        result = adapter.all
        expect(result[0].id).to eq(RepoUser.first.id)
        expect(result[1].id).to eq(RepoUser.last.id)
      end
    end
  end

  describe "#count" do
    context "no models exist" do
      it "returns 0" do
        expect(adapter.count).to eq(0)
      end
    end

    context "models exist" do
      before{ 2.times{ RepoUser.create!(first_name: "Axel", last_name: "Asher") } }

      it "returns the number of models in the DB" do
        expect(adapter.count).to eq(2)
      end
    end
  end
end
