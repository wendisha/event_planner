class Planner < ActiveRecord::Base
  has_many :events 
  has_many :categories, through: :events
  
end