Gem::Specification.new do |s|
    s.name = 'pandexio'
    s.version = '0.0.6'
    s.date = '2015-06-26'
    s.summary = "Signs Pandexio requests using HMAC"
    s.description = "Pandexio SDK for Ruby"
    s.authors = ["Brandon Varilone"]
    s.email = 'bvarilone@gmail.com'
    s.files = ["README.md", "Rakefile", "lib/pandexio.rb", "lib/request.rb", "lib/signing_algorithms.rb", "lib/signing_attributes.rb", "lib/signing_mechanisms.rb", "lib/signing_options.rb", "test/test_header_signing.rb", "test/test_query_string_signing.rb"]
    s.homepage = 'http://rubygems.org/gems/pandexio'
    s.license = 'MIT'
end