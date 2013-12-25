class CreateVacations < ActiveRecord::Migration
  def change
    create_table :vacations do |t|
      t.integer :user_id
      t.integer :vacation_type_id
      t.integer :leader_id
      t.integer :manager_id
      t.date :start_date
      t.date :end_date
      t.integer :total_day
      t.date :compensating_date
      t.float :hour

      t.timestamps
    end
  end
end
