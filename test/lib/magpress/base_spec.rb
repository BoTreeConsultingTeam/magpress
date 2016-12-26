require './test/minitest_helper'
require 'magpress/base'

describe Magpress::Base do
  describe '#end_point' do
    it 'raise error for non implemented method' do
      base =
          Magpress::Base.new(CREDENTIALS)

      assert_raises do
        base.end_point
      end
    end
  end

  describe '#resource_path' do
    it 'raise error for non implemented method end_point' do
      base =
          Magpress::Base.new(CREDENTIALS)

      assert_raises do
        base.end_point
      end
    end
  end
end
