require 'sinatra'
require 'aws-sdk-s3'
require 'yaml'
require 'json'
require 'time'
require 'pp'

set :port, ENV['PORT']

before do
  @title = '@hihats portfolio'
end

get "/" do
  data = YAML.load_file("#{settings.root}/data.yml")
  @social_accounts = data["social_accounts"]
  @works = data["works"]
  @projects = data["projects"]
  erb :index
end

get "/aboutme" do
  erb :'aboutme/index'
end

get '/advent_calendar_ranking' do
  @title = 'Advent calendar 2017 stockers ranking'
  Aws.config.update(
    region: ENV['AWS_REGION'],
    credentials: Aws::Credentials.new(ENV['AWS_ACCESS_KEY'], ENV['AWS_SECRET_ACCESS_KEY'])
  )
  s3 = Aws::S3::Resource.new(region: ENV['AWS_REGION'])
  bucket = s3.bucket(ENV['S3_BUCKET_NAME'])
  obj = bucket.object("advent_calendar_stockers.json")
  @last_updated_at = obj.last_modified

  calendars = JSON.parse(obj.get.body.read).map.with_index(1) do |calendar, i|
    stock_count = 0
    calendar['entries'].each {|entry| stock_count += entry['stock_count']}
    calendar['stock_count'] = stock_count
    calendar['likes_rank'] = i
    calendar
  end
  @calendars = calendars.sort_by{|calendar| calendar['stock_count']}.reverse
  erb :'advent_calendar_ranking/index'
end

not_found do
  '404 NOT FOUND'
end
