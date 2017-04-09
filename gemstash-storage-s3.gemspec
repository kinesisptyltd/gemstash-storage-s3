# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'gemstash/storage/s3/version'

Gem::Specification.new do |spec|
  spec.name          = "gemstash-storage-s3"
  spec.version       = Gemstash::Storage::S3::VERSION
  spec.authors       = ["Christopher Eckhardt"]
  spec.email         = ["eckhardt@squareup.com"]

  spec.summary       = "A Gemstash plugin that allows you to use Amazon's S3 Cloud Storage for private gems."
  spec.homepage      = "https://github.com/square/gemstash-storage-s3"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    #spec.metadata['allowed_push_host'] = "https://rubygems.org"
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "aws-sdk", "~> 2.0"
  spec.add_runtime_dependency "gemstash", "~> 1.0"

  spec.add_development_dependency "bundler", "~> 1.14"
  spec.add_development_dependency "rake", "~> 10.0"
end
