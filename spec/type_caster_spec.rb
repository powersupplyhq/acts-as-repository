require "spec_helper"

RSpec.describe ActsAsRepository::TypeCaster do
  class Stringable
    def to_s
      "foo"
    end
  end

  class UnStoppable
    def self.create
      instance = new
      instance.instance_eval('undef :to_s')
      instance
    end
  end

  describe "#value_to_primitive_type" do
    context "casting to a string" do
      context "when the object responds to to_s" do
        let(:caster){ ActsAsRepository::TypeCaster.new(Stringable.new) }

        it "returns the string value of the object" do
          value = caster.value_to_primitive_type(String)
          expect(value).to eq("foo")
        end
      end

      context "when the object does not respond to to_s" do
        let(:caster){ ActsAsRepository::TypeCaster.new(UnStoppable.create) }

        it "raises a typecast error" do
          expect{ caster.value_to_primitive_type(String) }.to raise_error(ActsAsRepository::TypeCastError)
        end
      end
    end

    context "casting to an Integer" do
      context "when the object responds to to_i" do
        let(:caster){ ActsAsRepository::TypeCaster.new("2") }

        it "returns the integer value of the object" do
          value = caster.value_to_primitive_type(Integer)
          expect(value).to eq(2)
        end
      end

      context "when the object does not respond to to_i" do
        let(:caster){ ActsAsRepository::TypeCaster.new(UnStoppable.create) }

        it "raises a typecast error" do
          expect{ caster.value_to_primitive_type(Integer) }.to raise_error(ActsAsRepository::TypeCastError)
        end
      end
    end

    context "casting to a BigDecimal" do
      context "when the value is a string" do
        let(:caster){ ActsAsRepository::TypeCaster.new("10.00") }

        it "returns the BigDecimal value of the object" do
          value = caster.value_to_primitive_type(BigDecimal)
          expect(value).to eq(BigDecimal.new("10.00"))
        end
      end

      context "when the value is a integer" do
        let(:caster){ ActsAsRepository::TypeCaster.new(10) }

        it "returns the BigDecimal value of the object" do
          value = caster.value_to_primitive_type(BigDecimal)
          expect(value).to eq(BigDecimal.new("10"))
        end
      end

      context "when the value cannot be cast" do
        let(:caster){ ActsAsRepository::TypeCaster.new(UnStoppable.new) }

        it "raises a typecast error" do
          expect{ caster.value_to_primitive_type(BigDecimal) }.to raise_error(ActsAsRepository::TypeCastError)
        end
      end
    end

    context "casting to a Boolean" do
      context "when the value seems truthy" do
        it "returns true" do
          expect(ActsAsRepository::TypeCaster.new(1).value_to_primitive_type(Boolean)).to be(true)
          expect(ActsAsRepository::TypeCaster.new("1").value_to_primitive_type(Boolean)).to be(true)
          expect(ActsAsRepository::TypeCaster.new("true").value_to_primitive_type(Boolean)).to be(true)
          expect(ActsAsRepository::TypeCaster.new(true).value_to_primitive_type(Boolean)).to be(true)
        end
      end

      context "when the value seems falsey" do
        it "returns false" do
          expect(ActsAsRepository::TypeCaster.new(0).value_to_primitive_type(Boolean)).to be(false)
          expect(ActsAsRepository::TypeCaster.new("0").value_to_primitive_type(Boolean)).to be(false)
          expect(ActsAsRepository::TypeCaster.new("false").value_to_primitive_type(Boolean)).to be(false)
          expect(ActsAsRepository::TypeCaster.new(false).value_to_primitive_type(Boolean)).to be(false)
        end
      end

      context "when the value cannot be cast" do
        let(:caster){ ActsAsRepository::TypeCaster.new(UnStoppable.new) }

        it "raises a typecast error" do
          expect{ caster.value_to_primitive_type(Boolean) }.to raise_error(ActsAsRepository::TypeCastError)
        end
      end
    end
  end
end
