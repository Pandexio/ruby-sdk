require 'net/http'
require 'json'
require 'stringio'
require 'open-uri'
require_relative 'request.rb'
require_relative 'signing_options.rb'
require_relative 'signer.rb'
require_relative 'scope_patterns.rb'
require_relative 'signing_algorithms.rb'
require_relative 'signing_mechanisms.rb'
require_relative 'ent/document_source.rb'
require_relative 'ent/document.rb'

module Pandexio

    class HttpClient

        HOSTED_HOST = "hosted.pandexio.com"
        PLATFORM_HOST = "platform.pandexio.com"

        private

        def build_headers(headers, content_type)

            items = {'Content-Type' => content_type}

            headers.each do |key, value|
                items[key] = value.to_s
            end

            return items
        end

        def build_query_string(query_parameters)

            query_string_builder = StringIO.new

            query_parameters.each do |key, value|
                query_string_builder << "&" if query_string_builder.length > 0
                encodedKey = URI::encode(key.to_s)
                encodedValue = URI::encode(value.to_s)
                query_string_builder << "#{encodedKey}=#{encodedValue}"
            end

            return query_string_builder.string
        end

        public

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
                :headers => { "Host" => HOSTED_HOST },
                :payload => payload)

            signer = Pandexio::Signer.new()

            authorized_request = signer.sign(normalized_request, signing_options)

            headers = build_headers(authorized_request.headers, 'application/json; charset=utf-8')
            query_string = build_query_string(authorized_request.query_parameters)

            http = Net::HTTP.new(HOSTED_HOST, 443)
            http.use_ssl = true
            http.open_timeout = 60
            http.read_timeout = 600

            req = Net::HTTP::Put.new("#{path}?#{query_string}", initheader = headers)
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

        def get_document(document_id, cover_size, signing_options)

            raise ArgumentError, "Signing options is nil." if signing_options.nil?

            id = document_id.to_s

            raise ArgumentError, "Document ID is not a string, is nil or empty, or does not match RegEx pattern: #{Pandexio::ScopePatterns::DOCUMENT_ID_PATTERN}." if !document_id.is_a?(String) || id.nil? || id.empty? || !id.strip!.nil? || id.match(Pandexio::ScopePatterns::DOCUMENT_ID_PATTERN).nil?
            raise ArgumentError, "Document cover size must be xs, s, m, l, or xl." unless cover_size == 'xs' || cover_size == 's' || cover_size == 'm' || cover_size == 'l' || cover_size == 'xl'

            path = "/v2/documents/#{id}"

            normalized_request = Pandexio::Request.new(
                :method => "GET",
                :path => path,
                :query_parameters => { "coverSize" => cover_size },
                :headers => { "Host" => PLATFORM_HOST },
                :payload => '')

            signer = Pandexio::Signer.new()

            authorized_request = signer.sign(normalized_request, signing_options)

            headers = build_headers(authorized_request.headers, 'application/json; charset=utf-8')
            query_string = build_query_string(authorized_request.query_parameters)

            http = Net::HTTP.new(PLATFORM_HOST, 443)
            http.use_ssl = true
            http.open_timeout = 60
            http.read_timeout = 120

            req = Net::HTTP::Get.new("#{path}?#{query_string}", initheader = headers)
            res = http.start {|http| http.request(req)}

            case res.code
                when "200"
                    data = JSON.parse(res.body)
                    document = Pandexio::Document.new(
                        :document_id => data['documentId'],
                        :name => data['name'],
                        :page_count => data['pageCount'],
                        :content_type => data['contentType'],
                        :content_length => data['contentLength'],
                        :cover => data['cover'])
                when "404"
                    return nil
                else
                    raise StandardError, "Failed to get document."
            end

        end

        def get_document_cover(document_id, cover_size, signing_options)

            raise ArgumentError, "Signing options is nil." if signing_options.nil?

            id = document_id.to_s

            raise ArgumentError, "Document ID is not a string, is nil or empty, or does not match RegEx pattern: #{Pandexio::ScopePatterns::DOCUMENT_ID_PATTERN}." if !document_id.is_a?(String) || id.nil? || id.empty? || !id.strip!.nil? || id.match(Pandexio::ScopePatterns::DOCUMENT_ID_PATTERN).nil?
            raise ArgumentError, "Document cover size must be xs, s, m, l, or xl." unless cover_size == 'xs' || cover_size == 's' || cover_size == 'm' || cover_size == 'l' || cover_size == 'xl'

            path = "/v2/documents/#{id}/cover"

            normalized_request = Pandexio::Request.new(
                :method => "GET",
                :path => path,
                :query_parameters => { "coverSize" => cover_size },
                :headers => { "Host" => PLATFORM_HOST },
                :payload => '')

            signer = Pandexio::Signer.new()

            authorized_request = signer.sign(normalized_request, signing_options)

            headers = build_headers(authorized_request.headers, 'image/png')
            query_string = build_query_string(authorized_request.query_parameters)

            http = Net::HTTP.new(PLATFORM_HOST, 443)
            http.use_ssl = true
            http.open_timeout = 60
            http.read_timeout = 120

            req = Net::HTTP::Get.new("#{path}?#{query_string}", initheader = headers)
            res = http.start {|http| http.request(req)}

            case res.code
                when "200"
                    return res.body
                when "404"
                    return nil
                else
                    raise StandardError, "Failed to get document cover."
            end

        end

        def get_document_cover_url(document_id, cover_size, signing_options)

            id = document_id.to_s

            raise ArgumentError, "Document ID is not a string, is nil or empty, or does not match RegEx pattern: #{Pandexio::ScopePatterns::DOCUMENT_ID_PATTERN}." if !document_id.is_a?(String) || id.nil? || id.empty? || !id.strip!.nil? || id.match(Pandexio::ScopePatterns::DOCUMENT_ID_PATTERN).nil?
            raise ArgumentError, "Document cover size must be xs, s, m, l, or xl." unless cover_size == 'xs' || cover_size == 's' || cover_size == 'm' || cover_size == 'l' || cover_size == 'xl'

            raise ArgumentError, "Signing options is nil." if signing_options.nil?
            raise ArgumentError, "Signing mechanism must be QueryString." unless signing_options.mechanism == Pandexio::SigningMechanisms::QUERY_STRING

            path = "/v2/documents/#{id}/cover"

            normalized_request = Pandexio::Request.new(
                :method => "GET",
                :path => path,
                :query_parameters => { "coverSize" => cover_size },
                :headers => { "Host" => PLATFORM_HOST },
                :payload => '')

            signer = Pandexio::Signer.new()

            authorized_request = signer.sign(normalized_request, signing_options)

            query_string = build_query_string(authorized_request.query_parameters)

            return "https://#{PLATFORM_HOST}#{path}?#{query_string}"

        end

        def get_document_snip_count(document_id, signing_options)

            raise ArgumentError, "Signing options is nil." if signing_options.nil?

            id = document_id.to_s

            raise ArgumentError, "Document ID is not a string, is nil or empty, or does not match RegEx pattern: #{Pandexio::ScopePatterns::DOCUMENT_ID_PATTERN}." if !document_id.is_a?(String) || id.nil? || id.empty? || !id.strip!.nil? || id.match(Pandexio::ScopePatterns::DOCUMENT_ID_PATTERN).nil?

            path = "/v2/documents/#{id}/snips/count"

            normalized_request = Pandexio::Request.new(
                :method => "GET",
                :path => path,
                :query_parameters => {},
                :headers => { "Host" => PLATFORM_HOST },
                :payload => '')

            signer = Pandexio::Signer.new()

            authorized_request = signer.sign(normalized_request, signing_options)

            headers = build_headers(authorized_request.headers, 'application/json; charset=utf-8')
            query_string = build_query_string(authorized_request.query_parameters)

            http = Net::HTTP.new(PLATFORM_HOST, 443)
            http.use_ssl = true

            req = Net::HTTP::Get.new("#{path}?#{query_string}", initheader = headers)
            res = http.start {|http| http.request(req)}

            case res.code
                when "200"
                    return res.body.to_i
                else
                    raise StandardError, "Failed to get document snip count."
            end

        end

    end

end