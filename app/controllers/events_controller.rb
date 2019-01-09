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
      @event = Event.create(:date => params[:date], :host_name => params[:host_name], :budget => params[:budget], :planner_id => current_user.id, :category_id => params[:category_id]) #How to shorten this line?
        if !params["category"]["name"].empty?
          @category = Category.create(name: params["category"]["name"])
          @event.category_id = @category.id
          #binding.pry
          #@event.save
        end
      redirect "/events/#{@event.id}"
    else 
      redirect '/events/new'
    end
  end
  
  get '/events/:id' do 
    @event = Event.find_by_id(params[:id])
    erb :'/events/show'
  end

end