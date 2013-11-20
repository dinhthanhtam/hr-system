class CreateCosts < ActiveRecord::Migration
  def change
    create_table :costs do |t|
      t.integer :project_id
      t.integer :user_id
      t.integer :week
      t.integer :cost
      t.integer :year

      t.timestamps
    end
  end
end
