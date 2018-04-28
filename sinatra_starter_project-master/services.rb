require 'sinatra'
require_relative 'authentication.rb'
require_relative 'user.rb'

if ENV['DATABASE_URL']
  DataMapper::setup(:default, ENV['DATABASE_URL'] || 'postgres://localhost/mydb')
else
  DataMapper::setup(:default, "sqlite3://#{Dir.pwd}/app.db")
end


class Services
	include DataMapper::Resource
	property :id, Serial
	property :workerId, Integer
	property :title, String
	property :category, String
	property :cost, Float
	property :description, String
    property :created_at, DateTime

    def gp(userid)
    	return Services.all()
    end
end

DataMapper.finalize

Services.auto_upgrade!

get "/billboard" do
	erb :billboard
end


post "/billboard" do
	s = Services.new
	title = params[:title]
	category = params[:category]

	s.workerId = session[:user_id]
	s.title = title.downcase
	s.category = category.downcase
	s.cost = params[:cost]
	s.save
	return "Post #{s.title} , #{s.workerId} added!"
end

get "/newsfeed" do
	@s = Services.new
	a = @s.gp(0)
	erb :newsfeed
end