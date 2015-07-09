require_relative 'signer.rb'

module Pandexio

    def self.to_authorized_request(normalized_request, signing_options)

        signer = Pandexio::Signer.new()

        authorized_request = signer.sign(normalized_request, signing_options)

        return authorized_request

    end

end