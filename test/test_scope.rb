# encoding: utf-8

require 'minitest/autorun'
require_relative '../lib/scope.rb'

describe Pandexio::Scope do
    describe "#initialize" do

        describe "when passing no document_ids param" do

            before do
                @scope = Pandexio::Scope.new()
            end

            it "should initialize document_ids as an empty array" do
                @scope.document_ids.count.must_equal 0
            end

        end

        describe "when passing document_ids param" do

            before do
                @scope = Pandexio::Scope.new(:document_ids => ['a', 'b', 'c'])
            end

            it "should initialize document_ids with params value" do
                @scope.document_ids.count.must_equal 3
                @scope.document_ids[0].must_equal 'a'
                @scope.document_ids[1].must_equal 'b'
                @scope.document_ids[2].must_equal 'c'
            end

        end

    end
end