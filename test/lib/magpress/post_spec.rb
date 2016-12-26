require './test/minitest_helper'
require 'magpress/post'

describe Magpress::Post do

  it 'exists' do
    assert Magpress::Post
  end

  POST_ATTRIBUTES = %w(id title date status type name author excerpt content link guid thumbnail categories tags)
  describe '#get' do
    it 'should return error for non existing post' do
      response = post.get(0)

      assert_equal 404, response.status
      assert_match /Invalid post id/, response.body.message
    end

    it 'should return post details' do
      response = post.get(110)

      assert_equal 200, response.status
      assert_equal POST_ATTRIBUTES, response.body.keys
      # TODO verify all attribute values
    end

    it 'should unauthorize request if altered auth_key is passed' do
      assert_unauthorized_token(Magpress::Post, :get, 110)
    end
  end

  describe '#all' do
    it 'should return empty array when no posts' do
      skip
    end

    it 'should return all posts' do
      response = post.all

      assert_equal 200, response.status

      body = response.body
      refute body.length.zero?
      assert_equal POST_ATTRIBUTES, response.body.first.keys, 'Any return post should have all required attributes'
      # TODO verify all attribute values
    end

    it 'should unauthorize request if altered auth_key is passed' do
      assert_unauthorized_token(Magpress::Post, :all)
    end
  end

  describe '#create' do
    describe 'with all params' do
      it 'should publish post successfully' do
        assert_create_post_with_valid_params(new_post_params)
      end
    end

    describe 'without optional params' do
      describe 'only title is given' do
        it 'should publishes post successfully' do
          assert_create_post_with_valid_params('title' => new_post_params['title'])
        end
      end

      describe 'only content is given' do
        it 'should publishes post successfully' do
          assert_create_post_with_valid_params('content' => new_post_params['content'])
        end
      end

      describe 'only excerpt is given' do
        it 'should publishes post successfully' do
          assert_create_post_with_valid_params('title' => new_post_params['excerpt'])
        end
      end
    end

    describe 'with optional tags' do
      describe 'having empty array' do
        it 'creates post without tags' do
          assert_create_post_with_valid_params('title' => new_post_params['title'], 'tags' => [])
        end
      end

      describe 'having nil' do
        it 'creates post without tags' do
          assert_create_post_with_valid_params('title' => new_post_params['title'], 'tags' => nil)
        end
      end
    end

    describe 'with optional categories' do
      describe 'having empty array' do
        it 'creates post without categories' do
          assert_create_post_with_valid_params('title' => new_post_params['title'], 'categories' => [])
        end
      end

      describe 'having nil' do
        it 'creates post without categories' do
          assert_create_post_with_valid_params('title' => new_post_params['title'], 'categories' => nil)
        end
      end
    end

    describe 'without required params' do
      it 'should fail' do
        response = post.create({})
        assert_equal 400, response.status
        assert_match /Content, title, and excerpt are empty/, response.body.message
      end
    end

    it 'should unauthorize request if altered auth_key is passed' do
      # assert_unauthorized_token(Magpress::Post, :create)
    end
  end


  describe '#update' do
    before(:each) do
      response = post.create(new_post_params)
      @post_id = response.body.id
    end

    context 'with all params' do
      it 'should update post successfully' do
        assert_update_post_with_valid_params(@post_id, update_post_params)
      end
    end

    context 'without optional params' do
      describe 'only title is given' do
        it 'should update post successfully' do
          assert_update_post_with_valid_params(@post_id, { 'title' => update_post_params['title'] })
        end
      end

      describe 'only content is given' do
        it 'should update post successfully' do
          assert_update_post_with_valid_params(@post_id, { 'content' => update_post_params['content'] })
        end
      end

      describe 'only excerpt is given' do
        it 'should update post successfully' do
          assert_update_post_with_valid_params(@post_id, { 'excerpt' => update_post_params['excerpt'] })
        end
      end
    end

    context 'with optional tags' do
      describe 'having empty array' do
        it 'deletes tags if already attached' do
          assert_update_post_with_valid_params(@post_id, { 'title' => update_post_params['title'], 'tags' => [] })
        end
      end

      describe 'having nil' do
        it 'deletes tags if already attached' do
          skip
          # assert_update_post_with_valid_params(@post_id, { 'title' => update_post_params['title'], 'tags' => nil })
        end
      end

      describe 'having additional tags' do
        it 'add/removes tags to the post' do
          assert_update_post_with_valid_params(@post_id, { 'title' => update_post_params['title'], 'tags' => %w(Two Four Six) })
        end
      end
    end

    context 'with optional categories' do
      describe 'having empty array' do
        it 'deletes categories if already attached' do
          assert_update_post_with_valid_params(@post_id, { 'title' => update_post_params['title'], 'categories' => [] })
        end
      end

      describe 'having nil' do
        it 'deletes categories if already attached' do
          skip
          # assert_update_post_with_valid_params(@post_id, { 'title' => update_post_params['title'], 'categories' => nil })
        end
      end

      describe 'having additional categories' do
        it 'add/removes categories to the post' do
          assert_update_post_with_valid_params(@post_id, { 'title' => update_post_params['title'], 'categories' => %w(TenTen FiftyFifty) })
        end
      end
    end

    describe 'without required params' do
      it 'should update post successfully' do
        assert_update_post_with_valid_params(@post_id, {})
      end
    end

    it 'should unauthorize request if altered auth_key is passed' do
      assert_unauthorized_token(Magpress::Post, :update)
    end
  end

  describe '#delete' do
    before(:each) do
      response = post.create(new_post_params)
      @post_id = response.body.id
    end

    it 'should trash the post' do
      response = post.destroy(@post_id)
      #TODO assert response
    end

    it 'should remove the post permanently' do
      response = post.destroy(@post_id, true)
      #TODO assert response
    end
  end

  private
    def post
      @post ||= Magpress::Post.new(CREDENTIALS)
    end

    def assert_unauthorized_token(klass, method, params=nil)
      Magpress::Base.any_instance.stubs(:auth_key).returns('eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwOlwvXC9hcHBzLm9wZW50ZXN0ZHJpdmUuY29tOjgwODBcL21hZ25pZmljZW50IiwiaWF0IjoxNDgyMzI0Mzg1LCJuYmYiOjE0ODIzMjQzODUsImV4cCI6MTQ4MjM0MTY2NSwiZGF0YSI6eyJ1c2VyIjp7ImlkIjoiMSJ9fX0.JhRq2AyurGHNPYQAGH-W2XvdizB2f6ktfiO1qWxrgA1') #mocha

      post = klass.new(CREDENTIALS)
      response = params ? post.send(method, params) :  post.send(method)

      assert_equal 403, response.status
      #TODO verify error body
    end

    def assert_create_post_with_valid_params(post_params)
      response = post.create(post_params)
      assert_equal 200, response.status
      assert response.body.id > 0
      response.body.id
    end

    def assert_update_post_with_valid_params(post_id, post_params)
      response = post.update(post_id, post_params)
      assert_equal 200, response.status
      assert response.body.success
    end

    def new_post_params
      @post_params ||= {
          'title' => 'Enter in NewYork',
          'status' => 'publish',
          'content' => "\r\n      \r\n    <p class=\"graf graf--p graf--empty graf--first\"><br></p><p class=\"graf graf--p\" name=\"shvpugnmtaux47vi\"><b> THE BROPINIONWORDS: GABE</b></p><p class=\"graf graf--p graf--last is-selected\" name=\"098lj5tl3iqeulvunmi\"><i>Like Christian Grey, the first and mostimportant trait a “Ms. Green” can bring tothe bedroom is a powerful, prideful presence. You can</i></p>\r\n ",
          'author' => 0,
          'excerpt' => 'Cool things to do in Newyork',
          'date' => '2016-12-22T10:44:33',
          'thumbnail' => 112,
          'tags' => %w(One Two Three Four),
          'categories' => %w(Ten Twenty),
      }
    end

    def update_post_params
      @update_post_params ||= {
          'title' => 'Enter in NewYork again',
          'status' => 'draft',
          'content' => 'Simple content',
          'author' => 1,
          'excerpt' => 'Cool things to do in Newyork over an over',
          'date' => '2016-12-22T10:44:33',
          'featured_media' => nil,
          'tags' => %w(Five Six),
          'categories' => %w(TenTen TwentyTwenty),
      }
    end
end
