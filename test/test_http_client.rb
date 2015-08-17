# encoding: utf-8

require 'minitest/autorun'
require 'time'
require 'uuid'
require "pandexio"

SKIP_INTEGRATION_TESTS = true
DOMAIN_ID = "<domain_id>"
DOMAIN_KEY = "<domain_key>"

describe Pandexio::HttpClient do
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
                skip("skip integration tests") if SKIP_INTEGRATION_TESTS
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
                skip("skip integration tests") if SKIP_INTEGRATION_TESTS
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

    describe "#get_document" do

        describe "when id is nil" do

            before do
                signing_options = Pandexio::SigningOptions.new()
                http_client = Pandexio::HttpClient.new()
                @get_document = ->{ http_client.get_document(nil, 'm', signing_options) }
            end

            it "should raise ArgumentError" do
                err = @get_document.must_raise ArgumentError
                err.message.must_match "Document ID is not a string, is nil or empty, or does not match RegEx pattern: #{Pandexio::ScopePatterns::DOCUMENT_ID_PATTERN}."
            end

        end

        describe "when id is empty" do

            before do
                signing_options = Pandexio::SigningOptions.new()
                http_client = Pandexio::HttpClient.new()
                @get_document = ->{ http_client.get_document("", 'm', signing_options) }
            end

            it "should raise ArgumentError" do
                err = @get_document.must_raise ArgumentError
                err.message.must_match "Document ID is not a string, is nil or empty, or does not match RegEx pattern: #{Pandexio::ScopePatterns::DOCUMENT_ID_PATTERN}."
            end

        end

        describe "when id is blank" do

            before do
                signing_options = Pandexio::SigningOptions.new()
                http_client = Pandexio::HttpClient.new()
                @get_document = ->{ http_client.get_document(" ", 'm', signing_options) }
            end

            it "should raise ArgumentError" do
                err = @get_document.must_raise ArgumentError
                err.message.must_match "Document ID is not a string, is nil or empty, or does not match RegEx pattern: #{Pandexio::ScopePatterns::DOCUMENT_ID_PATTERN}."
            end

        end

        describe "when id is not a string" do

            before do
                signing_options = Pandexio::SigningOptions.new()
                http_client = Pandexio::HttpClient.new()
                @get_document = ->{ http_client.get_document(123, 'm', signing_options) }
            end

            it "should raise ArgumentError" do
                err = @get_document.must_raise ArgumentError
                err.message.must_match "Document ID is not a string, is nil or empty, or does not match RegEx pattern: #{Pandexio::ScopePatterns::DOCUMENT_ID_PATTERN}."
            end

        end

        describe "when id does not match RegEx" do

            before do
                signing_options = Pandexio::SigningOptions.new()
                http_client = Pandexio::HttpClient.new()
                @get_document = ->{ http_client.get_document("123^%$*abc", 'm', signing_options) }
            end

            it "should raise ArgumentError" do
                err = @get_document.must_raise ArgumentError
                err.message.must_match "Document ID is not a string, is nil or empty, or does not match RegEx pattern: #{Pandexio::ScopePatterns::DOCUMENT_ID_PATTERN}."
            end

        end

        describe "when cover_size is invalid" do

            before do
                signing_options = Pandexio::SigningOptions.new()
                http_client = Pandexio::HttpClient.new()
                @get_document = ->{ http_client.get_document('test_id', 'abc', signing_options) }
            end

            it "should raise ArgumentError" do
                err = @get_document.must_raise ArgumentError
                err.message.must_match "Document cover size must be xs, s, m, l, or xl."
            end

        end

        describe "when document does not exist" do

            before do
                skip("skip integration tests") if SKIP_INTEGRATION_TESTS
                id = UUID.new.generate
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
                @get_document = ->{ http_client.get_document(id, 'm', signing_options) }
            end

            it "should return nil" do
                doc = @get_document.call
                doc.must_be_nil
            end

        end

        describe "when document exists" do

            before do
                skip("skip integration tests") if SKIP_INTEGRATION_TESTS
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
                http_client.load_document(document_source, signing_options)
                @get_document = ->{ http_client.get_document(@id, 'm', signing_options) }
            end

            it "should return document details" do
                doc = @get_document.call
                doc.document_id.must_equal @id
                doc.name.must_equal "test_name_#{@id}.txt"
                doc.page_count.must_equal 1
                doc.content_type.must_equal "text/plain"
                doc.content_length.must_equal 11
                doc.cover[0..29].must_equal 'data:image/png;base64,iVBORw0K'
                doc.cover.length.must_equal 2542
            end

        end

        describe "when cover size is xs" do

            before do
                skip("skip integration tests") if SKIP_INTEGRATION_TESTS
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
                http_client.load_document(document_source, signing_options)
                @get_document = ->{ http_client.get_document(@id, 'xs', signing_options) }
            end

            it "should return document details" do
                doc = @get_document.call
                doc.document_id.must_equal @id
                doc.name.must_equal "test_name_#{@id}.txt"
                doc.page_count.must_equal 1
                doc.content_type.must_equal "text/plain"
                doc.content_length.must_equal 11
                doc.cover[0..29].must_equal 'data:image/png;base64,iVBORw0K'
                doc.cover.length.must_equal 370
            end

        end

    end

    describe "#get_document_cover" do

        describe "when id is nil" do

            before do
                signing_options = Pandexio::SigningOptions.new()
                http_client = Pandexio::HttpClient.new()
                @get_document_cover = ->{ http_client.get_document_cover(nil, 'm', signing_options) }
            end

            it "should raise ArgumentError" do
                err = @get_document_cover.must_raise ArgumentError
                err.message.must_match "Document ID is not a string, is nil or empty, or does not match RegEx pattern: #{Pandexio::ScopePatterns::DOCUMENT_ID_PATTERN}."
            end

        end

        describe "when id is empty" do

            before do
                signing_options = Pandexio::SigningOptions.new()
                http_client = Pandexio::HttpClient.new()
                @get_document_cover = ->{ http_client.get_document_cover("", 'm', signing_options) }
            end

            it "should raise ArgumentError" do
                err = @get_document_cover.must_raise ArgumentError
                err.message.must_match "Document ID is not a string, is nil or empty, or does not match RegEx pattern: #{Pandexio::ScopePatterns::DOCUMENT_ID_PATTERN}."
            end

        end

        describe "when id is blank" do

            before do
                signing_options = Pandexio::SigningOptions.new()
                http_client = Pandexio::HttpClient.new()
                @get_document_cover = ->{ http_client.get_document_cover(" ", 'm', signing_options) }
            end

            it "should raise ArgumentError" do
                err = @get_document_cover.must_raise ArgumentError
                err.message.must_match "Document ID is not a string, is nil or empty, or does not match RegEx pattern: #{Pandexio::ScopePatterns::DOCUMENT_ID_PATTERN}."
            end

        end

        describe "when id is not a string" do

            before do
                signing_options = Pandexio::SigningOptions.new()
                http_client = Pandexio::HttpClient.new()
                @get_document_cover = ->{ http_client.get_document_cover(123, 'm', signing_options) }
            end

            it "should raise ArgumentError" do
                err = @get_document_cover.must_raise ArgumentError
                err.message.must_match "Document ID is not a string, is nil or empty, or does not match RegEx pattern: #{Pandexio::ScopePatterns::DOCUMENT_ID_PATTERN}."
            end

        end

        describe "when id does not match RegEx" do

            before do
                signing_options = Pandexio::SigningOptions.new()
                http_client = Pandexio::HttpClient.new()
                @get_document_cover = ->{ http_client.get_document_cover("123^%$*abc", 'm', signing_options) }
            end

            it "should raise ArgumentError" do
                err = @get_document_cover.must_raise ArgumentError
                err.message.must_match "Document ID is not a string, is nil or empty, or does not match RegEx pattern: #{Pandexio::ScopePatterns::DOCUMENT_ID_PATTERN}."
            end

        end

        describe "when cover_size is invalid" do

            before do
                signing_options = Pandexio::SigningOptions.new()
                http_client = Pandexio::HttpClient.new()
                @get_document_cover = ->{ http_client.get_document_cover('test_id', 'abc', signing_options) }
            end

            it "should raise ArgumentError" do
                err = @get_document_cover.must_raise ArgumentError
                err.message.must_match "Document cover size must be xs, s, m, l, or xl."
            end

        end

        describe "when document does not exist" do

            before do
                skip("skip integration tests") if SKIP_INTEGRATION_TESTS
                id = UUID.new.generate
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
                @get_document_cover = ->{ http_client.get_document_cover(id, 'm', signing_options) }
            end

            it "should return nil" do
                doc = @get_document_cover.call
                doc.must_be_nil
            end

        end

        describe "when cover size is xs" do

            before do
                skip("skip integration tests") if SKIP_INTEGRATION_TESTS
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
                http_client.load_document(document_source, signing_options)
                @get_document_cover = ->{ http_client.get_document_cover(@id, 'xs', signing_options) }
            end

            it "should return document details" do
                cover = @get_document_cover.call
                cover.length.must_equal 259
            end

        end

        describe "when cover size is s" do

            before do
                skip("skip integration tests") if SKIP_INTEGRATION_TESTS
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
                http_client.load_document(document_source, signing_options)
                @get_document_cover = ->{ http_client.get_document_cover(@id, 's', signing_options) }
            end

            it "should return document details" do
                cover = @get_document_cover.call
                cover.length.must_equal 808
            end

        end

        describe "when cover size is m" do

            before do
                skip("skip integration tests") if SKIP_INTEGRATION_TESTS
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
                http_client.load_document(document_source, signing_options)
                @get_document_cover = ->{ http_client.get_document_cover(@id, 'm', signing_options) }
            end

            it "should return document details" do
                cover = @get_document_cover.call
                cover.length.must_equal 1888
            end

        end

        describe "when cover size is l" do

            before do
                skip("skip integration tests") if SKIP_INTEGRATION_TESTS
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
                http_client.load_document(document_source, signing_options)
                @get_document_cover = ->{ http_client.get_document_cover(@id, 'l', signing_options) }
            end

            it "should return document details" do
                cover = @get_document_cover.call
                cover.length.must_equal 3726
            end

        end

        describe "when cover size is xl" do

            before do
                skip("skip integration tests") if SKIP_INTEGRATION_TESTS
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
                http_client.load_document(document_source, signing_options)
                @get_document_cover = ->{ http_client.get_document_cover(@id, 'xl', signing_options) }
            end

            it "should return document details" do
                cover = @get_document_cover.call
                cover.length.must_equal 7089
            end

        end

    end

    describe "#get_document_cover_url" do

        describe "when id is nil" do

            before do
                signing_options = Pandexio::SigningOptions.new()
                http_client = Pandexio::HttpClient.new()
                @get_document_cover_url = ->{ http_client.get_document_cover_url(nil, 'm', signing_options) }
            end

            it "should raise ArgumentError" do
                err = @get_document_cover_url.must_raise ArgumentError
                err.message.must_match "Document ID is not a string, is nil or empty, or does not match RegEx pattern: #{Pandexio::ScopePatterns::DOCUMENT_ID_PATTERN}."
            end

        end

        describe "when id is empty" do

            before do
                signing_options = Pandexio::SigningOptions.new()
                http_client = Pandexio::HttpClient.new()
                @get_document_cover_url = ->{ http_client.get_document_cover_url("", 'm', signing_options) }
            end

            it "should raise ArgumentError" do
                err = @get_document_cover_url.must_raise ArgumentError
                err.message.must_match "Document ID is not a string, is nil or empty, or does not match RegEx pattern: #{Pandexio::ScopePatterns::DOCUMENT_ID_PATTERN}."
            end

        end

        describe "when id is blank" do

            before do
                signing_options = Pandexio::SigningOptions.new()
                http_client = Pandexio::HttpClient.new()
                @get_document_cover_url = ->{ http_client.get_document_cover_url(" ", 'm', signing_options) }
            end

            it "should raise ArgumentError" do
                err = @get_document_cover_url.must_raise ArgumentError
                err.message.must_match "Document ID is not a string, is nil or empty, or does not match RegEx pattern: #{Pandexio::ScopePatterns::DOCUMENT_ID_PATTERN}."
            end

        end

        describe "when id is not a string" do

            before do
                signing_options = Pandexio::SigningOptions.new()
                http_client = Pandexio::HttpClient.new()
                @get_document_cover_url = ->{ http_client.get_document_cover_url(123, 'm', signing_options) }
            end

            it "should raise ArgumentError" do
                err = @get_document_cover_url.must_raise ArgumentError
                err.message.must_match "Document ID is not a string, is nil or empty, or does not match RegEx pattern: #{Pandexio::ScopePatterns::DOCUMENT_ID_PATTERN}."
            end

        end

        describe "when id does not match RegEx" do

            before do
                signing_options = Pandexio::SigningOptions.new()
                http_client = Pandexio::HttpClient.new()
                @get_document_cover_url = ->{ http_client.get_document_cover_url("123^%$*abc", 'm', signing_options) }
            end

            it "should raise ArgumentError" do
                err = @get_document_cover_url.must_raise ArgumentError
                err.message.must_match "Document ID is not a string, is nil or empty, or does not match RegEx pattern: #{Pandexio::ScopePatterns::DOCUMENT_ID_PATTERN}."
            end

        end

        describe "when cover_size is invalid" do

            before do
                signing_options = Pandexio::SigningOptions.new()
                http_client = Pandexio::HttpClient.new()
                @get_document_cover_url = ->{ http_client.get_document_cover_url('test_id', 'abc', signing_options) }
            end

            it "should raise ArgumentError" do
                err = @get_document_cover_url.must_raise ArgumentError
                err.message.must_match "Document cover size must be xs, s, m, l, or xl."
            end

        end

        describe "when signing_mechanism is Header" do

            before do
                id = UUID.new.generate
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
                @get_document_cover_url = ->{ http_client.get_document_cover_url(id, 'm', signing_options) }
            end

            it "should return nil" do
                err = @get_document_cover_url.must_raise ArgumentError
                err.message.must_match "Signing mechanism must be QueryString."
            end

        end

        describe "when cover size is xs" do

            before do
                @id = UUID.new.generate
                document_source = Pandexio::DocumentSource.new(
                    :id => @id,
                    :name => "test_name_#{@id}.txt",
                    :content => "data:text/plain;base64,dGVzdGluZyAxMjM=",
                    :location => "Inline")
                signing_options = Pandexio::SigningOptions.new(
                    :algorithm => Pandexio::SigningAlgorithms::PDX_HMAC_SHA256,
                    :mechanism => Pandexio::SigningMechanisms::QUERY_STRING,
                    :domain_id => DOMAIN_ID,
                    :domain_key => DOMAIN_KEY,
                    :date => Time.now.utc,
                    :expires => 90,
                    :originator => "HttpClientTest",
                    :email_address => "HttpClientTest",
                    :display_name => "HttpClientTest")
                http_client = Pandexio::HttpClient.new()
                @document_cover_url = http_client.get_document_cover_url(@id, 'xs', signing_options)
            end

            it "should return document details" do
                (@document_cover_url.include? "/v2/documents/#{@id}/cover").must_equal true
                (@document_cover_url.include? "coverSize=xs").must_equal true
                (@document_cover_url.include? "X-Pdx-Originator=HttpClientTest").must_equal true
                (@document_cover_url.include? "X-Pdx-EmailAddress=HttpClientTest").must_equal true
                (@document_cover_url.include? "X-Pdx-DisplayName=HttpClientTest").must_equal true
                (@document_cover_url.include? "X-Pdx-Expires=90").must_equal true
                (@document_cover_url.include? "X-Pdx-Credential=#{DOMAIN_ID}").must_equal true
                (@document_cover_url.include? "X-Pdx-Signature=").must_equal true
            end

        end

        describe "when cover size is s" do

            before do
                @id = UUID.new.generate
                document_source = Pandexio::DocumentSource.new(
                    :id => @id,
                    :name => "test_name_#{@id}.txt",
                    :content => "data:text/plain;base64,dGVzdGluZyAxMjM=",
                    :location => "Inline")
                signing_options = Pandexio::SigningOptions.new(
                    :algorithm => Pandexio::SigningAlgorithms::PDX_HMAC_SHA256,
                    :mechanism => Pandexio::SigningMechanisms::QUERY_STRING,
                    :domain_id => DOMAIN_ID,
                    :domain_key => DOMAIN_KEY,
                    :date => Time.now.utc,
                    :expires => 90,
                    :originator => "HttpClientTest",
                    :email_address => "HttpClientTest",
                    :display_name => "HttpClientTest")
                http_client = Pandexio::HttpClient.new()
                @document_cover_url = http_client.get_document_cover_url(@id, 's', signing_options)
            end

            it "should return document details" do
                (@document_cover_url.include? "/v2/documents/#{@id}/cover").must_equal true
                (@document_cover_url.include? "coverSize=s").must_equal true
                (@document_cover_url.include? "X-Pdx-Originator=HttpClientTest").must_equal true
                (@document_cover_url.include? "X-Pdx-EmailAddress=HttpClientTest").must_equal true
                (@document_cover_url.include? "X-Pdx-DisplayName=HttpClientTest").must_equal true
                (@document_cover_url.include? "X-Pdx-Expires=90").must_equal true
                (@document_cover_url.include? "X-Pdx-Credential=#{DOMAIN_ID}").must_equal true
                (@document_cover_url.include? "X-Pdx-Signature=").must_equal true
            end

        end

        describe "when cover size is m" do

            before do
                @id = UUID.new.generate
                document_source = Pandexio::DocumentSource.new(
                    :id => @id,
                    :name => "test_name_#{@id}.txt",
                    :content => "data:text/plain;base64,dGVzdGluZyAxMjM=",
                    :location => "Inline")
                signing_options = Pandexio::SigningOptions.new(
                    :algorithm => Pandexio::SigningAlgorithms::PDX_HMAC_SHA256,
                    :mechanism => Pandexio::SigningMechanisms::QUERY_STRING,
                    :domain_id => DOMAIN_ID,
                    :domain_key => DOMAIN_KEY,
                    :date => Time.now.utc,
                    :expires => 90,
                    :originator => "HttpClientTest",
                    :email_address => "HttpClientTest",
                    :display_name => "HttpClientTest")
                http_client = Pandexio::HttpClient.new()
                @document_cover_url = http_client.get_document_cover_url(@id, 'm', signing_options)
            end

            it "should return document details" do
                (@document_cover_url.include? "/v2/documents/#{@id}/cover").must_equal true
                (@document_cover_url.include? "coverSize=m").must_equal true
                (@document_cover_url.include? "X-Pdx-Originator=HttpClientTest").must_equal true
                (@document_cover_url.include? "X-Pdx-EmailAddress=HttpClientTest").must_equal true
                (@document_cover_url.include? "X-Pdx-DisplayName=HttpClientTest").must_equal true
                (@document_cover_url.include? "X-Pdx-Expires=90").must_equal true
                (@document_cover_url.include? "X-Pdx-Credential=#{DOMAIN_ID}").must_equal true
                (@document_cover_url.include? "X-Pdx-Signature=").must_equal true
            end

        end

        describe "when cover size is l" do

            before do
                @id = UUID.new.generate
                document_source = Pandexio::DocumentSource.new(
                    :id => @id,
                    :name => "test_name_#{@id}.txt",
                    :content => "data:text/plain;base64,dGVzdGluZyAxMjM=",
                    :location => "Inline")
                signing_options = Pandexio::SigningOptions.new(
                    :algorithm => Pandexio::SigningAlgorithms::PDX_HMAC_SHA256,
                    :mechanism => Pandexio::SigningMechanisms::QUERY_STRING,
                    :domain_id => DOMAIN_ID,
                    :domain_key => DOMAIN_KEY,
                    :date => Time.now.utc,
                    :expires => 90,
                    :originator => "HttpClientTest",
                    :email_address => "HttpClientTest",
                    :display_name => "HttpClientTest")
                http_client = Pandexio::HttpClient.new()
                @document_cover_url = http_client.get_document_cover_url(@id, 'l', signing_options)
            end

            it "should return document details" do
                (@document_cover_url.include? "/v2/documents/#{@id}/cover").must_equal true
                (@document_cover_url.include? "coverSize=l").must_equal true
                (@document_cover_url.include? "X-Pdx-Originator=HttpClientTest").must_equal true
                (@document_cover_url.include? "X-Pdx-EmailAddress=HttpClientTest").must_equal true
                (@document_cover_url.include? "X-Pdx-DisplayName=HttpClientTest").must_equal true
                (@document_cover_url.include? "X-Pdx-Expires=90").must_equal true
                (@document_cover_url.include? "X-Pdx-Credential=#{DOMAIN_ID}").must_equal true
                (@document_cover_url.include? "X-Pdx-Signature=").must_equal true
            end

        end

        describe "when cover size is xl" do

            before do
                @id = UUID.new.generate
                document_source = Pandexio::DocumentSource.new(
                    :id => @id,
                    :name => "test_name_#{@id}.txt",
                    :content => "data:text/plain;base64,dGVzdGluZyAxMjM=",
                    :location => "Inline")
                signing_options = Pandexio::SigningOptions.new(
                    :algorithm => Pandexio::SigningAlgorithms::PDX_HMAC_SHA256,
                    :mechanism => Pandexio::SigningMechanisms::QUERY_STRING,
                    :domain_id => DOMAIN_ID,
                    :domain_key => DOMAIN_KEY,
                    :date => Time.now.utc,
                    :expires => 90,
                    :originator => "HttpClientTest",
                    :email_address => "HttpClientTest",
                    :display_name => "HttpClientTest")
                http_client = Pandexio::HttpClient.new()
                @document_cover_url = http_client.get_document_cover_url(@id, 'xl', signing_options).to_s
            end

            it "should return document details" do
                (@document_cover_url.include? "/v2/documents/#{@id}/cover").must_equal true
                (@document_cover_url.include? "coverSize=xl").must_equal true
                (@document_cover_url.include? "X-Pdx-Originator=HttpClientTest").must_equal true
                (@document_cover_url.include? "X-Pdx-EmailAddress=HttpClientTest").must_equal true
                (@document_cover_url.include? "X-Pdx-DisplayName=HttpClientTest").must_equal true
                (@document_cover_url.include? "X-Pdx-Expires=90").must_equal true
                (@document_cover_url.include? "X-Pdx-Credential=#{DOMAIN_ID}").must_equal true
                (@document_cover_url.include? "X-Pdx-Signature=").must_equal true
            end

        end

    end

    describe "#get_document_snip_count" do

        describe "when id is nil" do

            before do
                signing_options = Pandexio::SigningOptions.new()
                http_client = Pandexio::HttpClient.new()
                @get_document_snip_count = ->{ http_client.get_document_snip_count(nil, signing_options) }
            end

            it "should raise ArgumentError" do
                err = @get_document_snip_count.must_raise ArgumentError
                err.message.must_match "Document ID is not a string, is nil or empty, or does not match RegEx pattern: #{Pandexio::ScopePatterns::DOCUMENT_ID_PATTERN}."
            end

        end

        describe "when id is empty" do

            before do
                signing_options = Pandexio::SigningOptions.new()
                http_client = Pandexio::HttpClient.new()
                @get_document_snip_count = ->{ http_client.get_document_snip_count("", signing_options) }
            end

            it "should raise ArgumentError" do
                err = @get_document_snip_count.must_raise ArgumentError
                err.message.must_match "Document ID is not a string, is nil or empty, or does not match RegEx pattern: #{Pandexio::ScopePatterns::DOCUMENT_ID_PATTERN}."
            end

        end

        describe "when id is blank" do

            before do
                signing_options = Pandexio::SigningOptions.new()
                http_client = Pandexio::HttpClient.new()
                @get_document_snip_count = ->{ http_client.get_document_snip_count(" ", signing_options) }
            end

            it "should raise ArgumentError" do
                err = @get_document_snip_count.must_raise ArgumentError
                err.message.must_match "Document ID is not a string, is nil or empty, or does not match RegEx pattern: #{Pandexio::ScopePatterns::DOCUMENT_ID_PATTERN}."
            end

        end

        describe "when id is not a string" do

            before do
                signing_options = Pandexio::SigningOptions.new()
                http_client = Pandexio::HttpClient.new()
                @get_document_snip_count = ->{ http_client.get_document_snip_count(123, signing_options) }
            end

            it "should raise ArgumentError" do
                err = @get_document_snip_count.must_raise ArgumentError
                err.message.must_match "Document ID is not a string, is nil or empty, or does not match RegEx pattern: #{Pandexio::ScopePatterns::DOCUMENT_ID_PATTERN}."
            end

        end

        describe "when id does not match RegEx" do

            before do
                signing_options = Pandexio::SigningOptions.new()
                http_client = Pandexio::HttpClient.new()
                @get_document_snip_count = ->{ http_client.get_document_snip_count("123^%$*abc", signing_options) }
            end

            it "should raise ArgumentError" do
                err = @get_document_snip_count.must_raise ArgumentError
                err.message.must_match "Document ID is not a string, is nil or empty, or does not match RegEx pattern: #{Pandexio::ScopePatterns::DOCUMENT_ID_PATTERN}."
            end

        end

        describe "when document does not exist" do

            before do
                skip("skip integration tests") if SKIP_INTEGRATION_TESTS
                id = UUID.new.generate
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
                @get_document_snip_count = ->{ http_client.get_document_snip_count(id, signing_options) }
            end

            it "should return ." do
                count = @get_document_snip_count.call
                count.must_equal 0
            end

        end

        describe "when document exists" do

            before do
                skip("skip integration tests") if SKIP_INTEGRATION_TESTS
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
                http_client.load_document(document_source, signing_options)
                @get_document_snip_count = ->{ http_client.get_document_snip_count(@id, signing_options) }
            end

            it "should return document details" do
                count = @get_document_snip_count.call
                count.must_equal 0
            end

        end

    end
end