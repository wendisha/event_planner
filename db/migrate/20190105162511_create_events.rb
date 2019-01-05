class CreateEvents < ActiveRecord::Migration
  def change
  create_table :events do |t|
    t.integer :date
    t.string :host_name 
    t.integer :budget 
    t.integer :planner_id 
    t.integer :category_id 
  end
end
