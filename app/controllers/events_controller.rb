class EventsController < ApplicationController
  get '/events/new' do
    if logged_in?
      erb :'/events/new'
    else
       redirect "/login"
    end
  end
  
  post '/events' do
    if params[:date] != "" && params[:host_name] != "" && params[:budget] != "" 
      @event = Event.create(:date => params[:date], :host_name => params[:host_name], :budget => params[:budget], :user_id => current_user.id) #How to shorten this line?
      redirect "/events/#{@event.id}"
    else 
      redirect '/events/new'
    end
  end
end