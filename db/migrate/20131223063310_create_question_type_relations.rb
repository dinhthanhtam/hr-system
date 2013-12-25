class CreateQuestionTypeRelations < ActiveRecord::Migration
  def change
    create_table :question_type_relations do |t|
      t.belongs_to :question
      t.belongs_to :question_type
      t.timestamps
    end
  end
end
