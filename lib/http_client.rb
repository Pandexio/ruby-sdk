require 'net/http'
require 'json'
require_relative 'request.rb'
require_relative 'scope_patterns.rb'
require_relative 'signer.rb'

module Pandexio

    class DocumentSource

        def initialize(params = {})
            @id = params.fetch(:id, nil)
            @name = params.fetch(:name, nil)
            @content = params.fetch(:content, nil)
            @location = params.fetch(:location, nil)
        end

        attr_accessor :id
        attr_accessor :name
        attr_accessor :content
        attr_accessor :location

    end

    class Document

        def initialize(params = {})
            @document_id = params.fetch(:document_id, nil)
            @name = params.fetch(:name, nil)
            @page_count = params.fetch(:page_count, nil)
            @content_type = params.fetch(:content_type, nil)
            @content_length = params.fetch(:content_length, nil)
            @cover = params.fetch(:cover, nil)
        end

        attr_accessor :document_id
        attr_accessor :name
        attr_accessor :page_count
        attr_accessor :content_type
        attr_accessor :content_length
        attr_accessor :cover

    end

    class HttpClient

        def load_document(source_document, signing_options)

            raise ArgumentError, "Document source is nil." if source_document.nil?
            raise ArgumentError, "Signing options is nil." if signing_options.nil?

            id = source_document.id.to_s
            name = source_document.name.to_s
            content = source_document.content.to_s
            location = source_document.location.to_s

            raise ArgumentError, "Document ID is not a string, is nil or empty, or does not match RegEx pattern: #{Pandexio::ScopePatterns::DOCUMENT_ID_PATTERN}." if !source_document.id.is_a?(String) || id.nil? || id.empty? || !id.strip!.nil? || id.match(Pandexio::ScopePatterns::DOCUMENT_ID_PATTERN).nil?
            raise ArgumentError, "Document name is not a string or is nil or empty." if !source_document.name.is_a?(String) || name.nil? || name.empty? || !name.strip!.nil?
            raise ArgumentError, "Document content is not a string or is nil or empty." if !source_document.content.is_a?(String) || content.nil? || content.empty? || !content.strip!.nil?
            raise ArgumentError, "Document location must be AWS, Azure, Internet, or Inline." unless location == "AWS" || location == "Azure" || location == "Internet" || location == "Inline"

            host = "testhosted.pandexio.com"
            path = "/api/documents/#{id}"
            payload = {
                "name" => name,
                "content" => content,
                "location" => location
            }.to_json

            normalized_request = Pandexio::Request.new(
                    :method => "PUT",
                    :path => path,
                    :query_parameters => { },
                    :headers => { "Host" => host },
                    :payload => payload)

            signer = Pandexio::Signer.new()

            authorized_request = signer.sign(normalized_request, signing_options)

            headers = {'Content-Type' => 'application/json; charset=utf-8'}
            authorized_request.headers.each do |key, value|
                headers[key] = value.to_s
            end

            http = Net::HTTP.new(host, 443)
            http.use_ssl = true
            http.open_timeout = 60
            http.read_timeout = 600

            req = Net::HTTP::Put.new(path, initheader = headers)
            req.body = payload
            res = http.start {|http| http.request(req)}

            case res.code
                when "202"
                    data = JSON.parse(res.body)
                    document = Pandexio::Document.new(
                        :document_id => data['documentId'],
                        :name => data['name'],
                        :page_count => data['pageCount'],
                        :content_type => data['contentType'],
                        :content_length => data['contentLength'],
                        :cover => data['cover'])
                else
                    raise StandardError, "Failed to load document."
            end

        end

    end

end