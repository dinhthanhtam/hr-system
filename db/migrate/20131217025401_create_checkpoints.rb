class CreateCheckpoints < ActiveRecord::Migration
  def change
    create_table :checkpoints do |t|
      t.integer :user_id
      t.date :start_date
      t.date :end_date
      t.string :ranking
      t.timestamps
    end
  end
end
