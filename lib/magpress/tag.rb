module Magpress
  class Tag < Base
    END_POINT = '/api/tags'

    def all(params={})
      connection.get(resource_path, params)
    end
  end
end