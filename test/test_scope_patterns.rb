# encoding: utf-8

require 'minitest/autorun'
require_relative '../lib/scope_patterns.rb'

describe Pandexio::ScopePatterns do

    it 'extracts_document_id_from_path_regardless_of_leading_segment' do
        match = '/asdf/documents/123/snips/abc'.match(Pandexio::ScopePatterns::DOCUMENT_PATH_PATTERN)
        refute_nil(match)
        match['documentid'].must_equal '123'
    end

    it 'extracts_document_id_from_path_containing_uppercase_and_lowercase_characters' do
        match = '/v2/Documents/123/Snips/abc'.match(Pandexio::ScopePatterns::DOCUMENT_PATH_PATTERN)
        refute_nil(match)
        match['documentid'].must_equal '123'
    end

    it 'extracts_document_id_from_path_containing_only_lowercase_characters' do
        match = '/v2/documents/123/snips/abc'.match(Pandexio::ScopePatterns::DOCUMENT_PATH_PATTERN)
        refute_nil(match)
        match['documentid'].must_equal '123'
    end

    it 'extracts_document_id_from_path_containing_only_uppercase_characters' do
        match = '/V2/DOCUMENTS/123/SNIPS/abc'.match(Pandexio::ScopePatterns::DOCUMENT_PATH_PATTERN)
        refute_nil(match)
        match['documentid'].must_equal '123'
    end

    it 'extracts_document_id_from_path_containing_only_document_id' do
        match = '/v2/documents/123'.match(Pandexio::ScopePatterns::DOCUMENT_PATH_PATTERN)
        refute_nil(match)
        match['documentid'].must_equal '123'
    end

    it 'extracts_document_id_from_path_containing_document_id_and_trailing_slash' do
        match = '/v2/documents/123/'.match(Pandexio::ScopePatterns::DOCUMENT_PATH_PATTERN)
        refute_nil(match)
        match['documentid'].must_equal '123'
    end

    it 'extracts_document_id_from_path_containing_document_id_and_trailing_query_string' do
        match = '/v2/documents/123?coversize=xl'.match(Pandexio::ScopePatterns::DOCUMENT_PATH_PATTERN)
        refute_nil(match)
        match['documentid'].must_equal '123'
    end

    it 'extracts_document_id_from_path_containing_document_id_and_snip_id' do
        match = '/v2/documents/123/snips/abc'.match(Pandexio::ScopePatterns::DOCUMENT_PATH_PATTERN)
        refute_nil(match)
        match['documentid'].must_equal '123'
    end

end