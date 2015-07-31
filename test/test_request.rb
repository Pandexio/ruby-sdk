# encoding: utf-8

require "minitest/autorun"
require "pandexio"

describe Pandexio::Request do
    describe "#initialize" do

        describe "when passing no params" do

            before do
                @request = Pandexio::Request.new()
            end

            it "should initialize method as nil" do
                assert_nil(@request.method)
            end

            it "should initialize path as nil" do
                assert_nil(@request.path)
            end

            it "should initialize query_parameters as an empty hash" do
                @request.query_parameters.count.must_equal(0)
            end

            it "should initialize headers as an empty hash" do
                @request.headers.count.must_equal(0)
            end

            it "should initialize payload as nil" do
                assert_nil(@request.payload)
            end

        end

        describe "when passing params" do

            before do
                @request = Pandexio::Request.new(:method => "test_method", :path => "test_path", :query_parameters => { "a" => "b", "c" => "d" }, :headers => { "w" => "x", "y" => "z" }, :payload => "test_payload")
            end

            it "should initialize method from params" do
                @request.method.must_equal("test_method")
            end

            it "should initialize path from params" do
                @request.path.must_equal("test_path")
            end

            it "should initialize query_parameters from params" do
                @request.query_parameters.count.must_equal(2)
                @request.query_parameters["a"].must_equal("b")
                @request.query_parameters["c"].must_equal("d")
            end

            it "should initialize headers from params" do
                @request.headers.count.must_equal(2)
                @request.headers["w"].must_equal("x")
                @request.headers["y"].must_equal("z")
            end

            it "should initialize payload from params" do
                @request.payload.must_equal("test_payload")
            end

        end

    end

    describe "#to_s" do

        describe "when passing no params" do

            before do
                @rstr = Pandexio::Request.new().to_s
            end

            it "returns and empty string" do
                @rstr.must_equal(" \r\nquery_parameters: {}\r\nheaders: {}\r\npayload: ")
            end

        end

        describe "when passing params" do

            before do
                @rstr = Pandexio::Request.new(:method => "test_method", :path => "test_path", :query_parameters => { "a" => "b", "c" => "d" }, :headers => { "w" => "x", "y" => "z" }, :payload => "test_payload").to_s
            end

            it "returns and empty string" do
                @rstr.must_equal("test_method test_path\r\nquery_parameters: {\"a\"=>\"b\", \"c\"=>\"d\"}\r\nheaders: {\"w\"=>\"x\", \"y\"=>\"z\"}\r\npayload: test_payload")
            end

        end

    end
end