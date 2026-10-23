Gem::Specification.new do |spec|
  spec.name = "seolyticize-site"
  spec.version = "0.1.0"
  spec.summary = "Seolyticize on your Ruby site: the analytics tag, the IndexNow key file, deploy notification and server-side events."
  spec.authors = ["Seolyticize"]
  spec.license = "MIT"
  spec.homepage = "https://github.com/Seolyticize/site-ruby"
  spec.required_ruby_version = ">= 3.0"
  spec.files = Dir["lib/**/*.rb"] + ["README.md", "LICENSE"]
  spec.require_paths = ["lib"]
  spec.metadata = { "documentation_uri" => "https://seolyticize.com/docs/site-kits", "source_code_uri" => "https://github.com/Seolyticize/site-ruby" }
end
