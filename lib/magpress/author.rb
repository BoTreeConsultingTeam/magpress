module Magpress
  class Author < Base
    END_POINT = '/api/authors'

    def all(params={})
      connection.get(resource_path, params)
    end
  end
end