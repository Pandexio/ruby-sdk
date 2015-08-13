module Pandexio

    class ScopePatterns
        DOCUMENT_ID_PATTERN = /^[a-zA-Z0-9\-_]+$/i
        DOCUMENT_PATH_PATTERN = /(\/.*?documents\/)(?<documentid>[a-zA-Z0-9\-_]+)/i
    end

end