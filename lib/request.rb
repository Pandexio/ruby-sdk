module Pandexio

    class Request

        def initialize(params = {})
            @method = params.fetch(:method, nil)
            @path = params.fetch(:path, nil)
            @query_parameters = params.fetch(:query_parameters, {})
            @headers = params.fetch(:headers, {})
            @payload = params.fetch(:payload, nil)
        end

        attr_accessor :method
        attr_accessor :path
        attr_accessor :query_parameters
        attr_accessor :headers
        attr_accessor :payload

        def to_s
            "#{@method} #{@path}#{LINE_BREAK}query_parameters: #{query_parameters}#{LINE_BREAK}headers: #{headers}#{LINE_BREAK}payload: #{payload}"
        end

    end

end