require './test/minitest_helper'
require 'magpress/tag'

describe Magpress::Tag do

  TAG_ATTRIBUTES = %w(id name count description link slug taxonomy)

  describe '#all' do
    it 'should return empty array when no tags' do
      skip
    end

    it 'should return all tags' do
      response = tag.all

      assert_equal 200, response.status

      body = response.body
      refute body.length.zero?
      assert_tag_attributes(response)
    end

    it 'should return tags on specific page' do
      response = tag.all(page: 1, per_page: 2)

      assert_equal 200, response.status

      body = response.body
      assert_equal 2, body.length
      assert_tag_attributes(response)
    end

    it 'should unauthorize request if altered auth_key is passed' do
      assert_unauthorized_token(Magpress::Tag, :all)
    end
  end

  private
    def assert_tag_attributes(response)
      assert_equal TAG_ATTRIBUTES, response.body.first.keys, 'Any return tag should have all required attributes'
    end

    def tag
      @tag ||= Magpress::Tag.new(CREDENTIALS)
    end
end
