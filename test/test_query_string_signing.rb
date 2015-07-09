# encoding: utf-8

require 'minitest/autorun'
require 'pandexio'

describe Pandexio do
    describe "#to_authorized_request" do

        describe "when using query string signing mechanism to generate a new authorized_request from a given normalized_request" do

            before do
                @normalized_request = Pandexio::Request.new(
                    :method => "PUT",
                    :path => "/asdf/qwer/1234/title",
                    :query_parameters => { "nonce" => "987654321", "Baseline" => "5" },
                    :headers => { "sample" => "example", "Host" => "localhost" },
                    :payload => "testing")

                signing_options = Pandexio::SigningOptions.new(
                    :algorithm => Pandexio::SigningAlgorithms::PDX_HMAC_SHA256,
                    :mechanism => Pandexio::SigningMechanisms::QUERY_STRING,
                    :domain_id => "1234567890",
                    :domain_key => "asdfjklqwerzxcv",
                    :date => Time.utc(2014, 11, 21, 13, 43, 15),
                    :expires => 90,
                    :originator => "QueryStringSigningTest",
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

        describe "when using query string signing mechanism to sign an authorized_request" do

            before do
                normalized_request = Pandexio::Request.new(
                    :method => "PUT",
                    :path => "/asdf/qwer/1234/title",
                    :query_parameters => { "nonce" => "987654321", "Baseline" => "5" },
                    :headers => { "sample" => "example", "Host" => "localhost" },
                    :payload => "testing")

                signing_options = Pandexio::SigningOptions.new(
                    :algorithm => Pandexio::SigningAlgorithms::PDX_HMAC_SHA256,
                    :mechanism => Pandexio::SigningMechanisms::QUERY_STRING,
                    :domain_id => "1234567890",
                    :domain_key => "asdfjklqwerzxcv",
                    :date => Time.utc(2014, 11, 21, 13, 43, 15),
                    :expires => 90,
                    :originator => "QueryStringSigningTest",
                    :email_address => "Anonymous",
                    :display_name => "Anonymous")

                @authorized_request = Pandexio::to_authorized_request(normalized_request, signing_options)
                @authorized_request = Pandexio::to_authorized_request(@authorized_request, signing_options)
            end

            it "returns the correct algorithm as a query parameter" do
                @authorized_request.query_parameters["X-Pdx-Algorithm"].must_equal "PDX-HMAC-SHA256"
            end
            it "returns the correct credential as a query parameter" do
                @authorized_request.query_parameters["X-Pdx-Credential"].must_equal "1234567890"
            end
            it "returns the correct signed_headers value as a query parameter" do
                @authorized_request.query_parameters["X-Pdx-SignedHeaders"].must_equal "host;sample"
            end
            it "returns the correct signature as a query parameter" do
                @authorized_request.query_parameters["X-Pdx-Signature"].must_equal "6ab83c6a331ba2d684d2557f1e415f3aee86bee105da1f5ad1bc4cc1cdf42f1a"
            end

        end

        describe "when using query string signing mechanism and email_address contains uppercase and lowercase characters" do

            before do
                normalized_request = Pandexio::Request.new(
                    :method => "PUT",
                    :path => "/asdf/qwer/1234/title",
                    :query_parameters => { "nonce" => "987654321", "Baseline" => "5" },
                    :headers => { "sample" => "example", "Host" => "localhost" },
                    :payload => "testing")

                signing_options = Pandexio::SigningOptions.new(
                    :algorithm => Pandexio::SigningAlgorithms::PDX_HMAC_SHA256,
                    :mechanism => Pandexio::SigningMechanisms::QUERY_STRING,
                    :domain_id => "1234567890",
                    :domain_key => "asdfjklqwerzxcv",
                    :date => Time.utc(2014, 11, 21, 13, 43, 15),
                    :expires => 90,
                    :originator => "QueryStringSigningTest",
                    :email_address => "Anonymous",
                    :display_name => "Anonymous")

                @authorized_request = Pandexio::to_authorized_request(normalized_request, signing_options)
            end

            it "returns the correct algorithm as a query parameter" do
                @authorized_request.query_parameters["X-Pdx-Algorithm"].must_equal "PDX-HMAC-SHA256"
            end
            it "returns the correct credential as a query parameter" do
                @authorized_request.query_parameters["X-Pdx-Credential"].must_equal "1234567890"
            end
            it "returns the correct signed_headers value as a query parameter" do
                @authorized_request.query_parameters["X-Pdx-SignedHeaders"].must_equal "host;sample"
            end
            it "returns the correct signature as a query parameter" do
                @authorized_request.query_parameters["X-Pdx-Signature"].must_equal "6ab83c6a331ba2d684d2557f1e415f3aee86bee105da1f5ad1bc4cc1cdf42f1a"
            end

        end

        describe "when using query string signing mechanism and email_address contains only lowercase characters" do

            before do
                normalized_request = Pandexio::Request.new(
                    :method => "PUT",
                    :path => "/asdf/qwer/1234/title",
                    :query_parameters => { "nonce" => "987654321", "Baseline" => "5" },
                    :headers => { "sample" => "example", "Host" => "localhost" },
                    :payload => "testing")

                signing_options = Pandexio::SigningOptions.new(
                    :algorithm => Pandexio::SigningAlgorithms::PDX_HMAC_SHA256,
                    :mechanism => Pandexio::SigningMechanisms::QUERY_STRING,
                    :domain_id => "1234567890",
                    :domain_key => "asdfjklqwerzxcv",
                    :date => Time.utc(2014, 11, 21, 13, 43, 15),
                    :expires => 90,
                    :originator => "QueryStringSigningTest",
                    :email_address => "anonymous",
                    :display_name => "Anonymous")

                @authorized_request = Pandexio::to_authorized_request(normalized_request, signing_options)
            end

            it "returns the correct algorithm as a query parameter" do
                @authorized_request.query_parameters["X-Pdx-Algorithm"].must_equal "PDX-HMAC-SHA256"
            end
            it "returns the correct credential as a query parameter" do
                @authorized_request.query_parameters["X-Pdx-Credential"].must_equal "1234567890"
            end
            it "returns the correct signed_headers value as a query parameter" do
                @authorized_request.query_parameters["X-Pdx-SignedHeaders"].must_equal "host;sample"
            end
            it "returns the correct signature as a query parameter" do
                @authorized_request.query_parameters["X-Pdx-Signature"].must_equal "4a8516231d42bf673e0660cebd81112f9540994856b2173daf2829b4897e3ada"
            end

        end

        describe "when using query string signing mechanism and email_address contains only uppercase characters" do

            before do
                normalized_request = Pandexio::Request.new(
                    :method => "PUT",
                    :path => "/asdf/qwer/1234/title",
                    :query_parameters => { "nonce" => "987654321", "Baseline" => "5" },
                    :headers => { "sample" => "example", "Host" => "localhost" },
                    :payload => "testing")

                signing_options = Pandexio::SigningOptions.new(
                    :algorithm => Pandexio::SigningAlgorithms::PDX_HMAC_SHA256,
                    :mechanism => Pandexio::SigningMechanisms::QUERY_STRING,
                    :domain_id => "1234567890",
                    :domain_key => "asdfjklqwerzxcv",
                    :date => Time.utc(2014, 11, 21, 13, 43, 15),
                    :expires => 90,
                    :originator => "QueryStringSigningTest",
                    :email_address => "ANONYMOUS",
                    :display_name => "Anonymous")

                @authorized_request = Pandexio::to_authorized_request(normalized_request, signing_options)
            end

            it "returns the correct algorithm as a query parameter" do
                @authorized_request.query_parameters["X-Pdx-Algorithm"].must_equal "PDX-HMAC-SHA256"
            end
            it "returns the correct credential as a query parameter" do
                @authorized_request.query_parameters["X-Pdx-Credential"].must_equal "1234567890"
            end
            it "returns the correct signed_headers value as a query parameter" do
                @authorized_request.query_parameters["X-Pdx-SignedHeaders"].must_equal "host;sample"
            end
            it "returns the correct signature as a query parameter" do
                @authorized_request.query_parameters["X-Pdx-Signature"].must_equal "8d549c05c925b92b609f9746be57acf944cdb13749de084d3d21daebb91b0c0a"
            end

        end

        describe "when using query string signing mechanism and display_name contains spaces" do

            before do
                normalized_request = Pandexio::Request.new(
                    :method => "PUT",
                    :path => "/asdf/qwer/1234/title",
                    :query_parameters => { "nonce" => "987654321", "Baseline" => "5" },
                    :headers => { "sample" => "example", "Host" => "localhost" },
                    :payload => "testing")

                signing_options = Pandexio::SigningOptions.new(
                    :algorithm => Pandexio::SigningAlgorithms::PDX_HMAC_SHA256,
                    :mechanism => Pandexio::SigningMechanisms::QUERY_STRING,
                    :domain_id => "1234567890",
                    :domain_key => "asdfjklqwerzxcv",
                    :date => Time.utc(2014, 11, 21, 13, 43, 15),
                    :expires => 90,
                    :originator => "QueryStringSigningTest",
                    :email_address => "Anonymous",
                    :display_name => "A. Anonymous")

                @authorized_request = Pandexio::to_authorized_request(normalized_request, signing_options)
            end

            it "returns the correct algorithm as a query parameter" do
                @authorized_request.query_parameters["X-Pdx-Algorithm"].must_equal "PDX-HMAC-SHA256"
            end
            it "returns the correct credential as a query parameter" do
                @authorized_request.query_parameters["X-Pdx-Credential"].must_equal "1234567890"
            end
            it "returns the correct signed_headers value as a query parameter" do
                @authorized_request.query_parameters["X-Pdx-SignedHeaders"].must_equal "host;sample"
            end
            it "returns the correct signature as a query parameter" do
                @authorized_request.query_parameters["X-Pdx-Signature"].must_equal "bcc1e6b33cd7f84316dc9cfd428a1d9161fd575de55d7e86008fb33664f43ac7"
            end

        end

        describe "when using query string signing mechanism and display_name contains non-ASCII characters" do

            before do
                normalized_request = Pandexio::Request.new(
                    :method => "PUT",
                    :path => "/asdf/qwer/1234/title",
                    :query_parameters => { "nonce" => "987654321", "Baseline" => "5" },
                    :headers => { "sample" => "example", "Host" => "localhost" },
                    :payload => "testing")

                signing_options = Pandexio::SigningOptions.new(
                    :algorithm => Pandexio::SigningAlgorithms::PDX_HMAC_SHA256,
                    :mechanism => Pandexio::SigningMechanisms::QUERY_STRING,
                    :domain_id => "1234567890",
                    :domain_key => "asdfjklqwerzxcv",
                    :date => Time.utc(2014, 11, 21, 13, 43, 15),
                    :expires => 90,
                    :originator => "QueryStringSigningTest",
                    :email_address => "Anonymous",
                    :display_name => "á Anonymous")

                @authorized_request = Pandexio::to_authorized_request(normalized_request, signing_options)
            end

            it "returns the correct algorithm as a query parameter" do
                @authorized_request.query_parameters["X-Pdx-Algorithm"].must_equal "PDX-HMAC-SHA256"
            end
            it "returns the correct credential as a query parameter" do
                @authorized_request.query_parameters["X-Pdx-Credential"].must_equal "1234567890"
            end
            it "returns the correct signed_headers value as a query parameter" do
                @authorized_request.query_parameters["X-Pdx-SignedHeaders"].must_equal "host;sample"
            end
            it "returns the correct signature as a query parameter" do
                @authorized_request.query_parameters["X-Pdx-Signature"].must_equal "1f008f205bff02f7a62c2bf9f630f9506c794524f51a37ce4140c1587ad90616"
            end

        end

        describe "when using query string signing mechanism and path contains spaces" do

            before do
                normalized_request = Pandexio::Request.new(
                    :method => "PUT",
                    :path => "/asdf/qwer/1234/title and description",
                    :query_parameters => { "nonce" => "987654321", "Baseline" => "5" },
                    :headers => { "sample" => "example", "Host" => "localhost" },
                    :payload => "testing")

                signing_options = Pandexio::SigningOptions.new(
                    :algorithm => Pandexio::SigningAlgorithms::PDX_HMAC_SHA256,
                    :mechanism => Pandexio::SigningMechanisms::QUERY_STRING,
                    :domain_id => "1234567890",
                    :domain_key => "asdfjklqwerzxcv",
                    :date => Time.utc(2014, 11, 21, 13, 43, 15),
                    :expires => 90,
                    :originator => "QueryStringSigningTest",
                    :email_address => "Anonymous",
                    :display_name => "Anonymous")

                @authorized_request = Pandexio::to_authorized_request(normalized_request, signing_options)
            end

            it "returns the correct algorithm as a query parameter" do
                @authorized_request.query_parameters["X-Pdx-Algorithm"].must_equal "PDX-HMAC-SHA256"
            end
            it "returns the correct credential as a query parameter" do
                @authorized_request.query_parameters["X-Pdx-Credential"].must_equal "1234567890"
            end
            it "returns the correct signed_headers value as a query parameter" do
                @authorized_request.query_parameters["X-Pdx-SignedHeaders"].must_equal "host;sample"
            end
            it "returns the correct signature as a query parameter" do
                @authorized_request.query_parameters["X-Pdx-Signature"].must_equal "9cbd539d41fe31394b11b848970cc127b514dadb9d52223c4dcab5089a86ae44"
            end

        end

        describe "when using query string signing mechanism and payload contains non-ASCII characters" do

            before do
                normalized_request = Pandexio::Request.new(
                    :method => "PUT",
                    :path => "/asdf/qwer/1234/title",
                    :query_parameters => { "nonce" => "987654321", "Baseline" => "5" },
                    :headers => { "sample" => "example", "Host" => "localhost" },
                    :payload => "testing á")

                signing_options = Pandexio::SigningOptions.new(
                    :algorithm => Pandexio::SigningAlgorithms::PDX_HMAC_SHA256,
                    :mechanism => Pandexio::SigningMechanisms::QUERY_STRING,
                    :domain_id => "1234567890",
                    :domain_key => "asdfjklqwerzxcv",
                    :date => Time.utc(2014, 11, 21, 13, 43, 15),
                    :expires => 90,
                    :originator => "QueryStringSigningTest",
                    :email_address => "Anonymous",
                    :display_name => "Anonymous")

                @authorized_request = Pandexio::to_authorized_request(normalized_request, signing_options)
            end

            it "returns the correct algorithm as a query parameter" do
                @authorized_request.query_parameters["X-Pdx-Algorithm"].must_equal "PDX-HMAC-SHA256"
            end
            it "returns the correct credential as a query parameter" do
                @authorized_request.query_parameters["X-Pdx-Credential"].must_equal "1234567890"
            end
            it "returns the correct signed_headers value as a query parameter" do
                @authorized_request.query_parameters["X-Pdx-SignedHeaders"].must_equal "host;sample"
            end
            it "returns the correct signature as a query parameter" do
                @authorized_request.query_parameters["X-Pdx-Signature"].must_equal "5155764a11094d8bfe4ebca3b0c87e8547636bd5391948fd2f2f2afa634ffabb"
            end

        end

        describe "when using query string signing mechanism and attributes include profile image" do

            before do
                normalized_request = Pandexio::Request.new(
                    :method => "PUT",
                    :path => "/asdf/qwer/1234/title",
                    :query_parameters => { "nonce" => "987654321", "Baseline" => "5" },
                    :headers => { "sample" => "example", "Host" => "localhost" },
                    :payload => "testing")

                signing_options = Pandexio::SigningOptions.new(
                    :algorithm => Pandexio::SigningAlgorithms::PDX_HMAC_SHA256,
                    :mechanism => Pandexio::SigningMechanisms::QUERY_STRING,
                    :domain_id => "1234567890",
                    :domain_key => "asdfjklqwerzxcv",
                    :date => Time.utc(2014, 11, 21, 13, 43, 15),
                    :expires => 90,
                    :originator => "QueryStringSigningTest",
                    :email_address => "Anonymous",
                    :display_name => "Anonymous",
                    :profile_image => "abcdefg")

                @authorized_request = Pandexio::to_authorized_request(normalized_request, signing_options)
            end

            it "returns the correct algorithm as a query parameter" do
                @authorized_request.query_parameters["X-Pdx-Algorithm"].must_equal "PDX-HMAC-SHA256"
            end
            it "returns the correct credential as a query parameter" do
                @authorized_request.query_parameters["X-Pdx-Credential"].must_equal "1234567890"
            end
            it "returns the correct signed_headers value as a query parameter" do
                @authorized_request.query_parameters["X-Pdx-SignedHeaders"].must_equal "host;sample"
            end
            it "returns the correct signature as a query parameter" do
                @authorized_request.query_parameters["X-Pdx-Signature"].must_equal "ead72d2e09c2a74b9712178f43eb68eed1c3877b206b221507eb8a1a82b67c77"
            end

        end

    end
end