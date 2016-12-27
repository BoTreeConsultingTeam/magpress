module Magpress
  class Image < Base
    END_POINT = '/api/images'

    def get(id)
      connection.get(resource_path(id))
    end

    def all(params={})
      connection.get(resource_path, params)
    end

    def create(params)
      connection.post(resource_path, params)
    end

    def destroy(id, force=true)
      connection.delete(resource_path(id), force: force)
    end
  end
end