require 'time'
require 'stringio'
require 'digest/hmac'
require_relative 'request.rb'
require_relative 'signing_algorithms.rb'
require_relative 'signing_attributes.rb'
require_relative 'signing_mechanisms.rb'
require_relative 'signing_options.rb'

module Pandexio

  LINE_BREAK = "\r\n"
  private_constant :LINE_BREAK
  
  private
  
  def self.append_metadata(parameters, signing_options)

      parameters[SigningAttributes::DATE] = signing_options.date.iso8601
      parameters[SigningAttributes::EXPIRES] = signing_options.expires
      parameters[SigningAttributes::NAME] = signing_options.name
      parameters[SigningAttributes::DISPLAY_NAME] = signing_options.display_name

      if !signing_options.thumbnail.nil? && signing_options.thumbnail.is_a?(String) && !signing_options.thumbnail.empty?
        parameters[SigningAttributes::THUMBNAIL] = signing_options.thumbnail
      end

  end

  def self.ordinal_sort(a, b)

    a_codepoints, b_codepoints = a[0].codepoints, b[0].codepoints

    max_i = [a_codepoints.size, b_codepoints.size].min

    for i in 0..max_i
      a_codepoint = a_codepoints[i]
      b_codepoint = b_codepoints[i]
      return -1 if a_codepoint < b_codepoint
      return 1 if a_codepoint > b_codepoint
    end

    return 0

  end

  def self.build_canonical_query_string(query_parameters)

    temp_query_parameters = query_parameters.dup

    query_sort = ->(a,b) { ordinal_sort(a, b) }
    temp_query_parameters = temp_query_parameters.sort(&query_sort)

    canonical_query_string = StringIO.new

    temp_query_parameters.each do |key, value|
      canonical_query_string << "&" if canonical_query_string.length > 0
      canonical_query_string << "#{key}=#{value}" unless key == SigningAttributes::SIGNATURE
    end

    return canonical_query_string.string

  end

  def self.build_canonical_headers(headers)

    temp_headers = {}

    headers.each do |key, value|
      temp_headers[key.downcase.strip] = value
    end

    header_sort = ->(a,b) { ordinal_sort(a, b) }
    temp_headers = temp_headers.sort(&header_sort)

    canonical_headers, signed_headers = StringIO.new, StringIO.new

    temp_headers.each do |key, value|
      canonical_headers << LINE_BREAK if canonical_headers.length > 0
      canonical_headers << "#{key}:#{value}"
      signed_headers << ";" if signed_headers.length > 0
      signed_headers << "#{key}"
    end

    return canonical_headers.string, signed_headers.string

  end

  def self.generate_signature(domain_key, algorithm, date, request)

    digest = case algorithm
      when SigningAlgorithms::PDX_HMAC_MD5; Digest::MD5
      when SigningAlgorithms::PDX_HMAC_SHA1; Digest::SHA1
      when SigningAlgorithms::PDX_HMAC_SHA256; Digest::SHA256
      when SigningAlgorithms::PDX_HMAC_SHA384; Digest::SHA384
      when SigningAlgorithms::PDX_HMAC_SHA512; Digest::SHA512
      else raise 'Invalid signing algorithm'
    end

    # create canonical request
    canonical_query_string = build_canonical_query_string(request.query_parameters)
    canonical_headers, signed_headers = build_canonical_headers(request.headers)
    canonical_payload = digest.hexdigest(request.payload)
    canonical_request = "#{request.method}#{LINE_BREAK}#{request.path}#{LINE_BREAK}#{canonical_query_string}#{LINE_BREAK}#{canonical_headers}#{LINE_BREAK}#{signed_headers}#{LINE_BREAK}#{canonical_payload}"

    # create string to sign
    string_to_sign = "#{algorithm}#{LINE_BREAK}#{date.iso8601}#{LINE_BREAK}#{canonical_request}"

    # generate signature
    signature = Digest::HMAC.hexdigest(string_to_sign, domain_key, digest)

    return signature, signed_headers

  end

  public

  def self.to_authorized_request(normalized_request, signing_options)

    raise ArgumentError, 'normalized_request must be of type Pandexio::Request and cannot be nil' unless !normalized_request.nil? && normalized_request.is_a?(Request)
    raise ArgumentError, 'normalized_request.query_parameters must be of type Hash and cannot be nil' unless !normalized_request.query_parameters.nil? && normalized_request.query_parameters.is_a?(Hash)
    raise ArgumentError, 'normalized_request.headers must be of type Hash and cannot be nil' unless !normalized_request.headers.nil? && normalized_request.headers.is_a?(Hash)
    raise ArgumentError, 'normalized_request already contains authorization details' unless
      normalized_request.query_parameters[SigningAttributes::SIGNATURE].nil? &&
      normalized_request.headers[SigningAttributes::AUTHORIZATION].nil?
    raise ArgumentError, 'signing_options must be of type Pandexio::SigningOptions cannot be nil' unless !signing_options.nil? && signing_options.is_a?(SigningOptions)
    raise ArgumentError, 'signing_options.domain_id must be of type String and cannot be nil or empty' unless !signing_options.domain_id.nil? && signing_options.domain_id.is_a?(String) && !signing_options.domain_id.empty?
    raise ArgumentError, 'signing_options.domain_key must be of type String and cannot be nil or empty' unless !signing_options.domain_key.nil? && signing_options.domain_key.is_a?(String) && !signing_options.domain_key.empty?
    raise ArgumentError, 'signing_options.algorithm must be of type String and cannot be nil or empty' unless !signing_options.algorithm.nil? && signing_options.algorithm.is_a?(String) && !signing_options.algorithm.empty?
    raise ArgumentError, 'signing_options.mechanism must be of type String and cannot be nil or empty' unless !signing_options.mechanism.nil? && signing_options.mechanism.is_a?(String) && !signing_options.mechanism.empty?
    raise ArgumentError, 'signing_options.date must be of type Time and cannot be nil' unless !signing_options.date.nil? && signing_options.date.is_a?(Time)
    raise ArgumentError, 'signing_options.expires must be of type Fixnum and cannot be nil or empty' unless !signing_options.expires.nil? && signing_options.expires.is_a?(Fixnum) && signing_options.expires > 0
    raise ArgumentError, 'signing_options.name must be of type String and cannot be nil or empty' unless !signing_options.name.nil? && signing_options.name.is_a?(String)  && !signing_options.name.empty?
    raise ArgumentError, 'signing_options.display_name must be of type String and cannot be nil or empty' unless !signing_options.display_name.nil? && signing_options.display_name.is_a?(String)  && !signing_options.display_name.empty?

    authorized_request = normalized_request.dup

    signature, signed_headers = generate_signature(signing_options.domain_key, signing_options.algorithm, signing_options.date, authorized_request)

    if signing_options.mechanism == SigningMechanisms::QUERY_STRING

      append_metadata(authorized_request.query_parameters, signing_options)

      authorized_request.query_parameters[SigningAttributes::ALGORITHM] = signing_options.algorithm
      authorized_request.query_parameters[SigningAttributes::CREDENTIAL] = signing_options.domain_id
      authorized_request.query_parameters[SigningAttributes::SIGNED_HEADERS] = signed_headers
      authorized_request.query_parameters[SigningAttributes::SIGNATURE] = signature

    elsif signing_options.mechanism == SigningMechanisms::HEADER

      append_metadata(authorized_request.headers, signing_options)

      authorized_request.headers[SigningAttributes::AUTHORIZATION] = "#{signing_options.algorithm} Credential=#{signing_options.domain_id}, SignedHeaders=#{signed_headers}, Signature=#{signature}"

    else

      raise "signing_options.mechanism must be either 'QueryString' or 'Headers'"

    end

    return authorized_request

  end

end