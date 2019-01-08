class PlannersController < ApplicationController
  
  get '/signup' do
    if logged_in?
      redirect "/events" 
    else
      erb :"planners/signup"
    end
  end

  post '/signup' do 
    @user = User.new(username: params[:username], password: params[:password])
    if @user.save
      session[:user_id] = @user.id
      redirect '/events'
    else 
      redirect '/signup'
    end
  end 
  
  get '/login' do
    if logged_in?
      redirect "/events" 
    else
      erb :"/planners/login"
    end
  end
  
  post '/login' do
    @user = User.find_by(:username => params[:username])
    if @user && @user.authenticate(params[:password])
      session[:user_id] = @user.id
      redirect to "/events"
    else 
      redirect to "/login"
    end
  end
end