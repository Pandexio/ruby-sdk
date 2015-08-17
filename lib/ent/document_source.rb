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

end