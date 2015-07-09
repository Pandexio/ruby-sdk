module Pandexio

    class SigningMechanisms

        QUERY_STRING = "QueryString"
        HEADER = "Header"

        def self.is_v(m)

            return !m.nil? && m.is_a?(String) &&
                   (m == QUERY_STRING || m == HEADER)

        end

    end

end