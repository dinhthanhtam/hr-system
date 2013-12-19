class CreateCheckpointQuestions < ActiveRecord::Migration
  def change
    create_table :checkpoint_questions do |t|
      t.string :content
      t.integer :max_point
      t.string :checkpoint_type
      t.integer :checkpoint_period_id
      t.timestamps
    end
  end
end
