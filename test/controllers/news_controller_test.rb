require 'test_helper'
require 'json'
require 'news_service'
require 'minitest/mock'

class NewsControllerTest < ActionController::TestCase
  test 'should render view with news listings' do
    url = 'http://example.com'
    stubbedResponse = '{"hits":[{"created_at":"2016-09-04T02:50:35.000Z","title":"In defence of Douglas Crockford","url":"http://atom-morgan.github.io/in-defense-of-douglas-crockford","author":"ramblerman","points":611,"story_text":null,"comment_text":null,"num_comments":381,"story_id":null,"story_title":null,"story_url":null,"parent_id":null,"created_at_i":1472957435,"_tags":["story","author_ramblerman","story_12422420"],"objectID":"12422420","_highlightResult":{"title":{"value":"In defence of Douglas Crockford","matchLevel":"none","matchedWords":[]},"url":{"value":"http://atom-morgan.\u003Cem\u003Egithub\u003C/em\u003E.io/in-defense-of-douglas-crockford","matchLevel":"full","fullyHighlighted":false,"matchedWords":["gitub"]},"author":{"value":"ramblerman","matchLevel":"none","matchedWords":[]}}}],"nbHits":139,"page":0,"nbPages":139,"hitsPerPage":1,"processingTimeMS":10,"query":"gitub","params":"advancedSyntax=true\u0026analytics=false\u0026hitsPerPage=1\u0026numericFilters=points%3E500\u0026page=0\u0026query=gitub\u0026restrictSearchableAttributes=url"}'
    newsReader = Minitest::Mock.new url
    newsReader.expect :newestFirst, true, [true]
    newsReader.expect :searchFor, 'github', ['github']
    newsReader.expect :searchOnFields, 'url', ['url']
    newsReader.expect :minimumAuthorPoints, 1000, [1000]
    newsReader.expect :itemsPerPage, '5', ['5']
    newsReader.expect :page, '0', ['0']
    newsReader.expect :read, JSON.parse(stubbedResponse)

    NewsService.stub :new, newsReader do
      reader = NewsService.new url
      get :index, {:pageNum => '0', :count => '5'}
      assert_response :success

      body = response.body
      assert_select '.post-preview a h2', 'In defence of Douglas Crockford'
      #assert_equal body['key'], 'value'
    end

  end
end
