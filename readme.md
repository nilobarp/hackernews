[![Build Status](https://travis-ci.org/nilobarp/hackernews.svg?branch=master)](https://travis-ci.org/nilobarp/hackernews)

#Hacker News Listing
###Simple news listing from Hacker News

Ruby on Rail implementation of a very simple news listing page using `https://hn.algolia.com/api` as the source.

The news scrapper picks up news items if the URL of the news contains `github` and author points are `1000+`. Then we order the listing by `created_date`. At the core, there is the `NewsService` that takes care of building proper resource URL and returning JSON formatted news items.


##Default configuration
The default configuration of the `NewsService` is 
    
    newsReader.newestFirst true
    newsReader.searchFor 'github'
    newsReader.searchOnFields 'url'
    newsReader.minimumAuthorPoints 1000

###News Service Options
`NewsService` exposes following options

|Option|Default value|Description|
|------|-------------|-----------|
|newestFirst| true | Toggle order by creation date.|
|searchFor| github | Term to search for in the news items [also see `searchOnFields`] |
|searchOnFields| url | Limit searching to the given fields, if omitted all fields will be searched.|
|minimumAuthorPoints| 1000 | Set threshold points of elligible authors.|
|itemsPerPage| 10 | Define number of news items to be displayed per page|
|page | 0 | Page number to be fetched from the API|
    
##Local environment setup
To view and modify the source locally,

- clone the repository `git clone https://github.com/nilobarp/hackernews.git`
- run `bundle install` from the repository folder
- start a local server `rails s -b 0.0.0.0 -p 8090`
- open a browser to `http://localhost:8090`
    
##Unit tests
After cloning,

- run `rake test` from the repository folder
    
##Acknowledgements
- The Clean Blog theme was downloaded from `https://startbootstrap.com/template-overviews/clean-blog/`
- Home page background image is from `https://minkcv.github.io/`
