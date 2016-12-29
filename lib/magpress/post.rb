module Magpress
  class Post < Base
    END_POINT = '/api/posts'

    def find(id)
      get(resource_path(id))
    end

    def all
      get(resource_path)
    end

    def create(params)
      post(resource_path, params)
    end

    def update(id, params)
      post(resource_path(id), params)
    end

    def destroy(id, force=nil)
      delete(resource_path(id), { force: force })
    end
  end
end