# encoding: utf-8

require 'time'
require 'uuid'
require 'minitest/autorun'
#require 'pandexio'
require_relative '../lib/http_client.rb'
require_relative '../lib/scope_patterns.rb'
require_relative '../lib/signing_options.rb'
require_relative '../lib/signing_algorithms.rb'
require_relative '../lib/signing_mechanisms.rb'

describe Pandexio::HttpClient do

    DOMAIN_ID = "<domain_id>"
    DOMAIN_KEY = "<domain_key>"

    describe "#load_document" do

        describe "when id is nil" do

            before do
                document_source = Pandexio::DocumentSource.new(:id => nil, :name => "test_name", :content => "test_content", :location => "Inline")
                signing_options = Pandexio::SigningOptions.new()
                http_client = Pandexio::HttpClient.new()
                @load_document = ->{ http_client.load_document(document_source, signing_options) }
            end

            it "should raise ArgumentError" do
                err = @load_document.must_raise ArgumentError
                err.message.must_match "Document ID is not a string, is nil or empty, or does not match RegEx pattern: #{Pandexio::ScopePatterns::DOCUMENT_ID_PATTERN}."
            end

        end

        describe "when id is empty" do

            before do
                document_source = Pandexio::DocumentSource.new(:id => "", :name => "test_name", :content => "test_content", :location => "Inline")
                signing_options = Pandexio::SigningOptions.new()
                http_client = Pandexio::HttpClient.new()
                @load_document = ->{ http_client.load_document(document_source, signing_options) }
            end

            it "should raise ArgumentError" do
                err = @load_document.must_raise ArgumentError
                err.message.must_match "Document ID is not a string, is nil or empty, or does not match RegEx pattern: #{Pandexio::ScopePatterns::DOCUMENT_ID_PATTERN}."
            end

        end

        describe "when id is blank" do

            before do
                document_source = Pandexio::DocumentSource.new(:id => " ", :name => "test_name", :content => "test_content", :location => "Inline")
                signing_options = Pandexio::SigningOptions.new()
                http_client = Pandexio::HttpClient.new()
                @load_document = ->{ http_client.load_document(document_source, signing_options) }
            end

            it "should raise ArgumentError" do
                err = @load_document.must_raise ArgumentError
                err.message.must_match "Document ID is not a string, is nil or empty, or does not match RegEx pattern: #{Pandexio::ScopePatterns::DOCUMENT_ID_PATTERN}."
            end

        end

        describe "when id is not a string" do

            before do
                document_source = Pandexio::DocumentSource.new(:id => 123, :name => "test_name", :content => "test_content", :location => "Inline")
                signing_options = Pandexio::SigningOptions.new()
                http_client = Pandexio::HttpClient.new()
                @load_document = ->{ http_client.load_document(document_source, signing_options) }
            end

            it "should raise ArgumentError" do
                err = @load_document.must_raise ArgumentError
                err.message.must_match "Document ID is not a string, is nil or empty, or does not match RegEx pattern: #{Pandexio::ScopePatterns::DOCUMENT_ID_PATTERN}."
            end

        end

        describe "when id does not match RegEx" do

            before do
                document_source = Pandexio::DocumentSource.new(:id => "123^%$*abc", :name => "test_name", :content => "test_content", :location => "Inline")
                signing_options = Pandexio::SigningOptions.new()
                http_client = Pandexio::HttpClient.new()
                @load_document = ->{ http_client.load_document(document_source, signing_options) }
            end

            it "should raise ArgumentError" do
                err = @load_document.must_raise ArgumentError
                err.message.must_match "Document ID is not a string, is nil or empty, or does not match RegEx pattern: #{Pandexio::ScopePatterns::DOCUMENT_ID_PATTERN}."
            end

        end

        describe "when name is nil" do

            before do
                document_source = Pandexio::DocumentSource.new(:id => "test_id", :name => nil, :content => "test_content", :location => "Inline")
                signing_options = Pandexio::SigningOptions.new()
                http_client = Pandexio::HttpClient.new()
                @load_document = ->{ http_client.load_document(document_source, signing_options) }
            end

            it "should raise ArgumentError" do
                err = @load_document.must_raise ArgumentError
                err.message.must_match "Document name is not a string or is nil or empty."
            end

        end

        describe "when name is empty" do

            before do
                document_source = Pandexio::DocumentSource.new(:id => "test_id", :name => "", :content => "test_content", :location => "Inline")
                signing_options = Pandexio::SigningOptions.new()
                http_client = Pandexio::HttpClient.new()
                @load_document = ->{ http_client.load_document(document_source, signing_options) }
            end

            it "should raise ArgumentError" do
                err = @load_document.must_raise ArgumentError
                err.message.must_match "Document name is not a string or is nil or empty."
            end

        end

        describe "when name is blank" do

            before do
                document_source = Pandexio::DocumentSource.new(:id => "test_id", :name => " ", :content => "test_content", :location => "Inline")
                signing_options = Pandexio::SigningOptions.new()
                http_client = Pandexio::HttpClient.new()
                @load_document = ->{ http_client.load_document(document_source, signing_options) }
            end

            it "should raise ArgumentError" do
                err = @load_document.must_raise ArgumentError
                err.message.must_match "Document name is not a string or is nil or empty."
            end

        end

        describe "when name is not a string" do

            before do
                document_source = Pandexio::DocumentSource.new(:id => "test_id", :name => 123, :content => "test_content", :location => "Inline")
                signing_options = Pandexio::SigningOptions.new()
                http_client = Pandexio::HttpClient.new()
                @load_document = ->{ http_client.load_document(document_source, signing_options) }
            end

            it "should raise ArgumentError" do
                err = @load_document.must_raise ArgumentError
                err.message.must_match "Document name is not a string or is nil or empty."
            end

        end

        describe "when content is nil" do

            before do
                document_source = Pandexio::DocumentSource.new(:id => "test_id", :name => "test_name", :content => nil, :location => "Inline")
                signing_options = Pandexio::SigningOptions.new()
                http_client = Pandexio::HttpClient.new()
                @load_document = ->{ http_client.load_document(document_source, signing_options) }
            end

            it "should raise ArgumentError" do
                err = @load_document.must_raise ArgumentError
                err.message.must_match "Document content is not a string or is nil or empty."
            end

        end

        describe "when content is empty" do

            before do
                document_source = Pandexio::DocumentSource.new(:id => "test_id", :name => "test_name", :content => "", :location => "Inline")
                signing_options = Pandexio::SigningOptions.new()
                http_client = Pandexio::HttpClient.new()
                @load_document = ->{ http_client.load_document(document_source, signing_options) }
            end

            it "should raise ArgumentError" do
                err = @load_document.must_raise ArgumentError
                err.message.must_match "Document content is not a string or is nil or empty."
            end

        end

        describe "when content is blank" do

            before do
                document_source = Pandexio::DocumentSource.new(:id => "test_id", :name => "test_name", :content => " ", :location => "Inline")
                signing_options = Pandexio::SigningOptions.new()
                http_client = Pandexio::HttpClient.new()
                @load_document = ->{ http_client.load_document(document_source, signing_options) }
            end

            it "should raise ArgumentError" do
                err = @load_document.must_raise ArgumentError
                err.message.must_match "Document content is not a string or is nil or empty."
            end

        end

        describe "when content is not a string" do

            before do
                document_source = Pandexio::DocumentSource.new(:id => "test_id", :name => "test_name", :content => 123, :location => "Inline")
                signing_options = Pandexio::SigningOptions.new()
                http_client = Pandexio::HttpClient.new()
                @load_document = ->{ http_client.load_document(document_source, signing_options) }
            end

            it "should raise ArgumentError" do
                err = @load_document.must_raise ArgumentError
                err.message.must_match "Document content is not a string or is nil or empty."
            end

        end

        describe "when location is not AWS" do

            before do
                document_source = Pandexio::DocumentSource.new(:id => "test_id", :name => "test_name", :content => "test_content", :location => "AUUS")
                signing_options = Pandexio::SigningOptions.new()
                http_client = Pandexio::HttpClient.new()
                @load_document = ->{ http_client.load_document(document_source, signing_options) }
            end

            it "should raise ArgumentError" do
                err = @load_document.must_raise ArgumentError
                err.message.must_match "Document location must be AWS, Azure, Internet, or Inline."
            end

        end

        describe "when content is data URL" do

            before do
                @id = UUID.new.generate
                document_source = Pandexio::DocumentSource.new(
                    :id => @id,
                    :name => "test_name_#{@id}.txt",
                    :content => "data:text/plain;base64,dGVzdGluZyAxMjM=",
                    :location => "Inline")
                signing_options = Pandexio::SigningOptions.new(
                    :algorithm => Pandexio::SigningAlgorithms::PDX_HMAC_SHA256,
                    :mechanism => Pandexio::SigningMechanisms::HEADER,
                    :domain_id => DOMAIN_ID,
                    :domain_key => DOMAIN_KEY,
                    :date => Time.now.utc,
                    :expires => 90,
                    :originator => "HttpClientTest",
                    :email_address => "HttpClientTest",
                    :display_name => "HttpClientTest")
                http_client = Pandexio::HttpClient.new()
                @load_document = ->{ http_client.load_document(document_source, signing_options) }
            end

            it "should return document details" do
                skip("skip integration tests")
                doc = @load_document.call
                doc.document_id.must_equal @id
                doc.name.must_equal "test_name_#{@id}.txt"
                doc.page_count.must_equal 1
                doc.content_type.must_equal "text/plain"
                doc.content_length.must_equal 11
                doc.cover[0..29].must_equal 'data:image/png;base64,iVBORw0K'
                doc.cover.length.must_equal 24846
            end

        end

        describe "when content is HTTP URL" do

            before do
                @id = UUID.new.generate
                document_source = Pandexio::DocumentSource.new(
                    :id => @id,
                    :name => "test_name_#{@id}.pdf",
                    :content => "http://martinfowler.com/ieeeSoftware/whenType.pdf",
                    :location => "Internet")
                signing_options = Pandexio::SigningOptions.new(
                    :algorithm => Pandexio::SigningAlgorithms::PDX_HMAC_SHA256,
                    :mechanism => Pandexio::SigningMechanisms::HEADER,
                    :domain_id => DOMAIN_ID,
                    :domain_key => DOMAIN_KEY,
                    :date => Time.now.utc,
                    :expires => 90,
                    :originator => "HttpClientTest",
                    :email_address => "HttpClientTest",
                    :display_name => "HttpClientTest")
                http_client = Pandexio::HttpClient.new()
                @load_document = ->{ http_client.load_document(document_source, signing_options) }
            end

            it "should return document details" do
                skip("skip integration tests")
                doc = @load_document.call
                doc.document_id.must_equal @id
                doc.name.must_equal "test_name_#{@id}.pdf"
                doc.page_count.must_equal 2
                doc.content_type.must_equal "application/pdf"
                doc.content_length.must_equal 289041
                doc.cover[0..29].must_equal 'data:image/png;base64,iVBORw0K'
                doc.cover.length.must_equal 436650
            end

        end
    end
end