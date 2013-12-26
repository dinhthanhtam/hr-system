class CreateCheckpointAnswers < ActiveRecord::Migration
  def change
    create_table :checkpoint_answers do |t|
      t.integer :question_id
      t.integer :checkpoint_id
      t.string :content
      t.integer :point
      t.timestamps
    end
  end
end
