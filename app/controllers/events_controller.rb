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
    if params[:date] != "" && params[:host_name] != "" && params[:budget] != "" && (params[:category_id] != nil || params[:category][:name] != "") 
      if !params["category"]["name"].empty?
        @category = Category.find_or_create_by(name: params["category"]["name"])
        @event = Event.create(:date => params[:date], :host_name => params[:host_name], :budget => params[:budget], :planner_id => current_user.id, :category_id => @category.id) #How to shorten this line?
      else
        @event = Event.create(:date => params[:date], :host_name => params[:host_name], :budget => params[:budget], :planner_id => current_user.id, :category_id => params[:category_id]) #How to shorten this line?
      end
      binding.pry
      redirect "/events/#{@event.id}"
    else 
      redirect '/events/new'
    end
  end
  
  get '/events/:id' do 
    @event = Event.find_by_id(params[:id])
    @category_name = Category.find_by_id(@event.category_id).name
    erb :'/events/show'
  end
  
  get '/events/:id/edit' do
    if logged_in? 
      @event = Event.find_by_id(params[:id])
      @category = Category.all
      @category_name = Category.find_by_id(@event.category_id).name
      erb :'/events/edit'
    else 
      redirect "/login"
    end
  end

  patch '/events/:id' do 
    @event = Event.find_by_id(params[:id])
    if @event.planner_id == current_user.id && params[:date] != "" && params[:host_name] != "" && params[:budget] != ""  && logged_in? && (params[:category_id] != nil || params[:category][:name] != "") 
      if !params["category"]["name"].empty?
        #binding.pry
        @category = Category.find_or_create_by(name: params["category"]["name"])
        binding.pry
        @event = Event.update(:date => params[:date], :host_name => params[:host_name], :budget => params[:budget], :planner_id => current_user.id, :category_id => @category.id)
        #@category_name = Category.find_by_id(@event.category_id).name
      else
        @event = Event.update(:date => params[:date], :host_name => params[:host_name], :budget => params[:budget], :planner_id => current_user.id, :category_id => params[:category_id]) #How to shorten this line?
      end
      redirect "/events/#{@event.id}"
    elsif 
      @event.planner_id == current_user.id && logged_in? && params[:date] == "" || params[:host_name] == "" || params[:budget] == "" || (params[:category_id] == nil || params[:category][:name] == "") 
      redirect "/events/#{@event.id}/edit"
    else 
      redirect "/events"
    end
  end 
  
  delete '/events/:id' do 
    @event = Event.find_by_id(params[:id])
    if @event.planner_id == current_user.id
      @event.delete
      redirect to '/planner_events'
    else 
      redirect "/events"
    end
  end
end