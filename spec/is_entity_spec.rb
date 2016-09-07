require "spec_helper"

RSpec.describe ActsAsRepository::IsEntity do
  class UserEntity
    include ActsAsRepository::IsEntity

    attribute :name, String
    attribute :active, Boolean
  end

  let(:entity){ UserEntity.new }

  describe "attribute" do
    it "allows the entity to define, set, and read attributes" do
      entity.name = "Captain Morgan"
      expect(entity.name).to eq("Captain Morgan")
    end

    it "coerces input into a string, when the type is String" do
      entity.name = 123
      expect(entity.name).to eq("123")
      entity.name = "123"
      expect(entity.name).to eq("123")
      entity.name = true
      expect(entity.name).to eq("true")
      entity.name = nil
      expect(entity.name).to eq(nil)
    end

    it "coerces input into a boolean, when the type is Boolean" do
      entity.active = 1
      expect(entity.active).to be(true)
      entity.active = "1"
      expect(entity.active).to be(true)
      entity.active = "true"
      expect(entity.active).to be(true)
      entity.active = true
      expect(entity.active).to be(true)

      entity.active = 0
      expect(entity.active).to be(false)
      entity.active = "0"
      expect(entity.active).to be(false)
      entity.active = "false"
      expect(entity.active).to be(false)
      entity.active = false
      expect(entity.active).to be(false)

      entity.active = nil
      expect(entity.active).to eq(nil)

      expect{ entity.active = 123 }.to raise_error(ActsAsRepository::TypeCastError)
    end
  end

  describe "attributes" do
    it "returns the settable attributes as a hash of keys and raw values" do
      entity.active = true
      entity.name = "Luke SkyWalker"

      expect(entity.attributes[:name]).to eq("Luke SkyWalker")
      expect(entity.attributes[:active]).to eq(true)
      expect(entity.attributes.keys.count).to eq(2)
    end
  end

  describe "attribute_set" do
    it "returns the default hash of attributes" do
      expect(entity.attribute_set[:name]).to be_an_instance_of(ActsAsRepository::EntityAttribute)
      expect(entity.attribute_set[:active]).to be_an_instance_of(ActsAsRepository::EntityAttribute)
    end
  end
end
