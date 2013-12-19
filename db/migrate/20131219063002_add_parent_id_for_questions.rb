class AddParentIdForQuestions < ActiveRecord::Migration
  def change
    remove_column :checkpoint_questions, :checkpoint_period_id
    add_column :checkpoint_questions, :parent_id, :integer
  end
end
