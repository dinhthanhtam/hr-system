class CreateCheckpointQuestions < ActiveRecord::Migration
  def change
    create_table :checkpoint_questions do |t|
      t.string :content
      t.integer :max_point
      t.timestamps
    end
  end
end
