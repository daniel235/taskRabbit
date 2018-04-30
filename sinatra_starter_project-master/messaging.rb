require 'sinatra'
require_relative 'user.rb'

if ENV['DATABASE_URL']
  DataMapper::setup(:default, ENV['DATABASE_URL'] || 'postgres://localhost/mydb')
else
  DataMapper::setup(:default, "sqlite3://#{Dir.pwd}/app.db")
end


class Message
	include DataMapper::Resource
	property :id, Serial
	property :senderId, Integer
	property :receiverId, Integer
	property :content, String
	property :created_at, DateTime

end

DataMapper.finalize!

Message.auto_upgrade!
	

get "/chat" do 
	@mchat = Message.all(:senderId => session[:user_id])
	#cycle through users

	if(params.has_key(:message))
		@id = params[:message]
		@mchat.each do |ch|
			if(ch.id == @id)
				@dms = ch

		@slide = Users.all(:id => @id)
		erb :dm 

	else
		erb :chat
	end
end


get "/create" do
	
end
