require 'news_service'

class NewsController < ApplicationController
  def index
    #fetch news items from API through a dedicated service
    newsUrl = Rails.configuration.x.news.url
    newsReader = NewsService.new(newsUrl)
    newsReader.newestFirst true
    newsReader.searchFor 'github'
    newsReader.searchOnFields 'url'
    newsReader.setMinimumAuthorPoints 500

    begin
      render json: newsReader.read
    rescue => ex
      render plain: ex.message
    end

  end
end
