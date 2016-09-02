class HomeController < ApplicationController
  def index
    render plain: Rails.configuration.x.news.url
  end
end
