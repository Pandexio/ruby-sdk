module Pandexio

    class SigningOptions
        def initialize(params = {})
            @algorithm = params.fetch(:algorithm, nil)
            @mechanism = params.fetch(:mechanism, nil)
            @domain_id = params.fetch(:domain_id, nil)
            @domain_key = params.fetch(:domain_key, nil)
            @date = params.fetch(:date, nil)
            @expires = params.fetch(:expires, nil)
            @originator = params.fetch(:originator, nil)
            @email_address = params.fetch(:email_address, nil)
            @display_name = params.fetch(:display_name, nil)
            @profile_image = params.fetch(:profile_image, nil)
        end

        attr_accessor :algorithm
        attr_accessor :mechanism
        attr_accessor :domain_id
        attr_accessor :domain_key
        attr_accessor :date
        attr_accessor :expires
        attr_accessor :originator
        attr_accessor :email_address
        attr_accessor :display_name
        attr_accessor :profile_image

    end

end