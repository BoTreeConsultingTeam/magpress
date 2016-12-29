module Magpress
  class Image < Base
    END_POINT = '/api/images'

    def find(id)
      get(resource_path(id))
    end

    def all(params={})
      get(resource_path, params)
    end

    def create(params)
      post(resource_path, params)
    end

    def destroy(id, force=true)
      delete(resource_path(id), force: force)
    end
  end
end