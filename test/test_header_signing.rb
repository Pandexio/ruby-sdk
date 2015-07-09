# encoding: utf-8

require 'minitest/autorun'
require 'pandexio'

describe Pandexio do
    describe "#to_authorized_request" do

        describe "when using header signing mechanism to generate a new authorized_request from a given normalized_request" do

            before do
                @normalized_request = Pandexio::Request.new(
                    :method => "PUT",
                    :path => "/asdf/qwer/1234/title",
                    :query_parameters => { "nonce" => "987654321", "Baseline" => "5" },
                    :headers => { "sample" => "example", "Host" => "localhost" },
                    :payload => "testing")

                signing_options = Pandexio::SigningOptions.new(
                    :algorithm => Pandexio::SigningAlgorithms::PDX_HMAC_SHA256,
                    :mechanism => Pandexio::SigningMechanisms::HEADER,
                    :domain_id => "1234567890",
                    :domain_key => "asdfjklqwerzxcv",
                    :date => Time.utc(2014, 11, 21, 13, 43, 15),
                    :expires => 90,
                    :originator => "HeaderSigningTest",
                    :email_address => "Anonymous",
                    :display_name => "Anonymous")

                @authorized_request = Pandexio::to_authorized_request(@normalized_request, signing_options)
            end

            it "does not modify the normalized_request method" do
                @normalized_request.method.must_equal "PUT"
            end
            it "does not modify the normalized_request path" do
                @normalized_request.path.must_equal "/asdf/qwer/1234/title"
            end
            it "does not modify the normalized_request query_parameters" do
                @normalized_request.query_parameters.count.must_equal 2
                @normalized_request.query_parameters["nonce"].must_equal "987654321"
                @normalized_request.query_parameters["Baseline"].must_equal "5"
            end
            it "does not modify the normalized_request headers" do
                @normalized_request.headers.count.must_equal 2
                @normalized_request.headers["sample"].must_equal "example"
                @normalized_request.headers["Host"].must_equal "localhost"
            end
            it "does not modify the normalized_request payload" do
                @normalized_request.payload.must_equal "testing"
            end

        end

        describe "when using header signing mechanism to sign and authorized_request" do

            before do
                normalized_request = Pandexio::Request.new(
                    :method => "PUT",
                    :path => "/asdf/qwer/1234/title",
                    :query_parameters => { "nonce" => "987654321", "Baseline" => "5" },
                    :headers => { "sample" => "example", "Host" => "localhost" },
                    :payload => "testing")

                signing_options = Pandexio::SigningOptions.new(
                    :algorithm => Pandexio::SigningAlgorithms::PDX_HMAC_SHA256,
                    :mechanism => Pandexio::SigningMechanisms::HEADER,
                    :domain_id => "1234567890",
                    :domain_key => "asdfjklqwerzxcv",
                    :date => Time.utc(2014, 11, 21, 13, 43, 15),
                    :expires => 90,
                    :originator => "HeaderSigningTest",
                    :email_address => "Anonymous",
                    :display_name => "Anonymous")

                @authorized_request = Pandexio::to_authorized_request(normalized_request, signing_options)
                @authorized_request = Pandexio::to_authorized_request(@authorized_request, signing_options)
            end

            it "returns the correct authorization header" do
                @authorized_request.headers["Authorization"].must_equal "PDX-HMAC-SHA256 Credential=1234567890, SignedHeaders=host;sample;x-pdx-date;x-pdx-displayname;x-pdx-emailaddress;x-pdx-expires;x-pdx-originator, Signature=a2e3dbc31b712bec6071dc7c5770bc60d4b03afa20e8329e6f4f6a2d74d32709"
            end

        end

        describe "when using header signing mechanism and email_address contains uppercase and lowercase characters" do

            before do
                normalized_request = Pandexio::Request.new(
                    :method => "PUT",
                    :path => "/asdf/qwer/1234/title",
                    :query_parameters => { "nonce" => "987654321", "Baseline" => "5" },
                    :headers => { "sample" => "example", "Host" => "localhost" },
                    :payload => "testing")

                signing_options = Pandexio::SigningOptions.new(
                    :algorithm => Pandexio::SigningAlgorithms::PDX_HMAC_SHA256,
                    :mechanism => Pandexio::SigningMechanisms::HEADER,
                    :domain_id => "1234567890",
                    :domain_key => "asdfjklqwerzxcv",
                    :date => Time.utc(2014, 11, 21, 13, 43, 15),
                    :expires => 90,
                    :originator => "HeaderSigningTest",
                    :email_address => "Anonymous",
                    :display_name => "Anonymous")

                @authorized_request = Pandexio::to_authorized_request(normalized_request, signing_options)
            end

            it "returns the correct authorization header" do
                @authorized_request.headers["Authorization"].must_equal "PDX-HMAC-SHA256 Credential=1234567890, SignedHeaders=host;sample;x-pdx-date;x-pdx-displayname;x-pdx-emailaddress;x-pdx-expires;x-pdx-originator, Signature=a2e3dbc31b712bec6071dc7c5770bc60d4b03afa20e8329e6f4f6a2d74d32709"
            end

        end

        describe "when using header signing mechanism and email_address contains all lowercase characters" do

            before do
                normalized_request = Pandexio::Request.new(
                    :method => "PUT",
                    :path => "/asdf/qwer/1234/title",
                    :query_parameters => { "nonce" => "987654321", "Baseline" => "5" },
                    :headers => { "sample" => "example", "Host" => "localhost" },
                    :payload => "testing")

                signing_options = Pandexio::SigningOptions.new(
                    :algorithm => Pandexio::SigningAlgorithms::PDX_HMAC_SHA256,
                    :mechanism => Pandexio::SigningMechanisms::HEADER,
                    :domain_id => "1234567890",
                    :domain_key => "asdfjklqwerzxcv",
                    :date => Time.utc(2014, 11, 21, 13, 43, 15),
                    :expires => 90,
                    :originator => "HeaderSigningTest",
                    :email_address => "anonymous",
                    :display_name => "Anonymous")

                @authorized_request = Pandexio::to_authorized_request(normalized_request, signing_options)
            end

            it "returns the correct authorization header" do
                @authorized_request.headers["Authorization"].must_equal "PDX-HMAC-SHA256 Credential=1234567890, SignedHeaders=host;sample;x-pdx-date;x-pdx-displayname;x-pdx-emailaddress;x-pdx-expires;x-pdx-originator, Signature=d2c3ba8ed5c10371a4a370a7e7ee5f483d4eaac4545a97d6aaced30d8e62d2a0"
            end

        end

        describe "when using header signing mechanism and email_address contains all uppercase characters" do

            before do
                normalized_request = Pandexio::Request.new(
                    :method => "PUT",
                    :path => "/asdf/qwer/1234/title",
                    :query_parameters => { "nonce" => "987654321", "Baseline" => "5" },
                    :headers => { "sample" => "example", "Host" => "localhost" },
                    :payload => "testing")

                signing_options = Pandexio::SigningOptions.new(
                    :algorithm => Pandexio::SigningAlgorithms::PDX_HMAC_SHA256,
                    :mechanism => Pandexio::SigningMechanisms::HEADER,
                    :domain_id => "1234567890",
                    :domain_key => "asdfjklqwerzxcv",
                    :date => Time.utc(2014, 11, 21, 13, 43, 15),
                    :expires => 90,
                    :originator => "HeaderSigningTest",
                    :email_address => "ANONYMOUS",
                    :display_name => "Anonymous")

                @authorized_request = Pandexio::to_authorized_request(normalized_request, signing_options)
            end

            it "returns the correct authorization header" do
                @authorized_request.headers["Authorization"].must_equal "PDX-HMAC-SHA256 Credential=1234567890, SignedHeaders=host;sample;x-pdx-date;x-pdx-displayname;x-pdx-emailaddress;x-pdx-expires;x-pdx-originator, Signature=865f3555991dc8f73760058b643a6a169c07c3a32ab3d247aa0eebdc24e9d6e9"
            end

        end

        describe "when using header signing mechanism and display_name contains spaces" do

            before do
                normalized_request = Pandexio::Request.new(
                    :method => "PUT",
                    :path => "/asdf/qwer/1234/title",
                    :query_parameters => { "nonce" => "987654321", "Baseline" => "5" },
                    :headers => { "sample" => "example", "Host" => "localhost" },
                    :payload => "testing")

                signing_options = Pandexio::SigningOptions.new(
                    :algorithm => Pandexio::SigningAlgorithms::PDX_HMAC_SHA256,
                    :mechanism => Pandexio::SigningMechanisms::HEADER,
                    :domain_id => "1234567890",
                    :domain_key => "asdfjklqwerzxcv",
                    :date => Time.utc(2014, 11, 21, 13, 43, 15),
                    :expires => 90,
                    :originator => "HeaderSigningTest",
                    :email_address => "Anonymous",
                    :display_name => "A. Anonymous")

                @authorized_request = Pandexio::to_authorized_request(normalized_request, signing_options)
            end

            it "returns the correct authorization header" do
                @authorized_request.headers["Authorization"].must_equal "PDX-HMAC-SHA256 Credential=1234567890, SignedHeaders=host;sample;x-pdx-date;x-pdx-displayname;x-pdx-emailaddress;x-pdx-expires;x-pdx-originator, Signature=e1fc00541454d11c58bae1273af56b528def5e60575feedbe0a9019b88fe1b79"
            end

        end

        describe "when using header signing mechanism and display_name contains non-ASCII characters" do

            before do
                normalized_request = Pandexio::Request.new(
                    :method => "PUT",
                    :path => "/asdf/qwer/1234/title",
                    :query_parameters => { "nonce" => "987654321", "Baseline" => "5" },
                    :headers => { "sample" => "example", "Host" => "localhost" },
                    :payload => "testing")

                signing_options = Pandexio::SigningOptions.new(
                    :algorithm => Pandexio::SigningAlgorithms::PDX_HMAC_SHA256,
                    :mechanism => Pandexio::SigningMechanisms::HEADER,
                    :domain_id => "1234567890",
                    :domain_key => "asdfjklqwerzxcv",
                    :date => Time.utc(2014, 11, 21, 13, 43, 15),
                    :expires => 90,
                    :originator => "HeaderSigningTest",
                    :email_address => "Anonymous",
                    :display_name => "á Anonymous")

                @authorized_request = Pandexio::to_authorized_request(normalized_request, signing_options)
            end

            it "returns the correct authorization header" do
                @authorized_request.headers["Authorization"].must_equal "PDX-HMAC-SHA256 Credential=1234567890, SignedHeaders=host;sample;x-pdx-date;x-pdx-displayname;x-pdx-emailaddress;x-pdx-expires;x-pdx-originator, Signature=347ac3df3930eaf2ba107c932e740dae5430a99f4fef76b18a4452d07125c209"
            end

        end

        describe "when using header signing mechanism and path contains spaces" do

            before do
                normalized_request = Pandexio::Request.new(
                    :method => "PUT",
                    :path => "/asdf/qwer/1234/title and description",
                    :query_parameters => { "nonce" => "987654321", "Baseline" => "5" },
                    :headers => { "sample" => "example", "Host" => "localhost" },
                    :payload => "testing")

                signing_options = Pandexio::SigningOptions.new(
                    :algorithm => Pandexio::SigningAlgorithms::PDX_HMAC_SHA256,
                    :mechanism => Pandexio::SigningMechanisms::HEADER,
                    :domain_id => "1234567890",
                    :domain_key => "asdfjklqwerzxcv",
                    :date => Time.utc(2014, 11, 21, 13, 43, 15),
                    :expires => 90,
                    :originator => "HeaderSigningTest",
                    :email_address => "Anonymous",
                    :display_name => "Anonymous")

                @authorized_request = Pandexio::to_authorized_request(normalized_request, signing_options)
            end

            it "returns the correct authorization header" do
                @authorized_request.headers["Authorization"].must_equal "PDX-HMAC-SHA256 Credential=1234567890, SignedHeaders=host;sample;x-pdx-date;x-pdx-displayname;x-pdx-emailaddress;x-pdx-expires;x-pdx-originator, Signature=e8946dbd83307f5bf86f7f152d6cee95426834dd5901588da84df1b8207e2bca"
            end

        end

        describe "when using header signing mechanism and payload contains non-ASCII characters" do

            before do
                normalized_request = Pandexio::Request.new(
                    :method => "PUT",
                    :path => "/asdf/qwer/1234/title",
                    :query_parameters => { "nonce" => "987654321", "Baseline" => "5" },
                    :headers => { "sample" => "example", "Host" => "localhost" },
                    :payload => "testing á")

                signing_options = Pandexio::SigningOptions.new(
                    :algorithm => Pandexio::SigningAlgorithms::PDX_HMAC_SHA256,
                    :mechanism => Pandexio::SigningMechanisms::HEADER,
                    :domain_id => "1234567890",
                    :domain_key => "asdfjklqwerzxcv",
                    :date => Time.utc(2014, 11, 21, 13, 43, 15),
                    :expires => 90,
                    :originator => "HeaderSigningTest",
                    :email_address => "Anonymous",
                    :display_name => "Anonymous")

                @authorized_request = Pandexio::to_authorized_request(normalized_request, signing_options)
            end

            it "returns the correct authorization header" do
                @authorized_request.headers["Authorization"].must_equal "PDX-HMAC-SHA256 Credential=1234567890, SignedHeaders=host;sample;x-pdx-date;x-pdx-displayname;x-pdx-emailaddress;x-pdx-expires;x-pdx-originator, Signature=fec62f69abbb53261dceaf1a52dab932e24e5f6e97f189da559562e14c13a9f7"
            end

        end

        describe "when using header signing mechanism and attributes include profile_image" do

            before do
                normalized_request = Pandexio::Request.new(
                    :method => "PUT",
                    :path => "/asdf/qwer/1234/title",
                    :query_parameters => { "nonce" => "987654321", "Baseline" => "5" },
                    :headers => { "sample" => "example", "Host" => "localhost" },
                    :payload => "testing")

                signing_options = Pandexio::SigningOptions.new(
                    :algorithm => Pandexio::SigningAlgorithms::PDX_HMAC_SHA256,
                    :mechanism => Pandexio::SigningMechanisms::HEADER,
                    :domain_id => "1234567890",
                    :domain_key => "asdfjklqwerzxcv",
                    :date => Time.utc(2014, 11, 21, 13, 43, 15),
                    :expires => 90,
                    :originator => "HeaderSigningTest",
                    :email_address => "Anonymous",
                    :display_name => "Anonymous",
                    :profile_image => "abcdefg")

                @authorized_request = Pandexio::to_authorized_request(normalized_request, signing_options)
            end

            it "returns the correct authorization header" do
                @authorized_request.headers["Authorization"].must_equal "PDX-HMAC-SHA256 Credential=1234567890, SignedHeaders=host;sample;x-pdx-date;x-pdx-displayname;x-pdx-emailaddress;x-pdx-expires;x-pdx-originator;x-pdx-profileimage, Signature=e7fb1de006519be4a1c778c3055f05dfa2fafb96fb1bc033a77ba4df4da8829d"
            end

        end

    end
end