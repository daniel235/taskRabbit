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
	property :description, Text
    property :created_at, DateTime

    def gp()
    	return Services.all()
    end
end

DataMapper.finalize

Services.auto_upgrade!

get "/billboard" do
	erb :billboard
end


post "/classifieds" do
	s = Services.new
	title = params[:title]
	category = params[:category]
	descript = params[:description]

	s.workerId = session[:user_id]
	s.title = title.downcase
	s.category = category.downcase
	s.description = descript.downcase
	s.cost = params[:cost]
	s.save
	erb :classifieds
end

get "/newsfeed" do
	@s = Services.new
	@u = User.all()
	a = @s.gp()
	@so = a
	erb :newsfeed
end

get "/checkout" do
	if(params.has_key?(:id))
		id = params[:id]
		@inst = Services.all(:id => id)
		@inst = @inst.first()
		erb :checkout
	else
		return "Need to select a service!"
	end
end