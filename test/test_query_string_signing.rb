require 'minitest/autorun'
require_relative '../lib/module.rb'

describe Pandexio do
  before do
    normalized_request = Pandexio::Request.new(
      :method => "PUT",
      :path => "/asdf/qwer/1234/title",
      :query_parameters => { "nonce" => "987654321", "Baseline" => "5" },
      :headers => { "sample" => "example", "Host" => "localhost" },
      :payload => "testing")

    date = Time.utc(2014, 11, 21, 13, 43, 15)

    signing_options = Pandexio::SigningOptions.new(
      :algorithm => Pandexio::SigningAlgorithms::PDX_HMAC_SHA256,
      #:mechanism => Pandexio::SigningMechanisms::HEADER,
      :mechanism => Pandexio::SigningMechanisms::QUERY_STRING,
      :domain_id => "1234567890",
      :domain_key => "asdfjklqwerzxcv",
      :date => date,
      :expires => 90,
      :email_address => "Anonymous",
      :display_name => "Anonymous")

    @authorized_request = Pandexio::to_authorized_request(normalized_request, signing_options)
  end

  describe "#query_string_signing" do
    it "returns the correct algorithm as a query parameter" do
      @authorized_request.query_parameters["X-Pdx-Algorithm"].must_equal "PDX-HMAC-SHA256"
    end
    it "returns the correct credential as a query parameter" do
      @authorized_request.query_parameters["X-Pdx-Credential"].must_equal "1234567890"
    end
    it "returns the correct signed_headers value as a query parameter" do
      @authorized_request.query_parameters["X-Pdx-SignedHeaders"].must_equal "host;sample"
    end
    it "returns the correct signature as a query parameter" do
      @authorized_request.query_parameters["X-Pdx-Signature"].must_equal "d86919fe9e52bcf00e903963566cabcd7d4432c8315bad0eda5edf103ac6317f"
    end
  end
end