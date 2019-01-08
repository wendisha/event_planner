class Planner < ActiveRecord::Base
  has_many :events 
  has_many :categories, through: :events
  validates_presence_of :username, :password
  has_secure_password
end