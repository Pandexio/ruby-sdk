module Pandexio

  class SigningAttributes
    # Used by "headers" only
    AUTHORIZATION = "Authorization"

    # Used by "query_parameters" only
    ALGORITHM = "X-Pdx-Algorithm"
    CREDENTIAL = "X-Pdx-Credential"
    SIGNED_HEADERS = "X-Pdx-SignedHeaders"
    SIGNATURE = "X-Pdx-Signature"

    # Used by "headers" and "query_parameters"
    DATE = "X-Pdx-Date"
    EXPIRES = "X-Pdx-Expires"
    EMAIL_ADDRESS = "X-Pdx-EmailAddress"
    DISPLAY_NAME = "X-Pdx-DisplayName"
    THUMBNAIL = "X-Pdx-Thumbnail"
  end

end