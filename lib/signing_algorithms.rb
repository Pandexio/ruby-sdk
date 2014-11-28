module Pandexio

  class SigningAlgorithms

    PDX_HMAC_MD5 = "PDX-HMAC-MD5"
    PDX_HMAC_SHA1 = "PDX-HMAC-SHA1"
    PDX_HMAC_SHA256 = "PDX-HMAC-SHA256"
    PDX_HMAC_SHA384 = "PDX-HMAC-SHA384"
    PDX_HMAC_SHA512 = "PDX-HMAC-SHA512"

    def self.is_v(a)

	  return !a.nil? && a.is_a?(String) &&
		(a == PDX_HMAC_MD5 ||
		a == PDX_HMAC_SHA1 ||
		a == PDX_HMAC_SHA256 ||
		a == PDX_HMAC_SHA384 ||
		a == PDX_HMAC_SHA512)

    end

    def self.to_d(a)

	  return case a
        when SigningAlgorithms::PDX_HMAC_MD5; Digest::MD5
        when SigningAlgorithms::PDX_HMAC_SHA1; Digest::SHA1
        when SigningAlgorithms::PDX_HMAC_SHA256; Digest::SHA256
        when SigningAlgorithms::PDX_HMAC_SHA384; Digest::SHA384
        when SigningAlgorithms::PDX_HMAC_SHA512; Digest::SHA512
        else raise 'Invalid signing algorithm'
        end

    end

  end

end