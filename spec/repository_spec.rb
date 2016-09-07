require "spec_helper"

RSpec.describe ActsAsRepository::Repository do
  before{ ActsAsRepository::Repository.clear! }
  after{ ActsAsRepository::Repository.clear! }

  describe "self.register" do
    context "with an invalid type" do
      it "raises an argument error" do
        expect{ ActsAsRepository::Repository.register(type: "foo", repository: UserRepository) }.to raise_error(ArgumentError)
      end
    end

    context "with an invalid repository" do
      it "raises an argument error" do
        expect{ ActsAsRepository::Repository.register(type: :user, repository: OpenStruct) }.to raise_error(ArgumentError)
      end
    end

    context "with valid arguments" do
      it "adds the repository to the register" do
        expect(ActsAsRepository::Repository.repositories).to be_empty
        ActsAsRepository::Repository.register(type: :user, repository: UserRepository)
        expect(ActsAsRepository::Repository.repositories[:user]).to eq(UserRepository)
      end
    end
  end

  describe "self.for" do
    context "when the repository does not exist" do
      it "returns nil" do
        expect(ActsAsRepository::Repository.for(:user)).to eq(nil)
      end
    end

    context "when the repository exists" do
      before{ ActsAsRepository::Repository.register(type: :user, repository: UserRepository) }

      it "returns the repo" do
        expect(ActsAsRepository::Repository.for(:user)).to eq(UserRepository)
      end
    end
  end

  describe "self.remove_for" do
    context "when the repository does not exist" do
      it "performs a no-op" do
        expect{ ActsAsRepository::Repository.remove_for(:user) }.to_not raise_error
      end
    end

    context "when the repository exists" do
      before{ ActsAsRepository::Repository.register(type: :user, repository: UserRepository) }

      it "removes the repo" do
        expect(ActsAsRepository::Repository.repositories[:user]).to eq(UserRepository)
        ActsAsRepository::Repository.remove_for(:user)
        expect(ActsAsRepository::Repository.repositories).to be_empty
      end
    end
  end

  describe "self.repositories" do
    it "reflects the registered repositores" do
      expect(ActsAsRepository::Repository.repositories).to be_empty
      ActsAsRepository::Repository.register(type: :user, repository: UserRepository)
      expect(ActsAsRepository::Repository.repositories[:user]).to eq(UserRepository)
      ActsAsRepository::Repository.remove_for(:user)
      expect(ActsAsRepository::Repository.repositories).to be_empty
    end
  end
end
