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
    ORIGINATOR = "X-Pdx-Originator"
    EMAIL_ADDRESS = "X-Pdx-EmailAddress"
    DISPLAY_NAME = "X-Pdx-DisplayName"
    PROFILE_IMAGE = "X-Pdx-ProfileImage"
  end

end