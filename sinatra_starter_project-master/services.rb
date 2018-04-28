require 'sinatra'

if ENV['DATABASE_URL']
  DataMapper::setup(:default, ENV['DATABASE_URL'] || 'postgres://localhost/mydb')
else
  DataMapper::setup(:default, "sqlite3://#{Dir.pwd}/app.db")
end


class Service
	include DataMapper::Resource
	property :id, Serial
	property :title, String
	property :category, String
	property :cost, Float
	property :description, String
    property :created_at, DateTime

end

DataMapper.finalize

Service.auto_upgrade!

get "/billboard" do
	erb :billboard
end


post "/billboard" do
	s = Service.new
	title = params[:title]
	category = params[:category]

	s.id = params[:id]
	s.title = title.downcase
	s.category = category.downcase
	s.cost = params[:cost]
	s.save
	return "Post #{s.title} added!"
	
end