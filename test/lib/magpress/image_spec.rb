require './test/minitest_helper'
require 'magpress/image'
require 'magpress/post'
require 'base64'

describe Magpress::Image do

  IMAGE_ATTRIBUTES = %w(id title date_create_gmt link caption description type thumbnail)

  describe '#get' do
    it 'should return error for non existing image' do

      error = assert_raises Magpress::ResourceNotFoundError do
        image.find(0)
      end
      assert_match INVALID_POST_ID, error.message
    end

    it 'should return image details' do
      create_image_response = image.create(image_params)

      response = image.find(create_image_response.id)
      assert_match /sample/, response.title
      assert_equal 'image/jpeg', response.type
    end

    it 'should unauthorize request if altered auth_key is passed' do
      assert_unauthorized_token(Magpress::Image, :find, 0)
    end
  end


  describe '#all' do
    it 'should return empty array when no images' do
      skip
    end

    it 'should return all images' do
      image.create(image_params)
      
      response = image.all

      refute response.length.zero?
      assert_resource_attributes('Image', response, IMAGE_ATTRIBUTES)
    end

    it 'should return images on specific page' do
      response = image.all(page: 1, per_page: 2)

      assert_equal 2, response.length
      assert_resource_attributes('Image', response, IMAGE_ATTRIBUTES)
    end
    
    it 'should unauthorize request if altered auth_key is passed' do
      assert_unauthorized_token(Magpress::Image, :all)
    end
  end


  describe '#create' do
    describe 'with all params' do
      it 'should publish image successfully' do
        assert_create_image_with_valid_params(image_params)
      end
    end

    describe 'without optional params' do
      describe 'only title is given' do
        it 'should publishes image successfully' do
          without_optional_params = image_params.clone
          %w(post_id overwrite).each{|v| without_optional_params.delete(v)}
          assert_create_image_with_valid_params(without_optional_params)
        end
      end
    end

    describe 'without required params' do
      it 'should fail' do
        assert_raises Magpress::BadRequestError do
          image.create({})
        end
      end
    end

    it 'should unauthorize request if altered auth_key is passed' do
      assert_unauthorized_token(Magpress::Image, :create, image_params)
    end
  end


  describe '#delete' do
    before(:each) do
      response = image.create(image_params)
      @image_id = response.id
    end

    it 'should remove the image permanently' do
      response = image.destroy(@image_id)
      assert response.success

      error = assert_raises Magpress::ResourceNotFoundError do
        image.find(@image_id)
      end
      assert_match INVALID_POST_ID, error.message
    end
  end

  private
    def image
      @image ||= Magpress::Image.new(CREDENTIALS)
    end

    def post_id
      @post_id ||= Magpress::Post.new(CREDENTIALS).create(title: 'For testing Image API').id
    end

    def image_params
      @image_params ||= {
          type: 'image/jpeg',
          filename: 'sample.jpg',
          # TODO why we need to explicitely append 'data:image/jpeg;base64,'?
          file: "data:image/jpeg;base64,#{Base64.encode64(File.open('test/fixtures/sample.jpg', 'rb').read)}",
          post_id: post_id,
          overwrite: true
      }
    end

    def assert_create_image_with_valid_params(image_params)
      response = image.create(image_params)
      assert response.id > 0
      response.id
    end
end
