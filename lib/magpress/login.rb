require 'magpress/base'

module Magpress
  class Login < Base
    END_POINT = '/api/login'

    def call
      post(resource_path, { username: username, password: password })
    end
  end
end