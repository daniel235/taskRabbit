require "sinatra"
require "data_mapper"
require_relative "authentication.rb"
require_relative "services.rb"


#the following urls are included in authentication.rb
# GET /login
# GET /logout
# GET /sign_up

# authenticate! will make sure that the user is signed in, if they are not they will be redirected to the login page
# if the user is signed in, current_user will refer to the signed in user object.
# if they are not signed in, current_user will be nil

get "/" do
	erb :index
end

get "/results" do
	if(params.has_key?(:search))
		s = "#{params[:search]}"
		if(s != "")
			return s
		else
			return "search empty"
		end
	else
		redirect "/"
	end
end

get "/dashboard" do
	authenticate!
	erb :dashboard
end