require "spec_helper"

describe ActsAsRepository do
  class FakeCaster
    def value_to_primitive_type(type)
    end
  end

  it "has a version number" do
    expect(ActsAsRepository::VERSION).not_to be nil
  end

  describe ".lookup_db_adapter" do
    context "when the adapter ActiveRecord" do
      it "returns the ActiveRecord adapter class" do
        expect(ActsAsRepository.lookup_db_adapter(:active_record)).to eq(ActsAsRepository::Adapter::ActiveRecord)
      end
    end

    context "when the adapter is not ActiveRecord" do
      it "returns nil" do
        expect(ActsAsRepository.lookup_db_adapter(:mongo)).to eq(nil)
      end
    end
  end

  describe ".type_cast_entity" do
    context "when the value is nil" do
      it "returns nil" do
        expect(ActsAsRepository.type_cast_entity(value: nil, to: String)).to eq(nil)
      end
    end

    context "when the 'to' argument is nil" do
      it "returns the value" do
        expect(ActsAsRepository.type_cast_entity(value: 1, to: nil)).to eq(1)
      end
    end

    context "with valid arguments" do
      let(:fake_caster){ FakeCaster.new }

      it "returns the casted value" do
        expect(fake_caster).to receive(:value_to_primitive_type).with(String).and_return("1")
        expect(ActsAsRepository::TypeCaster).to receive(:new).with(1).and_return(fake_caster)

        result = ActsAsRepository.type_cast_entity(value: 1, to: String)
        expect(result).to eq("1")
      end
    end
  end
end
