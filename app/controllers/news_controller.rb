require 'news_service'
require 'date'

class NewsController < ApplicationController
  def index
    #fetch news items from API through a dedicated service
    newsUrl = Rails.configuration.x.news.url
    newsReader = NewsService.new(newsUrl)
    newsReader.newestFirst true
    newsReader.searchFor 'github'
    newsReader.searchOnFields 'url'
    newsReader.minimumAuthorPoints 500
    newsReader.itemsPerPage params['count']
    newsReader.page params['pageNum']
    news = newsReader.read

    @listings = {}
    newsCount = 0

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
