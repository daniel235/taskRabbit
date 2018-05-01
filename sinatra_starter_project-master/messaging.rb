require 'sinatra'
require 'data_mapper'
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

DataMapper.finalize

Message.auto_upgrade!
	

get "/chat" do 
	@mchat = Message.all(:receiverId => session[:user_id])
	#cycle through users

	if(params.has_key?(:message))
		@id = params[:message]
		@mchat.each do |ch|
			if(ch.senderId == @id)
				@dms = ch
			end
		end
		@slide = User.all(:id => @id)
		erb :dm 
	else
		erb :chat
	end
end


post "/create" do
	id = params[:id]
	content = params[:content]

	d = Message.new
	d.senderId = session[:user_id]
	d.receiverId = id
	d.content = content.downcase

	d.save

	redirect "/chat"

end
