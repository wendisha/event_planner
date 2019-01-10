class EventsController < ApplicationController
  get "/events" do
    if logged_in?
      @events = Event.all
      @planner = current_user
      erb :"/events/events"
    else 
       redirect "/login"
    end 
  end
  
  get '/events/new' do
    if logged_in?
      @category = Category.all
      erb :'/events/new'
    else
       redirect "/login"
    end
  end
  
  post '/events' do
    if params[:date] != "" && params[:host_name] != "" && params[:budget] != "" 
      if !params["category"]["name"].empty?
        @category = Category.create(name: params["category"]["name"])
        #@event.category_id = @category.id
        @event = Event.create(:date => params[:date], :host_name => params[:host_name], :budget => params[:budget], :planner_id => current_user.id, :category_id => @category.id) #How to shorten this line?
      else
        @event = Event.create(:date => params[:date], :host_name => params[:host_name], :budget => params[:budget], :planner_id => current_user.id, :category_id => params[:category_id]) #How to shorten this line?
      end
      #@category_name = Category.find_by_id(@event.category_id).name
        #binding.pry
      redirect "/events/#{@event.id}"
    else 
      redirect '/events/new'
    end
  end
  
  get '/events/:id' do 
    @event = Event.find_by_id(params[:id])
    erb :'/events/show'
  end
  
    get '/events/:id/edit' do
    if logged_in? 
      @event = Event.find_by_id(params[:id])
      erb :'/events/edit'
    else 
      redirect "/login"
    end
  end
  
  patch '/events/:id' do 
    @event = Event.find_by_id(params[:id])
    if @event.planner_id == current_user.id && params[:date] != "" && params[:host_name] != "" && params[:budget] != ""  && logged_in?
      @event.update(:date => params[:date], :host_name => params[:host_name], :budget => params[:budget], :planner_id => current_user.id, :category_id => params[:category_id])
      redirect "/events/#{@event.id}"
    elsif 
      @event.planner_id == current_user.id && logged_in? && params[:date] == "" || params[:host_name] == "" || params[:budget] == ""
      redirect "/events/#{@event.id}/edit"
    else 
      redirect "/events"
    end
  end 
  
  delete '/events/:id' do 
    @event = Event.find_by_id(params[:id])
    if @event.planner_id == current_user.id
      @event.delete
      redirect to '/events'
    else 
      redirect "/events"
    end
  end
end