class CreatePlanners < ActiveRecord::Migration
  def change
    create_table :planners do |t|
      t.string :username
      t.string :password_digest
    end
  end
end
