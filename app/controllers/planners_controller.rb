class PlannersController < ApplicationController
  
  get '/signup' do
    if logged_in?
      redirect "/planner_events" 
    else
      erb :"planners/signup"
    end
  end

  post '/signup' do 
    @planner = Planner.new(username: params[:username], password: params[:password])
    if @planner.save
      session[:planner_id] = @planner.id
      redirect '/events'
    else 
      redirect '/signup'
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
      erb :"planners/planner_events"
    else 
      redirect to "/login"
    end
  end
  
  get '/planner_events' do
    @planner = Planner.find_by_id(params[:id])
    erb :"/planners/planner_events"
  end
end