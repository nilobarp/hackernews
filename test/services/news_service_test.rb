require 'test_helper'
require 'news_service'

class NewsServiceTest < ActionController::TestCase
  setup do

  end

  teardown do
  end

  test 'should accept host url on initialization' do
    hostUrl = 'example.com'
    newsReader = NewsService.new hostUrl
    assert_equal hostUrl, newsReader.baseUrl
  end

  test 'should return well formatted url' do
    hostUrl = 'http://example.com'
    newsReader = NewsService.new hostUrl
    newsReader.searchOnFields 'url'
    newsReader.searchFor 'github'
    newsReader.setMinimumAuthorPoints 500
    newsReader.newestFirst true

    expectedUrl = hostUrl + '/search_by_date?query=github&restrictSearchableAttributes=url&numericFilters=points>500'
    builtUrl = newsReader.buildNewsUrl

    assert_equal expectedUrl, builtUrl
  end

  test 'should raise error if search term is not present' do
    hostUrl = 'http://example.com'
    newsReader = NewsService.new hostUrl
    newsReader.searchOnFields 'url'
    newsReader.setMinimumAuthorPoints 500
    newsReader.newestFirst true

    assert_raises(Exception) { newsReader.buildNewsUrl }
  end

  test 'should fetch news in JSON format' do
    hostUrl = 'http://example.com'
    newsReader = NewsService.new hostUrl
    newsReader.searchOnFields 'url'
    newsReader.searchFor 'github'
    newsReader.setMinimumAuthorPoints 500
    newsReader.newestFirst true

    expectedUrl = hostUrl + '/search_by_date?query=github&restrictSearchableAttributes=url&numericFilters=points>500'
    stubbedResponse = '{"key": "value"}'

    stub_request(:any, expectedUrl)
      .to_return(body: stubbedResponse, status: 200,
      headers: { 'Content-Length' => 16 })

    response = newsReader.read

    assert_equal response['key'], 'value'
  end
end

#open up the private method for testing
class NewsService
  public :buildNewsUrl
end