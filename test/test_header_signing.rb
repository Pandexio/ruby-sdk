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
      :mechanism => Pandexio::SigningMechanisms::HEADER,
      #:mechanism => Pandexio::SigningMechanisms::QUERY_STRING,
      :domain_id => "1234567890",
      :domain_key => "asdfjklqwerzxcv",
      :date => date,
      :expires => 90,
      :email_address => "Anonymous",
      :display_name => "Anonymous")

    @authorized_request = Pandexio::to_authorized_request(normalized_request, signing_options)
  end

  describe "#header_signing" do
    it "returns the correct authorization header" do
      @authorized_request.headers["Authorization"].must_equal "PDX-HMAC-SHA256 Credential=1234567890, SignedHeaders=host;sample;x-pdx-date;x-pdx-displayname;x-pdx-emailaddress;x-pdx-expires, Signature=0216b89e5103e39996f3f1bf71ed27855c6031ad87db197327627ee2130f102b"
    end
  end
end