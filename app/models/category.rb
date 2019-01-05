class Category < ActiveRecord::Base
  has_many :events
  has_many :planners, through: :events
end