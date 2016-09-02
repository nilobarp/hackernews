require 'net/http'
require 'json'

class NewsService
  @newsUrl = :nil
  @searchFor = :nil
  @minAuthorPoints = 0
  @searchFields = :nil
  @newestFirst = :false

  def initialize (newsHostUrl)
    @newsUrl = newsHostUrl
  end

  def baseUrl
    @newsUrl
  end

  def searchFor (term)
    @searchFor = term
  end

  def setMinimumAuthorPoints (points)
    @minAuthorPoints = points
  end

  def searchOnFields (fields)
      @searchFields = fields
  end

  def newestFirst (truth)
    @newestFirst = truth
  end

  def read
    finalUrl = buildNewsUrl
    return nil unless finalUrl

    begin
      uri = URI(finalUrl)
      response = Net::HTTP.get(uri)
      return JSON.parse(response)
    rescue => ex
      raise ex
    end
  end

  private
  def buildNewsUrl
    return nil unless @newsUrl

    constructedUrl = @newsUrl

    if @newestFirst
      constructedUrl += '/search_by_date'
    else
      constructedUrl += '/search'
    end

    #a search term is mandatory
    if @searchFor
      constructedUrl += '?query=' + @searchFor if @searchFor
    else
      raise 'Missing search term'
    end

    constructedUrl += '&restrictSearchableAttributes=' + @searchFields if @searchFields

    constructedUrl += "&numericFilters=points>#@minAuthorPoints" if @minAuthorPoints

    return constructedUrl
  end
end