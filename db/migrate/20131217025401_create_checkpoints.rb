class CreateCheckpoints < ActiveRecord::Migration
  def change
    create_table :checkpoints do |t|
      t.integer :user_id
      t.integer :approve_id
      t.integer :reviewer_id
      t.string :ranking
      t.integer :checkpoint_period_id
      t.timestamps
    end
  end
end
