# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "acts_as_repository/version"

Gem::Specification.new do |spec|
  spec.name          = "acts_as_repository"
  spec.version       = ActsAsRepository::VERSION
  spec.authors       = ["PowerSupply"]
  spec.email         = ["devs@mypowersupply.com"]

  spec.summary       = %q{Add the repository pattern to your rail app!}
  spec.description   = %q{
    The repository pattern abstracts AR behind a thin layer that delegates to your AR models.
    Instead of working with models directly, you work with entities which are much lighter objects
    that just contain data, and handle no business logic. This separation allows for very easy testing
    and to switch DB adapters with incredible easy.
  }
  spec.homepage      = "http://github.com/powersupply/acts_as_repository"
  spec.license       = "MIT"
  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency("bundler", "~> 1.12")
  spec.add_development_dependency("rake", "~> 10.0")
  spec.add_development_dependency("rspec", "~> 3.0")
  spec.add_development_dependency("sqlite3")
  spec.add_development_dependency("pry")
end
