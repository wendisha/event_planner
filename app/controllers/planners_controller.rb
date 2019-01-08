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
  
end