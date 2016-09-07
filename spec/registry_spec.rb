require "spec_helper"

RSpec.describe ActsAsRepository::Registry do
  let(:registry){ ActsAsRepository::Registry.new }

  describe "self.add" do
    context "when the repository already exists" do
      before{ registry.add(:user, UserRepository) }

      it "raises an error" do
        expect{ registry.add(:user, UserRepository) }.to raise_error(ActsAsRepository::RepositoryAlreadyRegisteredError)
      end
    end

    context "with valid arguments" do
      it "adds the repository to the register" do
        expect(registry.repositories).to be_empty
        registry.add(:user, UserRepository)
        expect(registry.repositories[:user]).to eq(UserRepository)
      end
    end
  end

  describe "self.remove_for" do
    context "when the repository does not exist" do
      it "performs a no-op" do
        expect{ registry.remove_for(:user) }.to_not raise_error
      end
    end

    context "when the repository exists" do
      before{ registry.add(:user, UserRepository) }

      it "removes the repo" do
        expect(registry.repositories[:user]).to eq(UserRepository)
        registry.remove_for(:user)
        expect(registry.repositories).to be_empty
      end
    end
  end

  describe "self.repositories" do
    it "reflects the registered repositores" do
      expect(registry.repositories).to be_empty
      registry.add(:user, UserRepository)
      expect(registry.repositories[:user]).to eq(UserRepository)
      registry.remove_for(:user)
      expect(registry.repositories).to be_empty
    end
  end
end
