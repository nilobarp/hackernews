require 'test_helper'
require 'json'
require 'news_service'
require 'minitest/mock'

class NewsControllerTest < ActionController::TestCase
  test 'should have index method' do
    get :index
    assert_response :success
  end

  test 'should respond with JSON body' do
    url = 'http://example.com'
    stubbedResponse = '{"key": "value"}'
    newsReader = Minitest::Mock.new url
    newsReader.expect :newestFirst, true, [true]
    newsReader.expect :searchFor, 'github', ['github']
    newsReader.expect :searchOnFields, 'url', ['url']
    newsReader.expect :setMinimumAuthorPoints, 500, [500]
    newsReader.expect :read, stubbedResponse

    NewsService.stub :new, newsReader do
      reader = NewsService.new url
      get :index
      assert_response :success

      body = JSON.parse(response.body)
      assert_equal body['key'], 'value'
    end

  end
end
