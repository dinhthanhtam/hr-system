class CreatePeriodQuestions < ActiveRecord::Migration
  def change
    create_table :period_questions do |t|
      t.integer :checkpoint_period_id
      t.integer :question_id

      t.timestamps
    end
  end
end
