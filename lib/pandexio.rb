require 'time'
require 'stringio'
require 'openssl'
require_relative 'request.rb'
require_relative 'signing_algorithms.rb'
require_relative 'signing_attributes.rb'
require_relative 'signing_mechanisms.rb'
require_relative 'signing_options.rb'

module Pandexio

  LINE_BREAK = "\r\n"
  private_constant :LINE_BREAK
  
  private

  def self.ordinal_key_value_sort(a, b)

    a_codepoints, b_codepoints = a[0].codepoints.to_a, b[0].codepoints.to_a

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

    temp_query_parameters = temp_query_parameters.sort { |a, b| ordinal_key_value_sort(a, b) }

    canonical_query_string = StringIO.new

    temp_query_parameters.each do |key, value|
      next if key == SigningAttributes::ALGORITHM || key == SigningAttributes::CREDENTIAL || key == SigningAttributes::SIGNED_HEADERS || key == SigningAttributes::SIGNATURE
      canonical_query_string << "&" if canonical_query_string.length > 0
      canonical_query_string << "#{key}=#{value}"
    end

    return canonical_query_string.string

  end

  def self.build_canonical_headers(headers)

    temp_headers = {}

    headers.each do |key, value|
      next if key == SigningAttributes::AUTHORIZATION
      temp_headers[key.downcase.strip] = value
    end

    temp_headers = temp_headers.sort { |a, b| ordinal_key_value_sort(a, b) }

    canonical_headers, signed_headers = StringIO.new, StringIO.new

    temp_headers.each do |key, value|
      next if key == SigningAttributes::AUTHORIZATION
      canonical_headers << LINE_BREAK if canonical_headers.length > 0
      canonical_headers << "#{key}:#{value}"
      signed_headers << ";" if signed_headers.length > 0
      signed_headers << "#{key}"
    end

    return canonical_headers.string, signed_headers.string

  end

  def self.build_canonical_payload(payload, digest)
    canonical_payload = digest.hexdigest(payload).encode('UTF-8')
    return canonical_payload;
  end

  def self.build_canonical_request(request, digest)
    canonical_query_string = build_canonical_query_string(request.query_parameters)
    canonical_headers, signed_headers = build_canonical_headers(request.headers)
    canonical_payload = build_canonical_payload(request.payload, digest)
    canonical_request = "#{request.method}#{LINE_BREAK}#{request.path}#{LINE_BREAK}#{canonical_query_string}#{LINE_BREAK}#{canonical_headers}#{LINE_BREAK}#{signed_headers}#{LINE_BREAK}#{canonical_payload}"
    return canonical_request, signed_headers
  end

  def self.build_string_to_sign(canonical_request, signing_options)
    signing_string = "#{signing_options.algorithm}#{LINE_BREAK}#{signing_options.date.iso8601}#{LINE_BREAK}#{canonical_request}".encode('UTF-8')
    return signing_string
  end

  def self.generate_signature(string_to_sign, signing_options, digest)
    return OpenSSL::HMAC.hexdigest(digest, signing_options.domain_key, string_to_sign)
  end

  public

  def self.to_authorized_request(normalized_request, signing_options)

    raise ArgumentError, 'normalized_request must be of type Pandexio::Request and cannot be nil' unless !normalized_request.nil? && normalized_request.is_a?(Request)
    raise ArgumentError, 'normalized_request.query_parameters must be of type Hash and cannot be nil' unless !normalized_request.query_parameters.nil? && normalized_request.query_parameters.is_a?(Hash)
    raise ArgumentError, 'normalized_request.headers must be of type Hash and cannot be nil' unless !normalized_request.headers.nil? && normalized_request.headers.is_a?(Hash)

    raise ArgumentError, 'signing_options must be of type Pandexio::SigningOptions cannot be nil' unless !signing_options.nil? && signing_options.is_a?(SigningOptions)
    raise ArgumentError, 'signing_options.domain_id must be of type String and cannot be nil or empty' unless !signing_options.domain_id.nil? && signing_options.domain_id.is_a?(String) && !signing_options.domain_id.empty?
    raise ArgumentError, 'signing_options.domain_key must be of type String and cannot be nil or empty' unless !signing_options.domain_key.nil? && signing_options.domain_key.is_a?(String) && !signing_options.domain_key.empty?
    raise ArgumentError, 'signing_options.algorithm must be of type String and cannot be nil or empty' unless SigningAlgorithms.is_v(signing_options.algorithm)
    raise ArgumentError, 'signing_options.mechanism must be a valid signing mechanism' unless SigningMechanisms.is_v(signing_options.mechanism)
    raise ArgumentError, 'signing_options.date must be of type Time and cannot be nil' unless !signing_options.date.nil? && signing_options.date.is_a?(Time)
    raise ArgumentError, 'signing_options.expires must be of type Fixnum and cannot be nil or empty' unless !signing_options.expires.nil? && signing_options.expires.is_a?(Fixnum) && signing_options.expires > 0
    raise ArgumentError, 'signing_options.originator must be of type String and cannot be nil or empty' unless !signing_options.originator.nil? && signing_options.originator.is_a?(String)  && !signing_options.originator.empty?
    raise ArgumentError, 'signing_options.email_address must be of type String and cannot be nil or empty' unless !signing_options.email_address.nil? && signing_options.email_address.is_a?(String)  && !signing_options.email_address.empty?
    raise ArgumentError, 'signing_options.display_name must be of type String and cannot be nil or empty' unless !signing_options.display_name.nil? && signing_options.display_name.is_a?(String)  && !signing_options.display_name.empty?

    authorized_request = normalized_request.dup

    append = lambda { |p|
      p[SigningAttributes::DATE] = signing_options.date.iso8601
      p[SigningAttributes::EXPIRES] = signing_options.expires
      p[SigningAttributes::ORIGINATOR] = signing_options.originator
      p[SigningAttributes::EMAIL_ADDRESS] = signing_options.email_address
      p[SigningAttributes::DISPLAY_NAME] = signing_options.display_name
      p[SigningAttributes::PROFILE_IMAGE] = signing_options.profile_image if !signing_options.profile_image.nil? && signing_options.profile_image.is_a?(String) && !signing_options.profile_image.empty?
    }

    append.call(
      signing_options.mechanism == SigningMechanisms::QUERY_STRING ? authorized_request.query_parameters :
      signing_options.mechanism == SigningMechanisms::HEADER ? authorized_request.headers : {})
    
    digest = SigningAlgorithms.to_d(signing_options.algorithm)
    canonical_request, signed_headers = build_canonical_request(authorized_request, digest)
    string_to_sign = build_string_to_sign(canonical_request, signing_options)
    signature = generate_signature(string_to_sign, signing_options, digest)

    if signing_options.mechanism == SigningMechanisms::QUERY_STRING
      authorized_request.query_parameters[SigningAttributes::ALGORITHM] = signing_options.algorithm
      authorized_request.query_parameters[SigningAttributes::CREDENTIAL] = signing_options.domain_id
      authorized_request.query_parameters[SigningAttributes::SIGNED_HEADERS] = signed_headers
      authorized_request.query_parameters[SigningAttributes::SIGNATURE] = signature
    elsif signing_options.mechanism == SigningMechanisms::HEADER
      authorized_request.headers[SigningAttributes::AUTHORIZATION] = "#{signing_options.algorithm} Credential=#{signing_options.domain_id}, SignedHeaders=#{signed_headers}, Signature=#{signature}"
    end

    return authorized_request

  end

end