require 'news_service'
require 'date'

class NewsController < ApplicationController
  def index
    #fetch news items from API through a dedicated service
    newsUrl = Rails.configuration.x.news.url

    newsReader = NewsService.new(newsUrl)
    newsReader.newestFirst true #order news items by creation date
    newsReader.searchFor 'github' #filter items for github
    newsReader.searchOnFields 'url' #apply filter on the url field only
    newsReader.minimumAuthorPoints 1000 #author must have at least 1000 points to be listed
    newsReader.itemsPerPage params['count'] #get number of items to be displayed from URL parameter
    newsReader.page params['pageNum'] #get page number from URL parameter
    news = newsReader.read

    @listings = {}
    newsCount = 0

    #filter and collate each news item into a hash for view rendering
    news['hits'].each do |n|
      formatted_date = date_format n['created_at']
      @listings[newsCount] = {
          title: n["title"],
          author: n["author"],
          points: n["points"],
          url: n['url'],
          date: formatted_date
      }
      newsCount += 1
    end

    #build page navigators
    totalPages = news['nbPages']
    currentPage = news['page']
    if currentPage < totalPages
      @nextPageLink = newsList_path ({:pageNum => currentPage + 1, :count => params['count']})
    else
      @nextPageLink = nil
    end

    if currentPage > 0
      @prevPageLink = newsList_path ({:pageNum => currentPage - 1, :count => params['count']})
    else
      @prevPageLink = nil
    end

  end

  private
  def date_format (date_string)
    date = DateTime.parse(date_string)
    date.strftime('%d/%m/%Y')
  end
end
