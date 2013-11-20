class CreateProjectUsers < ActiveRecord::Migration
  def change
    create_table :project_users do |t|
      t.integer :project_id
      t.integer :user_id
      t.string :state
      t.date :join_date
      t.date :due_date
      t.date :out_date

      t.timestamps
    end
  end
end
