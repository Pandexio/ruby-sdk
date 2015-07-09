# encoding: utf-8

require 'minitest/autorun'
require 'pandexio'

describe Pandexio::Signer do
    describe "#scope_and_sign" do

        describe "when path contains a document_id" do

            before do
                normalized_request = Pandexio::Request.new(
                    :method => "PUT",
                    :path => "/asdf/documents/123/title",
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

                signer = Pandexio::Signer.new()

                @scope, authorized_request = signer.scope_and_sign(normalized_request, signing_options)
            end

            it "extracts document_id" do
                @scope.document_ids.count.must_equal 1
                @scope.document_ids[0].must_equal "123"
            end

        end

        describe "when query string contains document_ids" do

            before do
                normalized_request = Pandexio::Request.new(
                    :method => "PUT",
                    :path => "/asdf/qwer/1234/title",
                    :query_parameters => { "nonce" => "987654321", "Baseline" => "5", "documentIds" => "456,789" },
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

                signer = Pandexio::Signer.new()

                @scope, authorized_request = signer.scope_and_sign(normalized_request, signing_options)
            end

            it "extracts document_id" do
                @scope.document_ids.count.must_equal 2
                @scope.document_ids[0].must_equal "456"
                @scope.document_ids[1].must_equal "789"
            end

        end

        describe "when path contains a document_id and query string contains document_ids" do

            before do
                normalized_request = Pandexio::Request.new(
                    :method => "PUT",
                    :path => "/asdf/documents/123/title",
                    :query_parameters => { "nonce" => "987654321", "Baseline" => "5", "documentIds" => "456,789" },
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

                signer = Pandexio::Signer.new()

                @scope, authorized_request = signer.scope_and_sign(normalized_request, signing_options)
            end

            it "extracts document_id" do
                @scope.document_ids.count.must_equal 3
                @scope.document_ids[0].must_equal "123"
                @scope.document_ids[1].must_equal "456"
                @scope.document_ids[2].must_equal "789"
            end

        end

    end
end