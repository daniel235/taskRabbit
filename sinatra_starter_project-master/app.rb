require "sinatra"
require "data_mapper"
require_relative "authentication.rb"
require_relative "services.rb"
require_relative "messaging.rb"


#the following urls are included in authentication.rb
# GET /login
# GET /logout
# GET /sign_up

# authenticate! will make sure that the user is signed in, if they are not they will be redirected to the login page
# if the user is signed in, current_user will refer to the signed in user object.
# if they are not signed in, current_user will be nil

s = Services.new
ul = User.new
serv = s.gp()

get "/" do
	if(session[:user_id] != nil)
		@so = serv.all(:workerId => session[:user_id])
		@na = ul.getUserName(session[:user_id])
		erb :index
	else
		erb :"authentication/login"
	end
end

get "/results" do
	if(params.has_key?(:search))
		@u = User.all()
		sl = "#{params[:search]}"
		if(sl != "")
			sl = sl.downcase
			@keyword = sl
			@service = serv
			erb :results
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

get "/about" do 
	erb :about
end