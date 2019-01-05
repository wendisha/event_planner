class Event < ActiveRecord::Base
  belongs_to :planner
  belongs_to :category
  
end