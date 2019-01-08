class PlannersController < ApplicationController
  
  get '/signup' do
    if logged_in?
      redirect "/events" 
    else
      erb :"planners/signup"
    end
  end
end