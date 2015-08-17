module Pandexio

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

end