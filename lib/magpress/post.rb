module Magpress
  class Post < Base
    END_POINT = '/api/posts'

    def get(id)
      connection.get(resource_path(id))
    end

    def all
      connection.get(resource_path)
    end

    def create(params)
      connection.post(resource_path, params)
    end

    def update(id, params)
      connection.post(resource_path(id), params)
    end

    def destroy(id, force=nil)
      connection.delete(resource_path(id), { force: force })
    end
  end
end