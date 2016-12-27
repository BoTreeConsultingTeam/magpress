require './test/minitest_helper'
require 'magpress/author'

describe Magpress::Author do

  AUTHOR_ATTRIBUTES = %w(user_id user_login display_name email)

  describe '#all' do
    it 'should return empty array when no authors' do
      skip
    end

    it 'should return all authors' do
      response = author.all

      assert_equal 200, response.status

      body = response.body
      refute body.length.zero?
      assert_author_attributes(response)
    end

    it 'should unauthorize request if altered auth_key is passed' do
      assert_unauthorized_token(Magpress::Author, :all)
    end
  end

  private
    def assert_author_attributes(response)
      assert_equal AUTHOR_ATTRIBUTES, response.body.first.keys, 'Any return author should have all required attributes'
    end

    def author
      @author ||= Magpress::Author.new(CREDENTIALS)
    end
end
