module Pandexio

    class Scope

        def initialize(params = {})
            @document_ids = params.fetch(:document_ids, [])
        end

        attr_accessor :document_ids

    end

end