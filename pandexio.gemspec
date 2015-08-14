Gem::Specification.new do |s|
    s.name = 'pandexio'
    s.version = '0.0.9'
    s.date = '2015-08-13'
    s.summary = "Signs Pandexio requests using HMAC"
    s.description = "Pandexio SDK for Ruby"
    s.authors = ["Brandon Varilone"]
    s.email = 'bvarilone@gmail.com'
    s.files = ["README.md", "Rakefile", "lib/http_client.rb", "lib/pandexio.rb", "lib/request.rb", "lib/scope.rb", "lib/scope_patterns.rb", "lib/signer.rb", "lib/signing_algorithms.rb", "lib/signing_attributes.rb", "lib/signing_mechanisms.rb", "lib/signing_options.rb", "test/test_header_signing.rb", "test/test_http_client.rb", "test/test_query_string_signing.rb", "test/test_request.rb", "test/test_scope.rb", "test/test_scope_patterns.rb", "test/test_signer.rb"]
    s.add_runtime_dependency "json",
        [">= 1.8.1"]
    s.add_development_dependency "rake",
        [">= 10.4.2"]
    s.add_development_dependency "minitest",
        [">= 5.5.1"]
    s.add_development_dependency "uuid",
        [">= 2.3.7"]
    s.homepage = 'http://rubygems.org/gems/pandexio'
    s.license = 'MIT'
end