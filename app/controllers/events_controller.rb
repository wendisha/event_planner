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
      flash[:message] = "Event successfully created."
      redirect "/events/#{@event.id}"
    else 
      flash[:message] = "Event not created. Please make sure you fill out all required fields and try again."
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
        @category = Category.find_or_create_by(name: params["category"]["name"])
        @event.update(:date => params[:date], :host_name => params[:host_name], :budget => params[:budget], :planner_id => current_user.id, :category_id => @category.id)
        @event.save
      else 
        @event.update(:date => params[:date], :host_name => params[:host_name], :budget => params[:budget], :planner_id => current_user.id, :category_id => params[:category_id])
      end
      flash[:message] = "Success! Event updated."
      redirect "/events/#{@event.id}"
    elsif 
      @event.planner_id == current_user.id && logged_in? && params[:date] == "" || params[:host_name] == "" || params[:budget] == "" || (params[:category_id] == nil || params[:category][:name] == "") 
      flash[:message] = "Please make sure you fill out all required fields."
      redirect "/events/#{@event.id}/edit"
    elsif 
      @event.planner_id != current_user.id
      flash[:message] = "You can only edit events you have created."
      redirect "/events"
    else 
      redirect "/events"
    end
  end 
  
  delete '/events/:id' do 
    @event = Event.find_by_id(params[:id])
    if @event.planner_id == current_user.id
      @event.delete
      flash[:message] = "Event successfully deleted."
      redirect to '/planner_events'
    else 
      flash[:message] = "You can only delete events you have created."
      redirect "/events"
    end
  end
end