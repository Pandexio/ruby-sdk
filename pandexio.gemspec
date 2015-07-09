Gem::Specification.new do |s|
    s.name = 'pandexio'
    s.version = '0.0.7'
    s.date = '2015-07-09'
    s.summary = "Signs Pandexio requests using HMAC"
    s.description = "Pandexio SDK for Ruby"
    s.authors = ["Brandon Varilone"]
    s.email = 'bvarilone@gmail.com'
    s.files = ["README.md", "Rakefile", "lib/pandexio.rb", "lib/request.rb", "lib/scope.rb", "lib/scope_patterns.rb", "lib/signer.rb", "lib/signing_algorithms.rb", "lib/signing_attributes.rb", "lib/signing_mechanisms.rb", "lib/signing_options.rb", "test/test_header_signing.rb", "test/test_query_string_signing.rb", "test/test_scope.rb", "test/test_scope_patterns.rb", "test/test_signer.rb"]
    s.homepage = 'http://rubygems.org/gems/pandexio'
    s.license = 'MIT'
end