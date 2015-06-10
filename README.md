#Pandexio SDK for Ruby
========

##Overview
This Pandexio SDK enables Ruby server applications to easily generate signed requests that can be consumed by the Pandexio REST API (https://platform.pandexio.com) and the Pandexio Hosted Model (https://hosted.pandexio.com).

##Signing a Request

Take the following steps to create a signed Pandexio request.

1. Create an instance of Pandexio::Request containing details of the request to be made, the *normalized_request*.
2. Create an instance of Pandexio::SigningOptions. These *signing_options* specify the SDK will sign the request.
3. Call Pandexio::to_authorized_request, passing in the *normalized_request* and the *signing_options*.
4. Build an HTTP request using the Pandexio::Request, *authorized_request*, returned by Pandexio::to_authorized_request and make the HTTP request using the HTTP client of choice.

##Definitions

###Pandexio::Request
- type - class
- attributes:
  - method - required. The request HTTP verb (GET, POST, PUT, PATCH, DELETE).
  - path - required. The path part of the request URL (e.g., /v2/documents/a4df7a95-d1f6-4664-b208-74568990bd15).
  - query_parameters - optional. A hash containing the query parameters (e.g., { "coverSize" => "xl" }).
  - headers - required. A hash containing the headers (e.g., { "Host" => "platform.pandexio.com" }). Host header must be included.
  - payload - optional. UTF-8 encoded request body. Only applicable for POST, PUT, and PATCH requests.

###Pandexio::SigningOptions
- type - class
- attributes:
  - algorithm - required. The HMAC algorithm to use. Choose from any specified in 
    - Pandexio::SigningAlgorithms::PDX_HMAC_MD5 - MD5 HMAC
    - Pandexio::SigningAlgorithms::PDX_HMAC_SHA1 - SHA1 HMAC
    - Pandexio::SigningAlgorithms::PDX_HMAC_SHA256 - SHA256 HMAC
    - Pandexio::SigningAlgorithms::PDX_HMAC_SHA384 - SHA384 HMAC
    - Pandexio::SigningAlgorithms::PDX_HMAC_SHA512 - SHA512 HMAC
  - mechanism - required. Specifies which signing mechanism to use. Signing mechanisms include:
    - Pandexio::SigningMechanisms::QUERY_STRING - Sign the request using query string parameters
    - Pandexio::SigningMechanisms::HEADER - Sign the request using headers
  - domain_id - required. Public API key.
  - domain_key - required. Shared secret API key used to generate HMAC signatures.
  - date - required. ISO8601 date/time when the request was made.
  - expires - required. Number of seconds before the request signature expires.
  - originator - required. The name of the application, feature, etc. making the request.
  - email_address - required. The email address of the user making the request.
  - display_name - required. The display name of the user making the request.
  - profile_image - optional. The profile image thumbnail, either data URL or HTTP URL of the user making the request.

###Pandexio::to_authorized_request
- type - method
- arguments
  - Pandexio::Request *normalized_request* - A non-signed request containing information about the request to be made.
  - Pandexio::SigningOptions *signing_options* - The details specifying how to sign the *normalized_request*
- result
  - Pandexio::Request *authorized_request* - A signed request containing information about the request to be made as well as signing information as headers or query string parameters, depending on the *signing_options*.

##All Together
Here's an example showing the generation of a signed Pandexio request to retrieve an extra large document cover thumbnail for a given document:

```ruby
require 'pandexio'

normalized_request = Pandexio::Request.new(
  :method => "GET",
  :path => "/v2/documents/a4df7a95-d1f6-4664-b208-74568990bd15/cover",
  :query_parameters => { "coverSize" => "xl" },
  :headers => { "Host" => "platform.pandexio.com" })

signing_options = Pandexio::SigningOptions.new(
  :algorithm => Pandexio::SigningAlgorithms::PDX_HMAC_SHA256,
  :mechanism => Pandexio::SigningMechanisms::QUERY_STRING,
  :domain_id => "1234567890",
  :domain_key => "asdfjklqwerzxcv",
  :date => Time.utc(2015, 6, 10, 13, 22, 46),
  :expires => 90,
  :originator => "Demo",
  :email_address => "terry@contoso.com",
  :display_name => "Terry Contoso")

authorized_request = Pandexio::to_authorized_request(normalized_request, signing_options)
```
