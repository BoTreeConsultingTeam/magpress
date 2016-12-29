require './test/minitest_helper'
require 'magpress/author'

describe Magpress::Author do

  AUTHOR_ATTRIBUTES = %w(id user_login display_name email)

  describe '#all' do
    it 'should return empty array when no authors' do
      skip
    end

    it 'should return all authors' do
      response = author.all

      refute response.length.zero?
      assert_resource_attributes('Author', response, AUTHOR_ATTRIBUTES)
    end

    it 'should unauthorize request if altered auth_key is passed' do
      assert_unauthorized_token(Magpress::Author, :all)
    end
  end

  private
    def author
      @author ||= Magpress::Author.new(CREDENTIALS)
    end
end
