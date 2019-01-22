class PlannersController < ApplicationController

  get '/signup' do
    if logged_in?
      redirect "/planner_events" 
    else
      erb :"planners/signup"
    end
  end

  post '/signup' do 
    @planner = Planner.find_by(:username => params[:username])
    if @planner
      flash[:message] = "Please choose another username."
      redirect '/signup'
    else
      @planner = Planner.new(username: params[:username], password: params[:password])
      if @planner.save
        session[:planner_id] = @planner.id
        flash[:message] = "Successfully registered!"
        redirect '/planner_events'
      else 
        flash[:message] = "Please try again."
        redirect '/signup'
      end
    end
  end 
  
  get '/login' do
    if logged_in?
      redirect "/planner_events" 
    else
      erb :"/planners/login"
    end
  end
  
  post '/login' do
    @planner = Planner.find_by(:username => params[:username])
    if @planner && @planner.authenticate(params[:password])
      session[:planner_id] = @planner.id
      redirect "/planner_events"
    else 
      flash[:message] = "User or password not found. Please try again." 
      redirect to "/login"
    end
  end
  
  get '/planner_events' do
    @planner = current_user
    erb :"/planners/planner_events"
  end
  
  get '/logout' do
    if logged_in?
      session.clear
      erb :"/welcome"
    else 
      erb :"/welcome"
    end
  end
end