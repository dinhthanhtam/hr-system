class CreateUserAnswerComments < ActiveRecord::Migration
  def change
    create_table :user_answer_comments do |t|
      t.integer :user_id
      t.integer :checkpoint_answer_id
      t.string :comment
      t.timestamps
    end
  end
end
