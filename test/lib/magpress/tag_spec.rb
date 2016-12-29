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

      refute response.length.zero?
      assert_resource_attributes('Tag', response, TAG_ATTRIBUTES)
    end

    it 'should return tags on specific page' do
      response = tag.all(page: 1, per_page: 2)

      assert_equal 2, response.length
      assert_resource_attributes('Tag', response, TAG_ATTRIBUTES)
    end

    it 'should unauthorize request if altered auth_key is passed' do
      assert_unauthorized_token(Magpress::Tag, :all)
    end
  end

  private
    def tag
      @tag ||= Magpress::Tag.new(CREDENTIALS)
    end
end
